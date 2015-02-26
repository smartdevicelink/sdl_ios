//  SDLAudioPassThruCapabilities.m
//
//  

#import <SmartDeviceLink/SDLAudioPassThruCapabilities.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAudioPassThruCapabilities

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setSamplingRate:(SDLSamplingRate*) samplingRate {
    if (samplingRate != nil) {
        [store setObject:samplingRate forKey:NAMES_samplingRate];
    } else {
        [store removeObjectForKey:NAMES_samplingRate];
    }
}

-(SDLSamplingRate*) samplingRate {
    NSObject* obj = [store objectForKey:NAMES_samplingRate];
    if ([obj isKindOfClass:SDLSamplingRate.class]) {
        return (SDLSamplingRate*)obj;
    } else {
        return [SDLSamplingRate valueOf:(NSString*)obj];
    }
}

-(void) setBitsPerSample:(SDLBitsPerSample*) bitsPerSample {
    if (bitsPerSample != nil) {
        [store setObject:bitsPerSample forKey:NAMES_bitsPerSample];
    } else {
        [store removeObjectForKey:NAMES_bitsPerSample];
    }
}

-(SDLBitsPerSample*) bitsPerSample {
    NSObject* obj = [store objectForKey:NAMES_bitsPerSample];
    if ([obj isKindOfClass:SDLBitsPerSample.class]) {
        return (SDLBitsPerSample*)obj;
    } else {
        return [SDLBitsPerSample valueOf:(NSString*)obj];
    }
}

-(void) setAudioType:(SDLAudioType*) audioType {
    if (audioType != nil) {
        [store setObject:audioType forKey:NAMES_audioType];
    } else {
        [store removeObjectForKey:NAMES_audioType];
    }
}

-(SDLAudioType*) audioType {
    NSObject* obj = [store objectForKey:NAMES_audioType];
    if ([obj isKindOfClass:SDLAudioType.class]) {
        return (SDLAudioType*)obj;
    } else {
        return [SDLAudioType valueOf:(NSString*)obj];
    }
}

@end
