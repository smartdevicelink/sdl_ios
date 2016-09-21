//
//  SDLLockScreenManager.m
//  SmartDeviceLink
//

#import "SDLLockScreenStatusManager.h"

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

- (void)setHmiLevel:(SDLHMILevel)hmiLevel {
    if (_hmiLevel != hmiLevel) {
        _hmiLevel = hmiLevel;
    }

    if ([hmiLevel isEqualToString:SDLHMILevelFull] || [hmiLevel isEqualToString:SDLHMILevelLimited]) {
        self.userSelected = YES;
    } else if ([hmiLevel isEqualToString:SDLHMILevelNone]) {
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

- (SDLLockScreenStatus)lockScreenStatus {
    if (self.hmiLevel == nil || [self.hmiLevel isEqualToString:SDLHMILevelNone]) {
        // App is not active on the car
        return SDLLockScreenStatusOff;
    } else if ([self.hmiLevel isEqualToString:SDLHMILevelBackground]) {
        // App is in the background on the car
        // The lockscreen depends entirely on if the user selected the app
        if (self.userSelected) {
            return SDLLockScreenStatusRequired;
        } else {
            return SDLLockScreenStatusOff;
        }
    } else if ([self.hmiLevel isEqualToString:SDLHMILevelFull] || [self.hmiLevel isEqualToString:SDLHMILevelLimited]) {
        // App is in the foreground on the car in some manner
        if (self.haveDriverDistractionStatus && !self.driverDistracted) {
            // We have the distraction status, and the driver is not distracted
            return SDLLockScreenStatusOptional;
        } else {
            // We don't have the distraction status, and/or the driver is distracted
            return SDLLockScreenStatusRequired;
        }
    } else {
        // This shouldn't be possible.
        return SDLLockScreenStatusOff;
    }
}

@end
