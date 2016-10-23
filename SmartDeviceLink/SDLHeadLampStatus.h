//  SDLHeadLampStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLAmbientLightStatus.h"


/**
 * Status of the head lamps
 */
@interface SDLHeadLampStatus : SDLRPCStruct

/**
 * @abstract A boolean value. Status of the low beam lamps.
 */
@property (strong) NSNumber<SDLBool> *lowBeamsOn;
/**
 * @abstract A boolean value. Status of the high beam lamps.
 */
@property (strong) NSNumber<SDLBool> *highBeamsOn;

@property (strong) SDLAmbientLightStatus ambientLightSensorStatus;

@end
