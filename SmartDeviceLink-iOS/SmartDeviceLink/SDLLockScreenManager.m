//
//  SDLLockScreenManager.m
//  SmartDeviceLink
//

#import "SDLLockScreenManager.h"

#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLOnLockScreenStatus.h"


@interface SDLLockScreenManager ()

@property (assign, nonatomic) BOOL haveDriverDistractionStatus;

@end


@implementation SDLLockScreenManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userSelected = NO;
        _driverDistracted = NO;
        _haveDriverDistractionStatus = NO;
    }
    return self;
}

- (void)setDriverDistracted:(BOOL)driverDistracted
{
    _driverDistracted = driverDistracted;
    _haveDriverDistractionStatus = YES;
}

- (void)setHmiLevel:(SDLHMILevel *)hmiLevel
{
    if (_hmiLevel != hmiLevel) {
        _hmiLevel = hmiLevel;
    }
    
    if ([hmiLevel isEqualToEnum:[SDLHMILevel FULL]] || [hmiLevel isEqualToEnum:[SDLHMILevel LIMITED]]) {
        _userSelected = YES;
    } else if ([hmiLevel isEqualToEnum:[SDLHMILevel NONE]]) {
        _userSelected = NO;
    }
}

- (SDLOnLockScreenStatus *)lockScreenStatusNotification {
    NSNumber *userSelected = @(_userSelected);
    
    SDLOnLockScreenStatus *notification = [[SDLOnLockScreenStatus alloc] init];
    notification.driverDistractionStatus = @(_driverDistracted);
    notification.hmiLevel = _hmiLevel;
    notification.userSelected = userSelected;
    notification.lockScreenStatus = [self lockScreenStatus];
    
    return notification;
}

- (SDLLockScreenStatus *)lockScreenStatus
{
    if (_hmiLevel == nil || [_hmiLevel isEqualToEnum:[SDLHMILevel NONE]]) {
        // App is not active on the car
        return [SDLLockScreenStatus OFF];
    } else if ([_hmiLevel isEqualToEnum:[SDLHMILevel BACKGROUND]]) {
        // App is in the background on the car
        // The lockscreen depends entirely on if the user selected the app
        if (_userSelected) {
            return [SDLLockScreenStatus REQUIRED];
        } else {
            return [SDLLockScreenStatus OFF];
        }
    } else if ([_hmiLevel isEqualToEnum:[SDLHMILevel FULL]] || [_hmiLevel isEqualToEnum:[SDLHMILevel LIMITED]]) {
        // App is in the foreground on the car in some manner
        if (_haveDriverDistractionStatus && !_driverDistracted) {
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
