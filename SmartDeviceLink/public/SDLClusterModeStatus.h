//  SDLClusterModeStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLCarModeStatus.h"
#import "SDLPowerModeQualificationStatus.h"
#import "SDLPowerModeStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data struct for the cluster mode and power status
 */
@interface SDLClusterModeStatus : SDLRPCStruct

/**
 References signal "PowerMode_UB".

 Required
 */
@property (strong, nonatomic) NSNumber<SDLBool> *powerModeActive;

/**
 References signal "PowerModeQF". See PowerModeQualificationStatus.

 Required
 */
@property (strong, nonatomic) SDLPowerModeQualificationStatus powerModeQualificationStatus;

/**
 References signal "CarMode". See CarMode.

 Required
 */
@property (strong, nonatomic) SDLCarModeStatus carModeStatus;

/**
 References signal "PowerMode". See PowerMode.

 Required
 */
@property (strong, nonatomic) SDLPowerModeStatus powerModeStatus;

@end

NS_ASSUME_NONNULL_END
