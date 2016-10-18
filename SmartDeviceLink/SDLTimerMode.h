//  SDLTimerMode.h
//


#import "SDLEnum.h"

@interface SDLTimerMode : SDLEnum {
}

+ (SDLTimerMode *)valueOf:(NSString *)value;
+ (NSArray<SDLTimerMode *> *)values;

+ (SDLTimerMode *)UP;
+ (SDLTimerMode *)DOWN;
+ (SDLTimerMode *)NONE;

@end
