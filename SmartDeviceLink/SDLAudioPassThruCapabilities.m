//  SDLAudioPassThruCapabilities.m
//


#import "SDLAudioPassThruCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAudioPassThruCapabilities

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    [store sdl_setObject:samplingRate forName:SDLNameSamplingRate];
}

- (SDLSamplingRate)samplingRate {
    NSError *error;
    return [store sdl_enumForName:SDLNameSamplingRate error:&error];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [store sdl_setObject:bitsPerSample forName:SDLNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    NSError *error;
    return [store sdl_enumForName:SDLNameBitsPerSample error:&error];
}

- (void)setAudioType:(SDLAudioType)audioType {
    [store sdl_setObject:audioType forName:SDLNameAudioType];
}

- (SDLAudioType)audioType {
    NSError *error;
    return [store sdl_enumForName:SDLNameAudioType error:&error];
}

@end

NS_ASSUME_NONNULL_END
