//  SDLClusterModeStatus.m
//

#import "SDLClusterModeStatus.h"

#import "SDLCarModeStatus.h"
#import "SDLNames.h"
#import "SDLPowerModeQualificationStatus.h"
#import "SDLPowerModeStatus.h"

@implementation SDLClusterModeStatus

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setPowerModeActive:(NSNumber *)powerModeActive {
    if (powerModeActive != nil) {
        [store setObject:powerModeActive forKey:SDLNamePowerModeActive];
    } else {
        [store removeObjectForKey:SDLNamePowerModeActive];
    }
}

- (NSNumber *)powerModeActive {
    return [store objectForKey:SDLNamePowerModeActive];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus *)powerModeQualificationStatus {
    if (powerModeQualificationStatus != nil) {
        [store setObject:powerModeQualificationStatus forKey:SDLNamePowerModeQualificationStatus];
    } else {
        [store removeObjectForKey:SDLNamePowerModeQualificationStatus];
    }
}

- (SDLPowerModeQualificationStatus *)powerModeQualificationStatus {
    NSObject *obj = [store objectForKey:SDLNamePowerModeQualificationStatus];
    if (obj == nil || [obj isKindOfClass:SDLPowerModeQualificationStatus.class]) {
        return (SDLPowerModeQualificationStatus *)obj;
    } else {
        return [SDLPowerModeQualificationStatus valueOf:(NSString *)obj];
    }
}

- (void)setCarModeStatus:(SDLCarModeStatus *)carModeStatus {
    if (carModeStatus != nil) {
        [store setObject:carModeStatus forKey:SDLNameCarModeStatus];
    } else {
        [store removeObjectForKey:SDLNameCarModeStatus];
    }
}

- (SDLCarModeStatus *)carModeStatus {
    NSObject *obj = [store objectForKey:SDLNameCarModeStatus];
    if (obj == nil || [obj isKindOfClass:SDLCarModeStatus.class]) {
        return (SDLCarModeStatus *)obj;
    } else {
        return [SDLCarModeStatus valueOf:(NSString *)obj];
    }
}

- (void)setPowerModeStatus:(SDLPowerModeStatus *)powerModeStatus {
    if (powerModeStatus != nil) {
        [store setObject:powerModeStatus forKey:SDLNamePowerModeStatus];
    } else {
        [store removeObjectForKey:SDLNamePowerModeStatus];
    }
}

- (SDLPowerModeStatus *)powerModeStatus {
    NSObject *obj = [store objectForKey:SDLNamePowerModeStatus];
    if (obj == nil || [obj isKindOfClass:SDLPowerModeStatus.class]) {
        return (SDLPowerModeStatus *)obj;
    } else {
        return [SDLPowerModeStatus valueOf:(NSString *)obj];
    }
}

@end
