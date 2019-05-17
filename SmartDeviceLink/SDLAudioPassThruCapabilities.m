//  SDLAudioPassThruCapabilities.m
//


#import "SDLAudioPassThruCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAudioPassThruCapabilities

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    [self.store sdl_setObject:samplingRate forName:SDLRPCParameterNameSamplingRate];
}

- (SDLSamplingRate)samplingRate {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameSamplingRate error:&error];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [self.store sdl_setObject:bitsPerSample forName:SDLRPCParameterNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameBitsPerSample error:&error];
}

- (void)setAudioType:(SDLAudioType)audioType {
    [self.store sdl_setObject:audioType forName:SDLRPCParameterNameAudioType];
}

- (SDLAudioType)audioType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameAudioType error:&error];
}

@end

NS_ASSUME_NONNULL_END
