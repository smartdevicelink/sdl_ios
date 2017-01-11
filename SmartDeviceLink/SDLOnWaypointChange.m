//  SDLOnWaypointChange.m
//

#import "SDLOnWaypointChange.h"

#import "SDLLocationDetails.h"
#import "SDLNames.h"

@implementation SDLOnWayPointChange

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnWaypointChange]) {
    }
    return self;
}

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    if (waypoints != nil) {
        parameters[NAMES_waypoints] = waypoints;
    } else {
        [parameters removeObjectForKey:NAMES_waypoints];
    }
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    NSMutableArray *array = [parameters objectForKey:NAMES_waypoints];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLLocationDetails.class]) {
        return [array copy];
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLLocationDetails alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return [newList copy];
    }
}

@end

@implementation SDLOnWaypointChange

@end
