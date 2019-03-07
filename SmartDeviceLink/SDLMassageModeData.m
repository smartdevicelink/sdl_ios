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
    NSError *error;
    return [store sdl_enumForName:SDLNameMassageMode error:&error];
}

- (void)setMassageZone:(SDLMassageZone)massageZone {
    [store sdl_setObject:massageZone forName:SDLNameMassageZone];
}

- (SDLMassageZone)massageZone {
    NSError *error;
    return [store sdl_enumForName:SDLNameMassageZone error:&error];
}

@end
NS_ASSUME_NONNULL_END
