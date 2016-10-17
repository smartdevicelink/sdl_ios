//  SDLOnTouchEvent.m
//

#import "SDLOnTouchEvent.h"

#import "SDLNames.h"
#import "SDLTouchEvent.h"

@implementation SDLOnTouchEvent

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnTouchEvent]) {
    }
    return self;
}

- (void)setType:(SDLTouchType)type {
    if (type != nil) {
        [parameters setObject:type forKey:SDLNameType];
    } else {
        [parameters removeObjectForKey:SDLNameType];
    }
}

- (SDLTouchType)type {
    NSObject *obj = [parameters objectForKey:SDLNameType];
    return (SDLTouchType)obj;
}

- (void)setEvent:(NSMutableArray<SDLTouchEvent *> *)event {
    if (event != nil) {
        [parameters setObject:event forKey:SDLNameEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEvent];
    }
}

- (NSMutableArray<SDLTouchEvent *> *)event {
    NSMutableArray<SDLTouchEvent *> *array = [parameters objectForKey:SDLNameEvent];
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
