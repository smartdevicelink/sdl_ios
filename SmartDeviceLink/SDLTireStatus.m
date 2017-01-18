//  SDLTireStatus.m
//

#import "SDLTireStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSingleTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTireStatus

- (void)setPressureTelltale:(SDLWarningLightStatus)pressureTelltale {
    [store sdl_setObject:pressureTelltale forName:SDLNamePressureTelltale];
}

- (SDLWarningLightStatus)pressureTelltale {
    return [store sdl_objectForName:SDLNamePressureTelltale];
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    [store sdl_setObject:leftFront forName:SDLNameLeftFront];
}

- (SDLSingleTireStatus *)leftFront {
    return [store sdl_objectForName:SDLNameLeftFront ofClass:SDLSingleTireStatus.class];
}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    [store sdl_setObject:rightFront forName:SDLNameRightFront];
}

- (SDLSingleTireStatus *)rightFront {
    return [store sdl_objectForName:SDLNameRightFront ofClass:SDLSingleTireStatus.class];
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    [store sdl_setObject:leftRear forName:SDLNameLeftRear];
}

- (SDLSingleTireStatus *)leftRear {
    return [store sdl_objectForName:SDLNameLeftRear ofClass:SDLSingleTireStatus.class];
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    [store sdl_setObject:rightRear forName:SDLNameRightRear];
}

- (SDLSingleTireStatus *)rightRear {
    return [store sdl_objectForName:SDLNameRightRear ofClass:SDLSingleTireStatus.class];
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    [store sdl_setObject:innerLeftRear forName:SDLNameInnerLeftRear];
}

- (SDLSingleTireStatus *)innerLeftRear {
    return [store sdl_objectForName:SDLNameInnerLeftRear ofClass:SDLSingleTireStatus.class];
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    [store sdl_setObject:innerRightRear forName:SDLNameInnerRightRear];
}

- (SDLSingleTireStatus *)innerRightRear {
    return [store sdl_objectForName:SDLNameInnerRightRear ofClass:SDLSingleTireStatus.class];
}

@end

NS_ASSUME_NONNULL_END
