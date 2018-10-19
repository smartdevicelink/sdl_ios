//  SDLMassageModeData.m
//

#import "SDLNames.h"
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
    [store sdl_setObject:massageMode forName:SDLNameMassageMode];
}

- (SDLMassageMode)massageMode {
    return [store sdl_objectForName:SDLNameMassageMode];
}

- (void)setMassageZone:(SDLMassageZone)massageZone {
    [store sdl_setObject:massageZone forName:SDLNameMassageZone];
}

- (SDLMassageZone)massageZone {
    return [store sdl_objectForName:SDLNameMassageZone];
}

@end
NS_ASSUME_NONNULL_END
