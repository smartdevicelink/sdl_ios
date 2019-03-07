//
//  SDLClimateControlCapabilities.m
//

#import "SDLClimateControlCapabilities.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClimateControlCapabilities

- (instancetype)initWithModuleName:(NSString *)moduleName fanSpeedAvailable:(BOOL)fanSpeedAvailable desiredTemperatureAvailable:(BOOL)desiredTemperatureAvailable acEnableAvailable:(BOOL)acEnableAvailable acMaxEnableAvailable:(BOOL)acMaxEnableAvailable circulateAirAvailable:(BOOL)circulateAirEnableAvailable autoModeEnableAvailable:(BOOL)autoModeEnableAvailable dualModeEnableAvailable:(BOOL)dualModeEnableAvailable defrostZoneAvailable:(BOOL)defrostZoneAvailable ventilationModeAvailable:(BOOL)ventilationModeAvailable {

    return [self initWithModuleName:moduleName fanSpeedAvailable:fanSpeedAvailable desiredTemperatureAvailable:desiredTemperatureAvailable acEnableAvailable:acEnableAvailable acMaxEnableAvailable:acMaxEnableAvailable circulateAirAvailable:circulateAirEnableAvailable autoModeEnableAvailable:autoModeEnableAvailable dualModeEnableAvailable:dualModeEnableAvailable defrostZoneAvailable:defrostZoneAvailable ventilationModeAvailable:ventilationModeAvailable heatedSteeringWheelAvailable:NO heatedWindshieldAvailable:NO heatedRearWindowAvailable:NO heatedMirrorsAvailable:NO];
}

- (instancetype)initWithModuleName:(NSString *)moduleName fanSpeedAvailable:(BOOL)fanSpeedAvailable desiredTemperatureAvailable:(BOOL)desiredTemperatureAvailable acEnableAvailable:(BOOL)acEnableAvailable acMaxEnableAvailable:(BOOL)acMaxEnableAvailable circulateAirAvailable:(BOOL)circulateAirEnableAvailable autoModeEnableAvailable:(BOOL)autoModeEnableAvailable dualModeEnableAvailable:(BOOL)dualModeEnableAvailable defrostZoneAvailable:(BOOL)defrostZoneAvailable ventilationModeAvailable:(BOOL)ventilationModeAvailable heatedSteeringWheelAvailable:(BOOL)steeringWheelAvailable heatedWindshieldAvailable:(BOOL)windshieldAvailable heatedRearWindowAvailable:(BOOL)rearWindowAvailable heatedMirrorsAvailable:(BOOL)mirrorsAvailable {
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
    self.heatedSteeringWheelAvailable = @(steeringWheelAvailable);
    self.heatedWindshieldAvailable = @(windshieldAvailable);
    self.heatedRearWindowAvailable = @(rearWindowAvailable);
    self.heatedMirrorsAvailable = @(mirrorsAvailable);
    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [store sdl_setObject:moduleName forName:SDLNameModuleName];
}

- (NSString *)moduleName {
    NSError *error;
    return [store sdl_objectForName:SDLNameModuleName ofClass:NSString.class error:&error];
}

- (void)setFanSpeedAvailable:(nullable NSNumber<SDLBool> *)fanSpeedAvailable {
    [store sdl_setObject:fanSpeedAvailable forName:SDLNameFanSpeedAvailable];
}

- (nullable NSNumber<SDLBool> *)fanSpeedAvailable {
    return [store sdl_objectForName:SDLNameFanSpeedAvailable ofClass:NSNumber.class];
}

- (void)setDesiredTemperatureAvailable:(nullable NSNumber<SDLBool> *)desiredTemperatureAvailable {
    [store sdl_setObject:desiredTemperatureAvailable forName:SDLNameDesiredTemperatureAvailable];
}

- (nullable NSNumber<SDLBool> *)desiredTemperatureAvailable {
    return [store sdl_objectForName:SDLNameDesiredTemperatureAvailable ofClass:NSNumber.class];
}

- (void)setAcEnableAvailable:(nullable NSNumber<SDLBool> *)acEnableAvailable {
    [store sdl_setObject:acEnableAvailable forName:SDLNameACEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)acEnableAvailable {
    return [store sdl_objectForName:SDLNameACEnableAvailable ofClass:NSNumber.class];
}

- (void)setAcMaxEnableAvailable:(nullable NSNumber<SDLBool> *)acMaxEnableAvailable {
    [store sdl_setObject:acMaxEnableAvailable forName:SDLNameACMaxEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)acMaxEnableAvailable {
    return [store sdl_objectForName:SDLNameACMaxEnableAvailable ofClass:NSNumber.class];
}

- (void)setCirculateAirEnableAvailable:(nullable NSNumber<SDLBool> *)circulateAirEnableAvailable {
    [store sdl_setObject:circulateAirEnableAvailable forName:SDLNameCirculateAirEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)circulateAirEnableAvailable {
    return [store sdl_objectForName:SDLNameCirculateAirEnableAvailable ofClass:NSNumber.class];
}

- (void)setAutoModeEnableAvailable:(nullable NSNumber<SDLBool> *)autoModeEnableAvailable {
    [store sdl_setObject:autoModeEnableAvailable forName:SDLNameAutoModeEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)autoModeEnableAvailable {
    return [store sdl_objectForName:SDLNameAutoModeEnableAvailable ofClass:NSNumber.class];
}

- (void)setDualModeEnableAvailable:(nullable NSNumber<SDLBool> *)dualModeEnableAvailable {
    [store sdl_setObject:dualModeEnableAvailable forName:SDLNameDualModeEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)dualModeEnableAvailable {
    return [store sdl_objectForName:SDLNameDualModeEnableAvailable ofClass:NSNumber.class];
}

- (void)setDefrostZoneAvailable:(nullable NSNumber<SDLBool> *)defrostZoneAvailable {
    [store sdl_setObject:defrostZoneAvailable forName:SDLNameDefrostZoneAvailable];
}

- (nullable NSNumber<SDLBool> *)defrostZoneAvailable {
    return [store sdl_objectForName:SDLNameDefrostZoneAvailable ofClass:NSNumber.class];
}

- (void)setDefrostZone:(nullable NSArray <SDLDefrostZone>*)defrostZone {
    [store sdl_setObject:defrostZone forName:SDLNameDefrostZone];
}

- (nullable NSArray<SDLDefrostZone> *)defrostZone {
    return [store sdl_enumsForName:SDLNameDefrostZone];
}

- (void)setVentilationModeAvailable:(nullable NSNumber<SDLBool> *)ventilationModeAvailable {
    [store sdl_setObject:ventilationModeAvailable forName:SDLNameVentilationModeAvailable];
}

- (nullable NSNumber<SDLBool> *)ventilationModeAvailable {
    return [store sdl_objectForName:SDLNameVentilationModeAvailable ofClass:NSNumber.class];
}

- (void)setVentilationMode:(nullable NSArray<SDLVentilationMode> *)ventilationMode {
    [store sdl_setObject:ventilationMode forName:SDLNameVentilationMode];
}

- (nullable NSArray<SDLVentilationMode> *)ventilationMode {
    return [store sdl_enumsForName:SDLNameVentilationMode];
}

- (void)setHeatedSteeringWheelAvailable:(nullable NSNumber<SDLBool> *)heatedSteeringWheelAvailable {
    [store sdl_setObject:heatedSteeringWheelAvailable forName:SDLNameHeatedSteeringWheelAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedSteeringWheelAvailable {
    return [store sdl_objectForName:SDLNameHeatedSteeringWheelAvailable ofClass:NSNumber.class];
}

- (void)setHeatedWindshieldAvailable:(nullable NSNumber<SDLBool> *)heatedWindshieldAvailable {
    [store sdl_setObject:heatedWindshieldAvailable forName:SDLNameHeatedWindshieldAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedWindshieldAvailable {
    return [store sdl_objectForName:SDLNameHeatedWindshieldAvailable ofClass:NSNumber.class];
}

- (void)setHeatedRearWindowAvailable:(nullable NSNumber<SDLBool> *)heatedRearWindowAvailable {
    [store sdl_setObject:heatedRearWindowAvailable forName:SDLNameHeatedRearWindowAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedRearWindowAvailable {
    return [store sdl_objectForName:SDLNameHeatedRearWindowAvailable ofClass:NSNumber.class];
}

- (void)setHeatedMirrorsAvailable:(nullable NSNumber<SDLBool> *)heatedMirrorsAvailable {
    [store sdl_setObject:heatedMirrorsAvailable forName:SDLNameHeatedMirrorsAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedMirrorsAvailable {
    return [store sdl_objectForName:SDLNameHeatedMirrorsAvailable ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
