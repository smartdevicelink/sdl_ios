//  SDLHMILevel.m
//


#import "SDLHMILevel.h"

SDLHMILevel *SDLHMILevel_FULL = nil;
SDLHMILevel *SDLHMILevel_LIMITED = nil;
SDLHMILevel *SDLHMILevel_BACKGROUND = nil;
SDLHMILevel *SDLHMILevel_NONE = nil;

NSArray *SDLHMILevel_values = nil;

@implementation SDLHMILevel

+ (SDLHMILevel *)valueOf:(NSString *)value {
    for (SDLHMILevel *item in SDLHMILevel.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLHMILevel_values == nil) {
        SDLHMILevel_values = @[
            [SDLHMILevel FULL],
            [SDLHMILevel LIMITED],
            [SDLHMILevel BACKGROUND],
            [SDLHMILevel NONE]
        ];
    }
    return SDLHMILevel_values;
}

+ (SDLHMILevel *)FULL {
    if (SDLHMILevel_FULL == nil) {
        SDLHMILevel_FULL = [[SDLHMILevel alloc] initWithValue:@"FULL"];
    }
    return SDLHMILevel_FULL;
}

+ (SDLHMILevel *)LIMITED {
    if (SDLHMILevel_LIMITED == nil) {
        SDLHMILevel_LIMITED = [[SDLHMILevel alloc] initWithValue:@"LIMITED"];
    }
    return SDLHMILevel_LIMITED;
}

+ (SDLHMILevel *)BACKGROUND {
    if (SDLHMILevel_BACKGROUND == nil) {
        SDLHMILevel_BACKGROUND = [[SDLHMILevel alloc] initWithValue:@"BACKGROUND"];
    }
    return SDLHMILevel_BACKGROUND;
}

+ (SDLHMILevel *)NONE {
    if (SDLHMILevel_NONE == nil) {
        SDLHMILevel_NONE = [[SDLHMILevel alloc] initWithValue:@"NONE"];
    }
    return SDLHMILevel_NONE;
}

@end
