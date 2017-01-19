//  SDLScreenParams.h
//

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLTouchEventCapabilities;

NS_ASSUME_NONNULL_BEGIN

@interface SDLScreenParams : SDLRPCStruct

@property (strong, nonatomic) SDLImageResolution *resolution;
@property (nullable, strong, nonatomic) SDLTouchEventCapabilities *touchEventAvailable;

@end

NS_ASSUME_NONNULL_END
