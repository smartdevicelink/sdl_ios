//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "SDLNames.h"
#import "SDLTouchCoord.h"

@implementation SDLTouchEvent

- (void)setTouchEventId:(NSNumber<SDLInt> *)touchEventId {
    [self setObject:touchEventId forName:SDLNameId];
}

- (NSNumber<SDLInt> *)touchEventId {
    return [self objectForName:SDLNameId];
}

- (void)setTimeStamp:(NSMutableArray<NSNumber<SDLInt> *> *)timeStamp {
    [self setObject:timeStamp forName:SDLNameTimestamp];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)timeStamp {
    return [self objectForName:SDLNameTimestamp];
}

- (void)setCoord:(NSMutableArray<SDLTouchCoord *> *)coord {
    [self setObject:coord forName:SDLNameCoordinate];
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
