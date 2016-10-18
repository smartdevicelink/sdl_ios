//  SDLTouchType.h
//


#import "SDLEnum.h"

@interface SDLTouchType : SDLEnum {
}

+ (SDLTouchType *)valueOf:(NSString *)value;
+ (NSArray<SDLTouchType *> *)values;

+ (SDLTouchType *)BEGIN;
+ (SDLTouchType *)MOVE;
+ (SDLTouchType *)END;

@end
