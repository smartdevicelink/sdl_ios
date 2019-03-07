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
    NSError *error;
    return [store sdl_enumForName:SDLNamePressureTelltale error:&error];
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    [store sdl_setObject:leftFront forName:SDLNameLeftFront];
}

- (SDLSingleTireStatus *)leftFront {
    NSError *error;
    return [store sdl_objectForName:SDLNameLeftFront ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    [store sdl_setObject:rightFront forName:SDLNameRightFront];
}

- (SDLSingleTireStatus *)rightFront {
    NSError *error;
    return [store sdl_objectForName:SDLNameRightFront ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    [store sdl_setObject:leftRear forName:SDLNameLeftRear];
}

- (SDLSingleTireStatus *)leftRear {
    NSError *error;
    return [store sdl_objectForName:SDLNameLeftRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    [store sdl_setObject:rightRear forName:SDLNameRightRear];
}

- (SDLSingleTireStatus *)rightRear {
    NSError *error;
    return [store sdl_objectForName:SDLNameRightRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    [store sdl_setObject:innerLeftRear forName:SDLNameInnerLeftRear];
}

- (SDLSingleTireStatus *)innerLeftRear {
    NSError *error;
    return [store sdl_objectForName:SDLNameInnerLeftRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    [store sdl_setObject:innerRightRear forName:SDLNameInnerRightRear];
}

- (SDLSingleTireStatus *)innerRightRear {
    NSError *error;
    return [store sdl_objectForName:SDLNameInnerRightRear ofClass:SDLSingleTireStatus.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
