//
//  SDLClimateControlCapabilities.m
//

#import "SDLClimateControlCapabilities.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClimateControlCapabilities

- (instancetype)initWithModuleName:(NSString *)moduleName fanSpeedAvailable:(BOOL)fanSpeedAvailable desiredTemperatureAvailable:(BOOL)desiredTemperatureAvailable acEnableAvailable:(BOOL)acEnableAvailable acMaxEnableAvailable:(BOOL)acMaxEnableAvailable circulateAirAvailable:(BOOL)circulateAirEnableAvailable autoModeEnableAvailable:(BOOL)autoModeEnableAvailable dualModeEnableAvailable:(BOOL)dualModeEnableAvailable defrostZoneAvailable:(BOOL)defrostZoneAvailable ventilationModeAvailable:(BOOL)ventilationModeAvailable {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.moduleName = moduleName;
    self.fanSpeedAvailable = @(fanSpeedAvailable);
    self.desiredTemperatureAvailable = @(desiredTemperatureAvailable);
    self.acEnableAvailable = @(acEnableAvailable);
    self.acMaxEnableAvailable = @(acMaxEnableAvailable);
    self.circulateAirEnableAvailable = @(circulateAirEnableAvailable);
    self.autoModeEnableAvailable = @(autoModeEnableAvailable);
    self.dualModeEnableAvailable = @(dualModeEnableAvailable);
    self.defrostZoneAvailable = @(defrostZoneAvailable);
    self.ventilationModeAvailable = @(ventilationModeAvailable);
    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [store sdl_setObject:moduleName forName:SDLNameModuleName];
}

- (NSString *)moduleName {
    return [store sdl_objectForName:SDLNameModuleName];
}

- (void)setFanSpeedAvailable:(nullable NSNumber<SDLBool> *)fanSpeedAvailable {
    [store sdl_setObject:fanSpeedAvailable forName:SDLNameFanSpeedAvailable];
}

- (nullable NSNumber<SDLBool> *)fanSpeedAvailable {
    return [store sdl_objectForName:SDLNameFanSpeedAvailable];
}

- (void)setDesiredTemperatureAvailable:(nullable NSNumber<SDLBool> *)desiredTemperatureAvailable {
    [store sdl_setObject:desiredTemperatureAvailable forName:SDLNameDesiredTemperatureAvailable];
}

- (nullable NSNumber<SDLBool> *)desiredTemperatureAvailable {
    return [store sdl_objectForName:SDLNameDesiredTemperatureAvailable];
}

- (void)setAcEnableAvailable:(nullable NSNumber<SDLBool> *)acEnableAvailable {
    [store sdl_setObject:acEnableAvailable forName:SDLNameACEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)acEnableAvailable {
    return [store sdl_objectForName:SDLNameACEnableAvailable];
}

- (void)setAcMaxEnableAvailable:(nullable NSNumber<SDLBool> *)acMaxEnableAvailable {
    [store sdl_setObject:acMaxEnableAvailable forName:SDLNameACMaxEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)acMaxEnableAvailable {
    return [store sdl_objectForName:SDLNameACMaxEnableAvailable];
}

- (void)setCirculateAirEnableAvailable:(nullable NSNumber<SDLBool> *)circulateAirEnableAvailable {
    [store sdl_setObject:circulateAirEnableAvailable forName:SDLNameCirculateAirEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)circulateAirEnableAvailable {
    return [store sdl_objectForName:SDLNameCirculateAirEnableAvailable];
}

- (void)setAutoModeEnableAvailable:(nullable NSNumber<SDLBool> *)autoModeEnableAvailable {
    [store sdl_setObject:autoModeEnableAvailable forName:SDLNameAutoModeEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)autoModeEnableAvailable {
    return [store sdl_objectForName:SDLNameAutoModeEnableAvailable];
}

- (void)setDualModeEnableAvailable:(nullable NSNumber<SDLBool> *)dualModeEnableAvailable {
    [store sdl_setObject:dualModeEnableAvailable forName:SDLNameDualModeEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)dualModeEnableAvailable {
    return [store sdl_objectForName:SDLNameDualModeEnableAvailable];
}

- (void)setDefrostZoneAvailable:(nullable NSNumber<SDLBool> *)defrostZoneAvailable {
    [store sdl_setObject:defrostZoneAvailable forName:SDLNameDefrostZoneAvailable];
}

- (nullable NSNumber<SDLBool> *)defrostZoneAvailable {
    return [store sdl_objectForName:SDLNameDefrostZoneAvailable];
}

- (void)setDefrostZone:(nullable NSArray <SDLDefrostZone>*)defrostZone {
    [store sdl_setObject:defrostZone forName:SDLNameDefrostZone];
}

- (nullable NSArray<SDLDefrostZone> *)defrostZone {
    return [store sdl_objectForName:SDLNameDefrostZone];
}

- (void)setVentilationModeAvailable:(nullable NSNumber<SDLBool> *)ventilationModeAvailable {
    [store sdl_setObject:ventilationModeAvailable forName:SDLNameVentilationModeAvailable];
}

- (nullable NSNumber<SDLBool> *)ventilationModeAvailable {
    return [store sdl_objectForName:SDLNameVentilationModeAvailable];
}

- (void)setVentilationMode:(nullable NSArray<SDLVentilationMode> *)ventilationMode {
    [store sdl_setObject:ventilationMode forName:SDLNameVentilationMode];
}

- (nullable NSArray<SDLVentilationMode> *)ventilationMode {
    return [store sdl_objectForName:SDLNameVentilationMode];
}

@end

NS_ASSUME_NONNULL_END
