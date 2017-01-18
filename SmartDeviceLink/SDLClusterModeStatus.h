//  SDLClusterModeStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLCarModeStatus.h"
#import "SDLPowerModeQualificationStatus.h"
#import "SDLPowerModeStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLClusterModeStatus : SDLRPCStruct

@property (strong) NSNumber<SDLBool> *powerModeActive;
@property (strong) SDLPowerModeQualificationStatus powerModeQualificationStatus;
@property (strong) SDLCarModeStatus carModeStatus;
@property (strong) SDLPowerModeStatus powerModeStatus;

@end

NS_ASSUME_NONNULL_END
