//  SDLScreenParams.h
//

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLTouchEventCapabilities;


@interface SDLScreenParams : SDLRPCStruct

@property (strong, nonatomic) SDLImageResolution *resolution;
@property (strong, nonatomic) SDLTouchEventCapabilities *touchEventAvailable;

@end
