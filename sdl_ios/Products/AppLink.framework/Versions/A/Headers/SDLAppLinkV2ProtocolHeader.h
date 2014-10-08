//  SDLAppLinkV2ProtocolHeader.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAppLinkProtocolHeader.h"

@interface SDLAppLinkV2ProtocolHeader : SDLAppLinkProtocolHeader

@property (assign) UInt32 messageID;

- (id)init;
- (id)copyWithZone:(NSZone *)zone;
- (NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end
