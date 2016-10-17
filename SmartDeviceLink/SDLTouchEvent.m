//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "SDLNames.h"
#import "SDLTouchCoord.h"

@implementation SDLTouchEvent

- (void)setTouchEventId:(NSNumber *)touchEventId {
    if (touchEventId != nil) {
        [store setObject:touchEventId forKey:SDLNameId];
    } else {
        [store removeObjectForKey:SDLNameId];
    }
}

- (NSNumber *)touchEventId {
    return [store objectForKey:SDLNameId];
}

- (void)setTimeStamp:(NSMutableArray<NSNumber *> *)timeStamp {
    if (timeStamp != nil) {
        [store setObject:timeStamp forKey:SDLNameTimestamp];
    } else {
        [store removeObjectForKey:SDLNameTimestamp];
    }
}

- (NSMutableArray<NSNumber *> *)timeStamp {
    return [store objectForKey:SDLNameTimestamp];
}

- (void)setCoord:(NSMutableArray<SDLTouchCoord *> *)coord {
    if (coord != nil) {
        [store setObject:coord forKey:SDLNameCoordinate];
    } else {
        [store removeObjectForKey:SDLNameCoordinate];
    }
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
