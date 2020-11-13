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

#import "SDLRPCResponse.h"

@class SDLVehicleDataResult;

NS_ASSUME_NONNULL_BEGIN

/**
 * @added in SmartDeviceLink 2.0.0
 */
@interface SDLUnsubscribeVehicleDataResponse : SDLRPCResponse

/**
 * @param gps - gps
 * @param speed - speed
 * @param rpm - rpm
 * @param instantFuelConsumption - instantFuelConsumption
 * @param fuelRange - fuelRange
 * @param externalTemperature - externalTemperature
 * @param turnSignal - turnSignal
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
 * @param clusterModes - clusterModes
 * @param myKey - myKey
 * @param windowStatus - windowStatus
 * @param handsOffSteering - handsOffSteering
 * @param seatOccupancy - seatOccupancy
 * @return A SDLUnsubscribeVehicleDataResponse object
 */
- (instancetype)initWithGps:(nullable SDLVehicleDataResult *)gps speed:(nullable SDLVehicleDataResult *)speed rpm:(nullable SDLVehicleDataResult *)rpm instantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption fuelRange:(nullable SDLVehicleDataResult *)fuelRange externalTemperature:(nullable SDLVehicleDataResult *)externalTemperature turnSignal:(nullable SDLVehicleDataResult *)turnSignal gearStatus:(nullable SDLVehicleDataResult *)gearStatus tirePressure:(nullable SDLVehicleDataResult *)tirePressure odometer:(nullable SDLVehicleDataResult *)odometer beltStatus:(nullable SDLVehicleDataResult *)beltStatus bodyInformation:(nullable SDLVehicleDataResult *)bodyInformation deviceStatus:(nullable SDLVehicleDataResult *)deviceStatus driverBraking:(nullable SDLVehicleDataResult *)driverBraking wiperStatus:(nullable SDLVehicleDataResult *)wiperStatus headLampStatus:(nullable SDLVehicleDataResult *)headLampStatus engineTorque:(nullable SDLVehicleDataResult *)engineTorque accPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition steeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle engineOilLife:(nullable SDLVehicleDataResult *)engineOilLife electronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus cloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID stabilityControlsStatus:(nullable SDLVehicleDataResult *)stabilityControlsStatus eCallInfo:(nullable SDLVehicleDataResult *)eCallInfo airbagStatus:(nullable SDLVehicleDataResult *)airbagStatus emergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent clusterModes:(nullable SDLVehicleDataResult *)clusterModes myKey:(nullable SDLVehicleDataResult *)myKey windowStatus:(nullable SDLVehicleDataResult *)windowStatus handsOffSteering:(nullable SDLVehicleDataResult *)handsOffSteering seatOccupancy:(nullable SDLVehicleDataResult *)seatOccupancy;

/**
 * See GPSData
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *gps;

/**
 * The vehicle speed in kilometers per hour
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *speed;

/**
 * The number of revolutions per minute of the engine
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *rpm;

/**
 * The fuel level in the tank (percentage). This parameter is deprecated starting RPC Spec 7.0, please see fuelRange.
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *fuelLevel __deprecated;

/**
 * The fuel level state. This parameter is deprecated starting RPC Spec 7.0, please see fuelRange.
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *fuelLevel_State __deprecated;

/**
 * The instantaneous fuel consumption in microlitres
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *instantFuelConsumption;

/**
 * The fuel type, estimated range in KM, fuel level/capacity and fuel level state for the vehicle. See struct FuelRange for details.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *fuelRange;

/**
 * The external temperature in degrees celsius
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *externalTemperature;

/**
 * See TurnSignal
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *turnSignal;

/**
 * See GearStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *gearStatus;

/**
 * See PRNDL. This parameter is deprecated and it is now covered in `gearStatus`
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *prndl __deprecated;

/**
 * See TireStatus
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *tirePressure;

/**
 * Odometer in km
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *odometer;

/**
 * The status of the seat belts
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *beltStatus;

/**
 * The body information including power modes
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *bodyInformation;

/**
 * The device status including signal and battery strength
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *deviceStatus;

/**
 * The status of the brake pedal
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *driverBraking;

/**
 * The status of the wipers
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *wiperStatus;

/**
 * Status of the head lamps
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *headLampStatus;

/**
 * Torque value for engine (in Nm) on non-diesel variants
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *engineTorque;

/**
 * Accelerator pedal position (percentage depressed)
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *accPedalPosition;

/**
 * Current angle of the steering wheel (in deg)
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *steeringWheelAngle;

/**
 * The estimated percentage of remaining oil life of the engine.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *engineOilLife;

/**
 * The status of the park brake as provided by Electric Park Brake (EPB) system.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *electronicParkBrakeStatus;

/**
 * Parameter used by cloud apps to identify a head unit
 *
 * @added in SmartDeviceLink 5.1.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *cloudAppVehicleID;

/**
 * See StabilityControlsStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *stabilityControlsStatus;

/**
 * Emergency Call notification and confirmation data
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *eCallInfo;

/**
 * The status of the air bags
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *airbagStatus;

/**
 * Information related to an emergency event (and if it occurred)
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *emergencyEvent;

/**
 * The status modes of the cluster
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *clusterModes;

/**
 * Information related to the MyKey feature
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *myKey;

/**
 * See WindowStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *windowStatus;

/**
 * To indicate whether driver hands are off the steering wheel
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *handsOffSteering;

/**
 * See SeatOccupancy
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *seatOccupancy;

@end

NS_ASSUME_NONNULL_END