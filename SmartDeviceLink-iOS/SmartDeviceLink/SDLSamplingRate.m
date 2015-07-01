//  SDLSamplingRate.m
//


#import "SDLSamplingRate.h"

SDLSamplingRate *SDLSamplingRate_8KHZ = nil;
SDLSamplingRate *SDLSamplingRate_16KHZ = nil;
SDLSamplingRate *SDLSamplingRate_22KHZ = nil;
SDLSamplingRate *SDLSamplingRate_44KHZ = nil;

NSArray *SDLSamplingRate_values = nil;

@implementation SDLSamplingRate

+ (SDLSamplingRate *)valueOf:(NSString *)value {
    for (SDLSamplingRate *item in SDLSamplingRate.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLSamplingRate_values == nil) {
        SDLSamplingRate_values = @[
            SDLSamplingRate._8KHZ,
            SDLSamplingRate._16KHZ,
            SDLSamplingRate._22KHZ,
            SDLSamplingRate._44KHZ,
        ];
    }
    return SDLSamplingRate_values;
}

+ (SDLSamplingRate *)_8KHZ {
    if (SDLSamplingRate_8KHZ == nil) {
        SDLSamplingRate_8KHZ = [[SDLSamplingRate alloc] initWithValue:@"8KHZ"];
    }
    return SDLSamplingRate_8KHZ;
}

+ (SDLSamplingRate *)_16KHZ {
    if (SDLSamplingRate_16KHZ == nil) {
        SDLSamplingRate_16KHZ = [[SDLSamplingRate alloc] initWithValue:@"16KHZ"];
    }
    return SDLSamplingRate_16KHZ;
}

+ (SDLSamplingRate *)_22KHZ {
    if (SDLSamplingRate_22KHZ == nil) {
        SDLSamplingRate_22KHZ = [[SDLSamplingRate alloc] initWithValue:@"22KHZ"];
    }
    return SDLSamplingRate_22KHZ;
}

+ (SDLSamplingRate *)_44KHZ {
    if (SDLSamplingRate_44KHZ == nil) {
        SDLSamplingRate_44KHZ = [[SDLSamplingRate alloc] initWithValue:@"44KHZ"];
    }
    return SDLSamplingRate_44KHZ;
}

@end
