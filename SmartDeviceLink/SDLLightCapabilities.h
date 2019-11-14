//  SDLLightCapabilities.h
//

#import "SDLRPCMessage.h"

#import "SDLLightName.h"

NS_ASSUME_NONNULL_BEGIN

/// Current Light capabilities.
///
/// @since RPC 5.0
@interface SDLLightCapabilities : SDLRPCStruct

/**
 Constructs a newly allocated SDLLightCapabilities object with the name of the light or group of lights

 @param name The name of a light or a group of lights
 @return An instance of the SDLLightCapabilities class
 */
- (instancetype)initWithName:(SDLLightName)name;

/**
 Constructs a newly allocated SDLLightCapabilities object with given parameters

 @param name The name of a light or a group of lights
 @param densityAvailable light's density can be set remotely
 @param colorAvailable Light's color can be set remotely by using the RGB color space
 @param statusAvailable whether status is available

 @return An instance of the SDLLightCapabilities class
 */
- (instancetype)initWithName:(SDLLightName)name densityAvailable:(BOOL)densityAvailable colorAvailable:(BOOL)colorAvailable statusAvailable:(BOOL)statusAvailable;

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
 * @abstract Indicates if the light's color can be set remotely by using the RGB color space.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *colorAvailable;

/**
 * @abstract Indicates if the status (ON/OFF) can be set remotely.
 * App shall not use read-only values (RAMP_UP/RAMP_DOWN/UNKNOWN/INVALID) in a setInteriorVehicleData request.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *statusAvailable;

@end

NS_ASSUME_NONNULL_END
