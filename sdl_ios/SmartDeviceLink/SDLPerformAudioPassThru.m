//  SDLPerformAudioPassThru.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLPerformAudioPassThru.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTTSChunk.h>

@implementation SDLPerformAudioPassThru

-(id) init {
    if (self = [super initWithName:NAMES_PerformAudioPassThru]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setInitialPrompt:(NSMutableArray *)initialPrompt {
    [parameters setOrRemoveObject:initialPrompt forKey:NAMES_initialPrompt];
}

-(NSMutableArray*) initialPrompt {
    NSMutableArray* array = [parameters objectForKey:NAMES_initialPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setAudioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 {
    [parameters setOrRemoveObject:audioPassThruDisplayText1 forKey:NAMES_audioPassThruDisplayText1];
}

-(NSString*) audioPassThruDisplayText1 {
    return [parameters objectForKey:NAMES_audioPassThruDisplayText1];
}

- (void)setAudioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 {
    [parameters setOrRemoveObject:audioPassThruDisplayText2 forKey:NAMES_audioPassThruDisplayText2];
}

-(NSString*) audioPassThruDisplayText2 {
    return [parameters objectForKey:NAMES_audioPassThruDisplayText2];
}

- (void)setSamplingRate:(SDLSamplingRate *)samplingRate {
    [parameters setOrRemoveObject:samplingRate forKey:NAMES_samplingRate];
}

-(SDLSamplingRate*) samplingRate {
    NSObject* obj = [parameters objectForKey:NAMES_samplingRate];
    if ([obj isKindOfClass:SDLSamplingRate.class]) {
        return (SDLSamplingRate*)obj;
    } else {
        return [SDLSamplingRate valueOf:(NSString*)obj];
    }
}

- (void)setMaxDuration:(NSNumber *)maxDuration {
    [parameters setOrRemoveObject:maxDuration forKey:NAMES_maxDuration];
}

-(NSNumber*) maxDuration {
    return [parameters objectForKey:NAMES_maxDuration];
}

- (void)setBitsPerSample:(SDLBitsPerSample *)bitsPerSample {
    [parameters setOrRemoveObject:bitsPerSample forKey:NAMES_bitsPerSample];
}

-(SDLBitsPerSample*) bitsPerSample {
    NSObject* obj = [parameters objectForKey:NAMES_bitsPerSample];
    if ([obj isKindOfClass:SDLBitsPerSample.class]) {
        return (SDLBitsPerSample*)obj;
    } else {
        return [SDLBitsPerSample valueOf:(NSString*)obj];
    }
}

- (void)setAudioType:(SDLAudioType *)audioType {
    [parameters setOrRemoveObject:audioType forKey:NAMES_audioType];
}

-(SDLAudioType*) audioType {
    NSObject* obj = [parameters objectForKey:NAMES_audioType];
    if ([obj isKindOfClass:SDLAudioType.class]) {
        return (SDLAudioType*)obj;
    } else {
        return [SDLAudioType valueOf:(NSString*)obj];
    }
}

- (void)setMuteAudio:(NSNumber *)muteAudio {
    [parameters setOrRemoveObject:muteAudio forKey:NAMES_muteAudio];
}

-(NSNumber*) muteAudio {
    return [parameters objectForKey:NAMES_muteAudio];
}

@end
