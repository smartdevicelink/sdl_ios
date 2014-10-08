//  SDLSmartDeviceLinkV2ProtocolHeader.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLProtocolHeader.h"

@interface SDLV2ProtocolHeader : SDLProtocolHeader

@property (assign) UInt32 messageID;

- (id)init;
- (id)copyWithZone:(NSZone *)zone;
- (NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end
