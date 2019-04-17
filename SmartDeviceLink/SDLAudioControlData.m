//  SDLAudioControlData.m
//

#import "SDLAudioControlData.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLEqualizerSettings.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAudioControlData

- (instancetype)initWithSource:(nullable SDLPrimaryAudioSource)source keepContext:(nullable NSNumber<SDLBool> *)keepContext volume:(nullable NSNumber<SDLInt> *)volume equalizerSettings:(nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.source = source;
    self.keepContext = keepContext;
    self.volume = volume;
    self.equalizerSettings = equalizerSettings;

    return self;
}

- (void)setSource:(nullable SDLPrimaryAudioSource)source {
    [store sdl_setObject:source forName:SDLRPCParameterNameSource];

}

- (nullable SDLPrimaryAudioSource)source {
    return [store sdl_enumForName:SDLRPCParameterNameSource error:nil];
}

- (void)setKeepContext:(nullable NSNumber<SDLBool> *)keepContext {
    [store sdl_setObject:keepContext forName:SDLRPCParameterNameKeepContext];
}

- (nullable NSNumber<SDLBool> *)keepContext {
    return [store sdl_objectForName:SDLRPCParameterNameKeepContext ofClass:NSNumber.class error:nil];
}

- (void)setVolume:(nullable NSNumber<SDLInt> *)volume {
    [store sdl_setObject:volume forName:SDLRPCParameterNameVolume];
}

- (nullable NSNumber<SDLInt> *)volume {
    return [store sdl_objectForName:SDLRPCParameterNameVolume ofClass:NSNumber.class error:nil];
}

- (void)setEqualizerSettings:(nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings {
    [store sdl_setObject:equalizerSettings forName:SDLRPCParameterNameEqualizerSettings];
}

- (nullable NSArray<SDLEqualizerSettings *> *)equalizerSettings {
    return [store sdl_objectsForName:SDLRPCParameterNameEqualizerSettings ofClass:SDLEqualizerSettings.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
