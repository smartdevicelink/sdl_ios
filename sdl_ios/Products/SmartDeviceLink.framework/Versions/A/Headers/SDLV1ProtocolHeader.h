//  SDLSmartDeviceLinkV1ProtocolHeader.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLProtocolHeader.h"

@interface SDLV1ProtocolHeader : SDLProtocolHeader

- (id)init;
- (NSData *)data;
- (id)copyWithZone:(NSZone *)zone;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end
