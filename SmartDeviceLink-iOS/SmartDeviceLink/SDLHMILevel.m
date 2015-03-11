//  SDLHMILevel.m
//


#import "SDLHMILevel.h"

SDLHMILevel* SDLHMILevel_HMI_FULL = nil;
SDLHMILevel* SDLHMILevel_HMI_LIMITED = nil;
SDLHMILevel* SDLHMILevel_HMI_BACKGROUND = nil;
SDLHMILevel* SDLHMILevel_HMI_NONE = nil;

NSArray* SDLHMILevel_values = nil;

@implementation SDLHMILevel

+(SDLHMILevel*) valueOf:(NSString*) value {
    for (SDLHMILevel* item in SDLHMILevel.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSArray*) values {
    if (SDLHMILevel_values == nil) {
        SDLHMILevel_values = @[
                SDLHMILevel.HMI_FULL,
                SDLHMILevel.HMI_LIMITED,
                SDLHMILevel.HMI_BACKGROUND,
                SDLHMILevel.HMI_NONE,
                ];
    }
    return SDLHMILevel_values;
}

+(SDLHMILevel*) HMI_FULL {
    if (SDLHMILevel_HMI_FULL == nil) {
        SDLHMILevel_HMI_FULL = [[SDLHMILevel alloc] initWithValue:@"FULL"];
    }
    return SDLHMILevel_HMI_FULL;
}

+(SDLHMILevel*) HMI_LIMITED {
    if (SDLHMILevel_HMI_LIMITED == nil) {
        SDLHMILevel_HMI_LIMITED = [[SDLHMILevel alloc] initWithValue:@"LIMITED"];
    }
    return SDLHMILevel_HMI_LIMITED;
}

+(SDLHMILevel*) HMI_BACKGROUND {
    if (SDLHMILevel_HMI_BACKGROUND == nil) {
        SDLHMILevel_HMI_BACKGROUND = [[SDLHMILevel alloc] initWithValue:@"BACKGROUND"];
    }
    return SDLHMILevel_HMI_BACKGROUND;
}

+(SDLHMILevel*) HMI_NONE {
    if (SDLHMILevel_HMI_NONE == nil) {
        SDLHMILevel_HMI_NONE = [[SDLHMILevel alloc] initWithValue:@"NONE"];
    }
    return SDLHMILevel_HMI_NONE;
}

@end
