//  SDLSmartDeviceLinkV2ProtocolHeader.h
//


#import "SDLProtocolHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLV2ProtocolHeader : SDLProtocolHeader

@property (assign, nonatomic) UInt32 messageID;

- (instancetype)init;
- (instancetype)initWithVersion:(UInt8)version;
- (NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
