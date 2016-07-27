//  SDLTireStatus.m
//

#import "SDLTireStatus.h"

#import "SDLNames.h"
#import "SDLSingleTireStatus.h"
#import "SDLWarningLightStatus.h"


@implementation SDLTireStatus

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setPressureTelltale:(SDLWarningLightStatus *)pressureTelltale {
    if (pressureTelltale != nil) {
        [store setObject:pressureTelltale forKey:NAMES_pressureTelltale];
    } else {
        [store removeObjectForKey:NAMES_pressureTelltale];
    }
}

- (SDLWarningLightStatus *)pressureTelltale {
    NSObject *obj = [store objectForKey:NAMES_pressureTelltale];
    if (obj == nil || [obj isKindOfClass:SDLWarningLightStatus.class]) {
        return (SDLWarningLightStatus *)obj;
    } else {
        return [SDLWarningLightStatus valueOf:(NSString *)obj];
    }
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    if (leftFront != nil) {
        [store setObject:leftFront forKey:NAMES_leftFront];
    } else {
        [store removeObjectForKey:NAMES_leftFront];
    }
}

- (SDLSingleTireStatus *)leftFront {
    NSObject *obj = [store objectForKey:NAMES_leftFront];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    if (rightFront != nil) {
        [store setObject:rightFront forKey:NAMES_rightFront];
    } else {
        [store removeObjectForKey:NAMES_rightFront];
    }
}

- (SDLSingleTireStatus *)rightFront {
    NSObject *obj = [store objectForKey:NAMES_rightFront];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    if (leftRear != nil) {
        [store setObject:leftRear forKey:NAMES_leftRear];
    } else {
        [store removeObjectForKey:NAMES_leftRear];
    }
}

- (SDLSingleTireStatus *)leftRear {
    NSObject *obj = [store objectForKey:NAMES_leftRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    if (rightRear != nil) {
        [store setObject:rightRear forKey:NAMES_rightRear];
    } else {
        [store removeObjectForKey:NAMES_rightRear];
    }
}

- (SDLSingleTireStatus *)rightRear {
    NSObject *obj = [store objectForKey:NAMES_rightRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    if (innerLeftRear != nil) {
        [store setObject:innerLeftRear forKey:NAMES_innerLeftRear];
    } else {
        [store removeObjectForKey:NAMES_innerLeftRear];
    }
}

- (SDLSingleTireStatus *)innerLeftRear {
    NSObject *obj = [store objectForKey:NAMES_innerLeftRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    if (innerRightRear != nil) {
        [store setObject:innerRightRear forKey:NAMES_innerRightRear];
    } else {
        [store removeObjectForKey:NAMES_innerRightRear];
    }
}

- (SDLSingleTireStatus *)innerRightRear {
    NSObject *obj = [store objectForKey:NAMES_innerRightRear];
    if (obj == nil || [obj isKindOfClass:SDLSingleTireStatus.class]) {
        return (SDLSingleTireStatus *)obj;
    } else {
        return [[SDLSingleTireStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
