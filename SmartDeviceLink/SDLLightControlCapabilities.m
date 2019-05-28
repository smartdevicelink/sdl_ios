//  SDLLightControlCapabilities.m
//

#import "SDLLightControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLLightCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLightControlCapabilities


- (instancetype)initWithModuleName:(NSString *)moduleName supportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.moduleName = moduleName;
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


@end

NS_ASSUME_NONNULL_END
