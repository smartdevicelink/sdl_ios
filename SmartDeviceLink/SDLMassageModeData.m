//  SDLMassageModeData.m
//

#import "SDLRPCParameterNames.h"
#import "SDLMassageModeData.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMassageModeData

- (instancetype)initWithMassageMode:(SDLMassageMode)massageMode massageZone:(SDLMassageZone)massageZone {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.massageMode = massageMode;
    self.massageZone = massageZone;

    return self;
}

- (void)setMassageMode:(SDLMassageMode)massageMode {
    [store sdl_setObject:massageMode forName:SDLRPCParameterNameMassageMode];
}

- (SDLMassageMode)massageMode {
    return [store sdl_objectForName:SDLRPCParameterNameMassageMode];
}

- (void)setMassageZone:(SDLMassageZone)massageZone {
    [store sdl_setObject:massageZone forName:SDLRPCParameterNameMassageZone];
}

- (SDLMassageZone)massageZone {
    return [store sdl_objectForName:SDLRPCParameterNameMassageZone];
}

@end
NS_ASSUME_NONNULL_END
