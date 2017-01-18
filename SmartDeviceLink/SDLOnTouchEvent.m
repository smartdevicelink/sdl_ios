//  SDLOnTouchEvent.m
//

#import "SDLOnTouchEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLTouchEvent.h"

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

- (void)setEvent:(NSMutableArray<SDLTouchEvent *> *)event {
    [parameters sdl_setObject:event forName:SDLNameEvent];
}

- (NSMutableArray<SDLTouchEvent *> *)event {
    NSMutableArray<SDLTouchEvent *> *array = [parameters sdl_objectForName:SDLNameEvent];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTouchEvent.class]) {
        return array;
    } else {
        NSMutableArray<SDLTouchEvent *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTouchEvent alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
