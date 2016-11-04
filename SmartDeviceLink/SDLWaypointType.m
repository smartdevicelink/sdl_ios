//  SDLWaypointType.m
//

#import "SDLWaypointType.h"

SDLWaypointType *SDLWaypointType_ALL = nil;
SDLWaypointType *SDLWaypointType_DESTINATION = nil;

NSArray *SDLWaypointType_values = nil;

@implementation SDLWaypointType

+ (SDLWaypointType *)valueOf:(NSString *)value {
    for (SDLWaypointType *item in SDLWaypointType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLWaypointType_values == nil) {
        SDLWaypointType_values = @[
            SDLWaypointType.ALL,
            SDLWaypointType.DESTINATION,
        ];
    }
    return SDLWaypointType_values;
}

+ (SDLWaypointType *)ALL {
    if (SDLWaypointType_ALL == nil) {
        SDLWaypointType_ALL = [[SDLWaypointType alloc] initWithValue:@"ALL"];
    }
    return SDLWaypointType_ALL;
}

+ (SDLWaypointType *)DESTINATION {
    if (SDLWaypointType_DESTINATION == nil) {
        SDLWaypointType_DESTINATION = [[SDLWaypointType alloc] initWithValue:@"DESTINATION"];
    }
    return SDLWaypointType_DESTINATION;
}

@end
