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

#import "SDLComponentVolumeStatus.h"
#import "SDLElectronicParkBrakeStatus.h"
#import "SDLPRNDL.h"
#import "SDLRPCNotification.h"
#import "SDLTurnSignal.h"
#import "SDLVehicleDataEventStatus.h"
#import "SDLWiperStatus.h"

@class SDLAirbagStatus;
@class SDLBeltStatus;
@class SDLBodyInformation;
@class SDLClusterModeStatus;
@class SDLDeviceStatus;
@class SDLECallInfo;
@class SDLEmergencyEvent;
@class SDLFuelRange;
@class SDLGPSData;
@class SDLHeadLampStatus;
@class SDLMyKey;
@class SDLStabilityControlsStatus;
@class SDLTireStatus;

NS_ASSUME_NONNULL_BEGIN

/**
 Callback for the periodic and non periodic vehicle data read function.

 Since SmartDeviceLink 2.0
 */
@interface SDLOnVehicleData : SDLRPCNotification

/**
 * Convenience init for setting all possible values on vehicle data items.
 *
 * @param gps - gps
 * @param speed - @(speed)
 * @param rpm - rpm
 * @param fuelLevel - @(fuelLevel)
 * @param fuelLevel_State - fuelLevel_State
 * @param instantFuelConsumption - @(instantFuelConsumption)
 * @param fuelRange - fuelRange
 * @param externalTemperature - @(externalTemperature)
 * @param turnSignal - turnSignal
 * @param vin - vin
 * @param prndl - prndl
 * @param tirePressure - tirePressure
 * @param odometer - odometer
 * @param beltStatus - beltStatus
 * @param bodyInformation - bodyInformation
 * @param deviceStatus - deviceStatus
 * @param driverBraking - driverBraking
 * @param wiperStatus - wiperStatus
 * @param headLampStatus - headLampStatus
 * @param engineTorque - @(engineTorque)
 * @param accPedalPosition - @(accPedalPosition)
 * @param steeringWheelAngle - @(steeringWheelAngle)
 * @param engineOilLife - @(engineOilLife)
 * @param electronicParkBrakeStatus - electronicParkBrakeStatus
 * @param cloudAppVehicleID - cloudAppVehicleID
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @return A SDLOnVehicleData object
 */
- (instancetype)initWithGps:(nullable SDLGPSData *)gps speed:(float)speed rpm:(nullable NSNumber<SDLUInt> *)rpm fuelLevel:(float)fuelLevel fuelLevel_State:(nullable SDLComponentVolumeStatus)fuelLevel_State instantFuelConsumption:(float)instantFuelConsumption fuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange externalTemperature:(float)externalTemperature turnSignal:(nullable SDLTurnSignal)turnSignal vin:(nullable NSString *)vin prndl:(nullable SDLPRNDL)prndl tirePressure:(nullable SDLTireStatus *)tirePressure odometer:(nullable NSNumber<SDLUInt> *)odometer beltStatus:(nullable SDLBeltStatus *)beltStatus bodyInformation:(nullable SDLBodyInformation *)bodyInformation deviceStatus:(nullable SDLDeviceStatus *)deviceStatus driverBraking:(nullable SDLVehicleDataEventStatus)driverBraking wiperStatus:(nullable SDLWiperStatus)wiperStatus headLampStatus:(nullable SDLHeadLampStatus *)headLampStatus engineTorque:(float)engineTorque accPedalPosition:(float)accPedalPosition steeringWheelAngle:(float)steeringWheelAngle engineOilLife:(float)engineOilLife electronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSString *)cloudAppVehicleID eCallInfo:(nullable SDLECallInfo *)eCallInfo airbagStatus:(nullable SDLAirbagStatus *)airbagStatus emergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent clusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus myKey:(nullable SDLMyKey *)myKey;

/**
 Accelerator pedal position (percentage depressed)

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *accPedalPosition;

/**
 The status of the air bags

 Optional.
 */
@property (nullable, strong, nonatomic) SDLAirbagStatus *airbagStatus;

/**
 The status of the seat belts

 Optional.
 */
@property (nullable, strong, nonatomic) SDLBeltStatus *beltStatus;

/**
 The body information including power modes

 Optional.
 */
@property (nullable, strong, nonatomic) SDLBodyInformation *bodyInformation;

/**
 The cloud app vehicle ID

 Optional.
 */
@property (nullable, strong, nonatomic) NSString *cloudAppVehicleID;

/**
 The status modes of the cluster

 Optional.
 */
@property (nullable, strong, nonatomic) SDLClusterModeStatus *clusterModeStatus;

/**
 The IVI system status including signal and battery strength

 Optional.
 */
@property (nullable, strong, nonatomic) SDLDeviceStatus *deviceStatus;

/**
 The status of the brake pedal

 Optional.
 */
@property (nullable, strong, nonatomic) SDLVehicleDataEventStatus driverBraking;

/**
 Emergency Call notification and confirmation data

 Optional.
 */
@property (nullable, strong, nonatomic) SDLECallInfo *eCallInfo;

/**
 The status of the electronic parking brake

 Optional.
 */
@property (nullable, strong, nonatomic) SDLElectronicParkBrakeStatus electronicParkBrakeStatus;

/**
 Information related to an emergency event (and if it occurred)

 Optional.
 */
@property (nullable, strong, nonatomic) SDLEmergencyEvent *emergencyEvent;

/**
 The estimated percentage (0% - 100%) of remaining oil life of the engine

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *engineOilLife;

/**
 Torque value for engine (in Nm) on non-diesel variants

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *engineTorque;

/**
 The external temperature in degrees celsius.

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *externalTemperature;

/**
 The fuel level in the tank (percentage)

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *fuelLevel;

/**
 The fuel level state

 Optional.
 */
@property (nullable, strong, nonatomic) SDLComponentVolumeStatus fuelLevel_State;

/**
 The estimate range in KM the vehicle can travel based on fuel level and consumption

 Optional, Array of length 0 - 100, of SDLFuelRange
 */
@property (nullable, strong, nonatomic) NSArray<SDLFuelRange *> *fuelRange;

/**
 The car current GPS coordinates

 Optional.
 */
@property (nullable, strong, nonatomic) SDLGPSData *gps;

/**
 Status of the head lamps

 Optional.
 */
@property (nullable, strong, nonatomic) SDLHeadLampStatus *headLampStatus;

/**
 The instantaneous fuel consumption in microlitres

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *instantFuelConsumption;

/**
 Information related to the MyKey feature

 Optional.
 */
@property (nullable, strong, nonatomic) SDLMyKey *myKey;

/**
 Odometer reading in km

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *odometer;

/**
 The current gear shift state of the user's vehicle

 Optional.
 */
@property (nullable, strong, nonatomic) SDLPRNDL prndl;

/**
 The number of revolutions per minute of the engine.

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *rpm;

/**
 The vehicle speed in kilometers per hour

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *speed;

/**
 * See StabilityControlsStatus
 *
 * Optional.
 *
 * @since SDL 7.0.0
 */
@property (nullable, strong, nonatomic) SDLStabilityControlsStatus *stabilityControlsStatus;

/**
 Current angle of the steering wheel (in deg)

 Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *steeringWheelAngle;

/**
 The current pressure warnings for the user's vehicle

 Optional.
 */
@property (nullable, strong, nonatomic) SDLTireStatus *tirePressure;

/**
 The status of the turn signal

 Optional.
 */
@property (nullable, strong, nonatomic) SDLTurnSignal turnSignal;

/**
 The Vehicle Identification Number

 Optional.
 */
@property (nullable, strong, nonatomic) NSString *vin;

/**
 The status of the wipers

 Optional.
 */
@property (nullable, strong, nonatomic) SDLWiperStatus wiperStatus;

/**
 Sets the OEM custom vehicle data state for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @param vehicleDataState An object containing the OEM custom vehicle data item.

  Added in SmartDeviceLink 6.0
 */
- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(NSObject *)vehicleDataState NS_SWIFT_NAME(setOEMCustomVehicleData(name:state:));

/**
 Gets the OEM custom vehicle data item for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @return An OEM custom vehicle data object for the given vehicle data name.

  Added in SmartDeviceLink 6.0
 */
- (nullable NSObject *)getOEMCustomVehicleData:(NSString *)vehicleDataName;

@end

NS_ASSUME_NONNULL_END
