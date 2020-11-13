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
@class SDLGearStatus;
@class SDLHeadLampStatus;
@class SDLMyKey;
@class SDLSeatOccupancy;
@class SDLStabilityControlsStatus;
@class SDLTireStatus;
@class SDLWindowStatus;

NS_ASSUME_NONNULL_BEGIN

/**
 * Callback for the periodic and non periodic vehicle data read function.
 *
 * @added in SmartDeviceLink 2.0.0
 */
@interface SDLOnVehicleData : SDLRPCNotification

/**
 * @param gps - gps
 * @param speed - speed
 * @param rpm - rpm
 * @param instantFuelConsumption - instantFuelConsumption
 * @param fuelRange - fuelRange
 * @param externalTemperature - externalTemperature
 * @param turnSignal - turnSignal
 * @param vin - vin
 * @param gearStatus - gearStatus
 * @param tirePressure - tirePressure
 * @param odometer - odometer
 * @param beltStatus - beltStatus
 * @param bodyInformation - bodyInformation
 * @param deviceStatus - deviceStatus
 * @param driverBraking - driverBraking
 * @param wiperStatus - wiperStatus
 * @param headLampStatus - headLampStatus
 * @param engineTorque - engineTorque
 * @param accPedalPosition - accPedalPosition
 * @param steeringWheelAngle - steeringWheelAngle
 * @param engineOilLife - engineOilLife
 * @param electronicParkBrakeStatus - electronicParkBrakeStatus
 * @param cloudAppVehicleID - cloudAppVehicleID
 * @param stabilityControlsStatus - stabilityControlsStatus
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @param windowStatus - windowStatus
 * @param handsOffSteering - handsOffSteering
 * @param seatOccupancy - seatOccupancy
 * @return A SDLOnVehicleData object
 */
- (instancetype)initWithGps:(nullable SDLGPSData *)gps speed:(nullable NSNumber<SDLFloat> *)speed rpm:(nullable NSNumber<SDLUInt> *)rpm instantFuelConsumption:(nullable NSNumber<SDLFloat> *)instantFuelConsumption fuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange externalTemperature:(nullable NSNumber<SDLFloat> *)externalTemperature turnSignal:(nullable SDLTurnSignal)turnSignal vin:(nullable NSString *)vin gearStatus:(nullable SDLGearStatus *)gearStatus tirePressure:(nullable SDLTireStatus *)tirePressure odometer:(nullable NSNumber<SDLUInt> *)odometer beltStatus:(nullable SDLBeltStatus *)beltStatus bodyInformation:(nullable SDLBodyInformation *)bodyInformation deviceStatus:(nullable SDLDeviceStatus *)deviceStatus driverBraking:(nullable SDLVehicleDataEventStatus)driverBraking wiperStatus:(nullable SDLWiperStatus)wiperStatus headLampStatus:(nullable SDLHeadLampStatus *)headLampStatus engineTorque:(nullable NSNumber<SDLFloat> *)engineTorque accPedalPosition:(nullable NSNumber<SDLFloat> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLFloat> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLFloat> *)engineOilLife electronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSString *)cloudAppVehicleID stabilityControlsStatus:(nullable SDLStabilityControlsStatus *)stabilityControlsStatus eCallInfo:(nullable SDLECallInfo *)eCallInfo airbagStatus:(nullable SDLAirbagStatus *)airbagStatus emergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent clusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus myKey:(nullable SDLMyKey *)myKey windowStatus:(nullable NSArray<SDLWindowStatus *> *)windowStatus handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering seatOccupancy:(nullable SDLSeatOccupancy *)seatOccupancy;

/**
 * See GPSData
 */
@property (nullable, strong, nonatomic) SDLGPSData *gps;

/**
 * The vehicle speed in kilometers per hour
 * {"num_min_value": 0.0, "num_max_value": 700.0}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *speed;

/**
 * The number of revolutions per minute of the engine
 * {"num_min_value": 0, "num_max_value": 20000}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *rpm;

/**
 * The fuel level in the tank (percentage). This parameter is deprecated starting RPC Spec 7.0, please see fuelRange.
 * {"num_min_value": -6.0, "num_max_value": 106.0}
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *fuelLevel __deprecated;

/**
 * The fuel level state. This parameter is deprecated starting RPC Spec 7.0, please see fuelRange.
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) SDLComponentVolumeStatus fuelLevel_State __deprecated;

/**
 * The instantaneous fuel consumption in microlitres
 * {"num_min_value": 0.0, "num_max_value": 25575.0}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *instantFuelConsumption;

/**
 * The fuel type, estimated range in KM, fuel level/capacity and fuel level state for the vehicle. See struct FuelRange for details.
 * {"array_min_size": 0, "array_max_size": 100}
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLFuelRange *> *fuelRange;

/**
 * The external temperature in degrees celsius
 * {"num_min_value": -40.0, "num_max_value": 100.0}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *externalTemperature;

/**
 * See TurnSignal
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLTurnSignal turnSignal;

/**
 * Vehicle identification number.
 * {"string_min_length": 1, "string_max_length": 17}
 */
@property (nullable, strong, nonatomic) NSString *vin;

/**
 * See GearStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) SDLGearStatus *gearStatus;

/**
 * See PRNDL. This parameter is deprecated and it is now covered in `gearStatus`
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) SDLPRNDL prndl __deprecated;

/**
 * See TireStatus
 */
@property (nullable, strong, nonatomic) SDLTireStatus *tirePressure;

/**
 * Odometer in km
 * {"num_min_value": 0, "num_max_value": 17000000}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *odometer;

/**
 * The status of the seat belts
 */
@property (nullable, strong, nonatomic) SDLBeltStatus *beltStatus;

/**
 * The body information including power modes
 */
@property (nullable, strong, nonatomic) SDLBodyInformation *bodyInformation;

/**
 * The device status including signal and battery strength
 */
@property (nullable, strong, nonatomic) SDLDeviceStatus *deviceStatus;

/**
 * The status of the brake pedal
 */
@property (nullable, strong, nonatomic) SDLVehicleDataEventStatus driverBraking;

/**
 * The status of the wipers
 */
@property (nullable, strong, nonatomic) SDLWiperStatus wiperStatus;

/**
 * Status of the head lamps
 */
@property (nullable, strong, nonatomic) SDLHeadLampStatus *headLampStatus;

/**
 * Torque value for engine (in Nm) on non-diesel variants
 * {"num_min_value": -1000.0, "num_max_value": 2000.0}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *engineTorque;

/**
 * Accelerator pedal position (percentage depressed)
 * {"num_min_value": 0.0, "num_max_value": 100.0}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *accPedalPosition;

/**
 * Current angle of the steering wheel (in deg)
 * {"num_min_value": -2000.0, "num_max_value": 2000.0}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *steeringWheelAngle;

/**
 * The estimated percentage of remaining oil life of the engine.
 * {"num_min_value": 0.0, "num_max_value": 100.0}
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *engineOilLife;

/**
 * The status of the park brake as provided by Electric Park Brake (EPB) system.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLElectronicParkBrakeStatus electronicParkBrakeStatus;

/**
 * Parameter used by cloud apps to identify a head unit
 * {"string_min_length": 1, "string_max_length": null}
 *
 * @added in SmartDeviceLink 5.1.0
 */
@property (nullable, strong, nonatomic) NSString *cloudAppVehicleID;

/**
 * See StabilityControlsStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) SDLStabilityControlsStatus *stabilityControlsStatus;

/**
 * Emergency Call notification and confirmation data
 */
@property (nullable, strong, nonatomic) SDLECallInfo *eCallInfo;

/**
 * The status of the air bags
 */
@property (nullable, strong, nonatomic) SDLAirbagStatus *airbagStatus;

/**
 * Information related to an emergency event (and if it occurred)
 */
@property (nullable, strong, nonatomic) SDLEmergencyEvent *emergencyEvent;

/**
 * The status modes of the cluster
 */
@property (nullable, strong, nonatomic) SDLClusterModeStatus *clusterModeStatus;

/**
 * Information related to the MyKey feature
 */
@property (nullable, strong, nonatomic) SDLMyKey *myKey;

/**
 * See WindowStatus
 * {"array_min_size": 0, "array_max_size": 100}
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLWindowStatus *> *windowStatus;

/**
 * To indicate whether driver hands are off the steering wheel
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *handsOffSteering;

/**
 * See SeatOccupancy
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) SDLSeatOccupancy *seatOccupancy;

@end

NS_ASSUME_NONNULL_END