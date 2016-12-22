//  SDLClusterModeStatus.m
//

#import "SDLClusterModeStatus.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClusterModeStatus

- (void)setPowerModeActive:(NSNumber<SDLBool> *)powerModeActive {
    if (powerModeActive != nil) {
        [store setObject:powerModeActive forKey:SDLNamePowerModeActive];
    } else {
        [store removeObjectForKey:SDLNamePowerModeActive];
    }
}

- (NSNumber<SDLBool> *)powerModeActive {
    return [store objectForKey:SDLNamePowerModeActive];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    if (powerModeQualificationStatus != nil) {
        [store setObject:powerModeQualificationStatus forKey:SDLNamePowerModeQualificationStatus];
    } else {
        [store removeObjectForKey:SDLNamePowerModeQualificationStatus];
    }
}

- (SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    NSObject *obj = [store objectForKey:SDLNamePowerModeQualificationStatus];
    return (SDLPowerModeQualificationStatus)obj;
}

- (void)setCarModeStatus:(SDLCarModeStatus)carModeStatus {
    if (carModeStatus != nil) {
        [store setObject:carModeStatus forKey:SDLNameCarModeStatus];
    } else {
        [store removeObjectForKey:SDLNameCarModeStatus];
    }
}

- (SDLCarModeStatus)carModeStatus {
    NSObject *obj = [store objectForKey:SDLNameCarModeStatus];
    return (SDLCarModeStatus)obj;
}

- (void)setPowerModeStatus:(SDLPowerModeStatus)powerModeStatus {
    if (powerModeStatus != nil) {
        [store setObject:powerModeStatus forKey:SDLNamePowerModeStatus];
    } else {
        [store removeObjectForKey:SDLNamePowerModeStatus];
    }
}

- (SDLPowerModeStatus)powerModeStatus {
    NSObject *obj = [store objectForKey:SDLNamePowerModeStatus];
    return (SDLPowerModeStatus)obj;
}

@end

NS_ASSUME_NONNULL_END
