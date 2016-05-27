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
        [store setObject:touchEventId forKey:NAMES_id];
    } else {
        [store removeObjectForKey:NAMES_id];
    }
}

- (NSNumber *)touchEventId {
    return [store objectForKey:NAMES_id];
}

- (void)setTimeStamp:(NSMutableArray *)timeStamp {
    if (timeStamp != nil) {
        [store setObject:timeStamp forKey:NAMES_ts];
    } else {
        [store removeObjectForKey:NAMES_ts];
    }
}

- (NSMutableArray *)timeStamp {
    return [store objectForKey:NAMES_ts];
}

- (void)setCoord:(NSMutableArray *)coord {
    if (coord != nil) {
        [store setObject:coord forKey:NAMES_c];
    } else {
        [store removeObjectForKey:NAMES_c];
    }
}

- (NSMutableArray *)coord {
    NSMutableArray *array = [store objectForKey:NAMES_c];
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
