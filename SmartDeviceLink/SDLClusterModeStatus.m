//  SDLClusterModeStatus.m
//

#import "SDLClusterModeStatus.h"

#import "SDLNames.h"

@implementation SDLClusterModeStatus

- (void)setPowerModeActive:(NSNumber<SDLBool> *)powerModeActive {
    [self setObject:powerModeActive forName:SDLNamePowerModeActive];
}

- (NSNumber<SDLBool> *)powerModeActive {
    return [self objectForName:SDLNamePowerModeActive];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    [self setObject:powerModeQualificationStatus forName:SDLNamePowerModeQualificationStatus];
}

- (SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    return [self objectForName:SDLNamePowerModeQualificationStatus];
}

- (void)setCarModeStatus:(SDLCarModeStatus)carModeStatus {
    [self setObject:carModeStatus forName:SDLNameCarModeStatus];
}

- (SDLCarModeStatus)carModeStatus {
    return [self objectForName:SDLNameCarModeStatus];
}

- (void)setPowerModeStatus:(SDLPowerModeStatus)powerModeStatus {
    [self setObject:powerModeStatus forName:SDLNamePowerModeStatus];
}

- (SDLPowerModeStatus)powerModeStatus {
    return [self objectForName:SDLNamePowerModeStatus];
}

@end
