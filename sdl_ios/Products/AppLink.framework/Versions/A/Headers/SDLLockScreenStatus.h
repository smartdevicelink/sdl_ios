//
//  SDLLockScreenStatus.h
//  AppLink
//

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLLockScreenStatus : SDLEnum

+ (SDLLockScreenStatus *)valueOf:(NSString *)value;
+ (NSMutableArray *)values;

+ (SDLLockScreenStatus *)OFF;
+ (SDLLockScreenStatus *)OPTIONAL;
+ (SDLLockScreenStatus *)REQUIRED;

@end
