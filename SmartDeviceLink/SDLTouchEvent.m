//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "SDLNames.h"
#import "SDLTouchCoord.h"

@implementation SDLTouchEvent

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

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

- (void)setTimeStamp:(NSMutableArray *)timeStamp {
    if (timeStamp != nil) {
        [store setObject:timeStamp forKey:SDLNameTimestamp];
    } else {
        [store removeObjectForKey:SDLNameTimestamp];
    }
}

- (NSMutableArray *)timeStamp {
    return [store objectForKey:SDLNameTimestamp];
}

- (void)setCoord:(NSMutableArray *)coord {
    if (coord != nil) {
        [store setObject:coord forKey:SDLNameCoordinate];
    } else {
        [store removeObjectForKey:SDLNameCoordinate];
    }
}

- (NSMutableArray *)coord {
    NSMutableArray *array = [store objectForKey:SDLNameCoordinate];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTouchCoord.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTouchCoord alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

@end
