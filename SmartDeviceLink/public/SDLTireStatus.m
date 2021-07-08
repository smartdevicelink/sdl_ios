//  SDLTireStatus.m
//

#import "SDLTireStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLSingleTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTireStatus

- (void)setPressureTelltale:(SDLWarningLightStatus __nullable)pressureTelltale {
    [self.store sdl_setObject:pressureTelltale forName:SDLRPCParameterNamePressureTelltale];
}

- (SDLWarningLightStatus __nullable)pressureTelltale {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNamePressureTelltale error:&error];
}

- (void)setLeftFront:(SDLSingleTireStatus * __nullable)leftFront {
    [self.store sdl_setObject:leftFront forName:SDLRPCParameterNameLeftFront];
}

- (SDLSingleTireStatus * __nullable)leftFront {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLeftFront ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setRightFront:(SDLSingleTireStatus * __nullable)rightFront {
    [self.store sdl_setObject:rightFront forName:SDLRPCParameterNameRightFront];
}

- (SDLSingleTireStatus * __nullable)rightFront {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRightFront ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setLeftRear:(SDLSingleTireStatus * __nullable)leftRear {
    [self.store sdl_setObject:leftRear forName:SDLRPCParameterNameLeftRear];
}

- (SDLSingleTireStatus * __nullable)leftRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLeftRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setRightRear:(SDLSingleTireStatus * __nullable)rightRear {
    [self.store sdl_setObject:rightRear forName:SDLRPCParameterNameRightRear];
}

- (SDLSingleTireStatus * __nullable)rightRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRightRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setInnerLeftRear:(SDLSingleTireStatus * __nullable)innerLeftRear {
    [self.store sdl_setObject:innerLeftRear forName:SDLRPCParameterNameInnerLeftRear];
}

- (SDLSingleTireStatus * __nullable)innerLeftRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameInnerLeftRear ofClass:SDLSingleTireStatus.class error:&error];
}

- (void)setInnerRightRear:(SDLSingleTireStatus * __nullable)innerRightRear {
    [self.store sdl_setObject:innerRightRear forName:SDLRPCParameterNameInnerRightRear];
}

- (SDLSingleTireStatus * __nullable)innerRightRear {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameInnerRightRear ofClass:SDLSingleTireStatus.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
