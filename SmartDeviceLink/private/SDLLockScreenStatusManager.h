//
//  SDLLockScreenManager.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

#import "SDLHMILevel.h"
#import "SDLLockScreenConstants.h"

@class SDLLockScreenStatusInfo;
@class SDLNotificationDispatcher;
@class SDLOnDriverDistraction;
@class SDLOnHMIStatus;

NS_ASSUME_NONNULL_BEGIN

static NSString *const SDLDidChangeLockScreenStatusNotification = @"com.sdl.notification.lockScreenStatus";


@interface SDLLockScreenStatusManager : NSObject

@property (assign, nonatomic) BOOL userSelected;
@property (assign, nonatomic) BOOL driverDistracted;
@property (nullable, strong, nonatomic) SDLHMILevel hmiLevel;
@property (assign, nonatomic, readonly) SDLLockScreenStatus lockScreenStatus;
@property (strong, nonatomic, readonly) SDLLockScreenStatusInfo *lockScreenStatusNotification;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNotificationDispatcher:(SDLNotificationDispatcher *)dispatcher;

- (void)updateHMIStatus:(SDLOnHMIStatus *)hmiStatus;
- (void)updateDriverDistractionState:(SDLOnDriverDistraction *)driverDistraction;

@end

NS_ASSUME_NONNULL_END
