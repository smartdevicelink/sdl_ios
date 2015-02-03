//  SDLSmartDeviceLinkV1ProtocolHeader.h
//
//  

#import "SDLProtocolHeader.h"

@interface SDLV1ProtocolHeader : SDLProtocolHeader

- (id)init;
- (NSData *)data;
- (id)copyWithZone:(NSZone *)zone;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end
