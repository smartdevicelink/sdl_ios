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
    NSError *error;
    return [parameters sdl_enumForName:SDLNameType error:&error];
}

- (void)setEvent:(NSArray<SDLTouchEvent *> *)event {
    [parameters sdl_setObject:event forName:SDLNameEvent];
}

- (NSArray<SDLTouchEvent *> *)event {
    NSError *error;
    return [parameters sdl_objectsForName:SDLNameEvent ofClass:SDLTouchEvent.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
