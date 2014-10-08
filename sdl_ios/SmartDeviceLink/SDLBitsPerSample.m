//  SDLBitsPerSample.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLBitsPerSample.h>

SDLBitsPerSample* SDLBitsPerSample_8_BIT = nil;
SDLBitsPerSample* SDLBitsPerSample_16_BIT = nil;

NSMutableArray* SDLBitsPerSample_values = nil;

@implementation SDLBitsPerSample

+(SDLBitsPerSample*) valueOf:(NSString*) value {
    for (SDLBitsPerSample* item in SDLBitsPerSample.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLBitsPerSample_values == nil) {
        SDLBitsPerSample_values = [[NSMutableArray alloc] initWithObjects:
                SDLBitsPerSample._8_BIT,
                SDLBitsPerSample._16_BIT,
                nil];
    }
    return SDLBitsPerSample_values;
}

+(SDLBitsPerSample*) _8_BIT {
    if (SDLBitsPerSample_8_BIT == nil) {
        SDLBitsPerSample_8_BIT = [[SDLBitsPerSample alloc] initWithValue:@"8_BIT"];
    }
    return SDLBitsPerSample_8_BIT;
}

+(SDLBitsPerSample*) _16_BIT {
    if (SDLBitsPerSample_16_BIT == nil) {
        SDLBitsPerSample_16_BIT = [[SDLBitsPerSample alloc] initWithValue:@"16_BIT"];
    }
    return SDLBitsPerSample_16_BIT;
}

@end
