//
//  SDLOnLockScreenStatus.h
//  SmartDeviceLink
//

#import "SDLRPCNotification.h"

@class SDLLockScreenStatus;
@class SDLHMILevel;

@interface SDLOnLockScreenStatus : SDLRPCNotification

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property(strong) NSNumber *driverDistractionStatus;
@property(strong) NSNumber *userSelected;
@property(strong) SDLLockScreenStatus *lockScreenStatus;
@property(strong) SDLHMILevel *hmiLevel;

@end
