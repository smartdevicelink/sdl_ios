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
    SDLWarningLightStatus warningLightStatus = [self.store sdl_enumForName:SDLRPCParameterNamePressureTelltale error:&error];
    if (warningLightStatus == nil) {
        [self.store sdl_setObject:SDLWarningLightStatusNotUsed forName:SDLRPCParameterNamePressureTelltale];
        warningLightStatus = SDLWarningLightStatusNotUsed;
        SDLLogW(@"SDLTireStatus.pressureTelltale was nil and will be set to .notUsed. In the future, this will change to be nullable.");
    }

    return warningLightStatus;
}

- (void)setLeftFront:(SDLSingleTireStatus *)leftFront {
    [self.store sdl_setObject:leftFront forName:SDLRPCParameterNameLeftFront];
}

- (SDLSingleTireStatus *)leftFront {
    NSError *error = nil;
    SDLSingleTireStatus *tireStatus = [self.store sdl_objectForName:SDLRPCParameterNameLeftFront ofClass:SDLSingleTireStatus.class error:&error];
    if (tireStatus == nil) {
        SDLSingleTireStatus *newTireStatus = [[SDLSingleTireStatus alloc] init];
        newTireStatus.status = SDLComponentVolumeStatusUnknown;
        [self.store sdl_setObject:newTireStatus forName:SDLRPCParameterNameLeftFront];
        tireStatus = newTireStatus;
        SDLLogW(@"SDLTireStatus.leftFront was nil and will be set to .unknown. In the future, this will change to be nullable.");
    }

    return tireStatus;
}

- (void)setRightFront:(SDLSingleTireStatus *)rightFront {
    [self.store sdl_setObject:rightFront forName:SDLRPCParameterNameRightFront];
}

- (SDLSingleTireStatus *)rightFront {
    NSError *error = nil;
    SDLSingleTireStatus *tireStatus = [self.store sdl_objectForName:SDLRPCParameterNameRightFront ofClass:SDLSingleTireStatus.class error:&error];
    if (tireStatus == nil) {
        SDLSingleTireStatus *newTireStatus = [[SDLSingleTireStatus alloc] init];
        newTireStatus.status = SDLComponentVolumeStatusUnknown;
        [self.store sdl_setObject:newTireStatus forName:SDLRPCParameterNameRightFront];
        tireStatus = newTireStatus;
        SDLLogW(@"SDLTireStatus.rightFront was nil and will be set to .unknown. In the future, this will change to be nullable.");
    }

    return tireStatus;
}

- (void)setLeftRear:(SDLSingleTireStatus *)leftRear {
    [self.store sdl_setObject:leftRear forName:SDLRPCParameterNameLeftRear];
}

- (SDLSingleTireStatus *)leftRear {
    NSError *error = nil;
    SDLSingleTireStatus *tireStatus = [self.store sdl_objectForName:SDLRPCParameterNameLeftRear ofClass:SDLSingleTireStatus.class error:&error];
    if (tireStatus == nil) {
        SDLSingleTireStatus *newTireStatus = [[SDLSingleTireStatus alloc] init];
        newTireStatus.status = SDLComponentVolumeStatusUnknown;
        [self.store sdl_setObject:newTireStatus forName:SDLRPCParameterNameLeftRear];
        tireStatus = newTireStatus;
        SDLLogW(@"SDLTireStatus.leftRear was nil and will be set to .unknown. In the future, this will change to be nullable.");
    }

    return tireStatus;
}

- (void)setRightRear:(SDLSingleTireStatus *)rightRear {
    [self.store sdl_setObject:rightRear forName:SDLRPCParameterNameRightRear];
}

- (SDLSingleTireStatus *)rightRear {
    NSError *error = nil;
    SDLSingleTireStatus *tireStatus = [self.store sdl_objectForName:SDLRPCParameterNameRightRear ofClass:SDLSingleTireStatus.class error:&error];
    if (tireStatus == nil) {
        SDLSingleTireStatus *newTireStatus = [[SDLSingleTireStatus alloc] init];
        newTireStatus.status = SDLComponentVolumeStatusUnknown;
        [self.store sdl_setObject:newTireStatus forName:SDLRPCParameterNameRightRear];
        tireStatus = newTireStatus;
        SDLLogW(@"SDLTireStatus.rightRear was nil and will be set to .unknown. In the future, this will change to be nullable.");
    }

    return tireStatus;
}

- (void)setInnerLeftRear:(SDLSingleTireStatus *)innerLeftRear {
    [self.store sdl_setObject:innerLeftRear forName:SDLRPCParameterNameInnerLeftRear];
}

- (SDLSingleTireStatus *)innerLeftRear {
    NSError *error = nil;
    SDLSingleTireStatus *tireStatus = [self.store sdl_objectForName:SDLRPCParameterNameInnerLeftRear ofClass:SDLSingleTireStatus.class error:&error];
    if (tireStatus == nil) {
        SDLSingleTireStatus *newTireStatus = [[SDLSingleTireStatus alloc] init];
        newTireStatus.status = SDLComponentVolumeStatusUnknown;
        [self.store sdl_setObject:newTireStatus forName:SDLRPCParameterNameInnerLeftRear];
        tireStatus = newTireStatus;
        SDLLogW(@"SDLTireStatus.innerLeftRear was nil and will be set to .unknown. In the future, this will change to be nullable.");
    }

    return tireStatus;
}

- (void)setInnerRightRear:(SDLSingleTireStatus *)innerRightRear {
    [self.store sdl_setObject:innerRightRear forName:SDLRPCParameterNameInnerRightRear];
}

- (SDLSingleTireStatus *)innerRightRear {
    NSError *error = nil;
    SDLSingleTireStatus *tireStatus = [self.store sdl_objectForName:SDLRPCParameterNameInnerRightRear ofClass:SDLSingleTireStatus.class error:&error];
    if (tireStatus == nil) {
        SDLSingleTireStatus *newTireStatus = [[SDLSingleTireStatus alloc] init];
        newTireStatus.status = SDLComponentVolumeStatusUnknown;
        [self.store sdl_setObject:newTireStatus forName:SDLRPCParameterNameInnerRightRear];
        tireStatus = newTireStatus;
        SDLLogW(@"SDLTireStatus.innerRightRear was nil and will be set to .unknown. In the future, this will change to be nullable.");
    }

    return tireStatus;
}

@end

NS_ASSUME_NONNULL_END
