//  SDLHMISettingsControlCapabilities.m
//

#import "SDLHMISettingsControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMISettingsControlCapabilities

- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.moduleName = moduleName;
    self.moduleInfo = moduleInfo;
    
    return self;
}

- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo distanceUnitAvailable:(BOOL)distanceUnitAvailable temperatureUnitAvailable:(BOOL)temperatureUnitAvailable displayModeUnitAvailable:(BOOL)displayModeUnitAvailable {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.moduleName = moduleName;
    self.moduleInfo = moduleInfo;
    self.distanceUnitAvailable = @(distanceUnitAvailable);
    self.temperatureUnitAvailable = @(temperatureUnitAvailable);
    self.displayModeUnitAvailable = @(displayModeUnitAvailable);
    
    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [self.store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleName ofClass:NSString.class error:&error];
}


- (void)setDistanceUnitAvailable:(nullable NSNumber<SDLBool> *)distanceUnitAvailable {
    [self.store sdl_setObject:distanceUnitAvailable forName:SDLRPCParameterNameDistanceUnitAvailable];
}

- (nullable NSNumber<SDLBool> *)distanceUnitAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameDistanceUnitAvailable ofClass:NSNumber.class error:nil];
}

- (void)setTemperatureUnitAvailable:(nullable NSNumber<SDLBool> *)temperatureUnitAvailable {
    [self.store sdl_setObject:temperatureUnitAvailable forName:SDLRPCParameterNameTemperatureUnitAvailable];
}

- (nullable NSNumber<SDLBool> *)temperatureUnitAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameTemperatureUnitAvailable ofClass:NSNumber.class error:nil];
}

- (void)setDisplayModeUnitAvailable:(nullable NSNumber<SDLBool> *)displayModeUnitAvailable {
    [self.store sdl_setObject:displayModeUnitAvailable forName:SDLRPCParameterNameDisplayModeUnitAvailable];
}

- (nullable NSNumber<SDLBool> *)displayModeUnitAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameDisplayModeUnitAvailable ofClass:NSNumber.class error:nil];
}

- (void)setModuleInfo:(nullable SDLModuleInfo *)moduleInfo {
    [self.store sdl_setObject:moduleInfo forName:SDLRPCParameterNameModuleInfo];
}

- (nullable SDLModuleInfo *)moduleInfo {
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleInfo ofClass:SDLModuleInfo.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
