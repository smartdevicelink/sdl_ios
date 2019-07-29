//
//  SDLLockScreenManager.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"

@class SDLOnLockScreenStatus;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenStatusManager : NSObject

@property (assign, nonatomic) BOOL userSelected;
@property (assign, nonatomic) BOOL driverDistracted;
@property (nullable, strong, nonatomic) SDLHMILevel hmiLevel;
@property (strong, nonatomic, readonly) SDLLockScreenStatus lockScreenStatus;
@property (strong, nonatomic, readonly) SDLOnLockScreenStatus *lockScreenStatusNotification;

@end

NS_ASSUME_NONNULL_END
