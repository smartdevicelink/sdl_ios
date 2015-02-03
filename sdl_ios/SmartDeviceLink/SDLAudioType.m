//  SDLAudioType.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAudioType.h>

SDLAudioType* SDLAudioType_PCM = nil;

NSMutableArray* SDLAudioType_values = nil;

@implementation SDLAudioType

+(SDLAudioType*) valueOf:(NSString*) value {
    for (SDLAudioType* item in SDLAudioType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+(NSMutableArray*) values {
    if (SDLAudioType_values == nil) {
        SDLAudioType_values = [[NSMutableArray alloc] initWithObjects:
                SDLAudioType.PCM,
                nil];
    }
    return SDLAudioType_values;
}

+(SDLAudioType*) PCM {
    if (SDLAudioType_PCM == nil) {
        SDLAudioType_PCM = [[SDLAudioType alloc] initWithValue:@"PCM"];
    }
    return SDLAudioType_PCM;
}

@end
