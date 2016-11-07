//  SDLUnsubscribeVehicleData.m
//


#import "SDLUnsubscribeVehicleData.h"

#import "SDLNames.h"

@implementation SDLUnsubscribeVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameUnsubscribeVehicleData]) {
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
    [self setObject:gps forName:SDLNameGPS];
}

- (NSNumber<SDLBool> *)gps {
    return [parameters objectForKey:SDLNameGPS];
}

- (void)setSpeed:(NSNumber<SDLBool> *)speed {
    [self setObject:speed forName:SDLNameSpeed];
}

- (NSNumber<SDLBool> *)speed {
    return [parameters objectForKey:SDLNameSpeed];
}

- (void)setRpm:(NSNumber<SDLBool> *)rpm {
    [self setObject:rpm forName:SDLNameRPM];
}

- (NSNumber<SDLBool> *)rpm {
    return [parameters objectForKey:SDLNameRPM];
}

- (void)setFuelLevel:(NSNumber<SDLBool> *)fuelLevel {
    [self setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (NSNumber<SDLBool> *)fuelLevel {
    return [parameters objectForKey:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(NSNumber<SDLBool> *)fuelLevel_State {
    [self setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (NSNumber<SDLBool> *)fuelLevel_State {
    return [parameters objectForKey:SDLNameFuelLevelState];
}

- (void)setInstantFuelConsumption:(NSNumber<SDLBool> *)instantFuelConsumption {
    [self setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (NSNumber<SDLBool> *)instantFuelConsumption {
    return [parameters objectForKey:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(NSNumber<SDLBool> *)externalTemperature {
    [self setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (NSNumber<SDLBool> *)externalTemperature {
    return [parameters objectForKey:SDLNameExternalTemperature];
}

- (void)setPrndl:(NSNumber<SDLBool> *)prndl {
    [self setObject:prndl forName:SDLNamePRNDL];
}

- (NSNumber<SDLBool> *)prndl {
    return [parameters objectForKey:SDLNamePRNDL];
}

- (void)setTirePressure:(NSNumber<SDLBool> *)tirePressure {
    [self setObject:tirePressure forName:SDLNameTirePressure];
}

- (NSNumber<SDLBool> *)tirePressure {
    return [parameters objectForKey:SDLNameTirePressure];
}

- (void)setOdometer:(NSNumber<SDLBool> *)odometer {
    [self setObject:odometer forName:SDLNameOdometer];
}

- (NSNumber<SDLBool> *)odometer {
    return [parameters objectForKey:SDLNameOdometer];
}

- (void)setBeltStatus:(NSNumber<SDLBool> *)beltStatus {
    [self setObject:beltStatus forName:SDLNameBeltStatus];
}

- (NSNumber<SDLBool> *)beltStatus {
    return [parameters objectForKey:SDLNameBeltStatus];
}

- (void)setBodyInformation:(NSNumber<SDLBool> *)bodyInformation {
    [self setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (NSNumber<SDLBool> *)bodyInformation {
    return [parameters objectForKey:SDLNameBodyInformation];
}

- (void)setDeviceStatus:(NSNumber<SDLBool> *)deviceStatus {
    [self setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (NSNumber<SDLBool> *)deviceStatus {
    return [parameters objectForKey:SDLNameDeviceStatus];
}

- (void)setDriverBraking:(NSNumber<SDLBool> *)driverBraking {
    [self setObject:driverBraking forName:SDLNameDriverBraking];
}

- (NSNumber<SDLBool> *)driverBraking {
    return [parameters objectForKey:SDLNameDriverBraking];
}

- (void)setWiperStatus:(NSNumber<SDLBool> *)wiperStatus {
    [self setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (NSNumber<SDLBool> *)wiperStatus {
    return [parameters objectForKey:SDLNameWiperStatus];
}

- (void)setHeadLampStatus:(NSNumber<SDLBool> *)headLampStatus {
    [self setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (NSNumber<SDLBool> *)headLampStatus {
    return [parameters objectForKey:SDLNameHeadLampStatus];
}

- (void)setEngineTorque:(NSNumber<SDLBool> *)engineTorque {
    [self setObject:engineTorque forName:SDLNameEngineTorque];
}

- (NSNumber<SDLBool> *)engineTorque {
    return [parameters objectForKey:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(NSNumber<SDLBool> *)accPedalPosition {
    [self setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (NSNumber<SDLBool> *)accPedalPosition {
    return [parameters objectForKey:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(NSNumber<SDLBool> *)steeringWheelAngle {
    [self setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (NSNumber<SDLBool> *)steeringWheelAngle {
    return [parameters objectForKey:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(NSNumber<SDLBool> *)eCallInfo {
    [self setObject:eCallInfo forName:SDLNameECallInfo];
}

- (NSNumber<SDLBool> *)eCallInfo {
    return [parameters objectForKey:SDLNameECallInfo];
}

- (void)setAirbagStatus:(NSNumber<SDLBool> *)airbagStatus {
    [self setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (NSNumber<SDLBool> *)airbagStatus {
    return [parameters objectForKey:SDLNameAirbagStatus];
}

- (void)setEmergencyEvent:(NSNumber<SDLBool> *)emergencyEvent {
    [self setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (NSNumber<SDLBool> *)emergencyEvent {
    return [parameters objectForKey:SDLNameEmergencyEvent];
}

- (void)setClusterModeStatus:(NSNumber<SDLBool> *)clusterModeStatus {
    [self setObject:clusterModeStatus forName:SDLNameClusterModeStatus];
}

- (NSNumber<SDLBool> *)clusterModeStatus {
    return [parameters objectForKey:SDLNameClusterModeStatus];
}

- (void)setMyKey:(NSNumber<SDLBool> *)myKey {
    [self setObject:myKey forName:SDLNameMyKey];
}

- (NSNumber<SDLBool> *)myKey {
    return [parameters objectForKey:SDLNameMyKey];
}

@end
