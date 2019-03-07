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
    NSError *error;
    return [store sdl_objectForName:SDLNamePowerModeActive ofClass:NSNumber.class error:&error];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    [store sdl_setObject:powerModeQualificationStatus forName:SDLNamePowerModeQualificationStatus];
}

- (SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNamePowerModeQualificationStatus error:&error];
}

- (void)setCarModeStatus:(SDLCarModeStatus)carModeStatus {
    [store sdl_setObject:carModeStatus forName:SDLNameCarModeStatus];
}

- (SDLCarModeStatus)carModeStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNameCarModeStatus error:&error];
}

- (void)setPowerModeStatus:(SDLPowerModeStatus)powerModeStatus {
    [store sdl_setObject:powerModeStatus forName:SDLNamePowerModeStatus];
}

- (SDLPowerModeStatus)powerModeStatus {
    NSError *error;
    return [store sdl_enumForName:SDLNamePowerModeStatus error:&error];
}

@end

NS_ASSUME_NONNULL_END
