//  SDLSubscribeVehicleData.m
//


#import "SDLSubscribeVehicleData.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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

- (void)setGps:(nullable NSNumber<SDLBool> *)gps {
    if (gps != nil) {
        [parameters setObject:gps forKey:SDLNameGPS];
    } else {
        [parameters removeObjectForKey:SDLNameGPS];
    }
}

- (nullable NSNumber<SDLBool> *)gps {
    return [parameters objectForKey:SDLNameGPS];
}

- (void)setSpeed:(nullable NSNumber<SDLBool> *)speed {
    if (speed != nil) {
        [parameters setObject:speed forKey:SDLNameSpeed];
    } else {
        [parameters removeObjectForKey:SDLNameSpeed];
    }
}

- (nullable NSNumber<SDLBool> *)speed {
    return [parameters objectForKey:SDLNameSpeed];
}

- (void)setRpm:(nullable NSNumber<SDLBool> *)rpm {
    if (rpm != nil) {
        [parameters setObject:rpm forKey:SDLNameRPM];
    } else {
        [parameters removeObjectForKey:SDLNameRPM];
    }
}

- (nullable NSNumber<SDLBool> *)rpm {
    return [parameters objectForKey:SDLNameRPM];
}

- (void)setFuelLevel:(nullable NSNumber<SDLBool> *)fuelLevel {
    if (fuelLevel != nil) {
        [parameters setObject:fuelLevel forKey:SDLNameFuelLevel];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevel];
    }
}

- (nullable NSNumber<SDLBool> *)fuelLevel {
    return [parameters objectForKey:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(nullable NSNumber<SDLBool> *)fuelLevel_State {
    if (fuelLevel_State != nil) {
        [parameters setObject:fuelLevel_State forKey:SDLNameFuelLevelState];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevelState];
    }
}

- (nullable NSNumber<SDLBool> *)fuelLevel_State {
    return [parameters objectForKey:SDLNameFuelLevelState];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption {
    if (instantFuelConsumption != nil) {
        [parameters setObject:instantFuelConsumption forKey:SDLNameInstantFuelConsumption];
    } else {
        [parameters removeObjectForKey:SDLNameInstantFuelConsumption];
    }
}

- (nullable NSNumber<SDLBool> *)instantFuelConsumption {
    return [parameters objectForKey:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature {
    if (externalTemperature != nil) {
        [parameters setObject:externalTemperature forKey:SDLNameExternalTemperature];
    } else {
        [parameters removeObjectForKey:SDLNameExternalTemperature];
    }
}

- (nullable NSNumber<SDLBool> *)externalTemperature {
    return [parameters objectForKey:SDLNameExternalTemperature];
}

- (void)setPrndl:(nullable NSNumber<SDLBool> *)prndl {
    if (prndl != nil) {
        [parameters setObject:prndl forKey:SDLNamePRNDL];
    } else {
        [parameters removeObjectForKey:SDLNamePRNDL];
    }
}

- (nullable NSNumber<SDLBool> *)prndl {
    return [parameters objectForKey:SDLNamePRNDL];
}

- (void)setTirePressure:(nullable NSNumber<SDLBool> *)tirePressure {
    if (tirePressure != nil) {
        [parameters setObject:tirePressure forKey:SDLNameTirePressure];
    } else {
        [parameters removeObjectForKey:SDLNameTirePressure];
    }
}

- (nullable NSNumber<SDLBool> *)tirePressure {
    return [parameters objectForKey:SDLNameTirePressure];
}

- (void)setOdometer:(nullable NSNumber<SDLBool> *)odometer {
    if (odometer != nil) {
        [parameters setObject:odometer forKey:SDLNameOdometer];
    } else {
        [parameters removeObjectForKey:SDLNameOdometer];
    }
}

- (nullable NSNumber<SDLBool> *)odometer {
    return [parameters objectForKey:SDLNameOdometer];
}

- (void)setBeltStatus:(nullable NSNumber<SDLBool> *)beltStatus {
    if (beltStatus != nil) {
        [parameters setObject:beltStatus forKey:SDLNameBeltStatus];
    } else {
        [parameters removeObjectForKey:SDLNameBeltStatus];
    }
}

- (nullable NSNumber<SDLBool> *)beltStatus {
    return [parameters objectForKey:SDLNameBeltStatus];
}

- (void)setBodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation {
    if (bodyInformation != nil) {
        [parameters setObject:bodyInformation forKey:SDLNameBodyInformation];
    } else {
        [parameters removeObjectForKey:SDLNameBodyInformation];
    }
}

- (nullable NSNumber<SDLBool> *)bodyInformation {
    return [parameters objectForKey:SDLNameBodyInformation];
}

- (void)setDeviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus {
    if (deviceStatus != nil) {
        [parameters setObject:deviceStatus forKey:SDLNameDeviceStatus];
    } else {
        [parameters removeObjectForKey:SDLNameDeviceStatus];
    }
}

- (nullable NSNumber<SDLBool> *)deviceStatus {
    return [parameters objectForKey:SDLNameDeviceStatus];
}

- (void)setDriverBraking:(nullable NSNumber<SDLBool> *)driverBraking {
    if (driverBraking != nil) {
        [parameters setObject:driverBraking forKey:SDLNameDriverBraking];
    } else {
        [parameters removeObjectForKey:SDLNameDriverBraking];
    }
}

- (nullable NSNumber<SDLBool> *)driverBraking {
    return [parameters objectForKey:SDLNameDriverBraking];
}

- (void)setWiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus {
    if (wiperStatus != nil) {
        [parameters setObject:wiperStatus forKey:SDLNameWiperStatus];
    } else {
        [parameters removeObjectForKey:SDLNameWiperStatus];
    }
}

- (nullable NSNumber<SDLBool> *)wiperStatus {
    return [parameters objectForKey:SDLNameWiperStatus];
}

- (void)setHeadLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus {
    if (headLampStatus != nil) {
        [parameters setObject:headLampStatus forKey:SDLNameHeadLampStatus];
    } else {
        [parameters removeObjectForKey:SDLNameHeadLampStatus];
    }
}

- (nullable NSNumber<SDLBool> *)headLampStatus {
    return [parameters objectForKey:SDLNameHeadLampStatus];
}

- (void)setEngineTorque:(nullable NSNumber<SDLBool> *)engineTorque {
    if (engineTorque != nil) {
        [parameters setObject:engineTorque forKey:SDLNameEngineTorque];
    } else {
        [parameters removeObjectForKey:SDLNameEngineTorque];
    }
}

- (nullable NSNumber<SDLBool> *)engineTorque {
    return [parameters objectForKey:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition {
    if (accPedalPosition != nil) {
        [parameters setObject:accPedalPosition forKey:SDLNameAccelerationPedalPosition];
    } else {
        [parameters removeObjectForKey:SDLNameAccelerationPedalPosition];
    }
}

- (nullable NSNumber<SDLBool> *)accPedalPosition {
    return [parameters objectForKey:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle {
    if (steeringWheelAngle != nil) {
        [parameters setObject:steeringWheelAngle forKey:SDLNameSteeringWheelAngle];
    } else {
        [parameters removeObjectForKey:SDLNameSteeringWheelAngle];
    }
}

- (nullable NSNumber<SDLBool> *)steeringWheelAngle {
    return [parameters objectForKey:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(nullable NSNumber<SDLBool> *)eCallInfo {
    if (eCallInfo != nil) {
        [parameters setObject:eCallInfo forKey:SDLNameECallInfo];
    } else {
        [parameters removeObjectForKey:SDLNameECallInfo];
    }
}

- (nullable NSNumber<SDLBool> *)eCallInfo {
    return [parameters objectForKey:SDLNameECallInfo];
}

- (void)setAirbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus {
    if (airbagStatus != nil) {
        [parameters setObject:airbagStatus forKey:SDLNameAirbagStatus];
    } else {
        [parameters removeObjectForKey:SDLNameAirbagStatus];
    }
}

- (nullable NSNumber<SDLBool> *)airbagStatus {
    return [parameters objectForKey:SDLNameAirbagStatus];
}

- (void)setEmergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent {
    if (emergencyEvent != nil) {
        [parameters setObject:emergencyEvent forKey:SDLNameEmergencyEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEmergencyEvent];
    }
}

- (nullable NSNumber<SDLBool> *)emergencyEvent {
    return [parameters objectForKey:SDLNameEmergencyEvent];
}

- (void)setClusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus {
    if (clusterModeStatus != nil) {
        [parameters setObject:clusterModeStatus forKey:SDLNameClusterModeStatus];
    } else {
        [parameters removeObjectForKey:SDLNameClusterModeStatus];
    }
}

- (nullable NSNumber<SDLBool> *)clusterModeStatus {
    return [parameters objectForKey:SDLNameClusterModeStatus];
}

- (void)setMyKey:(nullable NSNumber<SDLBool> *)myKey {
    if (myKey != nil) {
        [parameters setObject:myKey forKey:SDLNameMyKey];
    } else {
        [parameters removeObjectForKey:SDLNameMyKey];
    }
}

- (nullable NSNumber<SDLBool> *)myKey {
    return [parameters objectForKey:SDLNameMyKey];
}

@end

NS_ASSUME_NONNULL_END
