//  SDLAudioControlCapabilities.m
//

#import "SDLAudioControlCapabilities.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAudioControlCapabilities

- (instancetype)initWithModuleName:(NSString *)name {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.moduleName = name;

    return self;
}

- (instancetype)initWithModuleName:(NSString *)name sourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable volueAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable equalizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable equalizerMaxChannelID:(nullable NSNumber<SDLInt> *)channelID {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.moduleName = name;
    self.sourceAvailable = sourceAvailable;
    self.volumeAvailable = volumeAvailable;
    self.equalizerAvailable = equalizerAvailable;
    self.equalizerMaxChannelId = channelID;

    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [store sdl_setObject:moduleName forName:SDLNameModuleName];
}

- (NSString *)moduleName {
    return [store sdl_objectForName:SDLNameModuleName];
}

- (void)setSourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable {
    [store sdl_setObject:sourceAvailable forName:SDLNameSourceAvailable];
}

- (nullable NSNumber<SDLBool> *)sourceAvailable {
    return [store sdl_objectForName:SDLNameSourceAvailable];
}

- (void)setVolumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable {
    [store sdl_setObject:volumeAvailable forName:SDLNameVolumeAvailable];
}

- (nullable NSNumber<SDLBool> *)volumeAvailable {
    return [store sdl_objectForName:SDLNameVolumeAvailable];
}

- (void)setEqualizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable {
    [store sdl_setObject:equalizerAvailable forName:SDLNameEqualizerAvailable];
}

- (nullable NSNumber<SDLBool> *)equalizerAvailable {
    return [store sdl_objectForName:SDLNameEqualizerAvailable];
}

- (void)setEqualizerMaxChannelId:(nullable NSNumber<SDLInt> *)equalizerMaxChannelId {
    [store sdl_setObject:equalizerMaxChannelId forName:SDLNameEqualizerMaxChannelId];
}

- (nullable NSNumber<SDLInt> *)equalizerMaxChannelId {
    return [store sdl_objectForName:SDLNameEqualizerMaxChannelId];
}

@end

NS_ASSUME_NONNULL_END
