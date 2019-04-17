//  SDLAudioControlCapabilities.m
//

#import "SDLAudioControlCapabilities.h"
#import "SDLRPCParameterNames.h"
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

- (instancetype)initWithModuleName:(NSString *)name sourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable keepContextAvailable:(nullable NSNumber<SDLBool> *)keepContextAvailable volumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable equalizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable equalizerMaxChannelID:(nullable NSNumber<SDLInt> *)equalizerMaxChannelID {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.moduleName = name;
    self.sourceAvailable = sourceAvailable;
    self.keepContextAvailable = keepContextAvailable;
    self.volumeAvailable = volumeAvailable;
    self.equalizerAvailable = equalizerAvailable;
    self.equalizerMaxChannelId = equalizerMaxChannelID;

    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameModuleName ofClass:NSString.class error:&error];
}

- (void)setSourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable {
    [store sdl_setObject:sourceAvailable forName:SDLRPCParameterNameSourceAvailable];
}

- (nullable NSNumber<SDLBool> *)sourceAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameSourceAvailable ofClass:NSNumber.class error:nil];
}

- (void)setKeepContextAvailable:(nullable NSNumber<SDLBool> *)keepContextAvailable {
    [store sdl_setObject:keepContextAvailable forName:SDLRPCParameterNameKeepContextAvailable];
}

- (nullable NSNumber<SDLBool> *)keepContextAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameKeepContextAvailable ofClass:NSNumber.class error:nil];
}

- (void)setVolumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable {
    [store sdl_setObject:volumeAvailable forName:SDLRPCParameterNameVolumeAvailable];
}

- (nullable NSNumber<SDLBool> *)volumeAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameVolumeAvailable ofClass:NSNumber.class error:nil];
}

- (void)setEqualizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable {
    [store sdl_setObject:equalizerAvailable forName:SDLRPCParameterNameEqualizerAvailable];
}

- (nullable NSNumber<SDLBool> *)equalizerAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameEqualizerAvailable ofClass:NSNumber.class error:nil];
}

- (void)setEqualizerMaxChannelId:(nullable NSNumber<SDLInt> *)equalizerMaxChannelId {
    [store sdl_setObject:equalizerMaxChannelId forName:SDLRPCParameterNameEqualizerMaxChannelId];
}

- (nullable NSNumber<SDLInt> *)equalizerMaxChannelId {
    return [store sdl_objectForName:SDLRPCParameterNameEqualizerMaxChannelId ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
