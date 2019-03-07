//  SDLLightControlCapabilities.m
//

#import "SDLLightControlCapabilities.h"
#import "SDLNames.h"
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
    [store sdl_setObject:moduleName forName:SDLNameModuleName];
}

- (NSString *)moduleName {
    NSError *error;
    return [store sdl_objectForName:SDLNameModuleName ofClass:NSString.class error:&error];
}

- (void)setSupportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights {
    [store sdl_setObject:supportedLights forName:SDLNameSupportedLights];

}

- (NSArray<SDLLightCapabilities *> *)supportedLights {
    NSError *error;
    return [store sdl_objectsForName:SDLNameSupportedLights ofClass:SDLLightCapabilities.class error:&error];
}


@end

NS_ASSUME_NONNULL_END
