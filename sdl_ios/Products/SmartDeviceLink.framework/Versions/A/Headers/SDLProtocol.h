//  SDLSmartDeviceLinkProtocol.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAbstractProtocol.h"


@interface SDLProtocol : SDLAbstractProtocol <SDLProtocolListener>

- (void)sendStartSessionWithType:(SDLServiceType)serviceType;
- (void)sendEndSessionWithType:(SDLServiceType)serviceType sessionID:(Byte)sessionID;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest;
- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)sendHeartbeat;

@end
