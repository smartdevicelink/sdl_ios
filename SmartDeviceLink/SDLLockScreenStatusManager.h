//
//  SDLLockScreenManager.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>

@class SDLHMILevel;
@class SDLLockScreenStatus;
@class SDLOnLockScreenStatus;


@interface SDLLockScreenStatusManager : NSObject

@property (assign, nonatomic) BOOL userSelected;
@property (assign, nonatomic) BOOL driverDistracted;
@property (strong, nonatomic) SDLHMILevel *hmiLevel;
@property (strong, nonatomic, readonly) SDLLockScreenStatus *lockScreenStatus;
@property (strong, nonatomic, readonly) SDLOnLockScreenStatus *lockScreenStatusNotification;

@end
