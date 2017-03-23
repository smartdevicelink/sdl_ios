//  SDLPerformAudioPassThru.m
//


#import "SDLPerformAudioPassThru.h"

#import "SDLAudioType.h"
#import "SDLBitsPerSample.h"
#import "SDLNames.h"
#import "SDLSamplingRate.h"
#import "SDLTTSChunk.h"
#import "SDLTTSChunkFactory.h"


@implementation SDLPerformAudioPassThru

- (instancetype)init {
    if (self = [super initWithName:NAMES_PerformAudioPassThru]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt audioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate *)samplingRate bitsPerSample:(SDLBitsPerSample *)bitsPerSample audioType:(SDLAudioType *)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio {
    self = [self initWithSamplingRate:samplingRate bitsPerSample:bitsPerSample audioType:audioType maxDuration:maxDuration];
    if (!self) {
        return nil;
    }

    self.initialPrompt = [SDLTTSChunk textChunksFromString:initialPrompt];
    self.audioPassThruDisplayText1 = audioPassThruDisplayText1;
    self.audioPassThruDisplayText2 = audioPassThruDisplayText2;
    self.muteAudio = @(muteAudio);

    return self;
}

- (instancetype)initWithSamplingRate:(SDLSamplingRate *)samplingRate bitsPerSample:(SDLBitsPerSample *)bitsPerSample audioType:(SDLAudioType *)audioType maxDuration:(UInt32)maxDuration {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.samplingRate = samplingRate;
    self.bitsPerSample = bitsPerSample;
    self.audioType = audioType;
    self.maxDuration = @(maxDuration);

    return self;
}

- (void)setInitialPrompt:(NSMutableArray *)initialPrompt {
    if (initialPrompt != nil) {
        [parameters setObject:initialPrompt forKey:NAMES_initialPrompt];
    } else {
        [parameters removeObjectForKey:NAMES_initialPrompt];
    }
}

- (NSMutableArray *)initialPrompt {
    NSMutableArray *array = [parameters objectForKey:NAMES_initialPrompt];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setAudioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 {
    if (audioPassThruDisplayText1 != nil) {
        [parameters setObject:audioPassThruDisplayText1 forKey:NAMES_audioPassThruDisplayText1];
    } else {
        [parameters removeObjectForKey:NAMES_audioPassThruDisplayText1];
    }
}

- (NSString *)audioPassThruDisplayText1 {
    return [parameters objectForKey:NAMES_audioPassThruDisplayText1];
}

- (void)setAudioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 {
    if (audioPassThruDisplayText2 != nil) {
        [parameters setObject:audioPassThruDisplayText2 forKey:NAMES_audioPassThruDisplayText2];
    } else {
        [parameters removeObjectForKey:NAMES_audioPassThruDisplayText2];
    }
}

- (NSString *)audioPassThruDisplayText2 {
    return [parameters objectForKey:NAMES_audioPassThruDisplayText2];
}

- (void)setSamplingRate:(SDLSamplingRate *)samplingRate {
    if (samplingRate != nil) {
        [parameters setObject:samplingRate forKey:NAMES_samplingRate];
    } else {
        [parameters removeObjectForKey:NAMES_samplingRate];
    }
}

- (SDLSamplingRate *)samplingRate {
    NSObject *obj = [parameters objectForKey:NAMES_samplingRate];
    if (obj == nil || [obj isKindOfClass:SDLSamplingRate.class]) {
        return (SDLSamplingRate *)obj;
    } else {
        return [SDLSamplingRate valueOf:(NSString *)obj];
    }
}

- (void)setMaxDuration:(NSNumber *)maxDuration {
    if (maxDuration != nil) {
        [parameters setObject:maxDuration forKey:NAMES_maxDuration];
    } else {
        [parameters removeObjectForKey:NAMES_maxDuration];
    }
}

- (NSNumber *)maxDuration {
    return [parameters objectForKey:NAMES_maxDuration];
}

- (void)setBitsPerSample:(SDLBitsPerSample *)bitsPerSample {
    if (bitsPerSample != nil) {
        [parameters setObject:bitsPerSample forKey:NAMES_bitsPerSample];
    } else {
        [parameters removeObjectForKey:NAMES_bitsPerSample];
    }
}

- (SDLBitsPerSample *)bitsPerSample {
    NSObject *obj = [parameters objectForKey:NAMES_bitsPerSample];
    if (obj == nil || [obj isKindOfClass:SDLBitsPerSample.class]) {
        return (SDLBitsPerSample *)obj;
    } else {
        return [SDLBitsPerSample valueOf:(NSString *)obj];
    }
}

- (void)setAudioType:(SDLAudioType *)audioType {
    if (audioType != nil) {
        [parameters setObject:audioType forKey:NAMES_audioType];
    } else {
        [parameters removeObjectForKey:NAMES_audioType];
    }
}

- (SDLAudioType *)audioType {
    NSObject *obj = [parameters objectForKey:NAMES_audioType];
    if (obj == nil || [obj isKindOfClass:SDLAudioType.class]) {
        return (SDLAudioType *)obj;
    } else {
        return [SDLAudioType valueOf:(NSString *)obj];
    }
}

- (void)setMuteAudio:(NSNumber *)muteAudio {
    if (muteAudio != nil) {
        [parameters setObject:muteAudio forKey:NAMES_muteAudio];
    } else {
        [parameters removeObjectForKey:NAMES_muteAudio];
    }
}

- (NSNumber *)muteAudio {
    return [parameters objectForKey:NAMES_muteAudio];
}

@end
