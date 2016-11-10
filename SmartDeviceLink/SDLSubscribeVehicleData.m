//  SDLSubscribeVehicleData.m
//


#import "SDLSubscribeVehicleData.h"

#import "SDLNames.h"

@implementation SDLSubscribeVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameSubscribeVehicleData]) {
    }
    return self;
}

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus {
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
    self.wiperStatus = @(wiperStatus);

    return self;
}

- (void)setGps:(NSNumber<SDLBool> *)gps {
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (NSNumber<SDLBool> *)gps {
    return [parameters sdl_objectForName:SDLNameGPS];
}

- (void)setSpeed:(NSNumber<SDLBool> *)speed {
    [parameters sdl_setObject:speed forName:SDLNameSpeed];
}

- (NSNumber<SDLBool> *)speed {
    return [parameters sdl_objectForName:SDLNameSpeed];
}

- (void)setRpm:(NSNumber<SDLBool> *)rpm {
    [parameters sdl_setObject:rpm forName:SDLNameRPM];
}

- (NSNumber<SDLBool> *)rpm {
    return [parameters sdl_objectForName:SDLNameRPM];
}

- (void)setFuelLevel:(NSNumber<SDLBool> *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (NSNumber<SDLBool> *)fuelLevel {
    return [parameters sdl_objectForName:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(NSNumber<SDLBool> *)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (NSNumber<SDLBool> *)fuelLevel_State {
    return [parameters sdl_objectForName:SDLNameFuelLevelState];
}

- (void)setInstantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (NSNumber<SDLBool> *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(NSNumber<SDLBool> *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (NSNumber<SDLBool> *)externalTemperature {
    return [parameters sdl_objectForName:SDLNameExternalTemperature];
}

- (void)setPrndl:(NSNumber<SDLBool> *)prndl {
    [parameters sdl_setObject:prndl forName:SDLNamePRNDL];
}

- (NSNumber<SDLBool> *)prndl {
    return [parameters sdl_objectForName:SDLNamePRNDL];
}

- (void)setTirePressure:(NSNumber<SDLBool> *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (NSNumber<SDLBool> *)tirePressure {
    return [parameters sdl_objectForName:SDLNameTirePressure];
}

- (void)setOdometer:(NSNumber<SDLBool> *)odometer {
    [parameters sdl_setObject:odometer forName:SDLNameOdometer];
}

- (NSNumber<SDLBool> *)odometer {
    return [parameters sdl_objectForName:SDLNameOdometer];
}

- (void)setBeltStatus:(NSNumber<SDLBool> *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLNameBeltStatus];
}

- (NSNumber<SDLBool> *)beltStatus {
    return [parameters sdl_objectForName:SDLNameBeltStatus];
}

- (void)setBodyInformation:(NSNumber<SDLBool> *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (NSNumber<SDLBool> *)bodyInformation {
    return [parameters sdl_objectForName:SDLNameBodyInformation];
}

- (void)setDeviceStatus:(NSNumber<SDLBool> *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (NSNumber<SDLBool> *)deviceStatus {
    return [parameters sdl_objectForName:SDLNameDeviceStatus];
}

- (void)setDriverBraking:(NSNumber<SDLBool> *)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (NSNumber<SDLBool> *)driverBraking {
    return [parameters sdl_objectForName:SDLNameDriverBraking];
}

- (void)setWiperStatus:(NSNumber<SDLBool> *)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (NSNumber<SDLBool> *)wiperStatus {
    return [parameters sdl_objectForName:SDLNameWiperStatus];
}

- (void)setHeadLampStatus:(NSNumber<SDLBool> *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (NSNumber<SDLBool> *)headLampStatus {
    return [parameters sdl_objectForName:SDLNameHeadLampStatus];
}

- (void)setEngineTorque:(NSNumber<SDLBool> *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLNameEngineTorque];
}

- (NSNumber<SDLBool> *)engineTorque {
    return [parameters sdl_objectForName:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(NSNumber<SDLBool> *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (NSNumber<SDLBool> *)accPedalPosition {
    return [parameters sdl_objectForName:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (NSNumber<SDLBool> *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(NSNumber<SDLBool> *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLNameECallInfo];
}

- (NSNumber<SDLBool> *)eCallInfo {
    return [parameters sdl_objectForName:SDLNameECallInfo];
}

- (void)setAirbagStatus:(NSNumber<SDLBool> *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (NSNumber<SDLBool> *)airbagStatus {
    return [parameters sdl_objectForName:SDLNameAirbagStatus];
}

- (void)setEmergencyEvent:(NSNumber<SDLBool> *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (NSNumber<SDLBool> *)emergencyEvent {
    return [parameters sdl_objectForName:SDLNameEmergencyEvent];
}

- (void)setClusterModeStatus:(NSNumber<SDLBool> *)clusterModeStatus {
    [parameters sdl_setObject:clusterModeStatus forName:SDLNameClusterModeStatus];
}

- (NSNumber<SDLBool> *)clusterModeStatus {
    return [parameters sdl_objectForName:SDLNameClusterModeStatus];
}

- (void)setMyKey:(NSNumber<SDLBool> *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (NSNumber<SDLBool> *)myKey {
    return [parameters sdl_objectForName:SDLNameMyKey];
}

@end
