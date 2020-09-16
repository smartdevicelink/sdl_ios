//
//  SDLLockScreenManager.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"

@class SDLNotificationDispatcher;
@class SDLOnLockScreenStatus;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenStatusManager : NSObject

@property (assign, nonatomic) BOOL userSelected;
@property (assign, nonatomic) BOOL driverDistracted;
@property (nullable, strong, nonatomic) SDLHMILevel hmiLevel;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, readonly) SDLLockScreenStatus lockScreenStatus;
@property (strong, nonatomic, readonly) SDLOnLockScreenStatus *lockScreenStatusNotification;
#pragma clang diagnostic pop

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNotificationDispatcher:(SDLNotificationDispatcher *)dispatcher;

@end

NS_ASSUME_NONNULL_END
