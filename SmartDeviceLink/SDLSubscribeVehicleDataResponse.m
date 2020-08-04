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
#import "SDLSubscribeVehicleDataResponse.h"
#import "SDLVehicleDataResult.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSubscribeVehicleDataResponse

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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)initWithGps:(nullable SDLVehicleDataResult *)gps speed:(nullable SDLVehicleDataResult *)speed rpm:(nullable SDLVehicleDataResult *)rpm fuelLevel:(nullable SDLVehicleDataResult *)fuelLevel fuelLevel_State:(nullable SDLVehicleDataResult *)fuelLevel_State instantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption fuelRange:(nullable SDLVehicleDataResult *)fuelRange externalTemperature:(nullable SDLVehicleDataResult *)externalTemperature turnSignal:(nullable SDLVehicleDataResult *)turnSignal gearStatus:(nullable SDLVehicleDataResult *)gearStatus prndl:(nullable SDLVehicleDataResult *)prndl tirePressure:(nullable SDLVehicleDataResult *)tirePressure odometer:(nullable SDLVehicleDataResult *)odometer beltStatus:(nullable SDLVehicleDataResult *)beltStatus bodyInformation:(nullable SDLVehicleDataResult *)bodyInformation deviceStatus:(nullable SDLVehicleDataResult *)deviceStatus driverBraking:(nullable SDLVehicleDataResult *)driverBraking wiperStatus:(nullable SDLVehicleDataResult *)wiperStatus headLampStatus:(nullable SDLVehicleDataResult *)headLampStatus engineTorque:(nullable SDLVehicleDataResult *)engineTorque accPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition steeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle engineOilLife:(nullable SDLVehicleDataResult *)engineOilLife electronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus cloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID eCallInfo:(nullable SDLVehicleDataResult *)eCallInfo airbagStatus:(nullable SDLVehicleDataResult *)airbagStatus emergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent clusterModes:(nullable SDLVehicleDataResult *)clusterModes myKey:(nullable SDLVehicleDataResult *)myKey {
    self = [self init];
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
    self.clusterModes = clusterModes;
    self.myKey = myKey;
    return self;
}
#pragma clang diagnostic pop

- (void)setGps:(nullable SDLVehicleDataResult *)gps {
    [self.parameters sdl_setObject:gps forName:SDLRPCParameterNameGPS];
}

- (nullable SDLVehicleDataResult *)gps {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGPS ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setSpeed:(nullable SDLVehicleDataResult *)speed {
    [self.parameters sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable SDLVehicleDataResult *)speed {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpeed ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setRpm:(nullable SDLVehicleDataResult *)rpm {
    [self.parameters sdl_setObject:rpm forName:SDLRPCParameterNameRPM];
}

- (nullable SDLVehicleDataResult *)rpm {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameRPM ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setFuelLevel:(nullable SDLVehicleDataResult *)fuelLevel {
    [self.parameters sdl_setObject:fuelLevel forName:SDLRPCParameterNameFuelLevel];
}

- (nullable SDLVehicleDataResult *)fuelLevel {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevel ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setFuelLevel_State:(nullable SDLVehicleDataResult *)fuelLevel_State {
    [self.parameters sdl_setObject:fuelLevel_State forName:SDLRPCParameterNameFuelLevelState];
}

- (nullable SDLVehicleDataResult *)fuelLevel_State {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevelState ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setFuelRange:(nullable SDLVehicleDataResult *)fuelRange {
    [self.parameters sdl_setObject:fuelRange forName:SDLRPCParameterNameFuelRange];
}

- (nullable SDLVehicleDataResult *)fuelRange {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelRange ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setInstantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption {
    [self.parameters sdl_setObject:instantFuelConsumption forName:SDLRPCParameterNameInstantFuelConsumption];
}

- (nullable SDLVehicleDataResult *)instantFuelConsumption {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInstantFuelConsumption ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setExternalTemperature:(nullable SDLVehicleDataResult *)externalTemperature {
    [self.parameters sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
}

- (nullable SDLVehicleDataResult *)externalTemperature {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameExternalTemperature ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setGearStatus:(nullable SDLVehicleDataResult *)gearStatus {
    [self.parameters sdl_setObject:gearStatus forName:SDLRPCParameterNameGearStatus];
}

- (nullable SDLVehicleDataResult *)gearStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGearStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setPrndl:(nullable SDLVehicleDataResult *)prndl {
    [self.parameters sdl_setObject:prndl forName:SDLRPCParameterNamePRNDL];
}

- (nullable SDLVehicleDataResult *)prndl {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePRNDL ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setTirePressure:(nullable SDLVehicleDataResult *)tirePressure {
    [self.parameters sdl_setObject:tirePressure forName:SDLRPCParameterNameTirePressure];
}

- (nullable SDLVehicleDataResult *)tirePressure {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTirePressure ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setOdometer:(nullable SDLVehicleDataResult *)odometer {
    [self.parameters sdl_setObject:odometer forName:SDLRPCParameterNameOdometer];
}

- (nullable SDLVehicleDataResult *)odometer {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOdometer ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setBeltStatus:(nullable SDLVehicleDataResult *)beltStatus {
    [self.parameters sdl_setObject:beltStatus forName:SDLRPCParameterNameBeltStatus];
}

- (nullable SDLVehicleDataResult *)beltStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBeltStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setBodyInformation:(nullable SDLVehicleDataResult *)bodyInformation {
    [self.parameters sdl_setObject:bodyInformation forName:SDLRPCParameterNameBodyInformation];
}

- (nullable SDLVehicleDataResult *)bodyInformation {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBodyInformation ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setDeviceStatus:(nullable SDLVehicleDataResult *)deviceStatus {
    [self.parameters sdl_setObject:deviceStatus forName:SDLRPCParameterNameDeviceStatus];
}

- (nullable SDLVehicleDataResult *)deviceStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDeviceStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setDriverBraking:(nullable SDLVehicleDataResult *)driverBraking {
    [self.parameters sdl_setObject:driverBraking forName:SDLRPCParameterNameDriverBraking];
}

- (nullable SDLVehicleDataResult *)driverBraking {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDriverBraking ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setWiperStatus:(nullable SDLVehicleDataResult *)wiperStatus {
    [self.parameters sdl_setObject:wiperStatus forName:SDLRPCParameterNameWiperStatus];
}

- (nullable SDLVehicleDataResult *)wiperStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameWiperStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setHeadLampStatus:(nullable SDLVehicleDataResult *)headLampStatus {
    [self.parameters sdl_setObject:headLampStatus forName:SDLRPCParameterNameHeadLampStatus];
}

- (nullable SDLVehicleDataResult *)headLampStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHeadLampStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setEngineOilLife:(nullable SDLVehicleDataResult *)engineOilLife {
    [self.parameters sdl_setObject:engineOilLife forName:SDLRPCParameterNameEngineOilLife];
}

- (nullable SDLVehicleDataResult *)engineOilLife {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineOilLife ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setEngineTorque:(nullable SDLVehicleDataResult *)engineTorque {
    [self.parameters sdl_setObject:engineTorque forName:SDLRPCParameterNameEngineTorque];
}

- (nullable SDLVehicleDataResult *)engineTorque {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineTorque ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setAccPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition {
    [self.parameters sdl_setObject:accPedalPosition forName:SDLRPCParameterNameAccelerationPedalPosition];
}

- (nullable SDLVehicleDataResult *)accPedalPosition {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAccelerationPedalPosition ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setSteeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle {
    [self.parameters sdl_setObject:steeringWheelAngle forName:SDLRPCParameterNameSteeringWheelAngle];
}

- (nullable SDLVehicleDataResult *)steeringWheelAngle {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSteeringWheelAngle ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setECallInfo:(nullable SDLVehicleDataResult *)eCallInfo {
    [self.parameters sdl_setObject:eCallInfo forName:SDLRPCParameterNameECallInfo];
}

- (nullable SDLVehicleDataResult *)eCallInfo {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECallInfo ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setAirbagStatus:(nullable SDLVehicleDataResult *)airbagStatus {
    [self.parameters sdl_setObject:airbagStatus forName:SDLRPCParameterNameAirbagStatus];
}

- (nullable SDLVehicleDataResult *)airbagStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAirbagStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setEmergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent {
    [self.parameters sdl_setObject:emergencyEvent forName:SDLRPCParameterNameEmergencyEvent];
}

- (nullable SDLVehicleDataResult *)emergencyEvent {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEmergencyEvent ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setClusterModes:(nullable SDLVehicleDataResult *)clusterModes {
    [self.parameters sdl_setObject:clusterModes forName:SDLRPCParameterNameClusterModes];
}

- (nullable SDLVehicleDataResult *)clusterModes {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameClusterModes ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setMyKey:(nullable SDLVehicleDataResult *)myKey {
    [self.parameters sdl_setObject:myKey forName:SDLRPCParameterNameMyKey];
}

- (nullable SDLVehicleDataResult *)myKey {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMyKey ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setElectronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus {
    [self.parameters sdl_setObject:electronicParkBrakeStatus forName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (nullable SDLVehicleDataResult *)electronicParkBrakeStatus {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameElectronicParkBrakeStatus ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setTurnSignal:(nullable SDLVehicleDataResult *)turnSignal {
    [self.parameters sdl_setObject:turnSignal forName:SDLRPCParameterNameTurnSignal];
}

- (nullable SDLVehicleDataResult *)turnSignal {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTurnSignal ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setCloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID {
    [self.parameters sdl_setObject:cloudAppVehicleID forName:SDLRPCParameterNameCloudAppVehicleID];
}

- (nullable SDLVehicleDataResult *)cloudAppVehicleID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCloudAppVehicleID ofClass:SDLVehicleDataResult.class error:&error];
}

- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(SDLVehicleDataResult *)vehicleDataState {
    [self.parameters sdl_setObject:vehicleDataState forName:vehicleDataName];
}

- (nullable SDLVehicleDataResult *)getOEMCustomVehicleData:(NSString *)vehicleDataName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:vehicleDataName ofClass:SDLVehicleDataResult.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
