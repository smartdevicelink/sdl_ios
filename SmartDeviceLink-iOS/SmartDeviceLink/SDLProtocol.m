//  SDLProtocol.m
//


#import "SDLJsonEncoder.h"
#import "SDLFunctionID.h"

#import "SDLAbstractTransport.h"
#import "SDLGlobals.h"
#import "SDLRPCRequest.h"
#import "SDLProtocol.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLProtocolMessageDisassembler.h"
#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLRPCPayload.h"
#import "SDLDebugTool.h"
#import "SDLPrioritizedObjectCollection.h"
#import "SDLRPCNotification.h"
#import "SDLRPCResponse.h"
#import "SDLSecurityType.h"
#import "SDLTimer.h"

NSString *const SDLProtocolSecurityErrorDomain = @"com.sdl.protocol.security";

@interface SDLProtocol () {
    UInt32 _messageID;
    dispatch_queue_t _receiveQueue;
    dispatch_queue_t _sendQueue;
    SDLPrioritizedObjectCollection *_prioritizedCollection;
    NSMutableDictionary *_sessionIDs;
    BOOL _alreadyDestructed;
}

@property (assign) UInt8 sessionID;
@property (strong) NSMutableData *receiveBuffer;
@property (strong) SDLProtocolReceivedMessageRouter *messageRouter;
@property (nonatomic) BOOL heartbeatACKed;
@property (nonatomic, strong) SDLTimer *heartbeatTimer;
@property (nonatomic, strong) id<SDLSecurityType> securityManager;

@end


@implementation SDLProtocol

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _messageID = 0;
        _sessionID = 0;
        _heartbeatACKed = NO;
        _receiveQueue = dispatch_queue_create("com.sdl.protocol.receive", DISPATCH_QUEUE_SERIAL);
        _sendQueue = dispatch_queue_create("com.sdl.protocol.transmit", DISPATCH_QUEUE_SERIAL);
        _prioritizedCollection = [[SDLPrioritizedObjectCollection alloc] init];
        _sessionIDs = [NSMutableDictionary new];
        _messageRouter = [[SDLProtocolReceivedMessageRouter alloc] init];
        _messageRouter.delegate = self;
    }

    return self;
}


#pragma mark - Service metadata

- (void)storeSessionID:(UInt8)sessionID forServiceType:(SDLServiceType)serviceType {
    _sessionIDs[@(serviceType)] = @(sessionID);
}

- (UInt8)retrieveSessionIDforServiceType:(SDLServiceType)serviceType {
    NSNumber *number = _sessionIDs[@(serviceType)];
    if (!number) {
        NSString *logMessage = [NSString stringWithFormat:@"Warning: Tried to retrieve sessionID for serviceType %i, but no sessionID is saved for that service type.", serviceType];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File | SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
    }

    return (number ? [number unsignedCharValue] : 0);
}

- (void)sendStartSessionWithType:(SDLServiceType)serviceType {
    [self startServiceWithType:serviceType];
}


#pragma mark - Start Service

- (void)startServiceWithType:(SDLServiceType)serviceType {
    // No encryption, just build and send the message synchronously
    SDLProtocolMessage *message = [self sdl_createStartServiceMessageWithType:serviceType encrypted:NO];
    [self sdl_sendDataToTransport:message.data onService:serviceType];
}

- (void)startEncryptedServiceWithType:(SDLServiceType)serviceType completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    [self sdl_initializeTLSEncryptionWithCompletionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            // We can't start the service because we don't have encryption, return the error
            completionHandler(success, error);
            return; // from block
        }
        
        // TLS initialization succeeded. Build and send the message.
        SDLProtocolMessage *message = [self sdl_createStartServiceMessageWithType:serviceType encrypted:NO];
        [self sdl_sendDataToTransport:message.data onService:serviceType];
    }];
}

- (SDLProtocolMessage *)sdl_createStartServiceMessageWithType:(SDLServiceType)serviceType encrypted:(BOOL)encryption {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    switch (serviceType) {
        case SDLServiceType_RPC: {
            // Need a different header for starting the RPC service
            header = [SDLProtocolHeader headerForVersion:1];
            if ([self retrieveSessionIDforServiceType:SDLServiceType_RPC]) {
                header.sessionID = [self retrieveSessionIDforServiceType:SDLServiceType_RPC];
            }
        } break;
        default: {
            header.sessionID = self.sessionID;
        } break;
    }
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_StartSession;
    
    // Sending a StartSession with the encrypted bit set causes module to initiate SSL Handshake with a ClientHello message, which should be handled by the 'processControlService' method.
    if (encryption) {
        header.encrypted = YES;
    }
    
    return [SDLProtocolMessage messageWithHeader:header andPayload:nil];
}

- (void)sdl_initializeTLSEncryptionWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    if (self.securityManager == nil) {
        [SDLDebugTool logInfo:@"Could not start service, encryption was requested but failed because no security manager has been set."];
        
        if (completionHandler != nil) {
            completionHandler(NO, [NSError errorWithDomain:SDLProtocolSecurityErrorDomain code:SDLProtocolErrorNoSecurityManager userInfo:nil]);
        }
        
        return;
    }
    
    [self.securityManager initializeWithCompletionHandler:^(NSError * _Nullable error) {
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
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_EndSession;
    header.sessionID = [self retrieveSessionIDforServiceType:serviceType];
    
    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];
    [self sdl_sendDataToTransport:message.data onService:serviceType];
}


#pragma mark - Send Data

- (void)sendRPC:(SDLRPCMessage *)message {
    [self sendRPC:message encrypted:NO error:nil];
}

- (void)sendRPC:(SDLRPCMessage *)message encrypted:(BOOL)encryption error:(NSError *__autoreleasing *)error {
    NSParameterAssert(message != nil);
    
    NSData *jsonData = [[SDLJsonEncoder instance] encodeDictionary:[message serializeAsDictionary:[SDLGlobals globals].protocolVersion]];
    NSData *messagePayload = nil;
    
    NSString *logMessage = [NSString stringWithFormat:@"%@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    // Build the message payload. Include the binary header if necessary
    // VERSION DEPENDENT CODE
    switch ([SDLGlobals globals].protocolVersion) {
        case 1: {
            // No binary header in version 1
            messagePayload = jsonData;
        } break;
        case 2: // Fallthrough
        case 3: // Fallthrough
        case 4: {
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
                return;
            }
            
            // If we're trying to encrypt, try to have the security manager encrypt it. Return if it fails.
            // TODO: (Joel F.)[2016-02-09] We should assert if the service isn't setup for encryption. See [#350](https://github.com/smartdevicelink/sdl_ios/issues/350)
            messagePayload = encryption ? [self.securityManager encryptData:rpcPayload.data withError:error] : rpcPayload.data;
            if (!messagePayload) {
                return;
            }
        } break;
        default: {
            NSAssert(NO, @"Attempting to send an RPC based on an unknown version number: %@, message: %@", @([SDLGlobals globals].protocolVersion), message);
        } break;
    }
    
    // Build the protocol level header & message
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    header.encrypted = encryption;
    header.frameType = SDLFrameType_Single;
    header.serviceType = SDLServiceType_RPC;
    header.frameData = SDLFrameData_SingleFrame;
    header.sessionID = [self retrieveSessionIDforServiceType:SDLServiceType_RPC];
    header.bytesInPayload = (UInt32)messagePayload.length;
    
    // V2+ messages need to have message ID property set.
    if ([SDLGlobals globals].protocolVersion >= 2) {
        [((SDLV2ProtocolHeader *)header) setMessageID:++_messageID];
    }
    
    
    SDLProtocolMessage *protocolMessage = [SDLProtocolMessage messageWithHeader:header andPayload:messagePayload];
    
    // See if the message is small enough to send in one transmission. If not, break it up into smaller messages and send.
    if (protocolMessage.size < [SDLGlobals globals].maxMTUSize) {
        [self sdl_logRPCSend:protocolMessage];
        [self sdl_sendDataToTransport:protocolMessage.data onService:SDLServiceType_RPC];
    } else {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:protocolMessage withLimit:[SDLGlobals globals].maxMTUSize];
        for (SDLProtocolMessage *smallerMessage in messages) {
            [self sdl_logRPCSend:smallerMessage];
            [self sdl_sendDataToTransport:smallerMessage.data onService:SDLServiceType_RPC];
        }
    }
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

- (void)sendHeartbeat {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    header.frameType = SDLFrameType_Control;
    header.serviceType = SDLServiceType_Control;
    header.frameData = SDLFrameData_Heartbeat;
    header.sessionID = self.sessionID;
    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];
    [self sdl_sendDataToTransport:message.data onService:header.serviceType];
}

- (void)startHeartbeatTimerWithDuration:(float)duration {
    self.heartbeatTimer = [[SDLTimer alloc] initWithDuration:duration repeat:YES];
    __weak typeof(self) weakSelf = self;
    self.heartbeatTimer.elapsedBlock = ^void() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.heartbeatACKed) {
            strongSelf.heartbeatACKed = NO;
            [strongSelf sendHeartbeat];
        } else {
            NSString *logMessage = [NSString stringWithFormat:@"Heartbeat ack not received. Goodbye."];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:strongSelf.debugConsoleGroupName];
            [strongSelf onProtocolClosed];
        }
    };
    [self.heartbeatTimer start];
}

- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType {
    [self sdl_sendRawData:data onService:serviceType encryption:NO];
}

- (void)sendEncryptedRawData:(NSData *)data onService:(SDLServiceType)serviceType {
    [self sdl_sendRawData:data onService:serviceType encryption:YES];
}

- (void)sdl_sendRawData:(NSData *)data onService:(SDLServiceType)service encryption:(BOOL)encryption {
    SDLV2ProtocolHeader *header = [[SDLV2ProtocolHeader alloc] initWithVersion:[SDLGlobals globals].protocolVersion];
    header.encrypted = encryption;
    header.frameType = SDLFrameType_Single;
    header.serviceType = service;
    header.sessionID = self.sessionID;
    header.bytesInPayload = (UInt32)data.length;
    header.messageID = ++_messageID;
    
    if (encryption) {
        NSError *encryptError = nil;
        data = [self.securityManager encryptData:data withError:&encryptError];
        
        if (encryptError) {
            NSString *encryptLogString = [NSString stringWithFormat:@"Error attempting to encrypt raw data for service: %@, error: %@", @(service), encryptError];
            [SDLDebugTool logInfo:encryptLogString];
        }
    }
    
    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:data];
    
    if (message.size < [SDLGlobals globals].maxMTUSize) {
        [self sdl_logRPCSend:message];
        [self sdl_sendDataToTransport:message.data onService:header.serviceType];
    } else {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:message withLimit:[SDLGlobals globals].maxMTUSize];
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
        self.receiveBuffer = [NSMutableData dataWithCapacity:(4 * [SDLGlobals globals].maxMTUSize)];
    }

    // Save the data
    [self.receiveBuffer appendData:receivedData];

    [self processMessages];
}

- (void)processMessages {
    NSMutableString *logMessage = [[NSMutableString alloc] init];
    UInt8 incomingVersion = [SDLProtocolMessage determineVersion:self.receiveBuffer];

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
        
        // If the message in encrypted, try to decrypt it
        if (header.encrypted) {
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


#pragma mark - SDLProtocolListener Implementation

- (void)handleProtocolStartSessionACK:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version {
    switch (serviceType) {
        case SDLServiceType_RPC: {
            self.sessionID = sessionID;
            [SDLGlobals globals].maxHeadUnitVersion = version;
            if ([SDLGlobals globals].protocolVersion >= 3) {
                self.heartbeatACKed = YES; // Ensures a first heartbeat is sent
                [self startHeartbeatTimerWithDuration:5.0];
            }
        } break;
        default:
            break;
    }

    [self storeSessionID:sessionID forServiceType:serviceType];

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolStartSessionACK:sessionID:version:)]) {
            [listener handleProtocolStartSessionACK:serviceType sessionID:sessionID version:version];
        }
    }
}

- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType {
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolStartSessionNACK:)]) {
            [listener handleProtocolStartSessionNACK:serviceType];
        }
    }
}

- (void)handleProtocolEndSessionACK:(SDLServiceType)serviceType {
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolEndSessionACK:)]) {
            [listener handleProtocolEndSessionACK:serviceType];
        }
    }
}

- (void)handleProtocolEndSessionNACK:(SDLServiceType)serviceType {
    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleProtocolEndSessionNACK:)]) {
            [listener handleProtocolEndSessionNACK:serviceType];
        }
    }
}

- (void)handleHeartbeatForSession:(Byte)session {
    // Respond with a heartbeat ACK
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
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
    self.heartbeatACKed = YES;

    for (id<SDLProtocolListener> listener in self.protocolDelegateTable.allObjects) {
        if ([listener respondsToSelector:@selector(handleHeartbeatACK)]) {
            [listener handleHeartbeatACK];
        }
    }
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg {
    if ([SDLGlobals globals].protocolVersion >= 3 && self.heartbeatTimer != nil) {
        self.heartbeatACKed = YES; // All messages count as heartbeats
        [self.heartbeatTimer start];
    }
    
    // Protocol (non CONTROL frame type) messages with service types are likely TLS handshake messages
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


#pragma mark - TLS Handshake

- (void)sdl_processSecurityMessage:(SDLProtocolMessage *)clientHandshakeMessage {
    if (self.securityManager == nil) {
        NSString *logString = [NSString stringWithFormat:@"Failed to process security message because no security manager is set. Message: %@", clientHandshakeMessage];
        [SDLDebugTool logInfo:logString];
    }
    
    if (clientHandshakeMessage.payload.length <= 12) {
        NSString *logString = [NSString stringWithFormat:@"Security message is malformed, less than 12 bytes. It does not have a protocol header. Message: %@", clientHandshakeMessage];
        [SDLDebugTool logInfo:logString];
    }
    
    // Pull out the client's handshake
    NSData *clientHandshakeData = [clientHandshakeMessage.payload subdataWithRange:NSMakeRange(12, (clientHandshakeMessage.payload.length - 12))];
    
    NSError *handshakeError = nil;
    NSData *serverHandshakeData = [self.securityManager runHandshakeWithClientData:clientHandshakeData error:&handshakeError];
    
    if (serverHandshakeData == nil) {
        NSString *logString = [NSString stringWithFormat:@"Error running TLS handshake procedure. Error: %@", handshakeError];
        [SDLDebugTool logInfo:logString];
        return;
    }
    
    // This can't possibly be a v1 header because v1 does not have control protocol messages
    SDLV2ProtocolHeader *serverMessageHeader = [SDLProtocolHeader headerForVersion:clientHandshakeMessage.header.version];
    serverMessageHeader.encrypted = NO;
    serverMessageHeader.frameType = SDLFrameType_Single;
    serverMessageHeader.serviceType = SDLServiceType_Control;
    serverMessageHeader.frameData = SDLFrameData_SingleFrame;
    serverMessageHeader.sessionID = clientHandshakeMessage.header.sessionID;
    serverMessageHeader.messageID = ++_messageID;
    
    // For a control service packet, we need a binary header with a function ID corresponding to what type of packet we're sending.
    SDLRPCPayload *serverTLSPayload = [[SDLRPCPayload alloc] init];
    serverTLSPayload.functionID = 0x01;
    serverTLSPayload.rpcType = 0x00;
    serverTLSPayload.correlationID = 0x00;
    serverTLSPayload.binaryData = serverHandshakeData;
    
    NSData *binaryData = serverTLSPayload.data;
    serverMessageHeader.bytesInPayload = (UInt32)binaryData.length;
    
    SDLProtocolMessage *serverHandshakeMessage = [SDLProtocolMessage messageWithHeader:serverMessageHeader andPayload:binaryData];
    [self sdl_sendDataToTransport:serverHandshakeMessage.data onService:SDLServiceType_Control];
}


#pragma mark - Lifecycle

- (void)destructObjects {
    if (!_alreadyDestructed) {
        _alreadyDestructed = YES;
        self.messageRouter.delegate = nil;
        self.messageRouter = nil;
        self.transport = nil;
        self.protocolDelegateTable = nil;
        self.heartbeatTimer = nil;
    }
}

- (void)dispose {
    [self destructObjects];
}

- (void)dealloc {
    [self destructObjects];
    [SDLDebugTool logInfo:@"SDLProtocol Dealloc" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

@end
