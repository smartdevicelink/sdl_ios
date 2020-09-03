//  SDLAudioControlCapabilities.m
//

#import "SDLAudioControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAudioControlCapabilities

- (instancetype)initWithModuleName:(NSString *)name moduleInfo:(nullable SDLModuleInfo *)moduleInfo {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.moduleName = name;
    self.moduleInfo = moduleInfo;

    return self;
}

- (instancetype)initWithModuleName:(NSString *)name moduleInfo:(nullable SDLModuleInfo *)moduleInfo sourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable keepContextAvailable:(nullable NSNumber<SDLBool> *)keepContextAvailable volumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable equalizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable equalizerMaxChannelID:(nullable NSNumber<SDLInt> *)equalizerMaxChannelID {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.moduleName = name;
    self.moduleInfo = moduleInfo;
    self.sourceAvailable = sourceAvailable;
    self.keepContextAvailable = keepContextAvailable;
    self.volumeAvailable = volumeAvailable;
    self.equalizerAvailable = equalizerAvailable;
    self.equalizerMaxChannelId = equalizerMaxChannelID;

    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [self.store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleName ofClass:NSString.class error:&error];
}

- (void)setSourceAvailable:(nullable NSNumber<SDLBool> *)sourceAvailable {
    [self.store sdl_setObject:sourceAvailable forName:SDLRPCParameterNameSourceAvailable];
}

- (nullable NSNumber<SDLBool> *)sourceAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameSourceAvailable ofClass:NSNumber.class error:nil];
}

- (void)setKeepContextAvailable:(nullable NSNumber<SDLBool> *)keepContextAvailable {
    [self.store sdl_setObject:keepContextAvailable forName:SDLRPCParameterNameKeepContextAvailable];
}

- (nullable NSNumber<SDLBool> *)keepContextAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameKeepContextAvailable ofClass:NSNumber.class error:nil];
}

- (void)setVolumeAvailable:(nullable NSNumber<SDLBool> *)volumeAvailable {
    [self.store sdl_setObject:volumeAvailable forName:SDLRPCParameterNameVolumeAvailable];
}

- (nullable NSNumber<SDLBool> *)volumeAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameVolumeAvailable ofClass:NSNumber.class error:nil];
}

- (void)setEqualizerAvailable:(nullable NSNumber<SDLBool> *)equalizerAvailable {
    [self.store sdl_setObject:equalizerAvailable forName:SDLRPCParameterNameEqualizerAvailable];
}

- (nullable NSNumber<SDLBool> *)equalizerAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameEqualizerAvailable ofClass:NSNumber.class error:nil];
}

- (void)setEqualizerMaxChannelId:(nullable NSNumber<SDLInt> *)equalizerMaxChannelId {
    [self.store sdl_setObject:equalizerMaxChannelId forName:SDLRPCParameterNameEqualizerMaxChannelId];
}

- (nullable NSNumber<SDLInt> *)equalizerMaxChannelId {
    return [self.store sdl_objectForName:SDLRPCParameterNameEqualizerMaxChannelId ofClass:NSNumber.class error:nil];
}

- (void)setModuleInfo:(nullable SDLModuleInfo *)moduleInfo {
    [self.store sdl_setObject:moduleInfo forName:SDLRPCParameterNameModuleInfo];
}

- (nullable SDLModuleInfo *)moduleInfo {
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleInfo ofClass:SDLModuleInfo.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
