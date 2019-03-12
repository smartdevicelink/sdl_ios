//  SDLTireStatus.m
//

#import "SDLTireStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLSingleTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTireStatus

- (void)setPressureTelltale:(SDLWarningLightStatus)pressureTelltale {
    [store sdl_setObject:pressureTelltale forName:SDLRPCParameterNamePressureTelltale];
}

- (SDLWarningLightStatus)pressureTelltale {
    return [store sdl_objectForName:SDLRPCParameterNamePressureTelltale];
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    [store sdl_setObject:leftFront forName:SDLRPCParameterNameLeftFront];
}

- (SDLSingleTireStatus *)leftFront {
    return [store sdl_objectForName:SDLRPCParameterNameLeftFront ofClass:SDLSingleTireStatus.class];
}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    [store sdl_setObject:rightFront forName:SDLRPCParameterNameRightFront];
}

- (SDLSingleTireStatus *)rightFront {
    return [store sdl_objectForName:SDLRPCParameterNameRightFront ofClass:SDLSingleTireStatus.class];
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    [store sdl_setObject:leftRear forName:SDLRPCParameterNameLeftRear];
}

- (SDLSingleTireStatus *)leftRear {
    return [store sdl_objectForName:SDLRPCParameterNameLeftRear ofClass:SDLSingleTireStatus.class];
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    [store sdl_setObject:rightRear forName:SDLRPCParameterNameRightRear];
}

- (SDLSingleTireStatus *)rightRear {
    return [store sdl_objectForName:SDLRPCParameterNameRightRear ofClass:SDLSingleTireStatus.class];
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    [store sdl_setObject:innerLeftRear forName:SDLRPCParameterNameInnerLeftRear];
}

- (SDLSingleTireStatus *)innerLeftRear {
    return [store sdl_objectForName:SDLRPCParameterNameInnerLeftRear ofClass:SDLSingleTireStatus.class];
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    [store sdl_setObject:innerRightRear forName:SDLRPCParameterNameInnerRightRear];
}

- (SDLSingleTireStatus *)innerRightRear {
    return [store sdl_objectForName:SDLRPCParameterNameInnerRightRear ofClass:SDLSingleTireStatus.class];
}

@end

NS_ASSUME_NONNULL_END
