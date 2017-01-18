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
    return [store sdl_objectForName:SDLNameSamplingRate];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [store sdl_setObject:bitsPerSample forName:SDLNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    return [store sdl_objectForName:SDLNameBitsPerSample];
}

- (void)setAudioType:(SDLAudioType)audioType {
    [store sdl_setObject:audioType forName:SDLNameAudioType];
}

- (SDLAudioType)audioType {
    return [store sdl_objectForName:SDLNameAudioType];
}

@end

NS_ASSUME_NONNULL_END
