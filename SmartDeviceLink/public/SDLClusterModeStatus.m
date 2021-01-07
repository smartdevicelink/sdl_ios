//  SDLClusterModeStatus.m
//

#import "SDLClusterModeStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClusterModeStatus

- (instancetype)initWithPowerModeActive:(BOOL)powerModeActive powerModeQualificationStatus:(SDLPowerModeQualificationStatus)powerModeQualificationStatus carModeStatus:(SDLCarModeStatus)carModeStatus powerModeStatus:(SDLPowerModeStatus)powerModeStatus {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.powerModeActive = @(powerModeActive);
    self.powerModeQualificationStatus = powerModeQualificationStatus;
    self.carModeStatus = carModeStatus;
    self.powerModeStatus = powerModeStatus;
    return self;
}

- (void)setPowerModeActive:(NSNumber<SDLBool> *)powerModeActive {
    [self.store sdl_setObject:powerModeActive forName:SDLRPCParameterNamePowerModeActive];
}

- (NSNumber<SDLBool> *)powerModeActive {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNamePowerModeActive ofClass:NSNumber.class error:&error];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    [self.store sdl_setObject:powerModeQualificationStatus forName:SDLRPCParameterNamePowerModeQualificationStatus];
}

- (SDLPowerModeQualificationStatus)powerModeQualificationStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNamePowerModeQualificationStatus error:&error];
}

- (void)setCarModeStatus:(SDLCarModeStatus)carModeStatus {
    [self.store sdl_setObject:carModeStatus forName:SDLRPCParameterNameCarModeStatus];
}

- (SDLCarModeStatus)carModeStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameCarModeStatus error:&error];
}

- (void)setPowerModeStatus:(SDLPowerModeStatus)powerModeStatus {
    [self.store sdl_setObject:powerModeStatus forName:SDLRPCParameterNamePowerModeStatus];
}

- (SDLPowerModeStatus)powerModeStatus {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNamePowerModeStatus error:&error];
}

@end

NS_ASSUME_NONNULL_END
