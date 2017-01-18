//  SDLScreenParams.h
//

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLTouchEventCapabilities;

NS_ASSUME_NONNULL_BEGIN

@interface SDLScreenParams : SDLRPCStruct

@property (strong) SDLImageResolution *resolution;
@property (nullable, strong) SDLTouchEventCapabilities *touchEventAvailable;

@end

NS_ASSUME_NONNULL_END
