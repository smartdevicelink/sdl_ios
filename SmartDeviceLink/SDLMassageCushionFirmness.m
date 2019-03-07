//  SDLMassageCushionFirmness.m
//

#import "SDLNames.h"
#import "SDLMassageCushionFirmness.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMassageCushionFirmness

- (instancetype)initWithMassageCushion:(SDLMassageCushion)cushion firmness:(UInt8)firmness {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.cushion = cushion;
    self.firmness = @(firmness);

    return self;
}

- (void)setCushion:(SDLMassageCushion)cushion {
    [store sdl_setObject:cushion forName:SDLNameCushion];
}

- (SDLMassageCushion)cushion {
    NSError *error;
    return [store sdl_enumForName:SDLNameCushion error:&error];
}

- (void)setFirmness:(NSNumber<SDLInt> *)firmness {
    [store sdl_setObject:firmness forName:SDLNameFirmness];
}

- (NSNumber<SDLInt> *)firmness {
    NSError *error;
    return [store sdl_objectForName:SDLNameFirmness ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
