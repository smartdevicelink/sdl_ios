//  SDLScreenParams.h
//

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLTouchEventCapabilities;

NS_ASSUME_NONNULL_BEGIN

/**
 A struct in DisplayCapabilities describing parameters related to a video / touch input area
 */
@interface SDLScreenParams : SDLRPCStruct

/**
 The resolution of the prescribed screen area

 Required
 */
@property (strong, nonatomic) SDLImageResolution *resolution;

/**
 Types of screen touch events available in screen area

 Optional
 */
@property (nullable, strong, nonatomic) SDLTouchEventCapabilities *touchEventAvailable;

@end

NS_ASSUME_NONNULL_END
