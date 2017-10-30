//
//  SDLClimateControlData.m
//

#import "SDLClimateControlData.h"
#import "SDLNames.h"
#import "SDLTemperature.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClimateControlData

- (instancetype)initWithFanSpeed:(nullable NSNumber<SDLInt> *)fanSpeed desiredTemperature:(nullable SDLTemperature *)desiredTemperature acEnable:(nullable NSNumber<SDLBool> *)acEnable circulateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable autoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable defrostZone:(nullable SDLDefrostZone)defrostZone dualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable acMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable ventilationMode:(nullable SDLVentilationMode)ventilationMode {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.fanSpeed = fanSpeed;
    self.desiredTemperature = desiredTemperature;
    self.acEnable = acEnable;
    self.circulateAirEnable = circulateAirEnable;
    self.autoModeEnable = autoModeEnable;
    self.defrostZone = defrostZone;
    self.dualModeEnable = dualModeEnable;
    self.acMaxEnable = acMaxEnable;
    self.ventilationMode = ventilationMode;
    
    return self;
}

- (void)setFanSpeed:(nullable NSNumber<SDLInt> *)fanSpeed {
    [store sdl_setObject:fanSpeed forName:SDLNameFanSpeed];
}

- (nullable NSNumber<SDLInt> *)fanSpeed {
    return [store sdl_objectForName:SDLNameFanSpeed];
}

- (void)setCurrentTemperature:(nullable SDLTemperature *)currentTemperature {
    [store sdl_setObject:currentTemperature forName:SDLNameCurrentTemperature];
}

- (nullable SDLTemperature *)currentTemperature {
    return [store sdl_objectForName:SDLNameCurrentTemperature ofClass:SDLTemperature.class];
}

- (void)setDesiredTemperature:(nullable SDLTemperature *)desiredTemperature {
    [store sdl_setObject:desiredTemperature forName:SDLNameDesiredTemperature];
}

- (nullable SDLTemperature *)desiredTemperature {
    return [store sdl_objectForName:SDLNameDesiredTemperature ofClass:SDLTemperature.class];
}

- (void)setAcEnable:(nullable NSNumber<SDLBool> *)acEnable {
    [store sdl_setObject:acEnable forName:SDLNameACEnable];
}

- (nullable NSNumber<SDLBool> *)acEnable {
    return [store sdl_objectForName:SDLNameACEnable];
}

- (void)setCirculateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable {
    [store sdl_setObject:circulateAirEnable forName:SDLNameCirculateAirEnable];
}

- (nullable NSNumber<SDLBool> *)circulateAirEnable {
    return [store sdl_objectForName:SDLNameCirculateAirEnable];
}

- (void)setAutoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable {
    [store sdl_setObject:autoModeEnable forName:SDLNameAutoModeEnable];
}

- (nullable NSNumber<SDLBool> *)autoModeEnable {
    return [store sdl_objectForName:SDLNameAutoModeEnable];
}

- (void)setDefrostZone:(nullable SDLDefrostZone)defrostZone {
    [store sdl_setObject:defrostZone forName:SDLNameDefrostZone];
}

- (nullable SDLDefrostZone)defrostZone {
    return [store sdl_objectForName:SDLNameDefrostZone];
}

- (void)setDualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable {
    [store sdl_setObject:dualModeEnable forName:SDLNameDualModeEnable];
}

- (nullable NSNumber<SDLBool> *)dualModeEnable {
    return [store sdl_objectForName:SDLNameDualModeEnable];
}

- (void)setAcMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable {
    [store sdl_setObject:acMaxEnable forName:SDLNameACMaxEnable];
}

- (nullable NSNumber<SDLBool> *)acMaxEnable {
    return [store sdl_objectForName:SDLNameACMaxEnable];
}

- (void)setVentilationMode:(nullable SDLVentilationMode)ventilationMode {
    [store sdl_setObject:ventilationMode forName:SDLNameVentilationMode];
}

- (nullable SDLVentilationMode)ventilationMode {
    return [store sdl_objectForName:SDLNameVentilationMode];
}

@end

NS_ASSUME_NONNULL_END
