//  SDLLightControlCapabilities.m
//

#import "SDLLightControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLLightCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLightControlCapabilities

- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo supportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.moduleName = moduleName;
    self.moduleInfo = moduleInfo;
    self.supportedLights = supportedLights;
    
    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [self.store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleName ofClass:NSString.class error:&error];
}

- (void)setSupportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights {
    [self.store sdl_setObject:supportedLights forName:SDLRPCParameterNameSupportedLights];

}

- (NSArray<SDLLightCapabilities *> *)supportedLights {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameSupportedLights ofClass:SDLLightCapabilities.class error:&error];
}

- (void)setModuleInfo:(nullable SDLModuleInfo *)moduleInfo {
    [self.store sdl_setObject:moduleInfo forName:SDLRPCParameterNameModuleInfo];
}

- (nullable SDLModuleInfo *)moduleInfo {
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleInfo ofClass:SDLModuleInfo.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
