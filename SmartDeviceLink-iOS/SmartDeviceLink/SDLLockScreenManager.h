//
//  SDLLockScreenManager.h
//  SmartDeviceLink
//

@import Foundation;

@class SDLHMILevel;
@class SDLLockScreenStatus;
@class SDLOnLockScreenStatus;


@interface SDLLockScreenManager : NSObject

@property (assign, nonatomic) BOOL userSelected;
@property (assign, nonatomic) BOOL driverDistracted;
@property (strong, nonatomic) SDLHMILevel *hmiLevel;
@property (strong, nonatomic, readonly) SDLLockScreenStatus *lockScreenStatus;
@property (strong, nonatomic, readonly) SDLOnLockScreenStatus *lockScreenStatusNotification;

@end
