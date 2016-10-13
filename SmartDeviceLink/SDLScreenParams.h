//  SDLScreenParams.h
//

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLTouchEventCapabilities;


@interface SDLScreenParams : SDLRPCStruct

@property (strong) SDLImageResolution *resolution;
@property (strong) SDLTouchEventCapabilities *touchEventAvailable;

@end
