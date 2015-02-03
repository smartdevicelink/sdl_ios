//  SDLAbstractProtocol.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAbstractProtocol.h"

@implementation SDLAbstractProtocol
- (id)init {
    if (self = [super init]) {
        _debugConsoleGroupName = @"default";
    }
    return self;
}

- (void)sendStartSessionWithType:(SDLServiceType)serviceType {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendEndSessionWithType:(SDLServiceType)serviceType sessionID:(Byte)sessionID {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)handleBytesFromTransport:(NSData *)receivedData {
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