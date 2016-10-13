//  SDLAudioPassThruCapabilities.m
//


#import "SDLAudioPassThruCapabilities.h"

#import "SDLNames.h"


@implementation SDLAudioPassThruCapabilities

- (void)setSamplingRate:(SDLSamplingRate)samplingRate {
    if (samplingRate != nil) {
        [store setObject:samplingRate forKey:SDLNameSamplingRate];
    } else {
        [store removeObjectForKey:SDLNameSamplingRate];
    }
}

- (SDLSamplingRate)samplingRate {
    NSObject *obj = [store objectForKey:SDLNameSamplingRate];
    return (SDLSamplingRate)obj;
}

- (void)setBitsPerSample:(SDLBitsPerSample)bitsPerSample {
    if (bitsPerSample != nil) {
        [store setObject:bitsPerSample forKey:SDLNameBitsPerSample];
    } else {
        [store removeObjectForKey:SDLNameBitsPerSample];
    }
}

- (SDLBitsPerSample)bitsPerSample {
    NSObject *obj = [store objectForKey:SDLNameBitsPerSample];
    return (SDLBitsPerSample)obj;
}

- (void)setAudioType:(SDLAudioType)audioType {
    if (audioType != nil) {
        [store setObject:audioType forKey:SDLNameAudioType];
    } else {
        [store removeObjectForKey:SDLNameAudioType];
    }
}

- (SDLAudioType)audioType {
    NSObject *obj = [store objectForKey:SDLNameAudioType];
    return (SDLAudioType)obj;
}

@end
