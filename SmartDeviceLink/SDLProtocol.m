//  SDLProtocol.m
//


#import "SDLFunctionID.h"

#import "SDLAbstractTransport.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadEndService.h"
#import "SDLControlFramePayloadNak.h"
#import "SDLControlFramePayloadRPCStartService.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLLogMacros.h"
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

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocol () {
    UInt32 _messageID;
    dispatch_queue_t _receiveQueue;
    dispatch_queue_t _sendQueue;
    SDLPrioritizedObjectCollection *_prioritizedCollection;
}

@property (strong, nonatomic) NSMutableData *receiveBuffer;
@property (nullable, strong, nonatomic) SDLProtocolReceivedMessageRouter *messageRouter;
@property (strong, nonatomic) NSMutableDictionary<SDLServiceTypeBox *, SDLProtocolHeader *> *serviceHeaders;
@property (assign, nonatomic) int32_t hashId;

@end


#pragma mark - SDLProtocol Implementation

@implementation SDLProtocol

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _messageID = 0;
        _hashId = SDLControlFrameInt32NotFound;
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
        SDLLogW(@"Warning: Tried to retrieve sessionID for serviceType %i, but no header is saved for that service type", serviceType);
    }

    return header.sessionID;
}


#pragma mark - Start Service

- (void)startServiceWithType:(SDLServiceType)serviceType payload:(nullable NSData *)payload {
    // No encryption, just build and send the message synchronously
    SDLProtocolMessage *message = [self sdl_createStartServiceMessageWithType:serviceType encrypted:NO payload:payload];
    [self sdl_sendDataToTransport:message.data onService:serviceType];
}

- (void)startSecureServiceWithType:(SDLServiceType)serviceType payload:(nullable NSData *)payload completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    [self sdl_initializeTLSEncryptionWithCompletionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            // We can't start the service because we don't have encryption, return the error
            completionHandler(success, error);
            BLOCK_RETURN;
        }

        // TLS initialization succeeded. Build and send the message.
        SDLProtocolMessage *message = [self sdl_createStartServiceMessageWithType:serviceType encrypted:YES payload:nil];
        [self sdl_sendDataToTransport:message.data onService:serviceType];
    }];
}

- (SDLProtocolMessage *)sdl_createStartServiceMessageWithType:(SDLServiceType)serviceType encrypted:(BOOL)encryption payload:(nullable NSData *)payload {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:(UInt8)[SDLGlobals sharedGlobals].majorProtocolVersion];
    NSData *servicePayload = payload;

    switch (serviceType) {
        case SDLServiceTypeRPC: {
            // Need a different header for starting the RPC service, we get the session Id from the HU, or its the same as the RPC service's
            header = [SDLProtocolHeader headerForVersion:1];
            if ([self sdl_retrieveSessionIDforServiceType:SDLServiceTypeRPC]) {
                header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceTypeRPC];
            } else {
                header.sessionID = 0;
            }

            SDLControlFramePayloadRPCStartService *startServicePayload = [[SDLControlFramePayloadRPCStartService alloc] initWithVersion:SDLMaxProxyProtocolVersion];
            servicePayload = startServicePayload.data;
        } break;
        default: {
            header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceTypeRPC];
        } break;
    }
    header.frameType = SDLFrameTypeControl;
    header.serviceType = serviceType;
    header.frameData = SDLFrameInfoStartService;

    // Sending a StartSession with the encrypted bit set causes module to initiate SSL Handshake with a ClientHello message, which should be handled by the 'processControlService' method.
    header.encrypted = encryption;

    return [SDLProtocolMessage messageWithHeader:header andPayload:servicePayload];
}

- (void)sdl_initializeTLSEncryptionWithCompletionHandler:(void (^)(BOOL success, NSError *_Nullable error))completionHandler {
    if (self.securityManager == nil) {
        SDLLogE(@"Could not start streaming service, encryption was requested by the remote system but failed because there is no security manager set for this app.");

        if (completionHandler != nil) {
            completionHandler(NO, [NSError errorWithDomain:SDLProtocolSecurityErrorDomain code:SDLProtocolErrorNoSecurityManager userInfo:nil]);
        }

        return;
    }

    [self.securityManager initializeWithAppId:self.appId completionHandler:^(NSError *_Nullable error) {
        if (error) {
            SDLLogE(@"Security Manager failed to initialize with error: %@", error);

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

- (void)endServiceWithType:(SDLServiceType)serviceType {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:(UInt8)[SDLGlobals sharedGlobals].majorProtocolVersion];
    header.frameType = SDLFrameTypeControl;
    header.serviceType = serviceType;
    header.frameData = SDLFrameInfoEndService;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:serviceType];

    // Assemble the payload, it's a full control frame if we're on 5.0+, it's just the hash id if we are not
    NSData *payload = nil;
    if (self.hashId != SDLControlFrameInt32NotFound) {
        if([SDLGlobals sharedGlobals].majorProtocolVersion > 4) {
            SDLControlFramePayloadEndService *endServicePayload = [[SDLControlFramePayloadEndService alloc] initWithHashId:self.hashId];
            payload = endServicePayload.data;
        } else {
            payload = [NSData dataWithBytes:&_hashId length:sizeof(_hashId)];
        }
    }

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:payload];
    [self sdl_sendDataToTransport:message.data onService:serviceType];
}


#pragma mark - Send Data

- (void)sendRPC:(SDLRPCMessage *)message {
    [self sendRPC:message encrypted:NO error:nil];
}

- (BOOL)sendRPC:(SDLRPCMessage *)message encrypted:(BOOL)encryption error:(NSError *__autoreleasing *)error {
    NSParameterAssert(message != nil);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[message serializeAsDictionary:(Byte)[SDLGlobals sharedGlobals].majorProtocolVersion] options:kNilOptions error:error];
    
    if (error != nil) {
        SDLLogW(@"Error encoding JSON data: %@", *error);
    }
    
    NSData *messagePayload = nil;
    SDLLogV(@"Send RPC %@", message);

    // Build the message payload. Include the binary header if necessary
    // VERSION DEPENDENT CODE
    switch ([SDLGlobals sharedGlobals].majorProtocolVersion) {
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
            rpcPayload.functionID = [[[SDLFunctionID sharedInstance] functionIdForName:[message getFunctionName]] unsignedIntValue];
            rpcPayload.jsonData = jsonData;
            rpcPayload.binaryData = message.bulkData;

            // If it's a request or a response, we need to pull out the correlation ID, so we'll downcast
            if ([message isKindOfClass:SDLRPCRequest.class]) {
                rpcPayload.rpcType = SDLRPCMessageTypeRequest;
                rpcPayload.correlationID = [((SDLRPCRequest *)message).correlationID unsignedIntValue];
            } else if ([message isKindOfClass:SDLRPCResponse.class]) {
                rpcPayload.rpcType = SDLRPCMessageTypeResponse;
                rpcPayload.correlationID = [((SDLRPCResponse *)message).correlationID unsignedIntValue];
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
            NSAssert(NO, @"Attempting to send an RPC based on an unknown version number: %@, message: %@", @([SDLGlobals sharedGlobals].majorProtocolVersion), message);
        } break;
    }

    // Build the protocol level header & message
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:(UInt8)[SDLGlobals sharedGlobals].majorProtocolVersion];
    header.encrypted = encryption;
    header.frameType = SDLFrameTypeSingle;
    header.serviceType = (message.bulkData.length <= 0) ? SDLServiceTypeRPC : SDLServiceTypeBulkData;
    header.frameData = SDLFrameInfoSingleFrame;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceTypeRPC];

    // V2+ messages need to have message ID property set.
    if ([SDLGlobals sharedGlobals].majorProtocolVersion >= 2) {
        [((SDLV2ProtocolHeader *)header) setMessageID:++_messageID];
    }

    SDLProtocolMessage *protocolMessage = [SDLProtocolMessage messageWithHeader:header andPayload:messagePayload];

    // See if the message is small enough to send in one transmission. If not, break it up into smaller messages and send.
    if (protocolMessage.size < [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]) {
        SDLLogV(@"Sending protocol message: %@", protocolMessage);
        [self sdl_sendDataToTransport:protocolMessage.data onService:SDLServiceTypeRPC];
    } else {
        NSArray<SDLProtocolMessage *> *messages = [SDLProtocolMessageDisassembler disassemble:protocolMessage withLimit:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
        for (SDLProtocolMessage *smallerMessage in messages) {
            SDLLogV(@"Sending protocol message: %@", smallerMessage);
            [self sdl_sendDataToTransport:smallerMessage.data onService:SDLServiceTypeRPC];
        }
    }

    return YES;
}

// Use for normal messages
- (void)sdl_sendDataToTransport:(NSData *)data onService:(NSInteger)priority {
    [_prioritizedCollection addObject:data withPriority:priority];

    // TODO: (Joel F.)[2016-02-11] Autoreleasepool?
    dispatch_async(_sendQueue, ^{
        NSData *dataToTransmit = nil;
        while (dataToTransmit = (NSData *)[self->_prioritizedCollection nextObject]) {
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
    SDLV2ProtocolHeader *header = [[SDLV2ProtocolHeader alloc] initWithVersion:(UInt8)[SDLGlobals sharedGlobals].majorProtocolVersion];
    header.encrypted = encryption;
    header.frameType = SDLFrameTypeSingle;
    header.serviceType = service;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:service];
    header.messageID = ++_messageID;

    if (encryption && data.length) {
        NSError *encryptError = nil;
        data = [self.securityManager encryptData:data withError:&encryptError];

        if (encryptError) {
            SDLLogE(@"Error attempting to encrypt raw data for service: %@, error: %@", @(service), encryptError);
        }
    }

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:data];

    if (message.size < [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]) {
        SDLLogV(@"Sending protocol message: %@", message);
        [self sdl_sendDataToTransport:message.data onService:header.serviceType];
    } else {
        NSArray<SDLProtocolMessage *> *messages = [SDLProtocolMessageDisassembler disassemble:message withLimit:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:service]];
        for (SDLProtocolMessage *smallerMessage in messages) {
            SDLLogV(@"Sending protocol message: %@", smallerMessage);
            [self sdl_sendDataToTransport:smallerMessage.data onService:header.serviceType];
        }
    }
}


#pragma mark - Receive and Process Data

// Turn received bytes into message objects.
- (void)handleBytesFromTransport:(NSData *)receivedData {
    // Initialize the receive buffer which will contain bytes while messages are constructed.
    if (self.receiveBuffer == nil) {
        self.receiveBuffer = [NSMutableData dataWithCapacity:(4 * [[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC])];
    }

    // Save the data
    [self.receiveBuffer appendData:receivedData];

    [self processMessages];
}

- (void)processMessages {
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
                SDLLogE(@"Error attempting to decrypt a payload with error: %@", decryptError);
                return;
            }
        }

        message = [SDLProtocolMessage messageWithHeader:header andPayload:payload];
        SDLLogV(@"Protocol message received: %@", message);
    } else {
        // Need to wait for more bytes.
        SDLLogV(@" protocol header complete, message incomplete, waiting for %ld more bytes. Header: %@", (long)(messageSize - self.receiveBuffer.length), header);
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
            case SDLServiceTypeRPC: {
                SDLControlFramePayloadRPCStartServiceAck *startServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:startServiceACK.payload];

                if (startServiceACKPayload.mtu != SDLControlFrameInt64NotFound) {
                    [[SDLGlobals sharedGlobals] setDynamicMTUSize:(NSUInteger)startServiceACKPayload.mtu forServiceType:startServiceACK.header.serviceType];
                }
                if (startServiceACKPayload.hashId != SDLControlFrameInt32NotFound) {
                    self.hashId = startServiceACKPayload.hashId;
                }
                [SDLGlobals sharedGlobals].maxHeadUnitVersion = (startServiceACKPayload.protocolVersion != nil) ? startServiceACKPayload.protocolVersion : [NSString stringWithFormat:@"%u.0.0", startServiceACK.header.version];
                // TODO: Hash id?
            } break;
            default:
                break;
        }
    } else {
        // V4 and below packet
        switch (startServiceACK.header.serviceType) {
            case SDLServiceTypeRPC: {
                [SDLGlobals sharedGlobals].maxHeadUnitVersion = [NSString stringWithFormat:@"%u.0.0", startServiceACK.header.version];
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
    }
}

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    [self sdl_logControlNAKPayload:startServiceNAK];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolStartServiceNAKMessage:)]) {
            [listener handleProtocolStartServiceNAKMessage:startServiceNAK];
        }
    }
}

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    // Remove the session id
    [self.serviceHeaders removeObjectForKey:@(endServiceACK.header.serviceType)];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolEndServiceACKMessage:)]) {
            [listener handleProtocolEndServiceACKMessage:endServiceACK];
        }
    }
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    [self sdl_logControlNAKPayload:endServiceNAK];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolEndServiceNAKMessage:)]) {
            [listener handleProtocolEndServiceNAKMessage:endServiceNAK];
        }
    }
}

- (void)handleHeartbeatForSession:(Byte)session {
    // Respond with a heartbeat ACK
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:(UInt8)[SDLGlobals sharedGlobals].majorProtocolVersion];
    header.frameType = SDLFrameTypeControl;
    header.serviceType = SDLServiceTypeControl;
    header.frameData = SDLFrameInfoHeartbeatACK;
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
    if (msg.header.serviceType == SDLServiceTypeControl) {
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
            SDLLogE(@"Start Service NAK'd, service type: %@, rejectedParams: %@", @(nakMessage.header.serviceType), rejectedParams);
        }
    }
}


#pragma mark - TLS Handshake
// TODO: These should be split out to a separate class to be tested properly
- (void)sdl_processSecurityMessage:(SDLProtocolMessage *)clientHandshakeMessage {
    if (self.securityManager == nil) {
        SDLLogE(@"Failed to process security message because no security manager is set. Message: %@", clientHandshakeMessage);
        return;
    }

    // Misformatted handshake message, something went wrong
    if (clientHandshakeMessage.payload.length <= 12) {
        SDLLogE(@"Security message is malformed, less than 12 bytes. It does not have a protocol header. Message: %@", clientHandshakeMessage);
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
        SDLLogE(@"Error running TLS handshake procedure. Sending error to module. Error: %@", handshakeError);

        serverSecurityMessage = [self.class sdl_serverSecurityFailedMessageWithClientMessageHeader:clientHandshakeMessage.header messageId:++_messageID];
    } else {
        // The handshake went fine, send the module the remaining handshake data
        serverSecurityMessage = [self.class sdl_serverSecurityHandshakeMessageWithData:serverHandshakeData clientMessageHeader:clientHandshakeMessage.header messageId:++_messageID];
    }

    // Send the response or error message. If it's an error message, the module will ACK the Start Service without encryption. If it's a TLS handshake message, the module will ACK with encryption
    [self sdl_sendDataToTransport:serverSecurityMessage.data onService:SDLServiceTypeControl];
}

+ (SDLProtocolMessage *)sdl_serverSecurityHandshakeMessageWithData:(NSData *)data clientMessageHeader:(SDLProtocolHeader *)clientHeader messageId:(UInt32)messageId {
    // This can't possibly be a v1 header because v1 does not have control protocol messages
    SDLV2ProtocolHeader *serverMessageHeader = [SDLProtocolHeader headerForVersion:clientHeader.version];
    serverMessageHeader.encrypted = NO;
    serverMessageHeader.frameType = SDLFrameTypeSingle;
    serverMessageHeader.serviceType = SDLServiceTypeControl;
    serverMessageHeader.frameData = SDLFrameInfoSingleFrame;
    serverMessageHeader.sessionID = clientHeader.sessionID;
    serverMessageHeader.messageID = messageId;

    // For a control service packet, we need a binary header with a function ID corresponding to what type of packet we're sending.
    SDLRPCPayload *serverTLSPayload = [[SDLRPCPayload alloc] init];
    serverTLSPayload.functionID = 0x01; // TLS Handshake message
    serverTLSPayload.rpcType = 0x00;
    serverTLSPayload.correlationID = 0x00;
    serverTLSPayload.binaryData = data;

    NSData *binaryData = serverTLSPayload.data;

    return [SDLProtocolMessage messageWithHeader:serverMessageHeader andPayload:binaryData];
}

+ (SDLProtocolMessage *)sdl_serverSecurityFailedMessageWithClientMessageHeader:(SDLProtocolHeader *)clientHeader messageId:(UInt32)messageId {
    // This can't possibly be a v1 header because v1 does not have control protocol messages
    SDLV2ProtocolHeader *serverMessageHeader = [SDLProtocolHeader headerForVersion:clientHeader.version];
    serverMessageHeader.encrypted = NO;
    serverMessageHeader.frameType = SDLFrameTypeSingle;
    serverMessageHeader.serviceType = SDLServiceTypeControl;
    serverMessageHeader.frameData = SDLFrameInfoSingleFrame;
    serverMessageHeader.sessionID = clientHeader.sessionID;
    serverMessageHeader.messageID = messageId;

    // For a control service packet, we need a binary header with a function ID corresponding to what type of packet we're sending.
    SDLRPCPayload *serverTLSPayload = [[SDLRPCPayload alloc] init];
    serverTLSPayload.functionID = 0x02; // TLS Error message
    serverTLSPayload.rpcType = 0x02;
    serverTLSPayload.correlationID = 0x00;

    NSData *binaryData = serverTLSPayload.data;

    // TODO: (Joel F.)[2016-02-15] This is supposed to have some JSON data and json data size
    return [SDLProtocolMessage messageWithHeader:serverMessageHeader andPayload:binaryData];
}

@end

NS_ASSUME_NONNULL_END
