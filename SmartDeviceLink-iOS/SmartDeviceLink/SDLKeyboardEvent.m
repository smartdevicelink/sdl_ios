//  SDLKeyboardEvent.m
//


#import "SDLKeyboardEvent.h"

SDLKeyboardEvent *SDLKeyboardEvent_KEYPRESS = nil;
SDLKeyboardEvent *SDLKeyboardEvent_ENTRY_SUBMITTED = nil;
SDLKeyboardEvent *SDLKeyboardEvent_ENTRY_CANCELLED = nil;
SDLKeyboardEvent *SDLKeyboardEvent_ENTRY_ABORTED = nil;
SDLKeyboardEvent *SDLKeyboardEvent_ENTRY_VOICE = nil;

NSArray *SDLKeyboardEvent_values = nil;

@implementation SDLKeyboardEvent

+ (SDLKeyboardEvent *)valueOf:(NSString *)value {
    for (SDLKeyboardEvent *item in SDLKeyboardEvent.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLKeyboardEvent_values == nil) {
        SDLKeyboardEvent_values = @[
            SDLKeyboardEvent.KEYPRESS,
            SDLKeyboardEvent.ENTRY_SUBMITTED,
            SDLKeyboardEvent.ENTRY_CANCELLED,
            SDLKeyboardEvent.ENTRY_ABORTED,
            SDLKeyboardEvent.ENTRY_VOICE,
        ];
    }
    return SDLKeyboardEvent_values;
}

+ (SDLKeyboardEvent *)KEYPRESS {
    if (SDLKeyboardEvent_KEYPRESS == nil) {
        SDLKeyboardEvent_KEYPRESS = [[SDLKeyboardEvent alloc] initWithValue:@"KEYPRESS"];
    }
    return SDLKeyboardEvent_KEYPRESS;
}

+ (SDLKeyboardEvent *)ENTRY_SUBMITTED {
    if (SDLKeyboardEvent_ENTRY_SUBMITTED == nil) {
        SDLKeyboardEvent_ENTRY_SUBMITTED = [[SDLKeyboardEvent alloc] initWithValue:@"ENTRY_SUBMITTED"];
    }
    return SDLKeyboardEvent_ENTRY_SUBMITTED;
}

+ (SDLKeyboardEvent *)ENTRY_CANCELLED {
    if (SDLKeyboardEvent_ENTRY_CANCELLED == nil) {
        SDLKeyboardEvent_ENTRY_CANCELLED = [[SDLKeyboardEvent alloc] initWithValue:@"ENTRY_CANCELLED"];
    }
    return SDLKeyboardEvent_ENTRY_CANCELLED;
}

+ (SDLKeyboardEvent *)ENTRY_ABORTED {
    if (SDLKeyboardEvent_ENTRY_ABORTED == nil) {
        SDLKeyboardEvent_ENTRY_ABORTED = [[SDLKeyboardEvent alloc] initWithValue:@"ENTRY_ABORTED"];
    }
    return SDLKeyboardEvent_ENTRY_ABORTED;
}

+ (SDLKeyboardEvent *)ENTRY_VOICE {
    if (SDLKeyboardEvent_ENTRY_VOICE == nil) {
        SDLKeyboardEvent_ENTRY_VOICE = [[SDLKeyboardEvent alloc] initWithValue:@"ENTRY_VOICE"];
    }
    return SDLKeyboardEvent_ENTRY_VOICE;
}

@end
