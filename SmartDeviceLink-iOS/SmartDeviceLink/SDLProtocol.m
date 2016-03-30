//  SDLProtocol.m
//


#import "SDLJsonEncoder.h"
#import "SDLFunctionID.h"

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
#import "SDLAbstractTransport.h"
#import "SDLTimer.h"


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
@end


@implementation SDLProtocol

- (instancetype)init {
    if (self = [super init]) {
        _messageID = 0;
        _sessionID = 0;
        _receiveQueue = dispatch_queue_create("com.sdl.protocol.receive", DISPATCH_QUEUE_SERIAL);
        _sendQueue = dispatch_queue_create("com.sdl.protocol.transmit", DISPATCH_QUEUE_SERIAL);
        _prioritizedCollection = [[SDLPrioritizedObjectCollection alloc] init];
        _sessionIDs = [NSMutableDictionary new];
        _messageRouter = [[SDLProtocolReceivedMessageRouter alloc] init];
        _messageRouter.delegate = self;
    }

    return self;
}

- (void)sdl_storeSessionID:(UInt8)sessionID forServiceType:(SDLServiceType)serviceType {
    _sessionIDs[@(serviceType)] = @(sessionID);
}

- (void)sdl_removeSessionIdForServiceType:(SDLServiceType)serviceType {
    [_sessionIDs removeObjectForKey:@(serviceType)];
}

- (UInt8)sdl_retrieveSessionIDforServiceType:(SDLServiceType)serviceType {
    NSNumber *number = _sessionIDs[@(serviceType)];
    if (!number) {
        NSString *logMessage = [NSString stringWithFormat:@"Warning: Tried to retrieve sessionID for serviceType %i, but no sessionID is saved for that service type.", serviceType];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File | SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
    }

    return (number ? [number unsignedCharValue] : 0);
}

- (void)sendStartSessionWithType:(SDLServiceType)serviceType {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    switch (serviceType) {
        case SDLServiceType_RPC: {
            // Need a different header for starting the RPC service
            header = [SDLProtocolHeader headerForVersion:1];
            if ([self sdl_retrieveSessionIDforServiceType:SDLServiceType_RPC]) {
                header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceType_RPC];
            }
        } break;
        default: {
            header.sessionID = self.sessionID;
        } break;
    }
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_StartSession;

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];
    [self sendDataToTransport:message.data withPriority:serviceType];
}

- (void)sendEndSessionWithType:(SDLServiceType)serviceType {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_EndSession;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:serviceType];

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];
    [self sendDataToTransport:message.data withPriority:serviceType];
}

- (void)sendRPC:(SDLRPCMessage *)message {
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

            messagePayload = rpcPayload.data;
        } break;
        default: {
            NSAssert(NO, @"Attempting to send an RPC based on an unknown version number: %@, message: %@", @([SDLGlobals globals].protocolVersion), message);
        } break;
    }

    // Build the protocol level header & message
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    header.frameType = SDLFrameType_Single;
    header.serviceType = (message.bulkData.length <= 0) ? SDLServiceType_RPC : SDLServiceType_BulkData;
    header.frameData = SDLFrameData_SingleFrame;
    header.sessionID = [self sdl_retrieveSessionIDforServiceType:SDLServiceType_RPC];
    header.bytesInPayload = (UInt32)messagePayload.length;

    // V2+ messages need to have message ID property set.
    if ([SDLGlobals globals].protocolVersion >= 2) {
        [((SDLV2ProtocolHeader *)header) setMessageID:++_messageID];
    }


    SDLProtocolMessage *protocolMessage = [SDLProtocolMessage messageWithHeader:header andPayload:messagePayload];

    // See if the message is small enough to send in one transmission. If not, break it up into smaller messages and send.
    if (protocolMessage.size < [SDLGlobals globals].maxMTUSize) {
        [self logRPCSend:protocolMessage];
        [self sendDataToTransport:protocolMessage.data withPriority:SDLServiceType_RPC];
    } else {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:protocolMessage withLimit:[SDLGlobals globals].maxMTUSize];
        for (SDLProtocolMessage *smallerMessage in messages) {
            [self logRPCSend:smallerMessage];
            [self sendDataToTransport:smallerMessage.data withPriority:SDLServiceType_RPC];
        }
    }
}

// SDLRPCRequest in from app -> SDLProtocolMessage out to transport layer.
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest {
    [self sendRPC:rpcRequest];
}

- (void)logRPCSend:(SDLProtocolMessage *)message {
    NSString *logMessage = [NSString stringWithFormat:@"Sending : %@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File | SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
}

// Use for normal messages
- (void)sendDataToTransport:(NSData *)data withPriority:(NSInteger)priority {
    [_prioritizedCollection addObject:data withPriority:priority];

    dispatch_async(_sendQueue, ^{
        NSData *dataToTransmit = nil;
        while (dataToTransmit = (NSData *)[_prioritizedCollection nextObject]) {
            [self.transport sendData:dataToTransmit];
        };
    });
}

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
    if (self.receiveBuffer.length > 0)
        [self processMessages];
}

- (void)sendHeartbeat {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:[SDLGlobals globals].protocolVersion];
    header.frameType = SDLFrameType_Control;
    header.serviceType = SDLServiceType_Control;
    header.frameData = SDLFrameData_Heartbeat;
    header.sessionID = self.sessionID;
    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];
    [self sendDataToTransport:message.data withPriority:header.serviceType];
}

- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType {
    SDLV2ProtocolHeader *header = [[SDLV2ProtocolHeader alloc] initWithVersion:[SDLGlobals globals].protocolVersion];
    header.frameType = SDLFrameType_Single;
    header.serviceType = serviceType;
    header.sessionID = self.sessionID;
    header.bytesInPayload = (UInt32)data.length;
    header.messageID = ++_messageID;

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:data];

    if (message.size < [SDLGlobals globals].maxMTUSize) {
        [self logRPCSend:message];
        [self sendDataToTransport:message.data withPriority:header.serviceType];
    } else {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:message withLimit:[SDLGlobals globals].maxMTUSize];
        for (SDLProtocolMessage *smallerMessage in messages) {
            [self logRPCSend:smallerMessage];
            [self sendDataToTransport:smallerMessage.data withPriority:header.serviceType];
        }
    }
}


#pragma mark - SDLProtocolListener Implementation
- (void)handleProtocolStartSessionACK:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version {
    switch (serviceType) {
        case SDLServiceType_RPC: {
            self.sessionID = sessionID;
            [SDLGlobals globals].maxHeadUnitVersion = version;
        } break;
        default:
            break;
    }

    [self sdl_storeSessionID:sessionID forServiceType:serviceType];

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
    // Remove the session id
    [self sdl_removeSessionIdForServiceType:serviceType];
    
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
    [self sendDataToTransport:message.data withPriority:header.serviceType];

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


#pragma mark - Lifecycle

- (void)destructObjects {
    if (!_alreadyDestructed) {
        _alreadyDestructed = YES;
        self.messageRouter.delegate = nil;
        self.messageRouter = nil;
        self.transport = nil;
        self.protocolDelegateTable = nil;
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
