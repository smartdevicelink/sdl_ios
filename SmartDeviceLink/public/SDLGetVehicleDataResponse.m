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
#import "SDLAirbagStatus.h"
#import "SDLBeltStatus.h"
#import "SDLBodyInformation.h"
#import "SDLClusterModeStatus.h"
#import "SDLComponentVolumeStatus.h"
#import "SDLDeviceStatus.h"
#import "SDLECallInfo.h"
#import "SDLElectronicParkBrakeStatus.h"
#import "SDLEmergencyEvent.h"
#import "SDLFuelRange.h"
#import "SDLGPSData.h"
#import "SDLGearStatus.h"
#import "SDLGetVehicleData.h"
#import "SDLHeadLampStatus.h"
#import "SDLMyKey.h"
#import "SDLPRNDL.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SDLSeatOccupancy.h"
#import "SDLStabilityControlsStatus.h"
#import "SDLTireStatus.h"
#import "SDLTurnSignal.h"
#import "SDLVehicleDataEventStatus.h"
#import "SDLWindowStatus.h"
#import "SDLWiperStatus.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SDLGetVehicleDataResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameGetVehicleData];
    if (!self) {
        return nil;
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithGps:(nullable SDLGPSData *)gps speed:(nullable NSNumber<SDLFloat> *)speed rpm:(nullable NSNumber<SDLUInt> *)rpm instantFuelConsumption:(nullable NSNumber<SDLFloat> *)instantFuelConsumption fuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange externalTemperature:(nullable NSNumber<SDLFloat> *)externalTemperature turnSignal:(nullable SDLTurnSignal)turnSignal vin:(nullable NSString *)vin gearStatus:(nullable SDLGearStatus *)gearStatus tirePressure:(nullable SDLTireStatus *)tirePressure odometer:(nullable NSNumber<SDLUInt> *)odometer beltStatus:(nullable SDLBeltStatus *)beltStatus bodyInformation:(nullable SDLBodyInformation *)bodyInformation deviceStatus:(nullable SDLDeviceStatus *)deviceStatus driverBraking:(nullable SDLVehicleDataEventStatus)driverBraking wiperStatus:(nullable SDLWiperStatus)wiperStatus headLampStatus:(nullable SDLHeadLampStatus *)headLampStatus engineTorque:(nullable NSNumber<SDLFloat> *)engineTorque accPedalPosition:(nullable NSNumber<SDLFloat> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLFloat> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLFloat> *)engineOilLife electronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSString *)cloudAppVehicleID stabilityControlsStatus:(nullable SDLStabilityControlsStatus *)stabilityControlsStatus eCallInfo:(nullable SDLECallInfo *)eCallInfo airbagStatus:(nullable SDLAirbagStatus *)airbagStatus emergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent clusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus myKey:(nullable SDLMyKey *)myKey windowStatus:(nullable NSArray<SDLWindowStatus *> *)windowStatus handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering seatOccupancy:(nullable SDLSeatOccupancy *)seatOccupancy {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.gps = gps;
    self.speed = speed;
    self.rpm = rpm;
    self.instantFuelConsumption = instantFuelConsumption;
    self.fuelRange = fuelRange;
    self.externalTemperature = externalTemperature;
    self.turnSignal = turnSignal;
    self.vin = vin;
    self.gearStatus = gearStatus;
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
    self.stabilityControlsStatus = stabilityControlsStatus;
    self.eCallInfo = eCallInfo;
    self.airbagStatus = airbagStatus;
    self.emergencyEvent = emergencyEvent;
    self.clusterModeStatus = clusterModeStatus;
    self.myKey = myKey;
    self.windowStatus = windowStatus;
    self.handsOffSteering = handsOffSteering;
    self.seatOccupancy = seatOccupancy;
    return self;
}

- (void)setGps:(nullable SDLGPSData *)gps {
    [self.parameters sdl_setObject:gps forName:SDLRPCParameterNameGps];
}

- (nullable SDLGPSData *)gps {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGps ofClass:SDLGPSData.class error:nil];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [self.parameters sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSpeed ofClass:NSNumber.class error:nil];
}

- (void)setRpm:(nullable NSNumber<SDLUInt> *)rpm {
    [self.parameters sdl_setObject:rpm forName:SDLRPCParameterNameRpm];
}

- (nullable NSNumber<SDLUInt> *)rpm {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameRpm ofClass:NSNumber.class error:nil];
}

- (void)setFuelLevel:(nullable NSNumber<SDLFloat> *)fuelLevel {
    [self.parameters sdl_setObject:fuelLevel forName:SDLRPCParameterNameFuelLevel];
}

- (nullable NSNumber<SDLFloat> *)fuelLevel {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFuelLevel ofClass:NSNumber.class error:nil];
}

- (void)setFuelLevel_State:(nullable SDLComponentVolumeStatus)fuelLevel_State {
    [self.parameters sdl_setObject:fuelLevel_State forName:SDLRPCParameterNameFuelLevel_State];
}

- (nullable SDLComponentVolumeStatus)fuelLevel_State {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameFuelLevel_State error:nil];
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    [self.parameters sdl_setObject:instantFuelConsumption forName:SDLRPCParameterNameInstantFuelConsumption];
}

- (nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInstantFuelConsumption ofClass:NSNumber.class error:nil];
}

- (void)setFuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange {
    [self.parameters sdl_setObject:fuelRange forName:SDLRPCParameterNameFuelRange];
}

- (nullable NSArray<SDLFuelRange *> *)fuelRange {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameFuelRange ofClass:SDLFuelRange.class error:nil];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLFloat> *)externalTemperature {
    [self.parameters sdl_setObject:externalTemperature forName:SDLRPCParameterNameExternalTemperature];
}

- (nullable NSNumber<SDLFloat> *)externalTemperature {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameExternalTemperature ofClass:NSNumber.class error:nil];
}

- (void)setTurnSignal:(nullable SDLTurnSignal)turnSignal {
    [self.parameters sdl_setObject:turnSignal forName:SDLRPCParameterNameTurnSignal];
}

- (nullable SDLTurnSignal)turnSignal {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameTurnSignal error:nil];
}

- (void)setVin:(nullable NSString *)vin {
    [self.parameters sdl_setObject:vin forName:SDLRPCParameterNameVin];
}

- (nullable NSString *)vin {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameVin ofClass:NSString.class error:nil];
}

- (void)setGearStatus:(nullable SDLGearStatus *)gearStatus {
    [self.parameters sdl_setObject:gearStatus forName:SDLRPCParameterNameGearStatus];
}

- (nullable SDLGearStatus *)gearStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameGearStatus ofClass:SDLGearStatus.class error:nil];
}

- (void)setPrndl:(nullable SDLPRNDL)prndl {
    [self.parameters sdl_setObject:prndl forName:SDLRPCParameterNamePrndl];
}

- (nullable SDLPRNDL)prndl {
    return [self.parameters sdl_enumForName:SDLRPCParameterNamePrndl error:nil];
}

- (void)setTirePressure:(nullable SDLTireStatus *)tirePressure {
    [self.parameters sdl_setObject:tirePressure forName:SDLRPCParameterNameTirePressure];
}

- (nullable SDLTireStatus *)tirePressure {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTirePressure ofClass:SDLTireStatus.class error:nil];
}

- (void)setOdometer:(nullable NSNumber<SDLUInt> *)odometer {
    [self.parameters sdl_setObject:odometer forName:SDLRPCParameterNameOdometer];
}

- (nullable NSNumber<SDLUInt> *)odometer {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOdometer ofClass:NSNumber.class error:nil];
}

- (void)setBeltStatus:(nullable SDLBeltStatus *)beltStatus {
    [self.parameters sdl_setObject:beltStatus forName:SDLRPCParameterNameBeltStatus];
}

- (nullable SDLBeltStatus *)beltStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBeltStatus ofClass:SDLBeltStatus.class error:nil];
}

- (void)setBodyInformation:(nullable SDLBodyInformation *)bodyInformation {
    [self.parameters sdl_setObject:bodyInformation forName:SDLRPCParameterNameBodyInformation];
}

- (nullable SDLBodyInformation *)bodyInformation {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBodyInformation ofClass:SDLBodyInformation.class error:nil];
}

- (void)setDeviceStatus:(nullable SDLDeviceStatus *)deviceStatus {
    [self.parameters sdl_setObject:deviceStatus forName:SDLRPCParameterNameDeviceStatus];
}

- (nullable SDLDeviceStatus *)deviceStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDeviceStatus ofClass:SDLDeviceStatus.class error:nil];
}

- (void)setDriverBraking:(nullable SDLVehicleDataEventStatus)driverBraking {
    [self.parameters sdl_setObject:driverBraking forName:SDLRPCParameterNameDriverBraking];
}

- (nullable SDLVehicleDataEventStatus)driverBraking {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameDriverBraking error:nil];
}

- (void)setWiperStatus:(nullable SDLWiperStatus)wiperStatus {
    [self.parameters sdl_setObject:wiperStatus forName:SDLRPCParameterNameWiperStatus];
}

- (nullable SDLWiperStatus)wiperStatus {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameWiperStatus error:nil];
}

- (void)setHeadLampStatus:(nullable SDLHeadLampStatus *)headLampStatus {
    [self.parameters sdl_setObject:headLampStatus forName:SDLRPCParameterNameHeadLampStatus];
}

- (nullable SDLHeadLampStatus *)headLampStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHeadLampStatus ofClass:SDLHeadLampStatus.class error:nil];
}

- (void)setEngineTorque:(nullable NSNumber<SDLFloat> *)engineTorque {
    [self.parameters sdl_setObject:engineTorque forName:SDLRPCParameterNameEngineTorque];
}

- (nullable NSNumber<SDLFloat> *)engineTorque {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineTorque ofClass:NSNumber.class error:nil];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLFloat> *)accPedalPosition {
    [self.parameters sdl_setObject:accPedalPosition forName:SDLRPCParameterNameAccPedalPosition];
}

- (nullable NSNumber<SDLFloat> *)accPedalPosition {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAccPedalPosition ofClass:NSNumber.class error:nil];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    [self.parameters sdl_setObject:steeringWheelAngle forName:SDLRPCParameterNameSteeringWheelAngle];
}

- (nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSteeringWheelAngle ofClass:NSNumber.class error:nil];
}

- (void)setEngineOilLife:(nullable NSNumber<SDLFloat> *)engineOilLife {
    [self.parameters sdl_setObject:engineOilLife forName:SDLRPCParameterNameEngineOilLife];
}

- (nullable NSNumber<SDLFloat> *)engineOilLife {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEngineOilLife ofClass:NSNumber.class error:nil];
}

- (void)setElectronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    [self.parameters sdl_setObject:electronicParkBrakeStatus forName:SDLRPCParameterNameElectronicParkBrakeStatus];
}

- (nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameElectronicParkBrakeStatus error:nil];
}

- (void)setCloudAppVehicleID:(nullable NSString *)cloudAppVehicleID {
    [self.parameters sdl_setObject:cloudAppVehicleID forName:SDLRPCParameterNameCloudAppVehicleID];
}

- (nullable NSString *)cloudAppVehicleID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCloudAppVehicleID ofClass:NSString.class error:nil];
}

- (void)setStabilityControlsStatus:(nullable SDLStabilityControlsStatus *)stabilityControlsStatus {
    [self.parameters sdl_setObject:stabilityControlsStatus forName:SDLRPCParameterNameStabilityControlsStatus];
}

- (nullable SDLStabilityControlsStatus *)stabilityControlsStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameStabilityControlsStatus ofClass:SDLStabilityControlsStatus.class error:nil];
}

- (void)setECallInfo:(nullable SDLECallInfo *)eCallInfo {
    [self.parameters sdl_setObject:eCallInfo forName:SDLRPCParameterNameECallInfo];
}

- (nullable SDLECallInfo *)eCallInfo {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECallInfo ofClass:SDLECallInfo.class error:nil];
}

- (void)setAirbagStatus:(nullable SDLAirbagStatus *)airbagStatus {
    [self.parameters sdl_setObject:airbagStatus forName:SDLRPCParameterNameAirbagStatus];
}

- (nullable SDLAirbagStatus *)airbagStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAirbagStatus ofClass:SDLAirbagStatus.class error:nil];
}

- (void)setEmergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent {
    [self.parameters sdl_setObject:emergencyEvent forName:SDLRPCParameterNameEmergencyEvent];
}

- (nullable SDLEmergencyEvent *)emergencyEvent {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEmergencyEvent ofClass:SDLEmergencyEvent.class error:nil];
}

- (void)setClusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus {
    [self.parameters sdl_setObject:clusterModeStatus forName:SDLRPCParameterNameClusterModeStatus];
}

- (nullable SDLClusterModeStatus *)clusterModeStatus {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameClusterModeStatus ofClass:SDLClusterModeStatus.class error:nil];
}

- (void)setMyKey:(nullable SDLMyKey *)myKey {
    [self.parameters sdl_setObject:myKey forName:SDLRPCParameterNameMyKey];
}

- (nullable SDLMyKey *)myKey {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMyKey ofClass:SDLMyKey.class error:nil];
}

- (void)setWindowStatus:(nullable NSArray<SDLWindowStatus *> *)windowStatus {
    [self.parameters sdl_setObject:windowStatus forName:SDLRPCParameterNameWindowStatus];
}

- (nullable NSArray<SDLWindowStatus *> *)windowStatus {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameWindowStatus ofClass:SDLWindowStatus.class error:nil];
}

- (void)setHandsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering {
    [self.parameters sdl_setObject:handsOffSteering forName:SDLRPCParameterNameHandsOffSteering];
}

- (nullable NSNumber<SDLBool> *)handsOffSteering {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHandsOffSteering ofClass:NSNumber.class error:nil];
}

- (void)setSeatOccupancy:(nullable SDLSeatOccupancy *)seatOccupancy {
    [self.parameters sdl_setObject:seatOccupancy forName:SDLRPCParameterNameSeatOccupancy];
}

- (nullable SDLSeatOccupancy *)seatOccupancy {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSeatOccupancy ofClass:SDLSeatOccupancy.class error:nil];
}

@end

NS_ASSUME_NONNULL_END