//  SDLSmartDeviceLinkProtocol.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAbstractProtocol.h"
#import <SmartDeviceLink/SDLRPCMessageType.h>


@interface SDLProtocol : SDLAbstractProtocol <SDLProtocolListener>

- (void)sendStartSessionWithType:(SDLServiceType)serviceType;
- (void)sendEndSessionWithType:(SDLServiceType)serviceType sessionID:(Byte)sessionID;
- (void)sendRPC:(SDLRPCMessage *)message withType:(SDLRPCMessageType)type;
- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)sendHeartbeat;

#pragma mark - Deprecated
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest __deprecated_msg("use -sendRPC:withType: instead");

@end
