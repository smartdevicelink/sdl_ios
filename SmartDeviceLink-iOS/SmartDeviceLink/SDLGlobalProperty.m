//  SDLGlobalProperty.m
//


#import "SDLGlobalProperty.h"

SDLGlobalProperty *SDLGlobalProperty_HELPPROMPT = nil;
SDLGlobalProperty *SDLGlobalProperty_TIMEOUTPROMPT = nil;
SDLGlobalProperty *SDLGlobalProperty_VRHELPTITLE = nil;
SDLGlobalProperty *SDLGlobalProperty_VRHELPITEMS = nil;
SDLGlobalProperty *SDLGlobalProperty_MENUNAME = nil;
SDLGlobalProperty *SDLGlobalProperty_MENUICON = nil;
SDLGlobalProperty *SDLGlobalProperty_KEYBOARDPROPERTIES = nil;

NSArray *SDLGlobalProperty_values = nil;

@implementation SDLGlobalProperty

+ (SDLGlobalProperty *)valueOf:(NSString *)value {
    for (SDLGlobalProperty *item in SDLGlobalProperty.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLGlobalProperty_values == nil) {
        SDLGlobalProperty_values = @[
            SDLGlobalProperty.HELPPROMPT,
            SDLGlobalProperty.TIMEOUTPROMPT,
            SDLGlobalProperty.VRHELPTITLE,
            SDLGlobalProperty.VRHELPITEMS,
            SDLGlobalProperty.MENUNAME,
            SDLGlobalProperty.MENUICON,
            SDLGlobalProperty.KEYBOARDPROPERTIES,
        ];
    }
    return SDLGlobalProperty_values;
}

+ (SDLGlobalProperty *)HELPPROMPT {
    if (SDLGlobalProperty_HELPPROMPT == nil) {
        SDLGlobalProperty_HELPPROMPT = [[SDLGlobalProperty alloc] initWithValue:@"HELPPROMPT"];
    }
    return SDLGlobalProperty_HELPPROMPT;
}

+ (SDLGlobalProperty *)TIMEOUTPROMPT {
    if (SDLGlobalProperty_TIMEOUTPROMPT == nil) {
        SDLGlobalProperty_TIMEOUTPROMPT = [[SDLGlobalProperty alloc] initWithValue:@"TIMEOUTPROMPT"];
    }
    return SDLGlobalProperty_TIMEOUTPROMPT;
}

+ (SDLGlobalProperty *)VRHELPTITLE {
    if (SDLGlobalProperty_VRHELPTITLE == nil) {
        SDLGlobalProperty_VRHELPTITLE = [[SDLGlobalProperty alloc] initWithValue:@"VRHELPTITLE"];
    }
    return SDLGlobalProperty_VRHELPTITLE;
}

+ (SDLGlobalProperty *)VRHELPITEMS {
    if (SDLGlobalProperty_VRHELPITEMS == nil) {
        SDLGlobalProperty_VRHELPITEMS = [[SDLGlobalProperty alloc] initWithValue:@"VRHELPITEMS"];
    }
    return SDLGlobalProperty_VRHELPITEMS;
}

+ (SDLGlobalProperty *)MENUNAME {
    if (SDLGlobalProperty_MENUNAME == nil) {
        SDLGlobalProperty_MENUNAME = [[SDLGlobalProperty alloc] initWithValue:@"MENUNAME"];
    }
    return SDLGlobalProperty_MENUNAME;
}

+ (SDLGlobalProperty *)MENUICON {
    if (SDLGlobalProperty_MENUICON == nil) {
        SDLGlobalProperty_MENUICON = [[SDLGlobalProperty alloc] initWithValue:@"MENUICON"];
    }
    return SDLGlobalProperty_MENUICON;
}

+ (SDLGlobalProperty *)KEYBOARDPROPERTIES {
    if (SDLGlobalProperty_KEYBOARDPROPERTIES == nil) {
        SDLGlobalProperty_KEYBOARDPROPERTIES = [[SDLGlobalProperty alloc] initWithValue:@"KEYBOARDPROPERTIES"];
    }
    return SDLGlobalProperty_KEYBOARDPROPERTIES;
}

@end
