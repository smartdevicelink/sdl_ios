//  SDLMediaClockFormat.m
//


#import "SDLMediaClockFormat.h"

SDLMediaClockFormat *SDLMediaClockFormat_CLOCK1 = nil;
SDLMediaClockFormat *SDLMediaClockFormat_CLOCK2 = nil;
SDLMediaClockFormat *SDLMediaClockFormat_CLOCK3 = nil;
SDLMediaClockFormat *SDLMediaClockFormat_CLOCKTEXT1 = nil;
SDLMediaClockFormat *SDLMediaClockFormat_CLOCKTEXT2 = nil;
SDLMediaClockFormat *SDLMediaClockFormat_CLOCKTEXT3 = nil;
SDLMediaClockFormat *SDLMediaClockFormat_CLOCKTEXT4 = nil;

NSArray *SDLMediaClockFormat_values = nil;

@implementation SDLMediaClockFormat

+ (SDLMediaClockFormat *)valueOf:(NSString *)value {
    for (SDLMediaClockFormat *item in SDLMediaClockFormat.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLMediaClockFormat_values == nil) {
        SDLMediaClockFormat_values = @[
            SDLMediaClockFormat.CLOCK1,
            SDLMediaClockFormat.CLOCK2,
            SDLMediaClockFormat.CLOCK3,
            SDLMediaClockFormat.CLOCKTEXT1,
            SDLMediaClockFormat.CLOCKTEXT2,
            SDLMediaClockFormat.CLOCKTEXT3,
            SDLMediaClockFormat.CLOCKTEXT4,
        ];
    }
    return SDLMediaClockFormat_values;
}

+ (SDLMediaClockFormat *)CLOCK1 {
    if (SDLMediaClockFormat_CLOCK1 == nil) {
        SDLMediaClockFormat_CLOCK1 = [[SDLMediaClockFormat alloc] initWithValue:@"CLOCK1"];
    }
    return SDLMediaClockFormat_CLOCK1;
}

+ (SDLMediaClockFormat *)CLOCK2 {
    if (SDLMediaClockFormat_CLOCK2 == nil) {
        SDLMediaClockFormat_CLOCK2 = [[SDLMediaClockFormat alloc] initWithValue:@"CLOCK2"];
    }
    return SDLMediaClockFormat_CLOCK2;
}

+ (SDLMediaClockFormat *)CLOCK3 {
    if (SDLMediaClockFormat_CLOCK3 == nil) {
        SDLMediaClockFormat_CLOCK3 = [[SDLMediaClockFormat alloc] initWithValue:@"CLOCK3"];
    }
    return SDLMediaClockFormat_CLOCK3;
}

+ (SDLMediaClockFormat *)CLOCKTEXT1 {
    if (SDLMediaClockFormat_CLOCKTEXT1 == nil) {
        SDLMediaClockFormat_CLOCKTEXT1 = [[SDLMediaClockFormat alloc] initWithValue:@"CLOCKTEXT1"];
    }
    return SDLMediaClockFormat_CLOCKTEXT1;
}

+ (SDLMediaClockFormat *)CLOCKTEXT2 {
    if (SDLMediaClockFormat_CLOCKTEXT2 == nil) {
        SDLMediaClockFormat_CLOCKTEXT2 = [[SDLMediaClockFormat alloc] initWithValue:@"CLOCKTEXT2"];
    }
    return SDLMediaClockFormat_CLOCKTEXT2;
}

+ (SDLMediaClockFormat *)CLOCKTEXT3 {
    if (SDLMediaClockFormat_CLOCKTEXT3 == nil) {
        SDLMediaClockFormat_CLOCKTEXT3 = [[SDLMediaClockFormat alloc] initWithValue:@"CLOCKTEXT3"];
    }
    return SDLMediaClockFormat_CLOCKTEXT3;
}

+ (SDLMediaClockFormat *)CLOCKTEXT4 {
    if (SDLMediaClockFormat_CLOCKTEXT4 == nil) {
        SDLMediaClockFormat_CLOCKTEXT4 = [[SDLMediaClockFormat alloc] initWithValue:@"CLOCKTEXT4"];
    }
    return SDLMediaClockFormat_CLOCKTEXT4;
}

@end
