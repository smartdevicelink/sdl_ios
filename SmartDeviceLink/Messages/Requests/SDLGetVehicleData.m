//  SDLGetVehicleData.m
//


#import "SDLGetVehicleData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetVehicleData]) {
    }
    return self;
}

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.accPedalPosition = @(accelerationPedalPosition);
    self.airbagStatus = @(airbagStatus);
    self.beltStatus = @(beltStatus);
    self.bodyInformation = @(bodyInformation);
    self.clusterModeStatus = @(clusterModeStatus);
    self.deviceStatus = @(deviceStatus);
    self.driverBraking = @(driverBraking);
    self.eCallInfo = @(eCallInfo);
    self.emergencyEvent = @(emergencyEvent);
    self.engineTorque = @(engineTorque);
    self.externalTemperature = @(externalTemperature);
    self.fuelLevel = @(fuelLevel);
    self.fuelLevel_State = @(fuelLevelState);
    self.myKey = @(myKey);
    self.odometer = @(odometer);
    self.gps = @(gps);
    self.headLampStatus = @(headLampStatus);
    self.instantFuelConsumption = @(instantFuelConsumption);
    self.prndl = @(prndl);
    self.rpm = @(rpm);
    self.speed = @(speed);
    self.steeringWheelAngle = @(steeringWheelAngle);
    self.tirePressure = @(tirePressure);
    self.vin = @(vin);
    self.wiperStatus = @(wiperStatus);

    return self;
}

- (void)setGps:(nullable NSNumber<SDLBool> *)gps {
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (nullable NSNumber<SDLBool> *)gps {
    return [parameters sdl_objectForName:SDLNameGPS];
}

- (void)setSpeed:(nullable NSNumber<SDLBool> *)speed {
    [parameters sdl_setObject:speed forName:SDLNameSpeed];
}

- (nullable NSNumber<SDLBool> *)speed {
    return [parameters sdl_objectForName:SDLNameSpeed];
}

- (void)setRpm:(nullable NSNumber<SDLBool> *)rpm {
    [parameters sdl_setObject:rpm forName:SDLNameRPM];
}

- (nullable NSNumber<SDLBool> *)rpm {
    return [parameters sdl_objectForName:SDLNameRPM];
}

- (void)setFuelLevel:(nullable NSNumber<SDLBool> *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (nullable NSNumber<SDLBool> *)fuelLevel {
    return [parameters sdl_objectForName:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(nullable NSNumber<SDLBool> *)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (nullable NSNumber<SDLBool> *)fuelLevel_State {
    return [parameters sdl_objectForName:SDLNameFuelLevelState];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (nullable NSNumber<SDLBool> *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (nullable NSNumber<SDLBool> *)externalTemperature {
    return [parameters sdl_objectForName:SDLNameExternalTemperature];
}

- (void)setVin:(nullable NSNumber<SDLBool> *)vin {
    [parameters sdl_setObject:vin forName:SDLNameVIN];
}

- (nullable NSNumber<SDLBool> *)vin {
    return [parameters sdl_objectForName:SDLNameVIN];
}

- (void)setPrndl:(nullable NSNumber<SDLBool> *)prndl {
    [parameters sdl_setObject:prndl forName:SDLNamePRNDL];
}

- (nullable NSNumber<SDLBool> *)prndl {
    return [parameters sdl_objectForName:SDLNamePRNDL];
}

- (void)setTirePressure:(nullable NSNumber<SDLBool> *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (nullable NSNumber<SDLBool> *)tirePressure {
    return [parameters sdl_objectForName:SDLNameTirePressure];
}

- (void)setOdometer:(nullable NSNumber<SDLBool> *)odometer {
    [parameters sdl_setObject:odometer forName:SDLNameOdometer];
}

- (nullable NSNumber<SDLBool> *)odometer {
    return [parameters sdl_objectForName:SDLNameOdometer];
}

- (void)setBeltStatus:(nullable NSNumber<SDLBool> *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLNameBeltStatus];
}

- (nullable NSNumber<SDLBool> *)beltStatus {
    return [parameters sdl_objectForName:SDLNameBeltStatus];
}

- (void)setBodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (nullable NSNumber<SDLBool> *)bodyInformation {
    return [parameters sdl_objectForName:SDLNameBodyInformation];
}

- (void)setDeviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (nullable NSNumber<SDLBool> *)deviceStatus {
    return [parameters sdl_objectForName:SDLNameDeviceStatus];
}

- (void)setDriverBraking:(nullable NSNumber<SDLBool> *)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (nullable NSNumber<SDLBool> *)driverBraking {
    return [parameters sdl_objectForName:SDLNameDriverBraking];
}

- (void)setWiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (nullable NSNumber<SDLBool> *)wiperStatus {
    return [parameters sdl_objectForName:SDLNameWiperStatus];
}

- (void)setHeadLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (nullable NSNumber<SDLBool> *)headLampStatus {
    return [parameters sdl_objectForName:SDLNameHeadLampStatus];
}

- (void)setEngineTorque:(nullable NSNumber<SDLBool> *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLNameEngineTorque];
}

- (nullable NSNumber<SDLBool> *)engineTorque {
    return [parameters sdl_objectForName:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (nullable NSNumber<SDLBool> *)accPedalPosition {
    return [parameters sdl_objectForName:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (nullable NSNumber<SDLBool> *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(nullable NSNumber<SDLBool> *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLNameECallInfo];
}

- (nullable NSNumber<SDLBool> *)eCallInfo {
    return [parameters sdl_objectForName:SDLNameECallInfo];
}

- (void)setAirbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (nullable NSNumber<SDLBool> *)airbagStatus {
    return [parameters sdl_objectForName:SDLNameAirbagStatus];
}

- (void)setEmergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (nullable NSNumber<SDLBool> *)emergencyEvent {
    return [parameters sdl_objectForName:SDLNameEmergencyEvent];
}

- (void)setClusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus {
    [parameters sdl_setObject:clusterModeStatus forName:SDLNameClusterModeStatus];
}

- (nullable NSNumber<SDLBool> *)clusterModeStatus {
    return [parameters sdl_objectForName:SDLNameClusterModeStatus];
}

- (void)setMyKey:(nullable NSNumber<SDLBool> *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (nullable NSNumber<SDLBool> *)myKey {
    return [parameters sdl_objectForName:SDLNameMyKey];
}

@end

NS_ASSUME_NONNULL_END
