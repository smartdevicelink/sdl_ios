//  SDLClusterModeStatus.h
//

#import "SDLRPCMessage.h"

@class SDLCarModeStatus;
@class SDLPowerModeQualificationStatus;
@class SDLPowerModeStatus;


@interface SDLClusterModeStatus : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSNumber *powerModeActive;
@property (strong) SDLPowerModeQualificationStatus *powerModeQualificationStatus;
@property (strong) SDLCarModeStatus *carModeStatus;
@property (strong) SDLPowerModeStatus *powerModeStatus;

@end
