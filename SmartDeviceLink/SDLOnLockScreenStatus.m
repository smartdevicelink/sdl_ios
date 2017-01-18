//
//  SDLOnLockScreenStatus.m
//  SmartDeviceLink
//

#import "SDLOnLockScreenStatus.h"

#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnLockScreenStatus

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnLockscreenStatus]) {
    }
    return self;
}

- (void)setLockScreenStatus:(SDLLockScreenStatus)lockScreenStatus {
    if (lockScreenStatus != nil) {
        [parameters setObject:lockScreenStatus forKey:SDLNameOnLockscreenStatus];
    } else {
        [parameters removeObjectForKey:SDLNameOnLockscreenStatus];
    }
}

- (SDLLockScreenStatus)lockScreenStatus {
    NSObject *obj = [parameters objectForKey:SDLNameOnLockscreenStatus];
    return (SDLLockScreenStatus)obj;
}

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    if (hmiLevel != nil) {
        [parameters setObject:hmiLevel forKey:SDLNameHMILevelLowercase];
    } else {
        [parameters removeObjectForKey:SDLNameHMILevelLowercase];
    }
}

- (SDLHMILevel)hmiLevel {
    NSObject *obj = [parameters objectForKey:SDLNameHMILevelLowercase];
    return (SDLHMILevel)obj;
}

- (void)setUserSelected:(NSNumber<SDLBool> *)userSelected {
    if (userSelected != nil) {
        [parameters setObject:userSelected forKey:SDLNameUserSelected];
    } else {
        [parameters removeObjectForKey:SDLNameUserSelected];
    }
}

- (NSNumber<SDLBool> *)userSelected {
    return [parameters objectForKey:SDLNameUserSelected];
}

- (void)setDriverDistractionStatus:(NSNumber<SDLBool> *)driverDistractionStatus {
    if (driverDistractionStatus != nil) {
        [parameters setObject:driverDistractionStatus forKey:SDLNameDriverDistractionStatus];
    } else {
        [parameters removeObjectForKey:SDLNameDriverDistractionStatus];
    }
}

- (NSNumber<SDLBool> *)driverDistractionStatus {
    return [parameters objectForKey:SDLNameDriverDistractionStatus];
}

@end

NS_ASSUME_NONNULL_END
