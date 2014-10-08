//  SDLAppLinkV2ProtocolMessage.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAppLinkProtocolMessage.h"

@interface SDLAppLinkV2ProtocolMessage : SDLAppLinkProtocolMessage

- (id)initWithHeader:(SDLAppLinkProtocolHeader*)header andPayload:(NSData *)payload;
- (NSDictionary *)rpcDictionary;

@end
