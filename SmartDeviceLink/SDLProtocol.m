//  SDLProtocol.m
//


#import "SDLFunctionID.h"
#import "SDLJsonEncoder.h"

#import "SDLAbstractTransport.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadNak.h"
#import "SDLControlFramePayloadRPCStartService.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLDebugTool.h"
#import "SDLGlobals.h"
#import "SDLPrioritizedObjectCollection.h"
#import "SDLProtocol.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLProtocolMessageDisassembler.h"
#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLRPCNotification.h"
#import "SDLRPCPayload.h"
#import "SDLRPCRequest.h"
#import "SDLRPCResponse.h"
#import "SDLSecurityType.h"
#import "SDLTimer.h"
#import "SDLV2ProtocolHeader.h"

NSString *const SDLProtocolSecurityErrorDomain = @"com.sdl.protocol.security";


#pragma mark - SDLProtocol Private Interface

typedef NSNumber SDLServiceTypeBox;

@interface SDLProtocol () {
    UInt32 _messageID;
    dispatch_queue_t _receiveQueue;
    dispatch_queue_t _sendQueue;
    SDLPrioritizedObjectCollection *_prioritizedCollection;
    BOOL _alreadyDestructed;
}

@property (strong) NSMutableData *receiveBuffer;
@property (strong) SDLProtocolReceivedMessageRouter *messageRouter;
@property (nonatomic, strong) NSMutableDictionary<SDLServiceTypeBox *, SDLProtocolHeader *> *serviceHeaders;
@end


#pragma mark - SDLProtocol Implementation

@implementation SDLProtocol

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _messageID = 0;
        _receiveQueue = dispatch_queue_create("com.sdl.protocol.receive", DISPATCH_QUEUE_SERIAL);
        _sendQueue = dispatch_queue_create("com.sdl.protocol.transmit", DISPATCH_QUEUE_SERIAL);
        _prioritizedCollection = [[SDLPrioritizedObjectCollection alloc] init];
        _serviceHeaders = [[NSMutableDictionary alloc] init];
        _messageRouter = [[SDLProtocolReceivedMessageRouter alloc] init];
        _messageRouter.delegate = self;
    }

    return self;
}


#pragma mark - Service metadata
- (UInt8)sdl_retrieveSessionIDforServiceType:(SDLServiceType)serviceType {
    SDLProtocolHeader *header = self.serviceHeaders[@(serviceType)];
    if (header == nil) {
        NSString *logMessage = [NSString stringWithFormat:@"Warning: Tried to retrieve sessionID for serviceType %i, but no header is saved for that service type", serviceType];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File | SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
    }

    return header.sessionID;
}

- (void)sendStartSessionWithType:(SDLServiceType)serviceType {
    [self startServiceWithType:serviceType payload:nil];
}


#pragma mark - Start Service

- (void)startServiceWithType:(SDLServiceType)serviceType {
    [self startServiceWithType:serviceType payload:nil];
}

- (void)startServiceWithType:(SDLServiceType)serviceType payload:(NSData *)payload {
    // No encryption, just build and send the message synchronously
    SDLProtocolMessage *message = [self sdl_createStartServiceMessageWithType:serviceType encrypted:NO payload:payload];
    [self sdl_sendDataToTransport:message.data onService:serviceType];
}

- (void)startSecureServiceWithType:(SDLServiceType)serviceType completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    [self startSecureServiceWithType:serviceType payload:nil completionHandler:completionHandler];
}

- (void)startSecureServiceWithType:(SDLServiceType)serviceType payload:(NSData *)payload completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    [self sdl_initializeTLSEncryptionWithCompletionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            // We can't start the service because we don't have encryption, return the error
            completionHandler(success, error);
            return; // from block
        }

        // TLS initialization succeeded. Build and send the message.
        SDLProtocolMessage *message = [self sdl_createStartServiceMessageWithType:serviceType encrypted:YES payload:nil];
        [self sdl_sendDataToTransport:message.data onService:serviceType];
    }];
}

- (SDLProtocolMessage *)sdl_createStartServiceMessageWithType:(SDLServiceType)serviceType encrypted:(BOOL)encryption payload:(NSData *)payload {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].majorProtocolVersion];
    NSData *servicePayload = payload;

    switch (serviceType) {
        case SDLServiceType_RPC: {
            // Need a different header for starting the RPC service, we get the session Id from the HU, or its the same as the RPC service's
            header = [SDLProtocolHeader headerForVersion:1];
            if ([self sdl_retrieveSessionIDforServiceType:SDLServiceType_RPC]) {
                header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceType_RPC];
            } else {
                header.sessionID = 0;
            }

            SDLControlFramePayloadRPCStartService *startServicePayload = [[SDLControlFramePayloadRPCStartService alloc] initWithVersion:SDLMaxProxyProtocolVersion];
            servicePayload = startServicePayload.data;
        } break;
        default: {
            header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceType_RPC];
        } break;
    }
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_StartSession;
    header.bytesInPayload = (UInt32)servicePayload.length;

    // Sending a StartSession with the encrypted bit set causes module to initiate SSL Handshake with a ClientHello message, which should be handled by the 'processControlService' method.
    header.encrypted = encryption;

    return [SDLProtocolMessage messageWithHeader:header andPayload:servicePayload];
}

- (void)sdl_initializeTLSEncryptionWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    if (self.securityManager == nil) {
        [SDLDebugTool logInfo:@"Could not start service, encryption was requested but failed because no security manager has been set."];

        if (completionHandler != nil) {
            completionHandler(NO, [NSError errorWithDomain:SDLProtocolSecurityErrorDomain code:SDLProtocolErrorNoSecurityManager userInfo:nil]);
        }

        return;
    }

    [self.securityManager initializeWithAppId:self.appId
                            completionHandler:^(NSError *_Nullable error) {
                                if (error) {
                                    NSString *logString = [NSString stringWithFormat:@"Security Manager failed to initialize with error: %@", error];
                                    [SDLDebugTool logInfo:logString];

                                    if (completionHandler != nil) {
                                        completionHandler(NO, error);
                                    }
                                } else {
                                    if (completionHandler != nil) {
                                        completionHandler(YES, nil);
                                    }
                                }
                            }];
}


#pragma mark - End Service

- (void)sendEndSessionWithType:(SDLServiceType)serviceType {
    [self endServiceWithType:serviceType];
}

- (void)endServiceWithType:(SDLServiceType)serviceType {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].majorProtocolVersion];
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_EndSession;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:serviceType];

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];
    [self sdl_sendDataToTransport:message.data onService:serviceType];
}


#pragma mark - Send Data

- (void)sendRPC:(SDLRPCMessage *)message {
    [self sendRPC:message encrypted:NO error:nil];
}

- (BOOL)sendRPC:(SDLRPCMessage *)message encrypted:(BOOL)encryption error:(NSError *__autoreleasing *)error {
    NSParameterAssert(message != nil);

    NSData *jsonData = [[SDLJsonEncoder instance] encodeDictionary:[message serializeAsDictionary:[SDLGlobals globals].majorProtocolVersion]];
    NSData *messagePayload = nil;

    NSString *logMessage = [NSString stringWithFormat:@"%@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    // Build the message payload. Include the binary header if necessary
    // VERSION DEPENDENT CODE
    switch ([SDLGlobals globals].majorProtocolVersion) {
        case 1: {
            // No binary header in version 1
            messagePayload = jsonData;
        } break;
        case 2: // Fallthrough
        case 3: // Fallthrough
        case 4: // Fallthrough
        case 5: {
            // Build a binary header
            // Serialize the RPC data into an NSData
            SDLRPCPayload *rpcPayload = [[SDLRPCPayload alloc] init];
            rpcPayload.functionID = [[[[SDLFunctionID alloc] init] getFunctionID:[message getFunctionName]] intValue];
            rpcPayload.jsonData = jsonData;
            rpcPayload.binaryData = message.bulkData;

            // If it's a request or a response, we need to pull out the correlation ID, so we'll downcast
            if ([message isKindOfClass:SDLRPCRequest.class]) {
                rpcPayload.rpcType = SDLRPCMessageTypeRequest;
                rpcPayload.correlationID = [((SDLRPCRequest *)message).correlationID intValue];
            } else if ([message isKindOfClass:SDLRPCResponse.class]) {
                rpcPayload.rpcType = SDLRPCMessageTypeResponse;
                rpcPayload.correlationID = [((SDLRPCResponse *)message).correlationID intValue];
            } else if ([message isKindOfClass:[SDLRPCNotification class]]) {
                rpcPayload.rpcType = SDLRPCMessageTypeNotification;
            } else {
                NSAssert(NO, @"Unknown message type attempted to send. Type: %@", [message class]);
                return NO;
            }

            // If we're trying to encrypt, try to have the security manager encrypt it. Return if it fails.
            // TODO: (Joel F.)[2016-02-09] We should assert if the service isn't setup for encryption. See [#350](https://github.com/smartdevicelink/sdl_ios/issues/350)
            messagePayload = encryption ? [self.securityManager encryptData:rpcPayload.data withError:error] : rpcPayload.data;
            if (!messagePayload) {
                return NO;
            }
        } break;
        default: {
            NSAssert(NO, @"Attempting to send an RPC based on an unknown version number: %@, message: %@", @([SDLGlobals globals].majorProtocolVersion), message);
        } break;
    }

    // Build the protocol level header & message
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].majorProtocolVersion];
    header.encrypted = encryption;
    header.frameType = SDLFrameType_Single;
    header.serviceType = (message.bulkData.length <= 0) ? SDLServiceType_RPC : SDLServiceType_BulkData;
    header.frameData = SDLFrameData_SingleFrame;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceType_RPC];
    header.bytesInPayload = (UInt32)messagePayload.length;

    // V2+ messages need to have message ID property set.
    if ([SDLGlobals globals].majorProtocolVersion >= 2) {
        [((SDLV2ProtocolHeader *)header) setMessageID:++_messageID];
    }


    SDLProtocolMessage *protocolMessage = [SDLProtocolMessage messageWithHeader:header andPayload:messagePayload];

    // See if the message is small enough to send in one transmission. If not, break it up into smaller messages and send.
    if (protocolMessage.size < [[SDLGlobals globals] mtuSizeForServiceType:SDLServiceType_RPC]) {
        [self sdl_logRPCSend:protocolMessage];
        [self sdl_sendDataToTransport:protocolMessage.data onService:SDLServiceType_RPC];
    } else {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:protocolMessage withLimit:[[SDLGlobals globals] mtuSizeForServiceType:SDLServiceType_RPC]];
        for (SDLProtocolMessage *smallerMessage in messages) {
            [self sdl_logRPCSend:smallerMessage];
            [self sdl_sendDataToTransport:smallerMessage.data onService:SDLServiceType_RPC];
        }
    }

    return YES;
}

// SDLRPCRequest in from app -> SDLProtocolMessage out to transport layer.
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest {
    [self sendRPC:rpcRequest];
}

- (void)sdl_logRPCSend:(SDLProtocolMessage *)message {
    NSString *logMessage = [NSString stringWithFormat:@"Sending : %@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File | SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
}

// Use for normal messages
- (void)sdl_sendDataToTransport:(NSData *)data onService:(NSInteger)priority {
    [_prioritizedCollection addObject:data withPriority:priority];

    // TODO: (Joel F.)[2016-02-11] Autoreleasepool?
    dispatch_async(_sendQueue, ^{
        NSData *dataToTransmit = nil;
        while (dataToTransmit = (NSData *)[_prioritizedCollection nextObject]) {
            [self.transport sendData:dataToTransmit];
        };
    });
}

- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType {
    [self sdl_sendRawData:data onService:serviceType encryption:NO];
}

- (void)sendEncryptedRawData:(NSData *)data onService:(SDLServiceType)serviceType {
    [self sdl_sendRawData:data onService:serviceType encryption:YES];
}

- (void)sdl_sendRawData:(NSData *)data onService:(SDLServiceType)service encryption:(BOOL)encryption {
    SDLV2ProtocolHeader *header = [[SDLV2ProtocolHeader alloc] initWithVersion:[SDLGlobals globals].majorProtocolVersion];
    header.encrypted = encryption;
    header.frameType = SDLFrameType_Single;
    header.serviceType = service;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:service];
    header.messageID = ++_messageID;

    if (encryption && data.length) {
        NSError *encryptError = nil;
        data = [self.securityManager encryptData:data withError:&encryptError];

        if (encryptError) {
            NSString *encryptLogString = [NSString stringWithFormat:@"Error attempting to encrypt raw data for service: %@, error: %@", @(service), encryptError];
            [SDLDebugTool logInfo:encryptLogString];
        }
    }

    header.bytesInPayload = (UInt32)data.length;

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:data];

    if (message.size < [[SDLGlobals globals] mtuSizeForServiceType:service]) {
        [self sdl_logRPCSend:message];
        [self sdl_sendDataToTransport:message.data onService:header.serviceType];
    } else {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:message withLimit:[[SDLGlobals globals] mtuSizeForServiceType:service]];
        for (SDLProtocolMessage *smallerMessage in messages) {
            [self sdl_logRPCSend:smallerMessage];
            [self sdl_sendDataToTransport:smallerMessage.data onService:header.serviceType];
        }
    }
}


#pragma mark - Receive and Process Data

// Turn received bytes into message objects.
- (void)handleBytesFromTransport:(NSData *)receivedData {
    // Initialize the receive buffer which will contain bytes while messages are constructed.
    if (self.receiveBuffer == nil) {
        self.receiveBuffer = [NSMutableData dataWithCapacity:(4 * [[SDLGlobals globals] mtuSizeForServiceType:SDLServiceType_RPC])];
    }

    // Save the data
    [self.receiveBuffer appendData:receivedData];

    [self processMessages];
}

- (void)processMessages {
    NSMutableString *logMessage = [[NSMutableString alloc] init];
    UInt8 incomingVersion = [SDLProtocolHeader determineVersion:self.receiveBuffer];

    // If we have enough bytes, create the header.
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:incomingVersion];
    NSUInteger headerSize = header.size;
    if (self.receiveBuffer.length >= headerSize) {
        [header parse:self.receiveBuffer];
    } else {
        return;
    }

    // If we have enough bytes, finish building the message.
    SDLProtocolMessage *message = nil;
    NSUInteger payloadSize = header.bytesInPayload;
    NSUInteger messageSize = headerSize + payloadSize;
    if (self.receiveBuffer.length >= messageSize) {
        NSUInteger payloadOffset = headerSize;
        NSUInteger payloadLength = payloadSize;
        NSData *payload = [self.receiveBuffer subdataWithRange:NSMakeRange(payloadOffset, payloadLength)];

        // If the message in encrypted and there is payload, try to decrypt it
        if (header.encrypted && payload.length) {
            NSError *decryptError = nil;
            payload = [self.securityManager decryptData:payload withError:&decryptError];

            if (decryptError) {
                NSString *decryptLogMessage = [NSString stringWithFormat:@"Error attempting to decrypt a payload with error: %@", decryptError];
                [SDLDebugTool logInfo:decryptLogMessage];
                return;
            }
        }

        message = [SDLProtocolMessage messageWithHeader:header andPayload:payload];
        [logMessage appendFormat:@"message complete. %@", message];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File | SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
    } else {
        // Need to wait for more bytes.
        [logMessage appendFormat:@"header complete. message incomplete, waiting for %ld more bytes. Header:%@", (long)(messageSize - self.receiveBuffer.length), header];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File | SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
        return;
    }

    // Need to maintain the receiveBuffer, remove the bytes from it which we just processed.
    self.receiveBuffer = [[self.receiveBuffer subdataWithRange:NSMakeRange(messageSize, self.receiveBuffer.length - messageSize)] mutableCopy];

    // Pass on the message to the message router.
    dispatch_async(_receiveQueue, ^{
        [self.messageRouter handleReceivedMessage:message];
    });

    // Call recursively until the buffer is empty or incomplete message is encountered
    if (self.receiveBuffer.length > 0) {
        [self processMessages];
    }
}

// TODO: This is a v4 packet (create new delegate methods)
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    // V5 Packet
    if (startServiceACK.header.version >= 5) {
        switch (startServiceACK.header.serviceType) {
            case SDLServiceType_RPC: {
                SDLControlFramePayloadRPCStartServiceAck *startServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:startServiceACK.payload];
//                NSLog(@"ServiceAckPayload: %@", startServiceACKPayload);

                if (startServiceACKPayload.mtu != SDLControlFrameInt64NotFound) {
                    [[SDLGlobals globals] setDynamicMTUSize:startServiceACKPayload.mtu forServiceType:startServiceACK.header.serviceType];
                }
                [SDLGlobals globals].maxHeadUnitVersion = (startServiceACKPayload.protocolVersion != nil) ? startServiceACKPayload.protocolVersion : [NSString stringWithFormat:@"%u.0.0", startServiceACK.header.version];
                // TODO: Hash id?
            } break;
            default:
                break;
        }
    } else {
        // V4 and below packet
        switch (startServiceACK.header.serviceType) {
            case SDLServiceType_RPC: {
                [SDLGlobals globals].maxHeadUnitVersion = [NSString stringWithFormat:@"%u.0.0", startServiceACK.header.version];
            } break;
            default:
                break;
        }
    }

    // Store the header of this service away for future use
    self.serviceHeaders[@(startServiceACK.header.serviceType)] = [startServiceACK.header copy];

    // Pass along to all the listeners
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolStartServiceACKMessage:)]) {
            [listener handleProtocolStartServiceACKMessage:startServiceACK];
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([listener respondsToSelector:@selector(handleProtocolStartSessionACK:)]) {
            [listener handleProtocolStartSessionACK:startServiceACK.header];
        }

        if ([listener respondsToSelector:@selector(handleProtocolStartSessionACK:sessionID:version:)]) {
            [listener handleProtocolStartSessionACK:startServiceACK.header.serviceType
                                          sessionID:startServiceACK.header.sessionID
                                            version:startServiceACK.header.version];
#pragma clang diagnostic pop
        }
    }
}

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    [self sdl_logControlNAKPayload:startServiceNAK];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolStartServiceNAKMessage:)]) {
            [listener handleProtocolStartServiceNAKMessage:startServiceNAK];
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([listener respondsToSelector:@selector(handleProtocolStartSessionNACK:)]) {
            [listener handleProtocolStartSessionNACK:startServiceNAK.header.serviceType];
        }
#pragma clang diagnostic pop
    }
}

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    // Remove the session id
    [self.serviceHeaders removeObjectForKey:@(endServiceACK.header.serviceType)];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolEndServiceACKMessage:)]) {
            [listener handleProtocolEndServiceACKMessage:endServiceACK];
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([listener respondsToSelector:@selector(handleProtocolEndSessionACK:)]) {
            [listener handleProtocolEndSessionACK:endServiceACK.header.serviceType];
        }
    }
#pragma clang diagnostic pop
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    [self sdl_logControlNAKPayload:endServiceNAK];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolEndServiceNAKMessage:)]) {
            [listener handleProtocolEndServiceNAKMessage:endServiceNAK];
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([listener respondsToSelector:@selector(handleProtocolEndSessionNACK:)]) {
            [listener handleProtocolEndSessionNACK:endServiceNAK.header.serviceType];
        }
    }
#pragma clang diagnostic pop
}

- (void)handleHeartbeatForSession:(Byte)session {
    // Respond with a heartbeat ACK
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].majorProtocolVersion];
    header.frameType = SDLFrameType_Control;
    header.serviceType = SDLServiceType_Control;
    header.frameData = SDLFrameData_HeartbeatACK;
    header.sessionID = session;
    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];
    [self sdl_sendDataToTransport:message.data onService:header.serviceType];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleHeartbeatForSession:)]) {
            [listener handleHeartbeatForSession:session];
        }
    }
}

- (void)handleHeartbeatACK {
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleHeartbeatACK)]) {
            [listener handleHeartbeatACK];
        }
    }
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg {
    // Control service (but not control frame type) messages are TLS handshake messages
    if (msg.header.serviceType == SDLServiceType_Control) {
        [self sdl_processSecurityMessage:msg];
        return;
    }

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(onProtocolMessageReceived:)]) {
            [listener onProtocolMessageReceived:msg];
        }
    }
}

- (void)onProtocolOpened {
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(onProtocolOpened)]) {
            [listener onProtocolOpened];
        }
    }
}

- (void)onProtocolClosed {
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(onProtocolClosed)]) {
            [listener onProtocolClosed];
        }
    }
}

- (void)onError:(NSString *)info exception:(NSException *)e {
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(onError:exception:)]) {
            [listener onError:info exception:e];
        }
    }
}

- (void)sdl_logControlNAKPayload:(SDLProtocolMessage *)nakMessage {
    if (nakMessage.header.version >= 5) {
        SDLControlFramePayloadNak *endServiceNakPayload = [[SDLControlFramePayloadNak alloc] initWithData:nakMessage.payload];
        NSArray<NSString *> *rejectedParams = endServiceNakPayload.rejectedParams;
        if (rejectedParams.count > 0) {
            NSString *log = [NSString stringWithFormat:@"Start Service NAK'd, service type: %@, rejectedParams: %@", @(nakMessage.header.serviceType), rejectedParams];
            [SDLDebugTool logInfo:log];
        }
    }
}


#pragma mark - TLS Handshake
// TODO: These should be split out to a separate class to be tested properly
- (void)sdl_processSecurityMessage:(SDLProtocolMessage *)clientHandshakeMessage {
    if (self.securityManager == nil) {
        NSString *logString = [NSString stringWithFormat:@"Failed to process security message because no security manager is set. Message: %@", clientHandshakeMessage];
        [SDLDebugTool logInfo:logString];
        return;
    }

    // Misformatted handshake message, something went wrong
    if (clientHandshakeMessage.payload.length <= 12) {
        NSString *logString = [NSString stringWithFormat:@"Security message is malformed, less than 12 bytes. It does not have a protocol header. Message: %@", clientHandshakeMessage];
        [SDLDebugTool logInfo:logString];
    }

    // Tear off the binary header of the client protocol message to get at the actual TLS handshake
    // TODO: (Joel F.)[2016-02-15] Should check for errors
    NSData *clientHandshakeData = [clientHandshakeMessage.payload subdataWithRange:NSMakeRange(12, (clientHandshakeMessage.payload.length - 12))];

    // Ask the security manager for server data based on the client data sent
    NSError *handshakeError = nil;
    NSData *serverHandshakeData = [self.securityManager runHandshakeWithClientData:clientHandshakeData error:&handshakeError];

    // If the handshake went bad and the security library ain't happy, send over the failure to the module. This should result in an ACK with encryption off.
    SDLProtocolMessage *serverSecurityMessage = nil;
    if (serverHandshakeData == nil) {
        NSString *logString = [NSString stringWithFormat:@"Error running TLS handshake procedure. Sending error to module. Error: %@", handshakeError];
        [SDLDebugTool logInfo:logString];

        serverSecurityMessage = [self.class sdl_serverSecurityFailedMessageWithClientMessageHeader:clientHandshakeMessage.header messageId:++_messageID];
    } else {
        // The handshake went fine, send the module the remaining handshake data
        serverSecurityMessage = [self.class sdl_serverSecurityHandshakeMessageWithData:serverHandshakeData clientMessageHeader:clientHandshakeMessage.header messageId:++_messageID];
    }

    // Send the response or error message. If it's an error message, the module will ACK the Start Service without encryption. If it's a TLS handshake message, the module will ACK with encryption
    [self sdl_sendDataToTransport:serverSecurityMessage.data onService:SDLServiceType_Control];
}

+ (SDLProtocolMessage *)sdl_serverSecurityHandshakeMessageWithData:(NSData *)data clientMessageHeader:(SDLProtocolHeader *)clientHeader messageId:(UInt32)messageId {
    // This can't possibly be a v1 header because v1 does not have control protocol messages
    SDLV2ProtocolHeader *serverMessageHeader = [SDLProtocolHeader headerForVersion:clientHeader.version];
    serverMessageHeader.encrypted = NO;
    serverMessageHeader.frameType = SDLFrameType_Single;
    serverMessageHeader.serviceType = SDLServiceType_Control;
    serverMessageHeader.frameData = SDLFrameData_SingleFrame;
    serverMessageHeader.sessionID = clientHeader.sessionID;
    serverMessageHeader.messageID = messageId;

    // For a control service packet, we need a binary header with a function ID corresponding to what type of packet we're sending.
    SDLRPCPayload *serverTLSPayload = [[SDLRPCPayload alloc] init];
    serverTLSPayload.functionID = 0x01; // TLS Handshake message
    serverTLSPayload.rpcType = 0x00;
    serverTLSPayload.correlationID = 0x00;
    serverTLSPayload.binaryData = data;

    NSData *binaryData = serverTLSPayload.data;
    serverMessageHeader.bytesInPayload = (UInt32)binaryData.length;

    return [SDLProtocolMessage messageWithHeader:serverMessageHeader andPayload:binaryData];
}

+ (SDLProtocolMessage *)sdl_serverSecurityFailedMessageWithClientMessageHeader:(SDLProtocolHeader *)clientHeader messageId:(UInt32)messageId {
    // This can't possibly be a v1 header because v1 does not have control protocol messages
    SDLV2ProtocolHeader *serverMessageHeader = [SDLProtocolHeader headerForVersion:clientHeader.version];
    serverMessageHeader.encrypted = NO;
    serverMessageHeader.frameType = SDLFrameType_Single;
    serverMessageHeader.serviceType = SDLServiceType_Control;
    serverMessageHeader.frameData = SDLFrameData_SingleFrame;
    serverMessageHeader.sessionID = clientHeader.sessionID;
    serverMessageHeader.messageID = messageId;

    // For a control service packet, we need a binary header with a function ID corresponding to what type of packet we're sending.
    SDLRPCPayload *serverTLSPayload = [[SDLRPCPayload alloc] init];
    serverTLSPayload.functionID = 0x02; // TLS Error message
    serverTLSPayload.rpcType = 0x02;
    serverTLSPayload.correlationID = 0x00;

    NSData *binaryData = serverTLSPayload.data;
    serverMessageHeader.bytesInPayload = (UInt32)binaryData.length;

    // TODO: (Joel F.)[2016-02-15] This is supposed to have some JSON data and json data size
    return [SDLProtocolMessage messageWithHeader:serverMessageHeader andPayload:binaryData];
}


#pragma mark - Lifecycle

- (void)sdl_destructObjects {
    if (!_alreadyDestructed) {
        _alreadyDestructed = YES;
        _messageRouter.delegate = nil;
        _messageRouter = nil;
        self.transport = nil;
        self.protocolDelegateTable = nil;
    }
}

- (void)dispose {
    [self sdl_destructObjects];
}

- (void)dealloc {
    [self sdl_destructObjects];
    [SDLDebugTool logInfo:@"SDLProtocol Dealloc" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

@end
