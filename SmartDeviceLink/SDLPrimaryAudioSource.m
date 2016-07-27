//  SDLPrimaryAudioSource.m
//


#import "SDLPrimaryAudioSource.h"

SDLPrimaryAudioSource *SDLPrimaryAudioSource_NO_SOURCE_SELECTED = nil;
SDLPrimaryAudioSource *SDLPrimaryAudioSource_USB = nil;
SDLPrimaryAudioSource *SDLPrimaryAudioSource_USB2 = nil;
SDLPrimaryAudioSource *SDLPrimaryAudioSource_BLUETOOTH_STEREO_BTST = nil;
SDLPrimaryAudioSource *SDLPrimaryAudioSource_LINE_IN = nil;
SDLPrimaryAudioSource *SDLPrimaryAudioSource_IPOD = nil;
SDLPrimaryAudioSource *SDLPrimaryAudioSource_MOBILE_APP = nil;

NSArray *SDLPrimaryAudioSource_values = nil;

@implementation SDLPrimaryAudioSource

+ (SDLPrimaryAudioSource *)valueOf:(NSString *)value {
    for (SDLPrimaryAudioSource *item in SDLPrimaryAudioSource.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLPrimaryAudioSource_values == nil) {
        SDLPrimaryAudioSource_values = @[
            SDLPrimaryAudioSource.NO_SOURCE_SELECTED,
            SDLPrimaryAudioSource.USB,
            SDLPrimaryAudioSource.USB2,
            SDLPrimaryAudioSource.BLUETOOTH_STEREO_BTST,
            SDLPrimaryAudioSource.LINE_IN,
            SDLPrimaryAudioSource.IPOD,
            SDLPrimaryAudioSource.MOBILE_APP,
        ];
    }
    return SDLPrimaryAudioSource_values;
}

+ (SDLPrimaryAudioSource *)NO_SOURCE_SELECTED {
    if (SDLPrimaryAudioSource_NO_SOURCE_SELECTED == nil) {
        SDLPrimaryAudioSource_NO_SOURCE_SELECTED = [[SDLPrimaryAudioSource alloc] initWithValue:@"NO_SOURCE_SELECTED"];
    }
    return SDLPrimaryAudioSource_NO_SOURCE_SELECTED;
}

+ (SDLPrimaryAudioSource *)USB {
    if (SDLPrimaryAudioSource_USB == nil) {
        SDLPrimaryAudioSource_USB = [[SDLPrimaryAudioSource alloc] initWithValue:@"USB"];
    }
    return SDLPrimaryAudioSource_USB;
}

+ (SDLPrimaryAudioSource *)USB2 {
    if (SDLPrimaryAudioSource_USB2 == nil) {
        SDLPrimaryAudioSource_USB2 = [[SDLPrimaryAudioSource alloc] initWithValue:@"USB2"];
    }
    return SDLPrimaryAudioSource_USB2;
}

+ (SDLPrimaryAudioSource *)BLUETOOTH_STEREO_BTST {
    if (SDLPrimaryAudioSource_BLUETOOTH_STEREO_BTST == nil) {
        SDLPrimaryAudioSource_BLUETOOTH_STEREO_BTST = [[SDLPrimaryAudioSource alloc] initWithValue:@"BLUETOOTH_STEREO_BTST"];
    }
    return SDLPrimaryAudioSource_BLUETOOTH_STEREO_BTST;
}

+ (SDLPrimaryAudioSource *)LINE_IN {
    if (SDLPrimaryAudioSource_LINE_IN == nil) {
        SDLPrimaryAudioSource_LINE_IN = [[SDLPrimaryAudioSource alloc] initWithValue:@"LINE_IN"];
    }
    return SDLPrimaryAudioSource_LINE_IN;
}

+ (SDLPrimaryAudioSource *)IPOD {
    if (SDLPrimaryAudioSource_IPOD == nil) {
        SDLPrimaryAudioSource_IPOD = [[SDLPrimaryAudioSource alloc] initWithValue:@"IPOD"];
    }
    return SDLPrimaryAudioSource_IPOD;
}

+ (SDLPrimaryAudioSource *)MOBILE_APP {
    if (SDLPrimaryAudioSource_MOBILE_APP == nil) {
        SDLPrimaryAudioSource_MOBILE_APP = [[SDLPrimaryAudioSource alloc] initWithValue:@"MOBILE_APP"];
    }
    return SDLPrimaryAudioSource_MOBILE_APP;
}

@end
