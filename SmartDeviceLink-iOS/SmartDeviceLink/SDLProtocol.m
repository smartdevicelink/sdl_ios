//  SDLSmartDeviceLinkProtocol.m
//


#import "SDLJsonEncoder.h"
#import "SDLFunctionID.h"

#import "SDLRPCRequest.h"
#import "SDLProtocol.h"
#import "SDLProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLProtocolMessageDisassembler.h"
#import "SDLProtocolRecievedMessageRouter.h"
#import "SDLRPCPayload.h"
#import "SDLDebugTool.h"
#import "SDLPrioritizedObjectCollection.h"


const NSUInteger MAX_TRANSMISSION_SIZE = 1024;
const UInt8 MAX_VERSION_TO_SEND = 3;

@interface SDLProtocol () {
    UInt32 _messageID;
    dispatch_queue_t _recieveQueue;
    dispatch_queue_t _sendQueue;
    SDLPrioritizedObjectCollection *_prioritizedCollection;
    NSMutableDictionary *_sessionIDs;
    BOOL _alreadyDestructed;
}

@property (assign) UInt8 version;
@property (assign) UInt8 maxVersionSupportedByHeadUnit;
@property (strong) NSMutableData *recieveBuffer;
@property (strong) SDLProtocolRecievedMessageRouter *messageRouter;

- (void)sendDataToTransport:(NSData *)data withPriority:(NSInteger)priority;
- (void)logRPCSend:(SDLProtocolMessage *)message;

@end


@implementation SDLProtocol

- (id)init {
    if (self = [super init]) {
        _alreadyDestructed = NO;
        _version = 1;
        _messageID = 0;
        _recieveQueue = dispatch_queue_create("com.ford.applink.protocol.recieve", DISPATCH_QUEUE_SERIAL);
        _sendQueue = dispatch_queue_create("com.ford.applink.protocol.send", DISPATCH_QUEUE_SERIAL);
        _prioritizedCollection = [SDLPrioritizedObjectCollection new];
        _sessionIDs = [NSMutableDictionary new];

        self.messageRouter = [[SDLProtocolRecievedMessageRouter alloc] init];
        self.messageRouter.delegate = self;
    }
    return self;
}

- (void)storeSessionID:(UInt8)sessionID forServiceType:(SDLServiceType)serviceType {
    [_sessionIDs setObject:[NSNumber numberWithUnsignedChar:sessionID] forKey:[NSNumber numberWithUnsignedChar:serviceType]];
}

- (UInt8)retrieveSessionIDforServiceType:(SDLServiceType)serviceType {

    NSNumber *number = _sessionIDs[@(serviceType)];
    if (!number) {
        NSString *logMessage = [NSString stringWithFormat:@"Warning: Tried to retrieve sessionID for serviceType %i, but no sessionID is saved for that service type.", serviceType];
        [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File|SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
    }

    return number?[number unsignedIntegerValue]:0;
}

- (void)sendStartSessionWithType:(SDLServiceType)serviceType {

    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:1];
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_StartSession;

    if ([self retrieveSessionIDforServiceType:SDLServiceType_RPC]) {
        header.sessionID = [self retrieveSessionIDforServiceType:SDLServiceType_RPC];
    }

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];

    [self sendDataToTransport:message.data withPriority:serviceType];
}

- (void)sendEndSessionWithType:(SDLServiceType)serviceType {

    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:self.version];
    header.frameType = SDLFrameType_Control;
    header.serviceType = serviceType;
    header.frameData = SDLFrameData_EndSession;
    header.sessionID = [self retrieveSessionIDforServiceType:serviceType];

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];

    [self sendDataToTransport:message.data withPriority:serviceType];

}

// SDLRPCRequest in from app -> SDLProtocolMessage out to transport layer.
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest {

    NSData *jsonData = [[SDLJsonEncoder instance] encodeDictionary:[rpcRequest serializeAsDictionary:self.version]];
    NSData* messagePayload = nil;

    NSString *logMessage = [NSString stringWithFormat:@"%@", rpcRequest];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];


    if(self.version == 1) {
        messagePayload = jsonData;
    } else if (self.version == 2) {
        // Serialize the RPC data into an NSData
        SDLRPCPayload *rpcPayload = [[SDLRPCPayload alloc] init];
        rpcPayload.rpcType = 0;
        rpcPayload.functionID = [[[[SDLFunctionID alloc] init] getFunctionID:[rpcRequest getFunctionName]] intValue];
        rpcPayload.correlationID = [rpcRequest.correlationID intValue];
        rpcPayload.jsonData = jsonData;
        rpcPayload.binaryData = rpcRequest.bulkData;
        messagePayload = rpcPayload.data;
    }

    //
    // Build the protocol level header & message
    //
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:self.version];
    header.frameType = SDLFrameType_Single;
    header.serviceType = SDLServiceType_RPC;
    header.frameData = SDLFrameData_SingleFrame;
    header.sessionID = [self retrieveSessionIDforServiceType:SDLServiceType_RPC];
    header.bytesInPayload = (UInt32)messagePayload.length;

    // V2+ messages need to have message ID property set.
    if (self.version >= 2) {
        [((SDLV2ProtocolHeader*)header) setMessageID:++_messageID];
    }


    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:messagePayload];


    //
    // See if the message is small enough to send in one transmission.
    // If not, break it up into smaller messages and send.
    //
    if (message.size < MAX_TRANSMISSION_SIZE)
    {
        [self logRPCSend:message];
        [self sendDataToTransport:message.data withPriority:SDLServiceType_RPC];
    }
    else
    {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:message withLimit:MAX_TRANSMISSION_SIZE];
        for (SDLProtocolMessage *smallerMessage in messages) {
            [self logRPCSend:smallerMessage];
            [self sendDataToTransport:smallerMessage.data withPriority:SDLServiceType_RPC];
        }

    }

}

- (void)logRPCSend:(SDLProtocolMessage *)message {
    NSString *logMessage = [NSString stringWithFormat:@"Sending : %@", message];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Protocol toOutput:SDLDebugOutput_File|SDLDebugOutput_DeviceConsole toGroup:self.debugConsoleGroupName];
}

// Use for normal messages
- (void)sendDataToTransport:(NSData *)data withPriority:(NSInteger)priority {

    [_prioritizedCollection addObject:data withPriority:priority];

    dispatch_async(_sendQueue, ^{

        NSData *dataToTransmit = nil;
        while(dataToTransmit = (NSData *)[_prioritizedCollection nextObject])
        {
            [self.transport sendData:dataToTransmit];
        };

    });

}

//
// Turn recieved bytes into message objects.
//
- (void)handleBytesFromTransport:(NSData *)recievedData {

    NSMutableString *logMessage = [[NSMutableString alloc]init];//
    [logMessage appendFormat:@"Received: %ld", (long)recievedData.length];

    // Initialize the recieve buffer which will contain bytes while messages are constructed.
    if (self.recieveBuffer == nil) {
        self.recieveBuffer = [NSMutableData dataWithCapacity:(4 * MAX_TRANSMISSION_SIZE)];
    }

    // Save the data
    [self.recieveBuffer appendData:recievedData];
    [logMessage appendFormat:@"(%ld) ", (long)self.recieveBuffer.length];

    [self processMessages];
}

- (void)processMessages {
    // Get the version
    UInt8 incomingVersion = [SDLProtocolMessage determineVersion:self.recieveBuffer];

    // If we have enough bytes, create the header.
    SDLProtocolHeader* header = [SDLProtocolHeader headerForVersion:incomingVersion];
    NSUInteger headerSize = header.size;
    if (self.recieveBuffer.length >= headerSize) {
        [header parse:self.recieveBuffer];
    } else {
        return;
    }

    // If we have enough bytes, finish building the message.
    SDLProtocolMessage *message = nil;
    NSUInteger payloadSize = header.bytesInPayload;
    NSUInteger messageSize = headerSize + payloadSize;
    if (self.recieveBuffer.length >= messageSize) {
        NSUInteger payloadOffset = headerSize;
        NSUInteger payloadLength = payloadSize;
        NSData *payload = [self.recieveBuffer subdataWithRange:NSMakeRange(payloadOffset, payloadLength)];
        message = [SDLProtocolMessage messageWithHeader:header andPayload:payload];
    } else {
        return;
    }

    // Need to maintain the recieveBuffer, remove the bytes from it which we just processed.
    self.recieveBuffer = [[self.recieveBuffer subdataWithRange:NSMakeRange(messageSize, self.recieveBuffer.length - messageSize)] mutableCopy];

    // Pass on ultimate disposition of the message to the message router.
    dispatch_async(_recieveQueue, ^{
        [self.messageRouter handleRecievedMessage:message];
    });

    // Call recursively until the buffer is empty or incomplete message is encountered
    if (self.recieveBuffer.length > 0)
        [self processMessages];
}

- (void)sendHeartbeat {
    SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:self.version];
    header.frameType = SDLFrameType_Control;
    header.serviceType = 0;
    header.frameData = SDLFrameData_Heartbeat;

    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];

    [self sendDataToTransport:message.data withPriority:header.serviceType];

}

- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType {
    SDLV2ProtocolHeader *header = [SDLV2ProtocolHeader new];
    header.frameType = SDLFrameType_Single;
    header.serviceType = serviceType;
    header.sessionID = [self retrieveSessionIDforServiceType:SDLServiceType_RPC];
    header.bytesInPayload = (UInt32)data.length;
    header.messageID = ++_messageID;
    SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:data];

    if (message.size < MAX_TRANSMISSION_SIZE) {
        [self logRPCSend:message];
        [self sendDataToTransport:message.data withPriority:header.serviceType];
    } else {
        NSArray *messages = [SDLProtocolMessageDisassembler disassemble:message withLimit:MAX_TRANSMISSION_SIZE];
        for (SDLProtocolMessage *smallerMessage in messages) {
            [self logRPCSend:smallerMessage];
            [self sendDataToTransport:smallerMessage.data withPriority:header.serviceType];
        }
    }
}


#pragma mark - SDLProtocolListener Implementation
- (void)handleProtocolSessionStarted:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version {

    [self storeSessionID:sessionID forServiceType:serviceType];

    self.maxVersionSupportedByHeadUnit = version;
    self.version = MIN(self.maxVersionSupportedByHeadUnit, MAX_VERSION_TO_SEND);

    if (self.version >= 3) {
        // start hearbeat
    }

    [self.protocolDelegate handleProtocolSessionStarted:serviceType sessionID:sessionID version:version];
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg {
    [self.protocolDelegate onProtocolMessageReceived:msg];
}

- (void)onProtocolOpened {
    [self.protocolDelegate onProtocolOpened];
}

- (void)onProtocolClosed {
    [self.protocolDelegate onProtocolClosed];
}

- (void)onError:(NSString *)info exception:(NSException *)e {
    [self.protocolDelegate onError:info exception:e];
}

- (void)destructObjects {
    if(!_alreadyDestructed) {
        _alreadyDestructed = YES;
        self.messageRouter.delegate = nil;
        self.messageRouter = nil;
        self.transport = nil;
        self.protocolDelegate = nil;
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
