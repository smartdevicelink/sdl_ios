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

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This function is used to unsubscribe the notifications from the subscribeVehicleData function.
 *
 * @added in SmartDeviceLink 2.0.0
 */
@interface SDLUnsubscribeVehicleData : SDLRPCRequest

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
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @param windowStatus - windowStatus
 * @param handsOffSteering - handsOffSteering
 * @param seatOccupancy - seatOccupancy
 * @return A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange externalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature turnSignal:(nullable NSNumber<SDLBool> *)turnSignal gearStatus:(nullable NSNumber<SDLBool> *)gearStatus tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID stabilityControlsStatus:(nullable NSNumber<SDLBool> *)stabilityControlsStatus eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey windowStatus:(nullable NSNumber<SDLBool> *)windowStatus handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering seatOccupancy:(nullable NSNumber<SDLBool> *)seatOccupancy;

/**
 * See GPSData
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *gps;

/**
 * The vehicle speed in kilometers per hour
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *speed;

/**
 * The number of revolutions per minute of the engine
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rpm;

/**
 * The fuel level in the tank (percentage). This parameter is deprecated starting RPC Spec 7.0, please see fuelRange.
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel __deprecated;

/**
 * The fuel level state. This parameter is deprecated starting RPC Spec 7.0, please see fuelRange.
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel_State __deprecated;

/**
 * The instantaneous fuel consumption in microlitres
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * The fuel type, estimated range in KM, fuel level/capacity and fuel level state for the vehicle. See struct FuelRange for details.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelRange;

/**
 * The external temperature in degrees celsius.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *externalTemperature;

/**
 * See TurnSignal
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *turnSignal;

/**
 * See GearStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *gearStatus;

/**
 * See PRNDL. This parameter is deprecated and it is now covered in `gearStatus`
 *
 * @deprecated in SmartDeviceLink 7.0.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *prndl __deprecated;

/**
 * See TireStatus
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *tirePressure;

/**
 * Odometer in km
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *odometer;

/**
 * The status of the seat belts
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *beltStatus;

/**
 * The body information including power modes
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *bodyInformation;

/**
 * The device status including signal and battery strength
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *deviceStatus;

/**
 * The status of the brake pedal
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverBraking;

/**
 * The status of the wipers
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *wiperStatus;

/**
 * Status of the head lamps
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headLampStatus;

/**
 * Torque value for engine (in Nm) on non-diesel variants
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *engineTorque;

/**
 * Accelerator pedal position (percentage depressed)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *accPedalPosition;

/**
 * Current angle of the steering wheel (in deg)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * The estimated percentage of remaining oil life of the engine.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *engineOilLife;

/**
 * The status of the park brake as provided by Electric Park Brake (EPB) system.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 * Parameter used by cloud apps to identify a head unit
 *
 * @added in SmartDeviceLink 5.1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *cloudAppVehicleID;

/**
 * See StabilityControlsStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *stabilityControlsStatus;

/**
 * Emergency Call notification and confirmation data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *eCallInfo;

/**
 * The status of the air bags
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *airbagStatus;

/**
 * Information related to an emergency event (and if it occurred)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *emergencyEvent;

/**
 * The status modes of the cluster
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *clusterModeStatus;

/**
 * Information related to the MyKey feature
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *myKey;

/**
 * See WindowStatus
 *
 * @added in SmartDeviceLink 7.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *windowStatus;

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
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *seatOccupancy;

@end

NS_ASSUME_NONNULL_END