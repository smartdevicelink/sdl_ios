//
//  SDLOnLockScreenStatus.m
//  SmartDeviceLink
//

#import "SDLOnLockScreenStatus.h"

#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"


@implementation SDLOnLockScreenStatus

- (instancetype)init {
    if (self = [super initWithName:@"OnLockScreenStatus"]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setLockScreenStatus:(SDLLockScreenStatus *)lockScreenStatus {
    if (lockScreenStatus != nil) {
        [parameters setObject:lockScreenStatus forKey:@"OnLockScreenStatus"];
    } else {
        [parameters removeObjectForKey:@"OnLockScreenStatus"];
    }
}

- (SDLLockScreenStatus *)lockScreenStatus {
    NSObject *obj = [parameters objectForKey:@"OnLockScreenStatus"];
    if (obj == nil || [obj isKindOfClass:SDLLockScreenStatus.class]) {
        return (SDLLockScreenStatus *)obj;
    } else {
        return [SDLLockScreenStatus valueOf:(NSString *)obj];
    }
}

- (void)setHmiLevel:(SDLHMILevel *)hmiLevel {
    if (hmiLevel != nil) {
        [parameters setObject:hmiLevel forKey:@"hmilevel"];
    } else {
        [parameters removeObjectForKey:@"hmilevel"];
    }
}

- (SDLHMILevel *)hmiLevel {
    NSObject *obj = [parameters objectForKey:@"hmilevel"];
    if (obj == nil || [obj isKindOfClass:SDLHMILevel.class]) {
        return (SDLHMILevel *)obj;
    } else {
        return [SDLHMILevel valueOf:(NSString *)obj];
    }
}

- (void)setUserSelected:(NSNumber *)userSelected {
    if (userSelected != nil) {
        [parameters setObject:userSelected forKey:@"userselected"];
    } else {
        [parameters removeObjectForKey:@"userselected"];
    }
}

- (NSNumber *)userSelected {
    return [parameters objectForKey:@"userselected"];
}

- (void)setDriverDistractionStatus:(NSNumber *)driverDistractionStatus {
    if (driverDistractionStatus != nil) {
        [parameters setObject:driverDistractionStatus forKey:@"driverdistractionstatus"];
    } else {
        [parameters removeObjectForKey:@"driverdistractionstatus"];
    }
}

- (NSNumber *)driverDistractionStatus {
    return [parameters objectForKey:@"driverdistractionstatus"];
}

@end
