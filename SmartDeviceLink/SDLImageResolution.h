//  SDLImageResolution.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLImageResolution : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLInt> *resolutionWidth;
@property (strong, nonatomic) NSNumber<SDLInt> *resolutionHeight;

- (instancetype)initWithWidth:(uint16_t)width height:(uint16_t)height;

@end

NS_ASSUME_NONNULL_END
