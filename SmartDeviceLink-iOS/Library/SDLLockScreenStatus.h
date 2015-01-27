//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//


#import "SDLEnum.h"

@interface SDLLockScreenStatus : SDLEnum

+ (SDLLockScreenStatus *)valueOf:(NSString *)value;
+ (NSMutableArray *)values;

+ (SDLLockScreenStatus *)OFF;
+ (SDLLockScreenStatus *)OPTIONAL;
+ (SDLLockScreenStatus *)REQUIRED;

@end
