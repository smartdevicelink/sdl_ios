//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLLockScreenStatus : SDLEnum

+ (SDLLockScreenStatus *)valueOf:(NSString *)value;
+ (NSMutableArray *)values;

+ (SDLLockScreenStatus *)OFF;
+ (SDLLockScreenStatus *)OPTIONAL;
+ (SDLLockScreenStatus *)REQUIRED;

@end
