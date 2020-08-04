/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSMutableDictionary+Store.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SDLSubscribeVehicleData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSubscribeVehicleData

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameSubscribeVehicleData];
    if (!self) {
        return nil;
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus {
    return [self initWithAccelerationPedalPosition:accelerationPedalPosition airbagStatus:airbagStatus beltStatus:beltStatus bodyInformation:bodyInformation cloudAppVehicleID:NO clusterModeStatus:clusterModeStatus deviceStatus:deviceStatus driverBraking:driverBraking eCallInfo:eCallInfo electronicParkBrakeStatus:NO emergencyEvent:emergencyEvent engineOilLife:NO engineTorque:engineTorque externalTemperature:externalTemperature fuelLevel:fuelLevel fuelLevelState:fuelLevelState fuelRange:NO gearStatus:NO gps:gps headLampStatus:headLampStatus instantFuelConsumption:instantFuelConsumption myKey:myKey odometer:odometer rpm:rpm speed:speed steeringWheelAngle:steeringWheelAngle tirePressure:tirePressure turnSignal:NO wiperStatus:wiperStatus];
}

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus {
    return [self initWithAccelerationPedalPosition:accelerationPedalPosition airbagStatus:airbagStatus beltStatus:beltStatus bodyInformation:bodyInformation cloudAppVehicleID:NO clusterModeStatus:clusterModeStatus deviceStatus:deviceStatus driverBraking:driverBraking eCallInfo:eCallInfo electronicParkBrakeStatus:electronicParkBrakeStatus emergencyEvent:emergencyEvent engineOilLife:engineOilLife engineTorque:engineTorque externalTemperature:externalTemperature fuelLevel:fuelLevel fuelLevelState:fuelLevelState fuelRange:fuelRange gearStatus:NO gps:gps headLampStatus:headLampStatus instantFuelConsumption:instantFuelConsumption myKey:myKey odometer:odometer rpm:rpm speed:speed steeringWheelAngle:steeringWheelAngle tirePressure:tirePressure turnSignal:turnSignal wiperStatus:wiperStatus];
}

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus {
    return [self initWithAccelerationPedalPosition:accelerationPedalPosition airbagStatus:airbagStatus beltStatus:beltStatus bodyInformation:bodyInformation cloudAppVehicleID:cloudAppVehicleID clusterModeStatus:clusterModeStatus deviceStatus:deviceStatus driverBraking:driverBraking eCallInfo:eCallInfo electronicParkBrakeStatus:electronicParkBrakeStatus emergencyEvent:emergencyEvent engineOilLife:engineOilLife engineTorque:engineTorque externalTemperature:externalTemperature fuelLevel:fuelLevel fuelLevelState:fuelLevelState fuelRange:fuelRange gearStatus:NO gps:gps headLampStatus:headLampStatus instantFuelConsumption:instantFuelConsumption myKey:myKey odometer:odometer rpm:rpm speed:speed steeringWheelAngle:steeringWheelAngle tirePressure:tirePressure turnSignal:turnSignal wiperStatus:wiperStatus];
}

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gearStatus:(BOOL)gearStatus gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.accPedalPosition = @(accelerationPedalPosition);
    self.airbagStatus = @(airbagStatus);
    self.beltStatus = @(beltStatus);
    self.bodyInformation = @(bodyInformation);
    self.cloudAppVehicleID = @(cloudAppVehicleID);
    self.clusterModeStatus = @(clusterModeStatus);
    self.deviceStatus = @(deviceStatus);
    self.driverBraking = @(driverBraking);
    self.eCallInfo = @(eCallInfo);
    self.electronicParkBrakeStatus = @(electronicParkBrakeStatus);
    self.emergencyEvent = @(emergencyEvent);
    self.engineOilLife = @(engineOilLife);
    self.engineTorque = @(engineTorque);
    self.externalTemperature = @(externalTemperature);
    self.fuelLevel = @(fuelLevel);
    self.fuelLevel_State = @(fuelLevelState);
    self.fuelRange = @(fuelRange);
    self.myKey = @(myKey);
    self.odometer = @(odometer);
    self.gps = @(gps);
    self.headLampStatus = @(headLampStatus);
    self.instantFuelConsumption = @(instantFuelConsumption);
    self.gearStatus = @(gearStatus);
    self.rpm = @(rpm);
    self.speed = @(speed);
    self.steeringWheelAngle = @(steeringWheelAngle);
    self.tirePressure = @(tirePressure);
    self.turnSignal = @(turnSignal);
    self.wiperStatus = @(wiperStatus);

    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm fuelLevel:(nullable NSNumber<SDLBool> *)fuelLevel fuelLevel_State:(nullable NSNumber<SDLBool> *)fuelLevel_State instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange externalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature turnSignal:(nullable NSNumber<SDLBool> *)turnSignal gearStatus:(nullable NSNumber<SDLBool> *)gearStatus prndl:(nullable NSNumber<SDLBool> *)prndl tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.gps = gps;
    self.speed = speed;
    self.rpm = rpm;
    self.fuelLevel = fuelLevel;
    self.fuelLevel_State = fuelLevel_State;
    self.instantFuelConsumption = instantFuelConsumption;
    self.fuelRange = fuelRange;
    self.externalTemperature = externalTemperature;
    self.turnSignal = turnSignal;
    self.gearStatus = gearStatus;
    self.prndl = prndl;
    self.tirePressure = tirePressure;
    self.odometer = odometer;
    self.beltStatus = beltStatus;
    self.bodyInformation = bodyInformation;
    self.deviceStatus = deviceStatus;
    self.driverBraking = driverBraking;
    self.wiperStatus = wiperStatus;
    self.headLampStatus = headLampStatus;
    self.engineTorque = engineTorque;
    self.accPedalPosition = accPedalPosition;
    self.steeringWheelAngle = steeringWheelAngle;
    self.engineOilLife = engineOilLife;
    self.electronicParkBrakeStatus = electronicParkBrakeStatus;
    self.cloudAppVehicleID = cloudAppVehicleID;
    self.eCallInfo = eCallInfo;
    self.airbagStatus = airbagStatus;
    self.emergencyEvent = emergencyEvent;
    self.clusterModeStatus = clusterModeStatus;
    self.myKey = myKey;
    return self;
}
#pragma clang diagnostic pop

- (void)setGps:(nullable NSNumber<SDLBool> *)gps {
    [self.parameters sdl_setObject:gps forName:SDLRPCParameterNameGPS];
}

- (nullable NSNumber<SDLBool> *)gps {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGPS ofClass:NSNumber.class error:&error];
}

- (void)setSpeed:(nullable NSNumber<SDLBool> *)speed {
    [self.parameters sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLBool> *)speed {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpeed ofClass:NSNumber.class error:&error];
}

- (void)setRpm:(nullable NSNumber<SDLBool> *)rpm {
    [self.parameters sdl_setObject:rpm forName:SDLRPCParameterNameRPM];
}

- (nullable NSNumber<SDLBool> *)rpm {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameRPM ofClass:NSNumber.class error:&error];
}

- (void)setFuelLevel:(nullable NSNumber<SDLBool> *)fuelLevel {
    [self.parameters sdl_setObject:fuelLevel forName:SDLRPCParameterNameFuelLevel];
}

- (nullable NSNumber<SDLBool> *)fuelLevel {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevel ofClass:NSNumber.class error:&error];
}

- (void)setFuelLevel_State:(nullable NSNumber<SDLBool> *)fuelLevel_State {
    [self.parameters sdl_setObject:fuelLevel_State forName:SDLRPCParameterNameFuelLevelState];
}

- (nullable NSNumber<SDLBool> *)fuelLevel_State {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevelState ofClass:NSNumber.class error:&error];
}

- (void)setFuelRange:(nullable NSNumber<SDLBool> *)fuelRange {
    [self.parameters sdl_setObject:fuelRange forName:SDLRPCParameterNameFuelRange];
}

- (nullable NSNumber<SDLBool> *)fuelRange {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelRange ofClass:NSNumber.class error:&error];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption {
    [self.parameters sdl_setObject:instantFuelConsumption forName:SDLRPCParameterNameInstantFuelConsumption];
}

- (nullable NSNumber<SDLBool> *)instantFuelConsumption {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInstantFuelConsumption ofClass:NSNumber.class error:&error];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature {
    [self.parameters sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
}

- (nullable NSNumber<SDLBool> *)externalTemperature {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameExternalTemperature ofClass:NSNumber.class error:&error];
}

- (void)setGearStatus:(nullable NSNumber<SDLBool> *)gearStatus {
    [self.parameters sdl_setObject:gearStatus forName:SDLRPCParameterNameGearStatus];
}

- (nullable NSNumber<SDLBool> *)gearStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGearStatus ofClass:NSNumber.class error:&error];
}

- (void)setPrndl:(nullable NSNumber<SDLBool> *)prndl {
    [self.parameters sdl_setObject:prndl forName:SDLRPCParameterNamePRNDL];
}

- (nullable NSNumber<SDLBool> *)prndl {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePRNDL ofClass:NSNumber.class error:&error];
}

- (void)setTirePressure:(nullable NSNumber<SDLBool> *)tirePressure {
    [self.parameters sdl_setObject:tirePressure forName:SDLRPCParameterNameTirePressure];
}

- (nullable NSNumber<SDLBool> *)tirePressure {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTirePressure ofClass:NSNumber.class error:&error];
}

- (void)setOdometer:(nullable NSNumber<SDLBool> *)odometer {
    [self.parameters sdl_setObject:odometer forName:SDLRPCParameterNameOdometer];
}

- (nullable NSNumber<SDLBool> *)odometer {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOdometer ofClass:NSNumber.class error:&error];
}

- (void)setBeltStatus:(nullable NSNumber<SDLBool> *)beltStatus {
    [self.parameters sdl_setObject:beltStatus forName:SDLRPCParameterNameBeltStatus];
}

- (nullable NSNumber<SDLBool> *)beltStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBeltStatus ofClass:NSNumber.class error:&error];
}

- (void)setBodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation {
    [self.parameters sdl_setObject:bodyInformation forName:SDLRPCParameterNameBodyInformation];
}

- (nullable NSNumber<SDLBool> *)bodyInformation {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBodyInformation ofClass:NSNumber.class error:&error];
}

- (void)setDeviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus {
    [self.parameters sdl_setObject:deviceStatus forName:SDLRPCParameterNameDeviceStatus];
}

- (nullable NSNumber<SDLBool> *)deviceStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDeviceStatus ofClass:NSNumber.class error:&error];
}

- (void)setDriverBraking:(nullable NSNumber<SDLBool> *)driverBraking {
    [self.parameters sdl_setObject:driverBraking forName:SDLRPCParameterNameDriverBraking];
}

- (nullable NSNumber<SDLBool> *)driverBraking {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDriverBraking ofClass:NSNumber.class error:&error];
}

- (void)setWiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus {
    [self.parameters sdl_setObject:wiperStatus forName:SDLRPCParameterNameWiperStatus];
}

- (nullable NSNumber<SDLBool> *)wiperStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWiperStatus ofClass:NSNumber.class error:&error];
}

- (void)setHeadLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus {
    [self.parameters sdl_setObject:headLampStatus forName:SDLRPCParameterNameHeadLampStatus];
}

- (nullable NSNumber<SDLBool> *)headLampStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHeadLampStatus ofClass:NSNumber.class error:&error];
}

- (void)setEngineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife {
    [self.parameters sdl_setObject:engineOilLife forName:SDLRPCParameterNameEngineOilLife];
}

- (nullable NSNumber<SDLBool> *)engineOilLife {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineOilLife ofClass:NSNumber.class error:&error];
}

- (void)setEngineTorque:(nullable NSNumber<SDLBool> *)engineTorque {
    [self.parameters sdl_setObject:engineTorque forName:SDLRPCParameterNameEngineTorque];
}

- (nullable NSNumber<SDLBool> *)engineTorque {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineTorque ofClass:NSNumber.class error:&error];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition {
    [self.parameters sdl_setObject:accPedalPosition forName:SDLRPCParameterNameAccelerationPedalPosition];
}

- (nullable NSNumber<SDLBool> *)accPedalPosition {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAccelerationPedalPosition ofClass:NSNumber.class error:&error];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle {
    [self.parameters sdl_setObject:steeringWheelAngle forName:SDLRPCParameterNameSteeringWheelAngle];
}

- (nullable NSNumber<SDLBool> *)steeringWheelAngle {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSteeringWheelAngle ofClass:NSNumber.class error:&error];
}

- (void)setECallInfo:(nullable NSNumber<SDLBool> *)eCallInfo {
    [self.parameters sdl_setObject:eCallInfo forName:SDLRPCParameterNameECallInfo];
}

- (nullable NSNumber<SDLBool> *)eCallInfo {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECallInfo ofClass:NSNumber.class error:&error];
}

- (void)setAirbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus {
    [self.parameters sdl_setObject:airbagStatus forName:SDLRPCParameterNameAirbagStatus];
}

- (nullable NSNumber<SDLBool> *)airbagStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAirbagStatus ofClass:NSNumber.class error:&error];
}

- (void)setEmergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent {
    [self.parameters sdl_setObject:emergencyEvent forName:SDLRPCParameterNameEmergencyEvent];
}

- (nullable NSNumber<SDLBool> *)emergencyEvent {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEmergencyEvent ofClass:NSNumber.class error:&error];
}

- (void)setClusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus {
    [self.parameters sdl_setObject:clusterModeStatus forName:SDLRPCParameterNameClusterModeStatus];
}

- (nullable NSNumber<SDLBool> *)clusterModeStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameClusterModeStatus ofClass:NSNumber.class error:&error];
}

- (void)setMyKey:(nullable NSNumber<SDLBool> *)myKey {
    [self.parameters sdl_setObject:myKey forName:SDLRPCParameterNameMyKey];
}

- (nullable NSNumber<SDLBool> *)myKey {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMyKey ofClass:NSNumber.class error:&error];
}

- (void)setElectronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus {
    [self.parameters sdl_setObject:electronicParkBrakeStatus forName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (nullable NSNumber<SDLBool> *)electronicParkBrakeStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameElectronicParkBrakeStatus ofClass:NSNumber.class error:&error];
}

- (void)setTurnSignal:(nullable NSNumber<SDLBool> *)turnSignal {
    [self.parameters sdl_setObject:turnSignal forName:SDLRPCParameterNameTurnSignal];
}

- (nullable NSNumber<SDLBool> *)turnSignal {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTurnSignal ofClass:NSNumber.class error:&error];
}

- (void)setCloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID {
    [self.parameters sdl_setObject:cloudAppVehicleID forName:SDLRPCParameterNameCloudAppVehicleID];
}

- (nullable NSNumber<SDLBool> *)cloudAppVehicleID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCloudAppVehicleID ofClass:NSNumber.class error:&error];
}

- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(BOOL)vehicleDataState {
    [self.parameters sdl_setObject:@(vehicleDataState) forName:vehicleDataName];
}

- (nullable NSNumber<SDLBool> *)getOEMCustomVehicleData:(NSString *)vehicleDataName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:vehicleDataName ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
