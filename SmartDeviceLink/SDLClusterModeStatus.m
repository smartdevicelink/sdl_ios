//  SDLClusterModeStatus.m
//

#import "SDLClusterModeStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClusterModeStatus

- (void)setPowerModeActive:(NSNumber<SDLBool> *)powerModeActive {
    [store sdl_setObject:powerModeActive forName:SDLRPCParameterNamePowerModeActive];
}

- (NSNumber<SDLBool> *)powerModeActive {
    return [store sdl_objectForName:SDLRPCParameterNamePowerModeActive];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    [store sdl_setObject:powerModeQualificationStatus forName:SDLRPCParameterNamePowerModeQualificationStatus];
}

- (SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    return [store sdl_objectForName:SDLRPCParameterNamePowerModeQualificationStatus];
}

- (void)setCarModeStatus:(SDLCarModeStatus)carModeStatus {
    [store sdl_setObject:carModeStatus forName:SDLRPCParameterNameCarModeStatus];
}

- (SDLCarModeStatus)carModeStatus {
    return [store sdl_objectForName:SDLRPCParameterNameCarModeStatus];
}

- (void)setPowerModeStatus:(SDLPowerModeStatus)powerModeStatus {
    [store sdl_setObject:powerModeStatus forName:SDLRPCParameterNamePowerModeStatus];
}

- (SDLPowerModeStatus)powerModeStatus {
    return [store sdl_objectForName:SDLRPCParameterNamePowerModeStatus];
}

@end

NS_ASSUME_NONNULL_END
