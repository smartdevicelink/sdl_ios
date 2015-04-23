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

    if ([SDLHMILevel.FULL.value isEqualToString:hmiLevel.value] || [SDLHMILevel.LIMITED.value isEqualToString:hmiLevel.value]) {
        _bUserSelected = YES;
    } else if ([SDLHMILevel.NONE.value isEqualToString:hmiLevel.value]) {
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
    if (_hmiLevel == nil || _hmiLevel == [SDLHMILevel NONE]) {
        return [SDLLockScreenStatus OFF];
    } else if (_hmiLevel == [SDLHMILevel BACKGROUND]) {
        if (!_bHaveDDStatus)
        {
            //we don't have driver distraction, lockscreen is entirely based on userselection
            if (_bUserSelected)
                return [SDLLockScreenStatus REQUIRED];
            else
                return [SDLLockScreenStatus OFF];
        }
        else if (_bHaveDDStatus && _bUserSelected)
        {
            return [SDLLockScreenStatus REQUIRED];
        }
        else if (!_bHaveDDStatus && _bUserSelected)
        {
            return [SDLLockScreenStatus OPTIONAL];
        }
        else
        {
            return [SDLLockScreenStatus OFF];
        }
    } else if (_hmiLevel == [SDLHMILevel FULL] || _hmiLevel == [SDLHMILevel LIMITED]) {
        if (_bHaveDDStatus && !_bDriverDistractionStatus) {
            return [SDLLockScreenStatus OPTIONAL];
        } else {
            return [SDLLockScreenStatus REQUIRED];
        }

    } else {
        return [SDLLockScreenStatus OFF];
    }
}

@end
