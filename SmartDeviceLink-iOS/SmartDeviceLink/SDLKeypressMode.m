//  SDLKeypressMode.m
//


#import "SDLKeypressMode.h"

SDLKeypressMode *SDLKeypressMode_SINGLE_KEYPRESS = nil;
SDLKeypressMode *SDLKeypressMode_QUEUE_KEYPRESSES = nil;
SDLKeypressMode *SDLKeypressMode_RESEND_CURRENT_ENTRY = nil;

NSArray *SDLKeypressMode_values = nil;

@implementation SDLKeypressMode

+ (SDLKeypressMode *)valueOf:(NSString *)value {
    for (SDLKeypressMode *item in SDLKeypressMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLKeypressMode_values == nil) {
        SDLKeypressMode_values = @[
            SDLKeypressMode.SINGLE_KEYPRESS,
            SDLKeypressMode.QUEUE_KEYPRESSES,
            SDLKeypressMode.RESEND_CURRENT_ENTRY,
        ];
    }
    return SDLKeypressMode_values;
}

+ (SDLKeypressMode *)SINGLE_KEYPRESS {
    if (SDLKeypressMode_SINGLE_KEYPRESS == nil) {
        SDLKeypressMode_SINGLE_KEYPRESS = [[SDLKeypressMode alloc] initWithValue:@"SINGLE_KEYPRESS"];
    }
    return SDLKeypressMode_SINGLE_KEYPRESS;
}

+ (SDLKeypressMode *)QUEUE_KEYPRESSES {
    if (SDLKeypressMode_QUEUE_KEYPRESSES == nil) {
        SDLKeypressMode_QUEUE_KEYPRESSES = [[SDLKeypressMode alloc] initWithValue:@"QUEUE_KEYPRESSES"];
    }
    return SDLKeypressMode_QUEUE_KEYPRESSES;
}

+ (SDLKeypressMode *)RESEND_CURRENT_ENTRY {
    if (SDLKeypressMode_RESEND_CURRENT_ENTRY == nil) {
        SDLKeypressMode_RESEND_CURRENT_ENTRY = [[SDLKeypressMode alloc] initWithValue:@"RESEND_CURRENT_ENTRY"];
    }
    return SDLKeypressMode_RESEND_CURRENT_ENTRY;
}

@end
