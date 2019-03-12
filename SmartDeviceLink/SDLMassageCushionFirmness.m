//  SDLMassageCushionFirmness.m
//

#import "SDLRPCParameterNames.h"
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
    [store sdl_setObject:cushion forName:SDLRPCParameterNameCushion];
}

- (SDLMassageCushion)cushion {
    return [store sdl_objectForName:SDLRPCParameterNameCushion];
}

- (void)setFirmness:(NSNumber<SDLInt> *)firmness {
    [store sdl_setObject:firmness forName:SDLRPCParameterNameFirmness];
}

- (NSNumber<SDLInt> *)firmness {
    return [store sdl_objectForName:SDLRPCParameterNameFirmness];
}

@end

NS_ASSUME_NONNULL_END
