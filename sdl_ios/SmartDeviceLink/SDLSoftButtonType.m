//  SDLSoftButtonType.m
//
//  

#import <SmartDeviceLink/SDLSoftButtonType.h>

SDLSoftButtonType* SDLSoftButtonType_TEXT = nil;
SDLSoftButtonType* SDLSoftButtonType_IMAGE = nil;
SDLSoftButtonType* SDLSoftButtonType_BOTH = nil;

NSMutableArray* SDLSoftButtonType_values = nil;

@implementation SDLSoftButtonType

+(SDLSoftButtonType*) valueOf:(NSString*) value {
    for (SDLSoftButtonType* item in SDLSoftButtonType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLSoftButtonType_values == nil) {
        SDLSoftButtonType_values = [[NSMutableArray alloc] initWithObjects:
                SDLSoftButtonType.TEXT,
                SDLSoftButtonType.IMAGE,
                SDLSoftButtonType.BOTH,
                nil];
    }
    return SDLSoftButtonType_values;
}

+(SDLSoftButtonType*) TEXT {
    if (SDLSoftButtonType_TEXT == nil) {
        SDLSoftButtonType_TEXT = [[SDLSoftButtonType alloc] initWithValue:@"TEXT"];
    }
    return SDLSoftButtonType_TEXT;
}

+(SDLSoftButtonType*) IMAGE {
    if (SDLSoftButtonType_IMAGE == nil) {
        SDLSoftButtonType_IMAGE = [[SDLSoftButtonType alloc] initWithValue:@"IMAGE"];
    }
    return SDLSoftButtonType_IMAGE;
}

+(SDLSoftButtonType*) BOTH {
    if (SDLSoftButtonType_BOTH == nil) {
        SDLSoftButtonType_BOTH = [[SDLSoftButtonType alloc] initWithValue:@"BOTH"];
    }
    return SDLSoftButtonType_BOTH;
}

@end
