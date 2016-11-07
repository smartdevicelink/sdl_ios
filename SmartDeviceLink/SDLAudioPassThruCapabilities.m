//  SDLAudioPassThruCapabilities.m
//


#import "SDLAudioPassThruCapabilities.h"

#import "SDLNames.h"


@implementation SDLAudioPassThruCapabilities

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    [self setObject:samplingRate forName:SDLNameSamplingRate];
}

- (SDLSamplingRate)samplingRate {
    return [self objectForName:SDLNameSamplingRate];
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    [self setObject:bitsPerSample forName:SDLNameBitsPerSample];
}

- (SDLBitsPerSample)bitsPerSample {
    return [self objectForName:SDLNameBitsPerSample];
}

- (void)setAudioType:(SDLAudioType)audioType {
    [self setObject:audioType forName:SDLNameAudioType];
}

- (SDLAudioType)audioType {
    return [self objectForName:SDLNameAudioType];
}

@end
