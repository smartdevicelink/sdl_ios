//  SDLSystemContext.m
//


#import "SDLSystemContext.h"

SDLSystemContext *SDLSystemContext_MAIN = nil;
SDLSystemContext *SDLSystemContext_VRSESSION = nil;
SDLSystemContext *SDLSystemContext_MENU = nil;
SDLSystemContext *SDLSystemContext_HMI_OBSCURED = nil;
SDLSystemContext *SDLSystemContext_ALERT = nil;

NSArray *SDLSystemContext_values = nil;

@implementation SDLSystemContext

+ (SDLSystemContext *)valueOf:(NSString *)value {
    for (SDLSystemContext *item in SDLSystemContext.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLSystemContext_values == nil) {
        SDLSystemContext_values = @[
            SDLSystemContext.MAIN,
            SDLSystemContext.VRSESSION,
            SDLSystemContext.MENU,
            SDLSystemContext.HMI_OBSCURED,
            SDLSystemContext.ALERT,
        ];
    }
    return SDLSystemContext_values;
}

+ (SDLSystemContext *)MAIN {
    if (SDLSystemContext_MAIN == nil) {
        SDLSystemContext_MAIN = [[SDLSystemContext alloc] initWithValue:@"MAIN"];
    }
    return SDLSystemContext_MAIN;
}

+ (SDLSystemContext *)VRSESSION {
    if (SDLSystemContext_VRSESSION == nil) {
        SDLSystemContext_VRSESSION = [[SDLSystemContext alloc] initWithValue:@"VRSESSION"];
    }
    return SDLSystemContext_VRSESSION;
}

+ (SDLSystemContext *)MENU {
    if (SDLSystemContext_MENU == nil) {
        SDLSystemContext_MENU = [[SDLSystemContext alloc] initWithValue:@"MENU"];
    }
    return SDLSystemContext_MENU;
}

+ (SDLSystemContext *)HMI_OBSCURED {
    if (SDLSystemContext_HMI_OBSCURED == nil) {
        SDLSystemContext_HMI_OBSCURED = [[SDLSystemContext alloc] initWithValue:@"HMI_OBSCURED"];
    }
    return SDLSystemContext_HMI_OBSCURED;
}

+ (SDLSystemContext *)ALERT {
    if (SDLSystemContext_ALERT == nil) {
        SDLSystemContext_ALERT = [[SDLSystemContext alloc] initWithValue:@"ALERT"];
    }
    return SDLSystemContext_ALERT;
}

@end
