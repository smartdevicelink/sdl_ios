//
//  SDLLockScreenManager.m
//  SmartDeviceLink
//

#import "SDLLockScreenManager.h"

#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLOnLockScreenStatus.h"


@interface SDLLockScreenManager ()

@property (assign, nonatomic) BOOL bHaveDDStatus;

@end


@implementation SDLLockScreenManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bUserSelected = NO;
        _bDriverDistractionStatus = NO;
        _bHaveDDStatus = NO;
    }
    return self;
}

- (void)setBDriverDistractionStatus:(BOOL)bDriverDistractionStatus
{
    _bDriverDistractionStatus = bDriverDistractionStatus;
    _bHaveDDStatus = YES;
}

- (void)setHmiLevel:(SDLHMILevel *)hmiLevel
{
    if (_hmiLevel != hmiLevel) {
        _hmiLevel = hmiLevel;
    }
    
    if ([hmiLevel isEqualToEnum:[SDLHMILevel FULL]] || [hmiLevel isEqualToEnum:[SDLHMILevel LIMITED]]) {
        _bUserSelected = YES;
    } else if ([hmiLevel isEqualToEnum:[SDLHMILevel NONE]]) {
        _bUserSelected = NO;
    }
}

- (SDLOnLockScreenStatus *)lockScreenStatusNotification {
    SDLOnLockScreenStatus *notification = [SDLOnLockScreenStatus new];
    notification.driverDistractionStatus = [NSNumber numberWithBool:_bDriverDistractionStatus];
    notification.hmiLevel = _hmiLevel;
    NSNumber *userSelected = [NSNumber numberWithBool:_bUserSelected];
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
        if (_bUserSelected) {
            return [SDLLockScreenStatus REQUIRED];
        } else {
            return [SDLLockScreenStatus OFF];
        }
    } else if ([_hmiLevel isEqualToEnum:[SDLHMILevel FULL]] || [_hmiLevel isEqualToEnum:[SDLHMILevel LIMITED]]) {
        // App is in the foreground on the car in some manner
        if (_bHaveDDStatus && !_bDriverDistractionStatus) {
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
