//  SDLOnTouchEvent.m
//

#import "SDLOnTouchEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLTouchEvent.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnTouchEvent

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnTouchEvent]) {
    }
    return self;
}

- (void)setType:(SDLTouchType)type {
    [parameters sdl_setObject:type forName:SDLNameType];
}

- (SDLTouchType)type {
    NSObject *obj = [parameters sdl_objectForName:SDLNameType];
    return (SDLTouchType)obj;
}

- (void)setEvent:(NSArray<SDLTouchEvent *> *)event {
    [parameters sdl_setObject:event forName:SDLNameEvent];
}

- (NSArray<SDLTouchEvent *> *)event {
    return [parameters sdl_objectsForName:SDLNameEvent ofClass:SDLTouchEvent.class];
}

@end

NS_ASSUME_NONNULL_END
