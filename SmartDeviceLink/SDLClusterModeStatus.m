//  SDLClusterModeStatus.m
//

#import "SDLClusterModeStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClusterModeStatus

- (void)setPowerModeActive:(NSNumber<SDLBool> *)powerModeActive {
    [store sdl_setObject:powerModeActive forName:SDLNamePowerModeActive];
}

- (NSNumber<SDLBool> *)powerModeActive {
    return [store sdl_objectForName:SDLNamePowerModeActive];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    [store sdl_setObject:powerModeQualificationStatus forName:SDLNamePowerModeQualificationStatus];
}

- (SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    return [store sdl_objectForName:SDLNamePowerModeQualificationStatus];
}

- (void)setCarModeStatus:(SDLCarModeStatus)carModeStatus {
    [store sdl_setObject:carModeStatus forName:SDLNameCarModeStatus];
}

- (SDLCarModeStatus)carModeStatus {
    return [store sdl_objectForName:SDLNameCarModeStatus];
}

- (void)setPowerModeStatus:(SDLPowerModeStatus)powerModeStatus {
    [store sdl_setObject:powerModeStatus forName:SDLNamePowerModeStatus];
}

- (SDLPowerModeStatus)powerModeStatus {
    return [store sdl_objectForName:SDLNamePowerModeStatus];
}

@end

NS_ASSUME_NONNULL_END
