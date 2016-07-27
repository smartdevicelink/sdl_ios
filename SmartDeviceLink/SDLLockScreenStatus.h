//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//


#import "SDLEnum.h"

@interface SDLLockScreenStatus : SDLEnum
+ (SDLLockScreenStatus *)valueOf:(NSString *)value;
+ (NSMutableArray *)values;
/**
 * LockScreen is Not Required
 */
+ (SDLLockScreenStatus *)OFF;
/**
 * LockScreen is Optional
 */
+ (SDLLockScreenStatus *)OPTIONAL;
/**
 * LockScreen is Not Required
 */
+ (SDLLockScreenStatus *)REQUIRED;
@end
