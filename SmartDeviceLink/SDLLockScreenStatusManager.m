//
//  SDLLockScreenManager.m
//  SmartDeviceLink
//

#import "SDLLockScreenStatusManager.h"

#import "SDLLockScreenStatus.h"
#import "SDLOnLockScreenStatus.h"

NS_ASSUME_NONNULL_BEGIN

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

- (void)setHmiLevel:(nullable SDLHMILevel)hmiLevel {
    if (_hmiLevel != hmiLevel) {
        _hmiLevel = hmiLevel;
    }

    if ([hmiLevel isEqualToEnum:SDLHMILevelFull] || [hmiLevel isEqualToEnum:SDLHMILevelLimited]) {
        self.userSelected = YES;
    } else if ([hmiLevel isEqualToEnum:SDLHMILevelNone]) {
        self.userSelected = NO;
    }
}


#pragma mark Custom Getters

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (SDLOnLockScreenStatus *)lockScreenStatusNotification {
    SDLOnLockScreenStatus *notification = [[SDLOnLockScreenStatus alloc] init];
#pragma clang diagnostic pop
    notification.driverDistractionStatus = @(self.driverDistracted);
    notification.hmiLevel = self.hmiLevel;
    notification.userSelected = @(self.userSelected);
    notification.lockScreenStatus = self.lockScreenStatus;

    return notification;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (SDLLockScreenStatus)lockScreenStatus {
#pragma clang diagnostic pop
    if (self.hmiLevel == nil || [self.hmiLevel isEqualToEnum:SDLHMILevelNone]) {
        // App is not active on the car
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return SDLLockScreenStatusOff;
#pragma clang diagnostic pop
    } else if ([self.hmiLevel isEqualToEnum:SDLHMILevelBackground]) {
        // App is in the background on the car
        if (self.userSelected) {
            // It was user selected
            if (self.haveDriverDistractionStatus && !self.driverDistracted) {
                // We have the distraction status, and the driver is not distracted
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                return SDLLockScreenStatusOptional;
#pragma clang diagnostic pop
            } else {
                // We don't have the distraction status, and/or the driver is distracted
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                return SDLLockScreenStatusRequired;
#pragma clang diagnostic pop
            }
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return SDLLockScreenStatusOff;
#pragma clang diagnostic pop
        }
    } else if ([self.hmiLevel isEqualToEnum:SDLHMILevelFull] || [self.hmiLevel isEqualToEnum:SDLHMILevelLimited]) {
        // App is in the foreground on the car in some manner
        if (self.haveDriverDistractionStatus && !self.driverDistracted) {
            // We have the distraction status, and the driver is not distracted
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return SDLLockScreenStatusOptional;
#pragma clang diagnostic pop
        } else {
            // We don't have the distraction status, and/or the driver is distracted
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return SDLLockScreenStatusRequired;
#pragma clang diagnostic pop
        }
    } else {
        // This shouldn't be possible.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return SDLLockScreenStatusOff;
#pragma clang diagnostic pop
    }
}

@end

NS_ASSUME_NONNULL_END
