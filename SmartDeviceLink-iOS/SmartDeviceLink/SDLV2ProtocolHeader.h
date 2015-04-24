//  SDLSmartDeviceLinkV2ProtocolHeader.h
//


#import "SDLProtocolHeader.h"

@interface SDLV2ProtocolHeader : SDLProtocolHeader

@property (assign) UInt32 messageID;

- (instancetype)init;
- (id)copyWithZone:(NSZone *)zone;
- (instancetype)initWithVersion:(UInt8)version;
- (NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end
