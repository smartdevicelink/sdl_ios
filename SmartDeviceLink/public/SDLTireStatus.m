//  SDLTireStatus.m
//

#import "SDLTireStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLSingleTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTireStatus

- (void)setPressureTelltale:(SDLWarningLightStatus)pressureTelltale {
    [self.store sdl_setObject:pressureTelltale forName:SDLRPCParameterNamePressureTelltale];
}

- (SDLWarningLightStatus)pressureTelltale {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNamePressureTelltale error:&error];
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    [self.store sdl_setObject:leftFront forName:SDLRPCParameterNameLeftFront];
}

- (SDLSingleTireStatus *)leftFront {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLeftFront ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    [self.store sdl_setObject:rightFront forName:SDLRPCParameterNameRightFront];
}

- (SDLSingleTireStatus *)rightFront {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRightFront ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    [self.store sdl_setObject:leftRear forName:SDLRPCParameterNameLeftRear];
}

- (SDLSingleTireStatus *)leftRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLeftRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    [self.store sdl_setObject:rightRear forName:SDLRPCParameterNameRightRear];
}

- (SDLSingleTireStatus *)rightRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRightRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    [self.store sdl_setObject:innerLeftRear forName:SDLRPCParameterNameInnerLeftRear];
}

- (SDLSingleTireStatus *)innerLeftRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameInnerLeftRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    [self.store sdl_setObject:innerRightRear forName:SDLRPCParameterNameInnerRightRear];
}

- (SDLSingleTireStatus *)innerRightRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameInnerRightRear ofClass:SDLSingleTireStatus.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
