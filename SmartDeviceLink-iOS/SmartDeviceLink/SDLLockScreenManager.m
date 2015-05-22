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

    if ([SDLHMILevel.FULL.value isEqualToString:hmiLevel.value] || [SDLHMILevel.LIMITED.value isEqualToString:hmiLevel.value]) {
        _userSelected = YES;
    } else if ([SDLHMILevel.NONE.value isEqualToString:hmiLevel.value]) {
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
    if (_hmiLevel == nil || _hmiLevel == [SDLHMILevel NONE]) {
        return [SDLLockScreenStatus OFF];
    } else if (_hmiLevel == [SDLHMILevel BACKGROUND]) {
        if (!_haveDriverDistractionStatus)
        {
            //we don't have driver distraction, lockscreen is entirely based on userselection
            if (_userSelected)
                return [SDLLockScreenStatus REQUIRED];
            else
                return [SDLLockScreenStatus OFF];
        }
        else if (_haveDriverDistractionStatus && _userSelected)
        {
            return [SDLLockScreenStatus REQUIRED];
        }
        else if (!_haveDriverDistractionStatus && _userSelected)
        {
            return [SDLLockScreenStatus OPTIONAL];
        }
        else
        {
            return [SDLLockScreenStatus OFF];
        }
    } else if (_hmiLevel == [SDLHMILevel FULL] || _hmiLevel == [SDLHMILevel LIMITED]) {
        if (_haveDriverDistractionStatus && !_driverDistracted) {
            return [SDLLockScreenStatus OPTIONAL];
        } else {
            return [SDLLockScreenStatus REQUIRED];
        }

    } else {
        return [SDLLockScreenStatus OFF];
    }
}

@end
