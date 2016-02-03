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
        [store setObject:powerModeActive forKey:NAMES_powerModeActive];
    } else {
        [store removeObjectForKey:NAMES_powerModeActive];
    }
}

- (NSNumber *)powerModeActive {
    return [store objectForKey:NAMES_powerModeActive];
}

- (void)setPowerModeQualificationStatus:(SDLPowerModeQualificationStatus *)powerModeQualificationStatus {
    if (powerModeQualificationStatus != nil) {
        [store setObject:powerModeQualificationStatus forKey:NAMES_powerModeQualificationStatus];
    } else {
        [store removeObjectForKey:NAMES_powerModeQualificationStatus];
    }
}

- (SDLPowerModeQualificationStatus *)powerModeQualificationStatus {
    NSObject *obj = [store objectForKey:NAMES_powerModeQualificationStatus];
    if (obj == nil || [obj isKindOfClass:SDLPowerModeQualificationStatus.class]) {
        return (SDLPowerModeQualificationStatus *)obj;
    } else {
        return [SDLPowerModeQualificationStatus valueOf:(NSString *)obj];
    }
}

- (void)setCarModeStatus:(SDLCarModeStatus *)carModeStatus {
    if (carModeStatus != nil) {
        [store setObject:carModeStatus forKey:NAMES_carModeStatus];
    } else {
        [store removeObjectForKey:NAMES_carModeStatus];
    }
}

- (SDLCarModeStatus *)carModeStatus {
    NSObject *obj = [store objectForKey:NAMES_carModeStatus];
    if (obj == nil || [obj isKindOfClass:SDLCarModeStatus.class]) {
        return (SDLCarModeStatus *)obj;
    } else {
        return [SDLCarModeStatus valueOf:(NSString *)obj];
    }
}

- (void)setPowerModeStatus:(SDLPowerModeStatus *)powerModeStatus {
    if (powerModeStatus != nil) {
        [store setObject:powerModeStatus forKey:NAMES_powerModeStatus];
    } else {
        [store removeObjectForKey:NAMES_powerModeStatus];
    }
}

- (SDLPowerModeStatus *)powerModeStatus {
    NSObject *obj = [store objectForKey:NAMES_powerModeStatus];
    if (obj == nil || [obj isKindOfClass:SDLPowerModeStatus.class]) {
        return (SDLPowerModeStatus *)obj;
    } else {
        return [SDLPowerModeStatus valueOf:(NSString *)obj];
    }
}

@end
