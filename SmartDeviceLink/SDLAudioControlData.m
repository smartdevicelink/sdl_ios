//  SDLAudioControlData.m
//

#import "SDLAudioControlData.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

@implementation SDLAudioControlData

- (instancetype)initWithSource:(nullable SDLPrimaryAudioSource)source keepContext:(nullable NSNumber<SDLBool> *)keepContext volume:(nullable NSNumber<SDLInt> *)volume equalizerSettings:(nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.source = source;
    self.keepContext = keepContext;
    self.equalizerSettings = equalizerSettings;
    self.volume = volume;
    
    return self;
}

- (void)setSource:(nullable SDLPrimaryAudioSource)source {
    [store sdl_setObject:source forName:SDLNameSource];

}

- (nullable SDLPrimaryAudioSource)source {
    return [store sdl_objectForName:SDLNameSource];
}

- (void)setKeepContext:(nullable NSNumber<SDLBool> *)keepContext {
    [store sdl_setObject:keepContext forName:SDLNameKeepContext];
}

- (nullable NSNumber<SDLBool> *)keepContext {
    return [store sdl_objectForName:SDLNameKeepContext];
}

- (void)setVolume:(nullable NSNumber<SDLInt> *)volume {
    [store sdl_setObject:volume forName:SDLNameVolume];
}

- (nullable NSNumber<SDLInt> *)volume {
    return [store sdl_objectForName:SDLNameVolume];
}

- (void)setEqualizerSettings:(nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings {
    [store sdl_setObject:equalizerSettings forName:SDLNameEqualizerSettings];
}

- (nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings {
    return [store sdl_objectForName:SDLNameEqualizerSettings];
}

@end
