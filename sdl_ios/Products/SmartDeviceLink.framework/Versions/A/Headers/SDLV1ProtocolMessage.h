//  SDLSmartDeviceLinkV1ProtocolMessage.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLProtocolMessage.h"

@interface SDLV1ProtocolMessage : SDLProtocolMessage

- (id)initWithHeader:(SDLProtocolHeader*)header andPayload:(NSData *)payload;
- (NSDictionary *)rpcDictionary;

@end
