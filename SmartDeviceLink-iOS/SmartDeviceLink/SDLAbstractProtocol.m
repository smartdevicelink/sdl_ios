//  SDLAbstractProtocol.m

#import "SDLAbstractProtocol.h"

#import "SDLRPCMessage.h"


@implementation SDLAbstractProtocol

- (instancetype)init {
    if (self = [super init]) {
        _debugConsoleGroupName = @"default";
    }
    return self;
}

// Implement in subclasses.
- (void)sendStartSessionWithType:(SDLServiceType)serviceType {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendEndSessionWithType:(SDLServiceType)serviceType {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)sendRPC:(SDLRPCMessage *)message {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendHeartbeat {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)handleBytesFromTransport:(NSData *)receivedData {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendRawDataStream:(NSInputStream *)inputStream withServiceType:(SDLServiceType)serviceType {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)dispose {
    [self doesNotRecognizeSelector:_cmd];
}


#pragma - SDLTransportListener Implementation
- (void)onTransportConnected {
    [self.protocolDelegate onProtocolOpened];
}

- (void)onTransportDisconnected {
    [self.protocolDelegate onProtocolClosed];
}

- (void)onDataReceived:(NSData *)receivedData {
    [self handleBytesFromTransport:receivedData];
}

@end
