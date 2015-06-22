//  SDLBodyInformation.h
//

#import "SDLRPCMessage.h"

@class SDLIgnitionStableStatus;
@class SDLIgnitionStatus;


/**
 * The body information including power modes.
 */
@interface SDLBodyInformation : SDLRPCStruct {
}

/**
 * @abstract Constructs a new SDLBodyInformation object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLBodyInformation object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract References signal "PrkBrkActv_B_Actl".
 */
@property (strong) NSNumber *parkBrakeActive;

/**
 * @abstract References signal "Ignition_Switch_Stable". See IgnitionStableStatus.
 */
@property (strong) SDLIgnitionStableStatus *ignitionStableStatus;

/**
 * @abstract References signal "Ignition_status". See IgnitionStatus.
 */
@property (strong) SDLIgnitionStatus *ignitionStatus;

/**
 * @abstract References signal "DrStatDrv_B_Actl".
 */
@property (strong) NSNumber *driverDoorAjar;

/**
 * @abstract References signal "DrStatPsngr_B_Actl".
 */
@property (strong) NSNumber *passengerDoorAjar;

/**
 * @abstract References signal "DrStatRl_B_Actl".
 */
@property (strong) NSNumber *rearLeftDoorAjar;

/**
 * @abstract References signal "DrStatRr_B_Actl".
 */
@property (strong) NSNumber *rearRightDoorAjar;

@end
