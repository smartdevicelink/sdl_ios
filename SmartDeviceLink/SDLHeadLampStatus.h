//  SDLHeadLampStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLAmbientLightStatus.h"


/**
 * Status of the head lamps
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLHeadLampStatus : SDLRPCStruct

/**
 * @abstract A boolean value. Status of the low beam lamps.
 */
@property (strong, nonatomic) NSNumber<SDLBool> *lowBeamsOn;
/**
 * @abstract A boolean value. Status of the high beam lamps.
 */
@property (strong, nonatomic) NSNumber<SDLBool> *highBeamsOn;

@property (nullable, strong, nonatomic) SDLAmbientLightStatus ambientLightSensorStatus;

@end

NS_ASSUME_NONNULL_END
