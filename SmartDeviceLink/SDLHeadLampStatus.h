//  SDLHeadLampStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLAmbientLightStatus.h"


NS_ASSUME_NONNULL_BEGIN

/**
 Vehicle data struct for status of head lamps
 */
@interface SDLHeadLampStatus : SDLRPCStruct

/**
 Low beams are on or off.

 Required, boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *lowBeamsOn;
/**
 High beams are on or off

 Required, boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *highBeamsOn;

/**
 Status of the ambient light senser

 Optional
 */
@property (nullable, strong, nonatomic) SDLAmbientLightStatus ambientLightSensorStatus;

@end

NS_ASSUME_NONNULL_END
