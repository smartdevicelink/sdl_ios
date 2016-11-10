//  SDLTireStatus.m
//

#import "SDLTireStatus.h"

#import "SDLNames.h"
#import "SDLSingleTireStatus.h"
#import "SDLWarningLightStatus.h"

@implementation SDLTireStatus

- (void)setPressureTelltale:(SDLWarningLightStatus)pressureTelltale {
    [store sdl_setObject:pressureTelltale forName:SDLNamePressureTelltale];
}

- (SDLWarningLightStatus)pressureTelltale {
    NSObject *obj = [store objectForKey:SDLNamePressureTelltale];
    return (SDLWarningLightStatus)obj;
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    [store sdl_setObject:leftFront forName:SDLNameLeftFront];
}

- (SDLSingleTireStatus *)leftFront {
    NSObject *obj = [store objectForKey:SDLNameLeftFront];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    [store sdl_setObject:rightFront forName:SDLNameRightFront];
}

- (SDLSingleTireStatus *)rightFront {
    NSObject *obj = [store objectForKey:SDLNameRightFront];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    [store sdl_setObject:leftRear forName:SDLNameLeftRear];
}

- (SDLSingleTireStatus *)leftRear {
    NSObject *obj = [store objectForKey:SDLNameLeftRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    [store sdl_setObject:rightRear forName:SDLNameRightRear];
}

- (SDLSingleTireStatus *)rightRear {
    NSObject *obj = [store objectForKey:SDLNameRightRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    [store sdl_setObject:innerLeftRear forName:SDLNameInnerLeftRear];
}

- (SDLSingleTireStatus *)innerLeftRear {
    NSObject *obj = [store objectForKey:SDLNameInnerLeftRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    [store sdl_setObject:innerRightRear forName:SDLNameInnerRightRear];
}

- (SDLSingleTireStatus *)innerRightRear {
    NSObject *obj = [store objectForKey:SDLNameInnerRightRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
