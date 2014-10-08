//  SDLButtonEventMode.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLButtonEventMode.h>

SDLButtonEventMode* SDLButtonEventMode_BUTTONUP = nil;
SDLButtonEventMode* SDLButtonEventMode_BUTTONDOWN = nil;

NSMutableArray* SDLButtonEventMode_values = nil;

@implementation SDLButtonEventMode

+(SDLButtonEventMode*) valueOf:(NSString*) value {
    for (SDLButtonEventMode* item in SDLButtonEventMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLButtonEventMode_values == nil) {
        SDLButtonEventMode_values = [[NSMutableArray alloc] initWithObjects:
                SDLButtonEventMode.BUTTONUP,
                SDLButtonEventMode.BUTTONDOWN,
                nil];
    }
    return SDLButtonEventMode_values;
}

+(SDLButtonEventMode*) BUTTONUP {
    if (SDLButtonEventMode_BUTTONUP == nil) {
        SDLButtonEventMode_BUTTONUP = [[SDLButtonEventMode alloc] initWithValue:@"BUTTONUP"];
    }
    return SDLButtonEventMode_BUTTONUP;
}

+(SDLButtonEventMode*) BUTTONDOWN {
    if (SDLButtonEventMode_BUTTONDOWN == nil) {
        SDLButtonEventMode_BUTTONDOWN = [[SDLButtonEventMode alloc] initWithValue:@"BUTTONDOWN"];
    }
    return SDLButtonEventMode_BUTTONDOWN;
}

@end
