//  SDLInteractionMode.m
//
//  

#import <SmartDeviceLink/SDLInteractionMode.h>

SDLInteractionMode* SDLInteractionMode_MANUAL_ONLY = nil;
SDLInteractionMode* SDLInteractionMode_VR_ONLY = nil;
SDLInteractionMode* SDLInteractionMode_BOTH = nil;

NSMutableArray* SDLInteractionMode_values = nil;

@implementation SDLInteractionMode

+(SDLInteractionMode*) valueOf:(NSString*) value {
    for (SDLInteractionMode* item in SDLInteractionMode.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLInteractionMode_values == nil) {
        SDLInteractionMode_values = [[NSMutableArray alloc] initWithObjects:
                SDLInteractionMode.MANUAL_ONLY,
                SDLInteractionMode.VR_ONLY,
                SDLInteractionMode.BOTH,
                nil];
    }
    return SDLInteractionMode_values;
}

+(SDLInteractionMode*) MANUAL_ONLY {
    if (SDLInteractionMode_MANUAL_ONLY == nil) {
        SDLInteractionMode_MANUAL_ONLY = [[SDLInteractionMode alloc] initWithValue:@"MANUAL_ONLY"];
    }
    return SDLInteractionMode_MANUAL_ONLY;
}

+(SDLInteractionMode*) VR_ONLY {
    if (SDLInteractionMode_VR_ONLY == nil) {
        SDLInteractionMode_VR_ONLY = [[SDLInteractionMode alloc] initWithValue:@"VR_ONLY"];
    }
    return SDLInteractionMode_VR_ONLY;
}

+(SDLInteractionMode*) BOTH {
    if (SDLInteractionMode_BOTH == nil) {
        SDLInteractionMode_BOTH = [[SDLInteractionMode alloc] initWithValue:@"BOTH"];
    }
    return SDLInteractionMode_BOTH;
}

@end
