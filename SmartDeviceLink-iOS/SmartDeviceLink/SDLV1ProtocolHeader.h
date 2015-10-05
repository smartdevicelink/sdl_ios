//  SDLSmartDeviceLinkV1ProtocolHeader.h
//


#import "SDLProtocolHeader.h"

@interface SDLV1ProtocolHeader : SDLProtocolHeader

- (instancetype)init;
- (NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end
