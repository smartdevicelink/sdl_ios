//  SDLAppLinkV1ProtocolHeader.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAppLinkProtocolHeader.h"

@interface SDLAppLinkV1ProtocolHeader : SDLAppLinkProtocolHeader

- (id)init;
- (NSData *)data;
- (id)copyWithZone:(NSZone *)zone;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end
