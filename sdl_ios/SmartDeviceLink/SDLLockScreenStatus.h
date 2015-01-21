//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>


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
