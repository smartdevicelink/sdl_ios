//  SDLTouchType.h
//


#import "SDLEnum.h"

@interface SDLTouchType : SDLEnum {
}

+ (SDLTouchType *)valueOf:(NSString *)value;
+ (NSMutableArray *)values;

+ (SDLTouchType *)BEGIN;
+ (SDLTouchType *)MOVE;
+ (SDLTouchType *)END;

@end
