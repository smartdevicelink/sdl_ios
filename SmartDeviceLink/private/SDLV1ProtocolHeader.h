//  SDLSmartDeviceLinkV1ProtocolHeader.h
//


#import "SDLProtocolHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLV1ProtocolHeader : SDLProtocolHeader

- (instancetype)init;
- (NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
