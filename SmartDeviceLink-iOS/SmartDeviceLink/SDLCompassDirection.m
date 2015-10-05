//  SDLCompassDirection.m
//


#import "SDLCompassDirection.h"

SDLCompassDirection *SDLCompassDirection_NORTH = nil;
SDLCompassDirection *SDLCompassDirection_NORTHWEST = nil;
SDLCompassDirection *SDLCompassDirection_WEST = nil;
SDLCompassDirection *SDLCompassDirection_SOUTHWEST = nil;
SDLCompassDirection *SDLCompassDirection_SOUTH = nil;
SDLCompassDirection *SDLCompassDirection_SOUTHEAST = nil;
SDLCompassDirection *SDLCompassDirection_EAST = nil;
SDLCompassDirection *SDLCompassDirection_NORTHEAST = nil;

NSArray *SDLCompassDirection_values = nil;

@implementation SDLCompassDirection

+ (SDLCompassDirection *)valueOf:(NSString *)value {
    for (SDLCompassDirection *item in SDLCompassDirection.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLCompassDirection_values == nil) {
        SDLCompassDirection_values = @[
            SDLCompassDirection.NORTH,
            SDLCompassDirection.NORTHWEST,
            SDLCompassDirection.WEST,
            SDLCompassDirection.SOUTHWEST,
            SDLCompassDirection.SOUTH,
            SDLCompassDirection.SOUTHEAST,
            SDLCompassDirection.EAST,
            SDLCompassDirection.NORTHEAST,
        ];
    }
    return SDLCompassDirection_values;
}

+ (SDLCompassDirection *)NORTH {
    if (SDLCompassDirection_NORTH == nil) {
        SDLCompassDirection_NORTH = [[SDLCompassDirection alloc] initWithValue:@"NORTH"];
    }
    return SDLCompassDirection_NORTH;
}

+ (SDLCompassDirection *)NORTHWEST {
    if (SDLCompassDirection_NORTHWEST == nil) {
        SDLCompassDirection_NORTHWEST = [[SDLCompassDirection alloc] initWithValue:@"NORTHWEST"];
    }
    return SDLCompassDirection_NORTHWEST;
}

+ (SDLCompassDirection *)WEST {
    if (SDLCompassDirection_WEST == nil) {
        SDLCompassDirection_WEST = [[SDLCompassDirection alloc] initWithValue:@"WEST"];
    }
    return SDLCompassDirection_WEST;
}

+ (SDLCompassDirection *)SOUTHWEST {
    if (SDLCompassDirection_SOUTHWEST == nil) {
        SDLCompassDirection_SOUTHWEST = [[SDLCompassDirection alloc] initWithValue:@"SOUTHWEST"];
    }
    return SDLCompassDirection_SOUTHWEST;
}

+ (SDLCompassDirection *)SOUTH {
    if (SDLCompassDirection_SOUTH == nil) {
        SDLCompassDirection_SOUTH = [[SDLCompassDirection alloc] initWithValue:@"SOUTH"];
    }
    return SDLCompassDirection_SOUTH;
}

+ (SDLCompassDirection *)SOUTHEAST {
    if (SDLCompassDirection_SOUTHEAST == nil) {
        SDLCompassDirection_SOUTHEAST = [[SDLCompassDirection alloc] initWithValue:@"SOUTHEAST"];
    }
    return SDLCompassDirection_SOUTHEAST;
}

+ (SDLCompassDirection *)EAST {
    if (SDLCompassDirection_EAST == nil) {
        SDLCompassDirection_EAST = [[SDLCompassDirection alloc] initWithValue:@"EAST"];
    }
    return SDLCompassDirection_EAST;
}

+ (SDLCompassDirection *)NORTHEAST {
    if (SDLCompassDirection_NORTHEAST == nil) {
        SDLCompassDirection_NORTHEAST = [[SDLCompassDirection alloc] initWithValue:@"NORTHEAST"];
    }
    return SDLCompassDirection_NORTHEAST;
}

@end
