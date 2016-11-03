//  SDLPerformAudioPassThru.m
//


#import "SDLPerformAudioPassThru.h"

#import "SDLNames.h"
#import "SDLTTSChunk.h"

@implementation SDLPerformAudioPassThru

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformAudioPassThru]) {
    }
    return self;
}

- (instancetype)initWithInitialPrompt:(NSString *)initialPrompt audioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio {
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

- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration {
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

- (void)setInitialPrompt:(NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    if (initialPrompt != nil) {
        [parameters setObject:initialPrompt forKey:SDLNameInitialPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameInitialPrompt];
    }
}

- (NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameInitialPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setAudioPassThruDisplayText1:(NSString *)audioPassThruDisplayText1 {
    if (audioPassThruDisplayText1 != nil) {
        [parameters setObject:audioPassThruDisplayText1 forKey:SDLNameAudioPassThruDisplayText1];
    } else {
        [parameters removeObjectForKey:SDLNameAudioPassThruDisplayText1];
    }
}

- (NSString *)audioPassThruDisplayText1 {
    return [parameters objectForKey:SDLNameAudioPassThruDisplayText1];
}

- (void)setAudioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 {
    if (audioPassThruDisplayText2 != nil) {
        [parameters setObject:audioPassThruDisplayText2 forKey:SDLNameAudioPassThruDisplayText2];
    } else {
        [parameters removeObjectForKey:SDLNameAudioPassThruDisplayText2];
    }
}

- (NSString *)audioPassThruDisplayText2 {
    return [parameters objectForKey:SDLNameAudioPassThruDisplayText2];
}

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    if (samplingRate != nil) {
        [parameters setObject:samplingRate forKey:SDLNameSamplingRate];
    } else {
        [parameters removeObjectForKey:SDLNameSamplingRate];
    }
}

- (SDLSamplingRate)samplingRate {
    NSObject *obj = [parameters objectForKey:SDLNameSamplingRate];
    return (SDLSamplingRate )obj;
}

- (void)setMaxDuration:(NSNumber<SDLInt> *)maxDuration {
    if (maxDuration != nil) {
        [parameters setObject:maxDuration forKey:SDLNameMaxDuration];
    } else {
        [parameters removeObjectForKey:SDLNameMaxDuration];
    }
}

- (NSNumber<SDLInt> *)maxDuration {
    return [parameters objectForKey:SDLNameMaxDuration];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    if (bitsPerSample != nil) {
        [parameters setObject:bitsPerSample forKey:SDLNameBitsPerSample];
    } else {
        [parameters removeObjectForKey:SDLNameBitsPerSample];
    }
}

- (SDLBitsPerSample)bitsPerSample {
    NSObject *obj = [parameters objectForKey:SDLNameBitsPerSample];
    return (SDLBitsPerSample)obj;
}

- (void)setAudioType:(SDLAudioType)audioType {
    if (audioType != nil) {
        [parameters setObject:audioType forKey:SDLNameAudioType];
    } else {
        [parameters removeObjectForKey:SDLNameAudioType];
    }
}

- (SDLAudioType)audioType {
    NSObject *obj = [parameters objectForKey:SDLNameAudioType];
    return (SDLAudioType)obj;
}

- (void)setMuteAudio:(NSNumber<SDLBool> *)muteAudio {
    if (muteAudio != nil) {
        [parameters setObject:muteAudio forKey:SDLNameMuteAudio];
    } else {
        [parameters removeObjectForKey:SDLNameMuteAudio];
    }
}

- (NSNumber<SDLBool> *)muteAudio {
    return [parameters objectForKey:SDLNameMuteAudio];
}

@end
