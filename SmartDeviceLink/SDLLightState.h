//  SDLLightState.h
//

#import "SDLRPCMessage.h"
#import "SDLLightName.h"
#import "SDLLightStatus.h"

@class SDLSRGBColor;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLightState : SDLRPCStruct

- (instancetype)initWithID:(SDLLightName)id status:(SDLLightStatus)status;

- (instancetype)initWithID:(SDLLightName)id status:(SDLLightStatus)status density:(double)density sRGBColor:(SDLSRGBColor *)sRGBColor;

/**
 * @abstract The name of a light or a group of lights
 *
 * Required, SDLLightName
 */
@property (strong, nonatomic) SDLLightName id;

/**
 * @abstract Reflects the status of Light.
 *
 * Required, SDLLightStatus
 */
@property (strong, nonatomic) SDLLightStatus status;

/**
 * @abstract Reflects the status of Light.
 *
 * Optional, Float type with minValue: 0 maxValue:1
 */
@property (nullable, copy, nonatomic) NSNumber<SDLFloat> *density;

/**
 * @abstract Reflects the status of Light.
 *
 * Optional, SDLLightStatus
 */
@property (nullable, strong, nonatomic) SDLSRGBColor *sRGBColor;

@end

NS_ASSUME_NONNULL_END
