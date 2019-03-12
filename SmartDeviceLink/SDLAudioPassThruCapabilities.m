//  SDLAudioPassThruCapabilities.m
//


#import "SDLAudioPassThruCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAudioPassThruCapabilities

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    [store sdl_setObject:samplingRate forName:SDLRPCParameterNameSamplingRate];
}

- (SDLSamplingRate)samplingRate {
    return [store sdl_objectForName:SDLRPCParameterNameSamplingRate];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [store sdl_setObject:bitsPerSample forName:SDLRPCParameterNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    return [store sdl_objectForName:SDLRPCParameterNameBitsPerSample];
}

- (void)setAudioType:(SDLAudioType)audioType {
    [store sdl_setObject:audioType forName:SDLRPCParameterNameAudioType];
}

- (SDLAudioType)audioType {
    return [store sdl_objectForName:SDLRPCParameterNameAudioType];
}

@end

NS_ASSUME_NONNULL_END
