//  SDLPRNDL.m
//


#import "SDLPRNDL.h"

SDLPRNDL *SDLPRNDL_PARK = nil;
SDLPRNDL *SDLPRNDL_REVERSE = nil;
SDLPRNDL *SDLPRNDL_NEUTRAL = nil;
SDLPRNDL *SDLPRNDL_DRIVE = nil;
SDLPRNDL *SDLPRNDL_SPORT = nil;
SDLPRNDL *SDLPRNDL_LOWGEAR = nil;
SDLPRNDL *SDLPRNDL_FIRST = nil;
SDLPRNDL *SDLPRNDL_SECOND = nil;
SDLPRNDL *SDLPRNDL_THIRD = nil;
SDLPRNDL *SDLPRNDL_FOURTH = nil;
SDLPRNDL *SDLPRNDL_FIFTH = nil;
SDLPRNDL *SDLPRNDL_SIXTH = nil;
SDLPRNDL *SDLPRNDL_SEVENTH = nil;
SDLPRNDL *SDLPRNDL_EIGHTH = nil;
SDLPRNDL *SDLPRNDL_UNKNOWN = nil;
SDLPRNDL *SDLPRNDL_FAULT = nil;

NSArray *SDLPRNDL_values = nil;

@implementation SDLPRNDL

+ (SDLPRNDL *)valueOf:(NSString *)value {
    for (SDLPRNDL *item in SDLPRNDL.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLPRNDL_values == nil) {
        SDLPRNDL_values = @[
            SDLPRNDL.PARK,
            SDLPRNDL.REVERSE,
            SDLPRNDL.NEUTRAL,
            SDLPRNDL.DRIVE,
            SDLPRNDL.SPORT,
            SDLPRNDL.LOWGEAR,
            SDLPRNDL.FIRST,
            SDLPRNDL.SECOND,
            SDLPRNDL.THIRD,
            SDLPRNDL.FOURTH,
            SDLPRNDL.FIFTH,
            SDLPRNDL.SIXTH,
            SDLPRNDL.SEVENTH,
            SDLPRNDL.EIGHTH,
            SDLPRNDL.UNKNOWN,
            SDLPRNDL.FAULT,
        ];
    }
    return SDLPRNDL_values;
}

+ (SDLPRNDL *)PARK {
    if (SDLPRNDL_PARK == nil) {
        SDLPRNDL_PARK = [[SDLPRNDL alloc] initWithValue:@"PARK"];
    }
    return SDLPRNDL_PARK;
}

+ (SDLPRNDL *)REVERSE {
    if (SDLPRNDL_REVERSE == nil) {
        SDLPRNDL_REVERSE = [[SDLPRNDL alloc] initWithValue:@"REVERSE"];
    }
    return SDLPRNDL_REVERSE;
}

+ (SDLPRNDL *)NEUTRAL {
    if (SDLPRNDL_NEUTRAL == nil) {
        SDLPRNDL_NEUTRAL = [[SDLPRNDL alloc] initWithValue:@"NEUTRAL"];
    }
    return SDLPRNDL_NEUTRAL;
}

+ (SDLPRNDL *)DRIVE {
    if (SDLPRNDL_DRIVE == nil) {
        SDLPRNDL_DRIVE = [[SDLPRNDL alloc] initWithValue:@"DRIVE"];
    }
    return SDLPRNDL_DRIVE;
}

+ (SDLPRNDL *)SPORT {
    if (SDLPRNDL_SPORT == nil) {
        SDLPRNDL_SPORT = [[SDLPRNDL alloc] initWithValue:@"SPORT"];
    }
    return SDLPRNDL_SPORT;
}

+ (SDLPRNDL *)LOWGEAR {
    if (SDLPRNDL_LOWGEAR == nil) {
        SDLPRNDL_LOWGEAR = [[SDLPRNDL alloc] initWithValue:@"LOWGEAR"];
    }
    return SDLPRNDL_LOWGEAR;
}

+ (SDLPRNDL *)FIRST {
    if (SDLPRNDL_FIRST == nil) {
        SDLPRNDL_FIRST = [[SDLPRNDL alloc] initWithValue:@"FIRST"];
    }
    return SDLPRNDL_FIRST;
}

+ (SDLPRNDL *)SECOND {
    if (SDLPRNDL_SECOND == nil) {
        SDLPRNDL_SECOND = [[SDLPRNDL alloc] initWithValue:@"SECOND"];
    }
    return SDLPRNDL_SECOND;
}

+ (SDLPRNDL *)THIRD {
    if (SDLPRNDL_THIRD == nil) {
        SDLPRNDL_THIRD = [[SDLPRNDL alloc] initWithValue:@"THIRD"];
    }
    return SDLPRNDL_THIRD;
}

+ (SDLPRNDL *)FOURTH {
    if (SDLPRNDL_FOURTH == nil) {
        SDLPRNDL_FOURTH = [[SDLPRNDL alloc] initWithValue:@"FOURTH"];
    }
    return SDLPRNDL_FOURTH;
}

+ (SDLPRNDL *)FIFTH {
    if (SDLPRNDL_FIFTH == nil) {
        SDLPRNDL_FIFTH = [[SDLPRNDL alloc] initWithValue:@"FIFTH"];
    }
    return SDLPRNDL_FIFTH;
}

+ (SDLPRNDL *)SIXTH {
    if (SDLPRNDL_SIXTH == nil) {
        SDLPRNDL_SIXTH = [[SDLPRNDL alloc] initWithValue:@"SIXTH"];
    }
    return SDLPRNDL_SIXTH;
}

+ (SDLPRNDL *)SEVENTH {
    if (SDLPRNDL_SEVENTH == nil) {
        SDLPRNDL_SEVENTH = [[SDLPRNDL alloc] initWithValue:@"SEVENTH"];
    }
    return SDLPRNDL_SEVENTH;
}

+ (SDLPRNDL *)EIGHTH {
    if (SDLPRNDL_EIGHTH == nil) {
        SDLPRNDL_EIGHTH = [[SDLPRNDL alloc] initWithValue:@"EIGHTH"];
    }
    return SDLPRNDL_EIGHTH;
}

+ (SDLPRNDL *)UNKNOWN {
    if (SDLPRNDL_UNKNOWN == nil) {
        SDLPRNDL_UNKNOWN = [[SDLPRNDL alloc] initWithValue:@"UNKNOWN"];
    }
    return SDLPRNDL_UNKNOWN;
}

+ (SDLPRNDL *)FAULT {
    if (SDLPRNDL_FAULT == nil) {
        SDLPRNDL_FAULT = [[SDLPRNDL alloc] initWithValue:@"FAULT"];
    }
    return SDLPRNDL_FAULT;
}

@end
