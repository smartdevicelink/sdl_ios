//  FMCAbstractProtocol.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLRPCRequest.h"
#import "SDLAbstractTransport.h"
#import "SDLProtocolListener.h"


@interface SDLAbstractProtocol : NSObject <SDLTransportDelegate>

@property (strong) NSString *debugConsoleGroupName;
@property (weak) SDLAbstractTransport *transport;
@property (weak) id<SDLProtocolListener> protocolDelegate;

// Sending
- (void)sendStartSessionWithType:(SDLServiceType)serviceType;
- (void)sendEndSessionWithType:(SDLServiceType)serviceType;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest;
- (void)sendHeartbeat;
- (void)sendRawDataStream:(NSInputStream *)inputStream withServiceType:(SDLServiceType)serviceType;
- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType;

// Recieving
- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)dispose;

@end
