//  SDLClusterModeStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLCarModeStatus.h"
#import "SDLPowerModeQualificationStatus.h"
#import "SDLPowerModeStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLClusterModeStatus : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLBool> *powerModeActive;
@property (strong, nonatomic) SDLPowerModeQualificationStatus powerModeQualificationStatus;
@property (strong, nonatomic) SDLCarModeStatus carModeStatus;
@property (strong, nonatomic) SDLPowerModeStatus powerModeStatus;

@end

NS_ASSUME_NONNULL_END
