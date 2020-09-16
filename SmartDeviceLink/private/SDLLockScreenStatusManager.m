//
//  SDLLockScreenManager.m
//  SmartDeviceLink
//

#import "SDLLockScreenStatusManager.h"

#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnDriverDistraction.h"
#import "SDLOnHMIStatus.h"
#import "SDLLockScreenStatusInfo.h"
#import "SDLRPCNotificationNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenStatusManager ()

@property (assign, nonatomic) BOOL haveDriverDistractionStatus;
@property (weak, nonatomic) SDLNotificationDispatcher *notificationDispatcher;

@end


@implementation SDLLockScreenStatusManager

#pragma mark - Lifecycle

- (instancetype)initWithNotificationDispatcher:(SDLNotificationDispatcher *)dispatcher {
    self = [super init];
    if (!self) { return nil; }

    _userSelected = NO;
    _driverDistracted = NO;
    _haveDriverDistractionStatus = NO;
    _notificationDispatcher = dispatcher;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusDidUpdate:) name:SDLDidChangeHMIStatusNotification object:dispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_driverDistractionDidUpdate:) name:SDLDidChangeDriverDistractionStateNotification object:dispatcher];

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

- (SDLLockScreenStatusInfo *)lockScreenStatusNotification {
    SDLLockScreenStatusInfo *notification = [[SDLLockScreenStatusInfo alloc] initWithDriverDistractionStatus:@(self.driverDistracted) userSelected:@(self.userSelected) lockScreenStatus:self.lockScreenStatus hmiLevel:self.hmiLevel];
    return notification;
}

- (SDLLockScreenStatus)lockScreenStatus {
    if (self.hmiLevel == nil || [self.hmiLevel isEqualToEnum:SDLHMILevelNone]) {
        // App is not active on the car
        return SDLLockScreenStatusOff;
    } else if ([self.hmiLevel isEqualToEnum:SDLHMILevelBackground]) {
        // App is in the background on the car
        if (self.userSelected) {
            // It was user selected
            if (self.haveDriverDistractionStatus && !self.driverDistracted) {
                // We have the distraction status, and the driver is not distracted
                return SDLLockScreenStatusOptional;
            } else {
                // We don't have the distraction status, and/or the driver is distracted
                return SDLLockScreenStatusRequired;
            }
        } else {
            return SDLLockScreenStatusOff;
        }
    } else if ([self.hmiLevel isEqualToEnum:SDLHMILevelFull] || [self.hmiLevel isEqualToEnum:SDLHMILevelLimited]) {
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

#pragma mark - Utilities

- (void)sdl_postLockScreenStatus:(SDLLockScreenStatusInfo *)statusNotification {
    SDLLogD(@"Lock screen status changed: %@", statusNotification);

    [self.notificationDispatcher postNotificationName:SDLDidChangeLockScreenStatusNotification infoObject:statusNotification];
}

#pragma mark - Observers

- (void)sdl_hmiStatusDidUpdate:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = notification.notification;

    self.hmiLevel = hmiStatus.hmiLevel;
    [self sdl_postLockScreenStatus:self.lockScreenStatusNotification];
}

- (void)sdl_driverDistractionDidUpdate:(SDLRPCNotificationNotification *)notification {
    SDLOnDriverDistraction *driverDistraction = notification.notification;

    self.driverDistracted = [driverDistraction.state isEqualToEnum:SDLDriverDistractionStateOn];
    [self sdl_postLockScreenStatus:self.lockScreenStatusNotification];
}

@end

NS_ASSUME_NONNULL_END
