//
//  SDLOnLockScreenStatus.h
//  SmartDeviceLink
//

#import "SDLLockScreenStatus.h"

#import "SDLRPCNotification.h"


@class SDLHMILevel;
@class SDLLockScreenStatus;

@interface SDLOnLockScreenStatus : SDLRPCNotification

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property(strong) NSNumber *driverDistractionStatus;
@property(strong) NSNumber *userSelected;
@property(strong) SDLLockScreenStatus *lockScreenStatus;
@property(strong) SDLHMILevel *hmiLevel;

@end
