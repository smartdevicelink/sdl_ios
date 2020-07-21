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
 * @since SDL 2.0.0
 */
@interface SDLSubscribeVehicleDataResponse : SDLRPCResponse

/**
 * Convenience initializer, initializes a new allocated object of the class SDLSubscribeVehicleDataResponse
 *
 * @paramn accPedalPosition The result of requesting to subscribe to the accelerator pedal position (percentage depressed), optional
 * @param airbagStatus The result of requesting to subscribe to the airbag status, optional
 * @param beltStatus The result of requesting to subscribe to the status of the seat belts., optional
 * @param bodyInformation The result of requesting to subscribe to the body information including power modes., optional
 * @param cloudAppVehicleID The result of requesting to subscribe to the cloud app vehicle ID, optional
 * @param clusterModes The result of requesting to subscribe to the cluster modes, optional
 * @param deviceStatus The result of requesting to subscribe to the device status including signal and battery strength., optional
 * @param driverBraking The result of requesting to subscribe to the status of the brake pedal., optional
 * @param eCallInfo The result of requesting to subscribe to the emergency call info, optional
 * @param electronicParkBrakeStatus The result of requesting to subscribe to the electronic parking brake status, optional
 * @param emergencyEvent The result of requesting to subscribe to the emergency event, optional
 * @param engineOilLife The result of requesting to subscribe to the estimated percentage of remaining oil life of the engine., optional
 * @param engineTorque The result of requesting to subscribe to the torque value for engine (in Nm) on non-diesel variants., optional
 * @param externalTemperature The result of requesting to subscribe to the external temperature in degrees celsius., optional
 * @param fuelLevel The result of requesting to subscribe to the fuel level in the tank (percentage), optional
 * @param fuelLevel_State The result of requesting to subscribe to the fuel level state., optional
 * @param fuelRange The result of requesting to subscribe to the fuel range., optional
 * @param gps The result of requesting to subscribe to the GPSData., optional
 * @param handsOffSteering To indicate whether driver hands are off the steering wheel, optional
 * @param headLampStatus The result of requesting to subscribe to the status of the head lamps., optional
 * @param instantFuelConsumption The result of requesting to subscribe to the instantaneous fuel consumption in microlitres., optional
 * @param myKey The result of requesting to subscribe to the myKey status, optional
 * @param odometer The result of requesting to subscribe to the odometer in km., optional
 * @param prndl The result of requesting to subscribe to the PRNDL status., optional
 * @param rpm The result of requesting to subscribe to the number of revolutions per minute of the engine., optional
 * @param speed The result of requesting to subscribe to the vehicle speed in kilometers per hour., optional
 * @param steeringWheelAngle The result of requesting to subscribe to the current angle of the steering wheel (in deg), optional
 * @param tirePressure The result of requesting to subscribe to the tireStatus., optional
 * @param turnSignal The result of requesting to subscribe to the turn signal, optional
 * @param wiperStatus The result of requesting to subscribe to the status of the wipers., optional
 *
 * @return an initialized objectof the class SDLSubscribeVehicleDataResponse
 */

- (nullable instancetype)initWithAccPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition
                                     airbagStatus:(nullable SDLVehicleDataResult *)airbagStatus
                                       beltStatus:(nullable SDLVehicleDataResult *)beltStatus
                                  bodyInformation:(nullable SDLVehicleDataResult *)bodyInformation
                                cloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID
                                     clusterModes:(nullable SDLVehicleDataResult *)clusterModes
                                     deviceStatus:(nullable SDLVehicleDataResult *)deviceStatus
                                    driverBraking:(nullable SDLVehicleDataResult *)driverBraking
                                        eCallInfo:(nullable SDLVehicleDataResult *)eCallInfo
                        electronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus
                                   emergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent
                                    engineOilLife:(nullable SDLVehicleDataResult *)engineOilLife
                                     engineTorque:(nullable SDLVehicleDataResult *)engineTorque
                              externalTemperature:(nullable SDLVehicleDataResult *)externalTemperature
                                        fuelLevel:(nullable SDLVehicleDataResult *)fuelLevel
                                  fuelLevel_State:(nullable SDLVehicleDataResult *)fuelLevel_State
                                        fuelRange:(nullable SDLVehicleDataResult *)fuelRange
                                              gps:(nullable SDLVehicleDataResult *)gps
                                 handsOffSteering:(nullable SDLVehicleDataResult *)handsOffSteering
                                   headLampStatus:(nullable SDLVehicleDataResult *)headLampStatus
                           instantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption
                                            myKey:(nullable SDLVehicleDataResult *)myKey
                                         odometer:(nullable SDLVehicleDataResult *)odometer
                                            prndl:(nullable SDLVehicleDataResult *)prndl
                                              rpm:(nullable SDLVehicleDataResult *)rpm
                                            speed:(nullable SDLVehicleDataResult *)speed
                               steeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle
                                     tirePressure:(nullable SDLVehicleDataResult *)tirePressure
                                       turnSignal:(nullable SDLVehicleDataResult *)turnSignal
                                      wiperStatus:(nullable SDLVehicleDataResult *)wiperStatus;

/**
 * note: auto generated initializer in comparision with the manually created one (see above)
 * @param gps - gps
 * @param speed - speed
 * @param rpm - rpm
 * @param fuelLevel - fuelLevel
 * @param fuelLevel_State - fuelLevel_State
 * @param instantFuelConsumption - instantFuelConsumption
 * @param fuelRange - fuelRange
 * @param externalTemperature - externalTemperature
 * @param turnSignal - turnSignal
 * @param prndl - prndl
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
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModes - clusterModes
 * @param myKey - myKey
 * @param handsOffSteering - handsOffSteering
 * @return A SDLSubscribeVehicleDataResponse object
 */
- (instancetype)initWithGps:(nullable SDLVehicleDataResult *)gps speed:(nullable SDLVehicleDataResult *)speed rpm:(nullable SDLVehicleDataResult *)rpm fuelLevel:(nullable SDLVehicleDataResult *)fuelLevel fuelLevel_State:(nullable SDLVehicleDataResult *)fuelLevel_State instantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption fuelRange:(nullable SDLVehicleDataResult *)fuelRange externalTemperature:(nullable SDLVehicleDataResult *)externalTemperature turnSignal:(nullable SDLVehicleDataResult *)turnSignal prndl:(nullable SDLVehicleDataResult *)prndl tirePressure:(nullable SDLVehicleDataResult *)tirePressure odometer:(nullable SDLVehicleDataResult *)odometer beltStatus:(nullable SDLVehicleDataResult *)beltStatus bodyInformation:(nullable SDLVehicleDataResult *)bodyInformation deviceStatus:(nullable SDLVehicleDataResult *)deviceStatus driverBraking:(nullable SDLVehicleDataResult *)driverBraking wiperStatus:(nullable SDLVehicleDataResult *)wiperStatus headLampStatus:(nullable SDLVehicleDataResult *)headLampStatus engineTorque:(nullable SDLVehicleDataResult *)engineTorque accPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition steeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle engineOilLife:(nullable SDLVehicleDataResult *)engineOilLife electronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus cloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID eCallInfo:(nullable SDLVehicleDataResult *)eCallInfo airbagStatus:(nullable SDLVehicleDataResult *)airbagStatus emergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent clusterModes:(nullable SDLVehicleDataResult *)clusterModes myKey:(nullable SDLVehicleDataResult *)myKey handsOffSteering:(nullable SDLVehicleDataResult *)handsOffSteering;

/**
 The result of requesting to subscribe to the GPSData.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *gps;

/**
 The result of requesting to subscribe to the vehicle speed in kilometers per hour.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *speed;

/**
 The result of requesting to subscribe to the number of revolutions per minute of the engine.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *rpm;

/**
 The result of requesting to subscribe to the fuel level in the tank (percentage)

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelLevel;

/**
 The result of requesting to subscribe to the fuel level state.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelLevel_State;

/**
 The result of requesting to subscribe to the fuel range.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelRange;

/**
 The result of requesting to subscribe to the instantaneous fuel consumption in microlitres.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *instantFuelConsumption;

/**
 The result of requesting to subscribe to the external temperature in degrees celsius.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *externalTemperature;

/**
 The result of requesting to subscribe to the PRNDL status.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *prndl;

/**
 The result of requesting to subscribe to the tireStatus.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *tirePressure;

/**
 The result of requesting to subscribe to the odometer in km.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *odometer;

/**
 The result of requesting to subscribe to the status of the seat belts.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *beltStatus;

/**
 The result of requesting to subscribe to the body information including power modes.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *bodyInformation;

/**
 The result of requesting to subscribe to the device status including signal and battery strength.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *deviceStatus;

/**
 The result of requesting to subscribe to the status of the brake pedal.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *driverBraking;

/**
 The result of requesting to subscribe to the status of the wipers.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *wiperStatus;

/**
 The result of requesting to subscribe to the status of the head lamps.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *headLampStatus;

/**
 The result of requesting to subscribe to the estimated percentage of remaining oil life of the engine.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *engineOilLife;

/**
 The result of requesting to subscribe to the torque value for engine (in Nm) on non-diesel variants.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *engineTorque;

/**
 The result of requesting to subscribe to the accelerator pedal position (percentage depressed)

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *accPedalPosition;

/**
 The result of requesting to subscribe to the current angle of the steering wheel (in deg)

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *steeringWheelAngle;

/**
 The result of requesting to subscribe to the emergency call info

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *eCallInfo;

/**
 The result of requesting to subscribe to the airbag status

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *airbagStatus;

/**
 The result of requesting to subscribe to the emergency event

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *emergencyEvent;

/**
 The result of requesting to subscribe to the cluster modes

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *clusterModes;

/**
 The result of requesting to subscribe to the myKey status

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *myKey;

/**
 The result of requesting to subscribe to the electronic parking brake status

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *electronicParkBrakeStatus;

/**
 The result of requesting to subscribe to the turn signal

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *turnSignal;

/**
 The result of requesting to subscribe to the cloud app vehicle ID

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *cloudAppVehicleID;

/**
 Sets the OEM custom vehicle data state for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @param vehicleDataState SDLVehicleDataResult object containing custom data type and result code information.

  Added SmartDeviceLink 6.0
 */
- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(SDLVehicleDataResult *)vehicleDataState NS_SWIFT_NAME(setOEMCustomVehicleData(name:state:));

/**
 Gets the OEM custom vehicle data state for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @return SDLVehicleDataResult An object containing custom data type and result code information.

  Added SmartDeviceLink 6.0
 */
- (nullable SDLVehicleDataResult *)getOEMCustomVehicleData:(NSString *)vehicleDataName;

/**
 * To indicate whether driver hands are off the steering wheel
 *
 * Optional.
 *
 * @since SDL 6.2.0
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *handsOffSteering;

@end

NS_ASSUME_NONNULL_END
