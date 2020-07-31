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
#import "SDLRPCResponse.h"
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
@class SDLTireStatus;

NS_ASSUME_NONNULL_BEGIN

/**
 * @since SDL 2.0.0
 */
@interface SDLGetVehicleDataResponse : SDLRPCResponse

/**
 * initializes a new allocated object of the SDLGetVehicleDataResponse class
 *
 *  @param accPedalPosition  Accelerator pedal position (percentage depressed), optional
 *  @param airbagStatus The status of the air bags, optional
 *  @param beltStatus  The status of the seat belts, optional
 *  @param bodyInformation The body information including power modes, optional
 *  @param cloudAppVehicleID The cloud app vehicle ID, optional
 *  @param clusterModeStatus The status modes of the cluster, optional
 *  @param deviceStatus The IVI system status including signal and battery strength, optional
 *  @param driverBraking The status of the brake pedal, optional
 *  @param eCallInfo Emergency Call notification and confirmation data, optional
 *  @param electronicParkBrakeStatus The status of the electronic parking brake, optional
 *  @param emergencyEvent Information related to an emergency event (and if it occurred), optional
 *  @param engineOilLife The estimated percentage (0% - 100%) of remaining oil life of the engine, optional
 *  @param engineTorque Torque value for engine (in Nm) on non-diesel variants, optional
 *  @param externalTemperature The external temperature in degrees celsius., optional
 *  @param fuelLevel The fuel level in the tank (percentage), optional
 *  @param fuelLevel_State The fuel level state, optional
 *  @param fuelRange The estimate range in KM the vehicle can travel based on fuel level and consumption. Optional, Array of length 0 - 100, of SDLFuelRange
 *  @param gps The car current GPS coordinates, optional
 *  @param handsOffSteering To indicate whether driver hands are off the steering wheel, optional
 *  @param headLampStatus Status of the head lamps, optional
 *  @param instantFuelConsumption The instantaneous fuel consumption in microlitres, optional
 *  @param myKey Information related to the MyKey feature, optional
 *  @param odometer Odometer reading in km, optional
 *  @param prndl The current gear shift state of the user's vehicle, optional
 *  @param rpm The number of revolutions per minute of the engine., optional
 *  @param speed The vehicle speed in kilometers per hour, optional
 *  @param steeringWheelAngle Current angle of the steering wheel (in deg), optional
 *  @param tirePressure The current pressure warnings for the user's vehicle, optional
 *  @param turnSignal The status of the turn signal, optional
 *  @param vin The Vehicle Identification Number, optional
 *  @param wiperStatus The status of the wipers, optional
 *
 * @return an initialized object of the SDLGetVehicleDataResponse class or nil
 */

- (instancetype)initWithAccPedalPosition:(float)accPedalPosition airbagStatus:(SDLAirbagStatus *)airbagStatus beltStatus:(SDLBeltStatus *)beltStatus bodyInformation:(SDLBodyInformation *)bodyInformation cloudAppVehicleID:(NSString *)cloudAppVehicleID clusterModeStatus:(SDLClusterModeStatus *)clusterModeStatus deviceStatus:(SDLDeviceStatus *)deviceStatus driverBraking:(SDLVehicleDataEventStatus)driverBraking eCallInfo:(SDLECallInfo *)eCallInfo electronicParkBrakeStatus:(SDLElectronicParkBrakeStatus)electronicParkBrakeStatus emergencyEvent:(SDLEmergencyEvent *)emergencyEvent engineOilLife:(float)engineOilLife engineTorque:(float)engineTorque externalTemperature:(float)externalTemperature fuelLevel:(float)fuelLevel fuelLevel_State:(SDLComponentVolumeStatus)fuelLevel_State fuelRange:(NSArray<SDLFuelRange *>*)fuelRange gps:(SDLGPSData *)gps handsOffSteering:(BOOL)handsOffSteering headLampStatus:(SDLHeadLampStatus *)headLampStatus instantFuelConsumption:(float)instantFuelConsumption myKey:(SDLMyKey *)myKey odometer:(NSInteger)odometer prndl:(SDLPRNDL)prndl rpm:(NSInteger)rpm speed:(float)speed steeringWheelAngle:(float)steeringWheelAngle tirePressure:(SDLTireStatus *)tirePressure turnSignal:(SDLTurnSignal)turnSignal vin:(NSString *)vin wiperStatus:(SDLWiperStatus)wiperStatus;


/**
  The car current GPS coordinates

 Optional
 */
@property (strong, nonatomic, nullable) SDLGPSData *gps;

/**
 The vehicle speed in kilometers per hour

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *speed;

/**
 The number of revolutions per minute of the engine.

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *rpm;

/**
 The fuel level in the tank (percentage)

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *fuelLevel;

/**
 The fuel level state

 Optional
 */
@property (strong, nonatomic, nullable) SDLComponentVolumeStatus fuelLevel_State;

/**
 The estimate range in KM the vehicle can travel based on fuel level and consumption

 Optional, Array of length 0 - 100, of SDLFuelRange
 */
@property (strong, nonatomic, nullable) NSArray<SDLFuelRange *> *fuelRange;

/**
 The instantaneous fuel consumption in microlitres

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *instantFuelConsumption;

/**
 The external temperature in degrees celsius.

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *externalTemperature;

/**
 The Vehicle Identification Number

 Optional
 */
@property (strong, nonatomic, nullable) NSString *vin;

/**
 The current gear shift state of the user's vehicle

 Optional
 */
@property (strong, nonatomic, nullable) SDLPRNDL prndl;

/**
 The current pressure warnings for the user's vehicle

 Optional
 */
@property (strong, nonatomic, nullable) SDLTireStatus *tirePressure;

/**
 Odometer reading in km

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *odometer;

/**
 The status of the seat belts

 Optional
 */
@property (strong, nonatomic, nullable) SDLBeltStatus *beltStatus;

/**
 The body information including power modes

 Optional
 */
@property (strong, nonatomic, nullable) SDLBodyInformation *bodyInformation;

/**
 The IVI system status including signal and battery strength

 Optional
 */
@property (strong, nonatomic, nullable) SDLDeviceStatus *deviceStatus;

/**
 The status of the brake pedal

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataEventStatus driverBraking;

/**
 The status of the wipers

 Optional
 */
@property (strong, nonatomic, nullable) SDLWiperStatus wiperStatus;

/**
 Status of the head lamps

 Optional
 */
@property (strong, nonatomic, nullable) SDLHeadLampStatus *headLampStatus;

/**
 The estimated percentage (0% - 100%) of remaining oil life of the engine

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *engineOilLife;

/**
 Torque value for engine (in Nm) on non-diesel variants

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *engineTorque;

/**
 Accelerator pedal position (percentage depressed)

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *accPedalPosition;

/**
 Current angle of the steering wheel (in deg)

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *steeringWheelAngle;

/**
 Emergency Call notification and confirmation data

 Optional
 */
@property (strong, nonatomic, nullable) SDLECallInfo *eCallInfo;

/**
 The status of the air bags

 Optional
 */
@property (strong, nonatomic, nullable) SDLAirbagStatus *airbagStatus;

/**
 Information related to an emergency event (and if it occurred)

 Optional
 */
@property (strong, nonatomic, nullable) SDLEmergencyEvent *emergencyEvent;

/**
 The status modes of the cluster

 Optional
 */
@property (strong, nonatomic, nullable) SDLClusterModeStatus *clusterModeStatus;

/**
 Information related to the MyKey feature

 Optional
 */
@property (strong, nonatomic, nullable) SDLMyKey *myKey;

/**
 The status of the electronic parking brake

 Optional
 */
@property (strong, nonatomic, nullable) SDLElectronicParkBrakeStatus electronicParkBrakeStatus;

/**
 The status of the turn signal

 Optional
 */
@property (strong, nonatomic, nullable) SDLTurnSignal turnSignal;

/**
 The cloud app vehicle ID

 Optional
 */
@property (strong, nonatomic, nullable) NSString *cloudAppVehicleID;

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

/**
 * To indicate whether driver hands are off the steering wheel
 *
 * @since SDL 6.2.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *handsOffSteering;

@end

NS_ASSUME_NONNULL_END
