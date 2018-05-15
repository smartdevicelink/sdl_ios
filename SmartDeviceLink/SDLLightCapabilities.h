//  SDLLightCapabilities.h
//

#import "SDLRPCMessage.h"

#import "SDLLightName.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLLightCapabilities : SDLRPCStruct

- (instancetype)initWithName:(SDLLightName)name;

- (instancetype)initWithName:(SDLLightName)name desityAvailable:(BOOL)desityAvailable sRGBColorSpaceAvailable:(BOOL)sRGBColorSpaceAvailable;

/**
 * @abstract The name of a light or a group of lights
 *
 * Required, SDLLightName
 */
@property (strong, nonatomic) SDLLightName name;

/**
 * @abstract  Indicates if the light's density can be set remotely (similar to a dimmer).
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *densityAvailable;

/**
 * @abstract Indicates if the light's color can be set remotely by using the sRGB color space.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *sRGBColorSpaceAvailable;

@end

NS_ASSUME_NONNULL_END
