//  SDLHeadLampStatus.h
//

#import "SDLRPCMessage.h"

@class SDLAmbientLightStatus;


/**
 * Status of the head lamps
 */
@interface SDLHeadLampStatus : SDLRPCStruct {
}
/**
 * @abstract Constructs a new SDLHeadLampStatus object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLHeadLampStatus object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;
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