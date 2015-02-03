//  SDLKeypressMode.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLKeypressMode.h>

SDLKeypressMode* SDLKeypressMode_SINGLE_KEYPRESS = nil;
SDLKeypressMode* SDLKeypressMode_QUEUE_KEYPRESSES = nil;
SDLKeypressMode* SDLKeypressMode_RESEND_CURRENT_ENTRY = nil;

NSMutableArray* SDLKeypressMode_values = nil;

@implementation SDLKeypressMode

+(SDLKeypressMode*) valueOf:(NSString*) value {
    for (SDLKeypressMode* item in SDLKeypressMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLKeypressMode_values == nil) {
        SDLKeypressMode_values = [[NSMutableArray alloc] initWithObjects:
                SDLKeypressMode.SINGLE_KEYPRESS,
                SDLKeypressMode.QUEUE_KEYPRESSES,
                SDLKeypressMode.RESEND_CURRENT_ENTRY,
                nil];
    }
    return SDLKeypressMode_values;
}

+(SDLKeypressMode*) SINGLE_KEYPRESS {
    if (SDLKeypressMode_SINGLE_KEYPRESS == nil) {
        SDLKeypressMode_SINGLE_KEYPRESS = [[SDLKeypressMode alloc] initWithValue:@"SINGLE_KEYPRESS"];
    }
    return SDLKeypressMode_SINGLE_KEYPRESS;
}

+(SDLKeypressMode*) QUEUE_KEYPRESSES {
    if (SDLKeypressMode_QUEUE_KEYPRESSES == nil) {
        SDLKeypressMode_QUEUE_KEYPRESSES = [[SDLKeypressMode alloc] initWithValue:@"QUEUE_KEYPRESSES"];
    }
    return SDLKeypressMode_QUEUE_KEYPRESSES;
}

+(SDLKeypressMode*) RESEND_CURRENT_ENTRY {
    if (SDLKeypressMode_RESEND_CURRENT_ENTRY == nil) {
        SDLKeypressMode_RESEND_CURRENT_ENTRY = [[SDLKeypressMode alloc] initWithValue:@"RESEND_CURRENT_ENTRY"];
    }
    return SDLKeypressMode_RESEND_CURRENT_ENTRY;
}

@end
