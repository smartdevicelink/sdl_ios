//  SDLTireStatus.m
//

#import "SDLTireStatus.h"

#import "SDLNames.h"
#import "SDLSingleTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTireStatus

- (void)setPressureTelltale:(SDLWarningLightStatus)pressureTelltale {
    if (pressureTelltale != nil) {
        [store setObject:pressureTelltale forKey:SDLNamePressureTelltale];
    } else {
        [store removeObjectForKey:SDLNamePressureTelltale];
    }
}

- (SDLWarningLightStatus)pressureTelltale {
    NSObject *obj = [store objectForKey:SDLNamePressureTelltale];
    return (SDLWarningLightStatus)obj;
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    if (leftFront != nil) {
        [store setObject:leftFront forKey:SDLNameLeftFront];
    } else {
        [store removeObjectForKey:SDLNameLeftFront];
    }
}

- (SDLSingleTireStatus *)leftFront {
    NSObject *obj = [store objectForKey:SDLNameLeftFront];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLSingleTireStatus*)obj;

}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    if (rightFront != nil) {
        [store setObject:rightFront forKey:SDLNameRightFront];
    } else {
        [store removeObjectForKey:SDLNameRightFront];
    }
}

- (SDLSingleTireStatus *)rightFront {
    NSObject *obj = [store objectForKey:SDLNameRightFront];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLSingleTireStatus*)obj;
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    if (leftRear != nil) {
        [store setObject:leftRear forKey:SDLNameLeftRear];
    } else {
        [store removeObjectForKey:SDLNameLeftRear];
    }
}

- (SDLSingleTireStatus *)leftRear {
    NSObject *obj = [store objectForKey:SDLNameLeftRear];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLSingleTireStatus*)obj;
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    if (rightRear != nil) {
        [store setObject:rightRear forKey:SDLNameRightRear];
    } else {
        [store removeObjectForKey:SDLNameRightRear];
    }
}

- (SDLSingleTireStatus *)rightRear {
    NSObject *obj = [store objectForKey:SDLNameRightRear];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLSingleTireStatus*)obj;
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    if (innerLeftRear != nil) {
        [store setObject:innerLeftRear forKey:SDLNameInnerLeftRear];
    } else {
        [store removeObjectForKey:SDLNameInnerLeftRear];
    }
}

- (SDLSingleTireStatus *)innerLeftRear {
    NSObject *obj = [store objectForKey:SDLNameInnerLeftRear];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLSingleTireStatus*)obj;
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    if (innerRightRear != nil) {
        [store setObject:innerRightRear forKey:SDLNameInnerRightRear];
    } else {
        [store removeObjectForKey:SDLNameInnerRightRear];
    }
}

- (SDLSingleTireStatus *)innerRightRear {
    NSObject *obj = [store objectForKey:SDLNameInnerRightRear];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLSingleTireStatus*)obj;
}

@end

NS_ASSUME_NONNULL_END
