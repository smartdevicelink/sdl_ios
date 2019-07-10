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
    [self.store sdl_setObject:cushion forName:SDLRPCParameterNameCushion];
}

- (SDLMassageCushion)cushion {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameCushion error:&error];
}

- (void)setFirmness:(NSNumber<SDLInt> *)firmness {
    [self.store sdl_setObject:firmness forName:SDLRPCParameterNameFirmness];
}

- (NSNumber<SDLInt> *)firmness {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameFirmness ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
