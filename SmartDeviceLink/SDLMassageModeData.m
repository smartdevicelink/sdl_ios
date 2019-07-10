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
    [self.store sdl_setObject:massageMode forName:SDLRPCParameterNameMassageMode];
}

- (SDLMassageMode)massageMode {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameMassageMode error:&error];
}

- (void)setMassageZone:(SDLMassageZone)massageZone {
    [self.store sdl_setObject:massageZone forName:SDLRPCParameterNameMassageZone];
}

- (SDLMassageZone)massageZone {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameMassageZone error:&error];
}

@end
NS_ASSUME_NONNULL_END
