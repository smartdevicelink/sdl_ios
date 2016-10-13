//  SDLHeadLampStatus.h
//

#import "SDLRPCMessage.h"

@class SDLAmbientLightStatus;


/**
 * Status of the head lamps
 */
@interface SDLHeadLampStatus : SDLRPCStruct

/**
 * @abstract A boolean value. Status of the low beam lamps.
 */
@property (strong) NSNumber *lowBeamsOn;
/**
 * @abstract A boolean value. Status of the high beam lamps.
 */
@property (strong) NSNumber *highBeamsOn;
@property (strong) SDLAmbientLightStatus *ambientLightSensorStatus;
@end
