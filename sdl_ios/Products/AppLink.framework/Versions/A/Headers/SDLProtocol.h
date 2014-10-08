//  SDLProtocol.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLProtocolListener.h"
#import "SDLAppLinkProtocolMessage.h"
#import "SDLRPCRequest.h"
#import "SDLTransport.h"
#import "SDLTransportDelegate.h"

@protocol SDLProtocol<SDLTransportDelegate>

@property (weak) id<SDLProtocolListener> protocolDelegate;
@property (strong) id<SDLTransport> transport;

- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)sendStartSessionWithType:(SDLServiceType)sessionType;
- (void)sendEndSessionWithType:(SDLServiceType)sessionType sessionID:(Byte)sessionID;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest;

@end