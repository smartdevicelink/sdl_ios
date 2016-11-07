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
    [self setObject:initialPrompt forName:SDLNameInitialPrompt];
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
    [self setObject:audioPassThruDisplayText1 forName:SDLNameAudioPassThruDisplayText1];
}

- (NSString *)audioPassThruDisplayText1 {
    return [parameters objectForKey:SDLNameAudioPassThruDisplayText1];
}

- (void)setAudioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 {
    [self setObject:audioPassThruDisplayText2 forName:SDLNameAudioPassThruDisplayText2];
}

- (NSString *)audioPassThruDisplayText2 {
    return [parameters objectForKey:SDLNameAudioPassThruDisplayText2];
}

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    [self setObject:samplingRate forName:SDLNameSamplingRate];
}

- (SDLSamplingRate)samplingRate {
    NSObject *obj = [parameters objectForKey:SDLNameSamplingRate];
    return (SDLSamplingRate )obj;
}

- (void)setMaxDuration:(NSNumber<SDLInt> *)maxDuration {
    [self setObject:maxDuration forName:SDLNameMaxDuration];
}

- (NSNumber<SDLInt> *)maxDuration {
    return [parameters objectForKey:SDLNameMaxDuration];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [self setObject:bitsPerSample forName:SDLNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    NSObject *obj = [parameters objectForKey:SDLNameBitsPerSample];
    return (SDLBitsPerSample)obj;
}

- (void)setAudioType:(SDLAudioType)audioType {
    [self setObject:audioType forName:SDLNameAudioType];
}

- (SDLAudioType)audioType {
    NSObject *obj = [parameters objectForKey:SDLNameAudioType];
    return (SDLAudioType)obj;
}

- (void)setMuteAudio:(NSNumber<SDLBool> *)muteAudio {
    [self setObject:muteAudio forName:SDLNameMuteAudio];
}

- (NSNumber<SDLBool> *)muteAudio {
    return [parameters objectForKey:SDLNameMuteAudio];
}

@end
