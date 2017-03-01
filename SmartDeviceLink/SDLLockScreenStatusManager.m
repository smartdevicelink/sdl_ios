//
//  SDLLockScreenManager.m
//  SmartDeviceLink
//

#import "SDLLockScreenStatusManager.h"

#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLOnLockScreenStatus.h"


@interface SDLLockScreenStatusManager ()

@property (assign, nonatomic) BOOL haveDriverDistractionStatus;

@end


@implementation SDLLockScreenStatusManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _userSelected = NO;
        _driverDistracted = NO;
        _haveDriverDistractionStatus = NO;
    }
    return self;
}


#pragma mark - Getters / Setters
#pragma mark Custom setters

- (void)setDriverDistracted:(BOOL)driverDistracted {
    _driverDistracted = driverDistracted;
    _haveDriverDistractionStatus = YES;
}

- (void)setHmiLevel:(SDLHMILevel *)hmiLevel {
    if (_hmiLevel != hmiLevel) {
        _hmiLevel = hmiLevel;
    }

    if ([hmiLevel isEqualToEnum:[SDLHMILevel FULL]] || [hmiLevel isEqualToEnum:[SDLHMILevel LIMITED]]) {
        self.userSelected = YES;
    } else if ([hmiLevel isEqualToEnum:[SDLHMILevel NONE]]) {
        self.userSelected = NO;
    }
}


#pragma mark Custom Getters

- (SDLOnLockScreenStatus *)lockScreenStatusNotification {
    SDLOnLockScreenStatus *notification = [[SDLOnLockScreenStatus alloc] init];
    notification.driverDistractionStatus = @(self.driverDistracted);
    notification.hmiLevel = self.hmiLevel;
    notification.userSelected = @(self.userSelected);
    notification.lockScreenStatus = self.lockScreenStatus;

    return notification;
}

- (SDLLockScreenStatus *)lockScreenStatus {
    if (self.hmiLevel == nil || [self.hmiLevel isEqualToEnum:[SDLHMILevel NONE]]) {
        // App is not active on the car
        return [SDLLockScreenStatus OFF];
    } else if ([self.hmiLevel isEqualToEnum:[SDLHMILevel BACKGROUND]]) {
        // App is in the background on the car
        if (self.userSelected) {
            // It was user selected
            if (self.haveDriverDistractionStatus && !self.driverDistracted) {
                // We have the distraction status, and the driver is not distracted
                return [SDLLockScreenStatus OPTIONAL];
            } else {
                // We don't have the distraction status, and/or the driver is distracted
                return [SDLLockScreenStatus REQUIRED];
            }
        } else {
            // It wasn't user selected
            return [SDLLockScreenStatus OFF];
        }
    } else if ([self.hmiLevel isEqualToEnum:[SDLHMILevel FULL]] || [self.hmiLevel isEqualToEnum:[SDLHMILevel LIMITED]]) {
        // App is in the foreground on the car in some manner
        if (self.haveDriverDistractionStatus && !self.driverDistracted) {
            // We have the distraction status, and the driver is not distracted
            return [SDLLockScreenStatus OPTIONAL];
        } else {
            // We don't have the distraction status, and/or the driver is distracted
            return [SDLLockScreenStatus REQUIRED];
        }
    } else {
        // This shouldn't be possible.
        return [SDLLockScreenStatus OFF];
    }
}

@end
