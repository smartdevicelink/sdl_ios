//  SDLPerformAudioPassThru.m
//


#import "SDLPerformAudioPassThru.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformAudioPassThru

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePerformAudioPassThru]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt audioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio {
    return [self initWithInitialPrompt:initialPrompt audioPassThruDisplayText1:audioPassThruDisplayText1 audioPassThruDisplayText2:audioPassThruDisplayText2 samplingRate:samplingRate bitsPerSample:bitsPerSample audioType:audioType maxDuration:maxDuration muteAudio:muteAudio audioDataHandler:nil];
}

- (instancetype)initWithInitialPrompt:(nullable NSString *)initialPrompt audioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 audioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 samplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration muteAudio:(BOOL)muteAudio audioDataHandler:(nullable SDLAudioPassThruHandler)audioDataHandler {
    self = [self initWithSamplingRate:samplingRate bitsPerSample:bitsPerSample audioType:audioType maxDuration:maxDuration audioDataHandler:audioDataHandler];
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
    return [self initWithSamplingRate:samplingRate bitsPerSample:bitsPerSample audioType:audioType maxDuration:maxDuration audioDataHandler:nil];
}
    
- (instancetype)initWithSamplingRate:(SDLSamplingRate)samplingRate bitsPerSample:(SDLBitsPerSample)bitsPerSample audioType:(SDLAudioType)audioType maxDuration:(UInt32)maxDuration audioDataHandler:(nullable SDLAudioPassThruHandler)audioDataHandler {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.samplingRate = samplingRate;
    self.bitsPerSample = bitsPerSample;
    self.audioType = audioType;
    self.maxDuration = @(maxDuration);
    self.audioDataHandler = audioDataHandler;
    
    return self;
}
    

- (void)setInitialPrompt:(nullable NSArray<SDLTTSChunk *> *)initialPrompt {
    [self.parameters sdl_setObject:initialPrompt forName:SDLRPCParameterNameInitialPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)initialPrompt {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameInitialPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setAudioPassThruDisplayText1:(nullable NSString *)audioPassThruDisplayText1 {
    [self.parameters sdl_setObject:audioPassThruDisplayText1 forName:SDLRPCParameterNameAudioPassThruDisplayText1];
}

- (nullable NSString *)audioPassThruDisplayText1 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAudioPassThruDisplayText1 ofClass:NSString.class error:nil];
}

- (void)setAudioPassThruDisplayText2:(nullable NSString *)audioPassThruDisplayText2 {
    [self.parameters sdl_setObject:audioPassThruDisplayText2 forName:SDLRPCParameterNameAudioPassThruDisplayText2];
}

- (nullable NSString *)audioPassThruDisplayText2 {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAudioPassThruDisplayText2 ofClass:NSString.class error:nil];
}

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    [self.parameters sdl_setObject:samplingRate forName:SDLRPCParameterNameSamplingRate];
}

- (SDLSamplingRate)samplingRate {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameSamplingRate error:&error];
}

- (void)setMaxDuration:(NSNumber<SDLInt> *)maxDuration {
    [self.parameters sdl_setObject:maxDuration forName:SDLRPCParameterNameMaxDuration];
}

- (NSNumber<SDLInt> *)maxDuration {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMaxDuration ofClass:NSNumber.class error:&error];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [self.parameters sdl_setObject:bitsPerSample forName:SDLRPCParameterNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameBitsPerSample error:&error];
}

- (void)setAudioType:(SDLAudioType)audioType {
    [self.parameters sdl_setObject:audioType forName:SDLRPCParameterNameAudioType];
}

- (SDLAudioType)audioType {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameAudioType error:&error];
}

- (void)setMuteAudio:(nullable NSNumber<SDLBool> *)muteAudio {
    [self.parameters sdl_setObject:muteAudio forName:SDLRPCParameterNameMuteAudio];
}

- (nullable NSNumber<SDLBool> *)muteAudio {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMuteAudio ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
