//
//  SDLClimateControlCapabilities.m
//

#import "SDLClimateControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLClimateControlCapabilities

- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo fanSpeedAvailable:(BOOL)fanSpeedAvailable desiredTemperatureAvailable:(BOOL)desiredTemperatureAvailable acEnableAvailable:(BOOL)acEnableAvailable acMaxEnableAvailable:(BOOL)acMaxEnableAvailable circulateAirAvailable:(BOOL)circulateAirEnableAvailable autoModeEnableAvailable:(BOOL)autoModeEnableAvailable dualModeEnableAvailable:(BOOL)dualModeEnableAvailable defrostZoneAvailable:(BOOL)defrostZoneAvailable ventilationModeAvailable:(BOOL)ventilationModeAvailable heatedSteeringWheelAvailable:(BOOL)steeringWheelAvailable heatedWindshieldAvailable:(BOOL)windshieldAvailable heatedRearWindowAvailable:(BOOL)rearWindowAvailable heatedMirrorsAvailable:(BOOL)mirrorsAvailable climateEnableAvailable:(BOOL)climateEnableAvailable{
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.moduleName = moduleName;
    self.moduleInfo = moduleInfo;
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
    self.climateEnableAvailable = @(climateEnableAvailable);
    return self;
}

- (void)setModuleName:(NSString *)moduleName {
    [self.store sdl_setObject:moduleName forName:SDLRPCParameterNameModuleName];
}

- (NSString *)moduleName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleName ofClass:NSString.class error:&error];
}

- (void)setFanSpeedAvailable:(nullable NSNumber<SDLBool> *)fanSpeedAvailable {
    [self.store sdl_setObject:fanSpeedAvailable forName:SDLRPCParameterNameFanSpeedAvailable];
}

- (nullable NSNumber<SDLBool> *)fanSpeedAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameFanSpeedAvailable ofClass:NSNumber.class error:nil];
}

- (void)setDesiredTemperatureAvailable:(nullable NSNumber<SDLBool> *)desiredTemperatureAvailable {
    [self.store sdl_setObject:desiredTemperatureAvailable forName:SDLRPCParameterNameDesiredTemperatureAvailable];
}

- (nullable NSNumber<SDLBool> *)desiredTemperatureAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameDesiredTemperatureAvailable ofClass:NSNumber.class error:nil];
}

- (void)setAcEnableAvailable:(nullable NSNumber<SDLBool> *)acEnableAvailable {
    [self.store sdl_setObject:acEnableAvailable forName:SDLRPCParameterNameACEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)acEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameACEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setAcMaxEnableAvailable:(nullable NSNumber<SDLBool> *)acMaxEnableAvailable {
    [self.store sdl_setObject:acMaxEnableAvailable forName:SDLRPCParameterNameACMaxEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)acMaxEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameACMaxEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setCirculateAirEnableAvailable:(nullable NSNumber<SDLBool> *)circulateAirEnableAvailable {
    [self.store sdl_setObject:circulateAirEnableAvailable forName:SDLRPCParameterNameCirculateAirEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)circulateAirEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameCirculateAirEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setAutoModeEnableAvailable:(nullable NSNumber<SDLBool> *)autoModeEnableAvailable {
    [self.store sdl_setObject:autoModeEnableAvailable forName:SDLRPCParameterNameAutoModeEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)autoModeEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameAutoModeEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setDualModeEnableAvailable:(nullable NSNumber<SDLBool> *)dualModeEnableAvailable {
    [self.store sdl_setObject:dualModeEnableAvailable forName:SDLRPCParameterNameDualModeEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)dualModeEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameDualModeEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setDefrostZoneAvailable:(nullable NSNumber<SDLBool> *)defrostZoneAvailable {
    [self.store sdl_setObject:defrostZoneAvailable forName:SDLRPCParameterNameDefrostZoneAvailable];
}

- (nullable NSNumber<SDLBool> *)defrostZoneAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameDefrostZoneAvailable ofClass:NSNumber.class error:nil];
}

- (void)setDefrostZone:(nullable NSArray <SDLDefrostZone>*)defrostZone {
    [self.store sdl_setObject:defrostZone forName:SDLRPCParameterNameDefrostZone];
}

- (nullable NSArray<SDLDefrostZone> *)defrostZone {
    return [self.store sdl_enumsForName:SDLRPCParameterNameDefrostZone error:nil];
}

- (void)setVentilationModeAvailable:(nullable NSNumber<SDLBool> *)ventilationModeAvailable {
    [self.store sdl_setObject:ventilationModeAvailable forName:SDLRPCParameterNameVentilationModeAvailable];
}

- (nullable NSNumber<SDLBool> *)ventilationModeAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameVentilationModeAvailable ofClass:NSNumber.class error:nil];
}

- (void)setVentilationMode:(nullable NSArray<SDLVentilationMode> *)ventilationMode {
    [self.store sdl_setObject:ventilationMode forName:SDLRPCParameterNameVentilationMode];
}

- (nullable NSArray<SDLVentilationMode> *)ventilationMode {
    return [self.store sdl_enumsForName:SDLRPCParameterNameVentilationMode error:nil];
}

- (void)setHeatedSteeringWheelAvailable:(nullable NSNumber<SDLBool> *)heatedSteeringWheelAvailable {
    [self.store sdl_setObject:heatedSteeringWheelAvailable forName:SDLRPCParameterNameHeatedSteeringWheelAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedSteeringWheelAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatedSteeringWheelAvailable ofClass:NSNumber.class error:nil];
}

- (void)setHeatedWindshieldAvailable:(nullable NSNumber<SDLBool> *)heatedWindshieldAvailable {
    [self.store sdl_setObject:heatedWindshieldAvailable forName:SDLRPCParameterNameHeatedWindshieldAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedWindshieldAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatedWindshieldAvailable ofClass:NSNumber.class error:nil];
}

- (void)setHeatedRearWindowAvailable:(nullable NSNumber<SDLBool> *)heatedRearWindowAvailable {
    [self.store sdl_setObject:heatedRearWindowAvailable forName:SDLRPCParameterNameHeatedRearWindowAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedRearWindowAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatedRearWindowAvailable ofClass:NSNumber.class error:nil];
}

- (void)setHeatedMirrorsAvailable:(nullable NSNumber<SDLBool> *)heatedMirrorsAvailable {
    [self.store sdl_setObject:heatedMirrorsAvailable forName:SDLRPCParameterNameHeatedMirrorsAvailable];
}

- (nullable NSNumber<SDLBool> *)heatedMirrorsAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeatedMirrorsAvailable ofClass:NSNumber.class error:nil];
}

- (void)setClimateEnableAvailable:(nullable NSNumber<SDLBool> *)climateEnableAvailable {
    [self.store sdl_setObject:climateEnableAvailable forName:SDLRPCParameterNameClimateEnableAvailable];
}

- (nullable NSNumber<SDLBool> *)climateEnableAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameClimateEnableAvailable ofClass:NSNumber.class error:nil];
}

- (void)setModuleInfo:(nullable SDLModuleInfo *)moduleInfo {
    [self.store sdl_setObject:moduleInfo forName:SDLRPCParameterNameModuleInfo];
}

- (nullable SDLModuleInfo *)moduleInfo {
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleInfo ofClass:SDLModuleInfo.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
