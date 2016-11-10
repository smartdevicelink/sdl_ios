//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "SDLNames.h"
#import "SDLTouchCoord.h"

@implementation SDLTouchEvent

- (void)setTouchEventId:(NSNumber<SDLInt> *)touchEventId {
    [store sdl_setObject:touchEventId forName:SDLNameId];
}

- (NSNumber<SDLInt> *)touchEventId {
    return [store sdl_objectForName:SDLNameId];
}

- (void)setTimeStamp:(NSMutableArray<NSNumber<SDLInt> *> *)timeStamp {
    [store sdl_setObject:timeStamp forName:SDLNameTimestamp];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)timeStamp {
    return [store sdl_objectForName:SDLNameTimestamp];
}

- (void)setCoord:(NSMutableArray<SDLTouchCoord *> *)coord {
    [store sdl_setObject:coord forName:SDLNameCoordinate];
}

- (NSMutableArray<SDLTouchCoord *> *)coord {
    NSMutableArray<SDLTouchCoord *> *array = [store objectForKey:SDLNameCoordinate];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTouchCoord.class]) {
        return array;
    } else {
        NSMutableArray<SDLTouchCoord *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTouchCoord alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
