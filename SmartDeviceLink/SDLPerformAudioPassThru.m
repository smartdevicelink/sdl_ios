//  SDLPerformAudioPassThru.m
//


#import "SDLPerformAudioPassThru.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:initialPrompt forName:SDLNameInitialPrompt];
}

- (NSMutableArray<SDLTTSChunk *> *)initialPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters sdl_objectForName:SDLNameInitialPrompt];
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
    [parameters sdl_setObject:audioPassThruDisplayText1 forName:SDLNameAudioPassThruDisplayText1];
}

- (NSString *)audioPassThruDisplayText1 {
    return [parameters sdl_objectForName:SDLNameAudioPassThruDisplayText1];
}

- (void)setAudioPassThruDisplayText2:(NSString *)audioPassThruDisplayText2 {
    [parameters sdl_setObject:audioPassThruDisplayText2 forName:SDLNameAudioPassThruDisplayText2];
}

- (NSString *)audioPassThruDisplayText2 {
    return [parameters sdl_objectForName:SDLNameAudioPassThruDisplayText2];
}

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    [parameters sdl_setObject:samplingRate forName:SDLNameSamplingRate];
}

- (SDLSamplingRate)samplingRate {
    NSObject *obj = [parameters sdl_objectForName:SDLNameSamplingRate];
    return (SDLSamplingRate )obj;
}

- (void)setMaxDuration:(NSNumber<SDLInt> *)maxDuration {
    [parameters sdl_setObject:maxDuration forName:SDLNameMaxDuration];
}

- (NSNumber<SDLInt> *)maxDuration {
    return [parameters sdl_objectForName:SDLNameMaxDuration];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [parameters sdl_setObject:bitsPerSample forName:SDLNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    NSObject *obj = [parameters sdl_objectForName:SDLNameBitsPerSample];
    return (SDLBitsPerSample)obj;
}

- (void)setAudioType:(SDLAudioType)audioType {
    [parameters sdl_setObject:audioType forName:SDLNameAudioType];
}

- (SDLAudioType)audioType {
    NSObject *obj = [parameters sdl_objectForName:SDLNameAudioType];
    return (SDLAudioType)obj;
}

- (void)setMuteAudio:(NSNumber<SDLBool> *)muteAudio {
    [parameters sdl_setObject:muteAudio forName:SDLNameMuteAudio];
}

- (NSNumber<SDLBool> *)muteAudio {
    return [parameters sdl_objectForName:SDLNameMuteAudio];
}

@end
