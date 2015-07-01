//  SDLSystemAction.m
//


#import "SDLSystemAction.h"

SDLSystemAction *SDLSystemAction_DEFAULT_ACTION = nil;
SDLSystemAction *SDLSystemAction_STEAL_FOCUS = nil;
SDLSystemAction *SDLSystemAction_KEEP_CONTEXT = nil;

NSArray *SDLSystemAction_values = nil;

@implementation SDLSystemAction

+ (SDLSystemAction *)valueOf:(NSString *)value {
    for (SDLSystemAction *item in SDLSystemAction.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLSystemAction_values == nil) {
        SDLSystemAction_values = @[
            SDLSystemAction.DEFAULT_ACTION,
            SDLSystemAction.STEAL_FOCUS,
            SDLSystemAction.KEEP_CONTEXT,
        ];
    }
    return SDLSystemAction_values;
}

+ (SDLSystemAction *)DEFAULT_ACTION {
    if (SDLSystemAction_DEFAULT_ACTION == nil) {
        SDLSystemAction_DEFAULT_ACTION = [[SDLSystemAction alloc] initWithValue:@"DEFAULT_ACTION"];
    }
    return SDLSystemAction_DEFAULT_ACTION;
}

+ (SDLSystemAction *)STEAL_FOCUS {
    if (SDLSystemAction_STEAL_FOCUS == nil) {
        SDLSystemAction_STEAL_FOCUS = [[SDLSystemAction alloc] initWithValue:@"STEAL_FOCUS"];
    }
    return SDLSystemAction_STEAL_FOCUS;
}

+ (SDLSystemAction *)KEEP_CONTEXT {
    if (SDLSystemAction_KEEP_CONTEXT == nil) {
        SDLSystemAction_KEEP_CONTEXT = [[SDLSystemAction alloc] initWithValue:@"KEEP_CONTEXT"];
    }
    return SDLSystemAction_KEEP_CONTEXT;
}

@end
