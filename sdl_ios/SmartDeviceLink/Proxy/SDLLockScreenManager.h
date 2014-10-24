//
//  SDLLockScreenManager.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>
#import "SDLHMILevel.h"
#import "SDLLockScreenStatus.h"
#import "SDLOnLockScreenStatus.h"

@interface SDLLockScreenManager : NSObject

@property (assign, nonatomic) BOOL bUserSelected;
@property (assign, nonatomic) BOOL bDriverDistractionStatus;
@property (strong, nonatomic) SDLHMILevel *hmiLevel;
@property (strong, nonatomic, readonly) SDLLockScreenStatus *lockScreenStatus;
@property (strong, nonatomic, readonly) SDLOnLockScreenStatus *lockScreenStatusNotification;

@end
