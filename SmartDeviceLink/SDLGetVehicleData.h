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
 * Non periodic vehicle data read request.
 *
 * @since SDL 2.0.0
 */
@interface SDLGetVehicleData : SDLRPCRequest

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition  Get accelerationPedalPosition data
 *  @param airbagStatus  Get airbagStatus data
 *  @param beltStatus  Get beltStatus data
 *  @param bodyInformation  Get bodyInformation data
 *  @param clusterModeStatus  Get clusterModeStatus data
 *  @param deviceStatus  Get deviceStatus data
 *  @param driverBraking  Get driverBraking data
 *  @param eCallInfo  Get eCallInfo data
 *  @param emergencyEvent  Get emergencyEvent data
 *  @param engineTorque  Get engineTorque data
 *  @param externalTemperature  Get externalTemperature data
 *  @param fuelLevel  Get fuelLevel data
 *  @param fuelLevelState  Get fuelLevelState data
 *  @param gps  Get gps data
 *  @param headLampStatus  Get headLampStatus data
 *  @param instantFuelConsumption  Get instantFuelConsumption data
 *  @param myKey  Get myKey data
 *  @param odometer  Get odometer data
 *  @param prndl  Get prndl data
 *  @param rpm  Get rpm data
 *  @param speed  Get speed data
 *  @param steeringWheelAngle  Get steeringWheelAngle data
 *  @param tirePressure  Get tirePressure data
 *  @param vin  Get vin data
 *  @param wiperStatus  Get wiperStatus data
 *  @returnA SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus:windowStatus: instead");

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition  Get accelerationPedalPosition data
 *  @param airbagStatus  Get airbagStatus data
 *  @param beltStatus  Get beltStatus data
 *  @param bodyInformation  Get bodyInformation data
 *  @param clusterModeStatus  Get clusterModeStatus data
 *  @param deviceStatus  Get deviceStatus data
 *  @param driverBraking  Get driverBraking data
 *  @param eCallInfo  Get eCallInfo data
 *  @param electronicParkBrakeStatus  Get electronicParkBrakeStatus data
 *  @param emergencyEvent  Get emergencyEvent data
 *  @param engineOilLife  Get engineOilLife data
 *  @param engineTorque  Get engineTorque data
 *  @param externalTemperature  Get externalTemperature data
 *  @param fuelLevel  Get fuelLevel data
 *  @param fuelLevelState  Get fuelLevelState data
 *  @param fuelRange  Get fuelRange data
 *  @param gps  Get gps data
 *  @param headLampStatus  Get headLampStatus data
 *  @param instantFuelConsumption  Get instantFuelConsumption data
 *  @param myKey  Get myKey data
 *  @param odometer  Get odometer data
 *  @param prndl  Get prndl data
 *  @param rpm  Get rpm data
 *  @param speed  Get speed data
 *  @param steeringWheelAngle  Get steeringWheelAngle data
 *  @param tirePressure  Get tirePressure data
 *  @param turnSignal  Get turnSignal data
 *  @param vin  Get vin data
 *  @param wiperStatus  Get wiperStatus data
 *  @return A SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus:windowStatus: instead");

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition  Get accelerationPedalPosition data
 *  @param airbagStatus  Get airbagStatus data
 *  @param beltStatus  Get beltStatus data
 *  @param bodyInformation  Get bodyInformation data
 *  @param cloudAppVehicleID  Get cloudAppVehicleID data
 *  @param clusterModeStatus  Get clusterModeStatus data
 *  @param deviceStatus  Get deviceStatus data
 *  @param driverBraking  Get driverBraking data
 *  @param eCallInfo  Get eCallInfo data
 *  @param electronicParkBrakeStatus  Get electronicParkBrakeStatus data
 *  @param emergencyEvent  Get emergencyEvent data
 *  @param engineOilLife  Get engineOilLife data
 *  @param engineTorque  Get engineTorque data
 *  @param externalTemperature  Get externalTemperature data
 *  @param fuelLevel  Get fuelLevel data
 *  @param fuelLevelState  Get fuelLevelState data
 *  @param fuelRange  Get fuelRange data
 *  @param gps  Get gps data
 *  @param headLampStatus  Get headLampStatus data
 *  @param instantFuelConsumption  Get instantFuelConsumption data
 *  @param myKey  Get myKey data
 *  @param odometer  Get odometer data
 *  @param prndl  Get prndl data
 *  @param rpm  Get rpm data
 *  @param speed  Get speed data
 *  @param steeringWheelAngle  Get steeringWheelAngle data
 *  @param tirePressure  Get tirePressure data
 *  @param turnSignal  Get turnSignal data
 *  @param vin  Get vin data
 *  @param wiperStatus  Get wiperStatus data
 *  @return A SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus:windowStatus: instead");

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition  Get accelerationPedalPosition data
 *  @param airbagStatus  Get airbagStatus data
 *  @param beltStatus  Get beltStatus data
 *  @param bodyInformation  Get bodyInformation data
 *  @param cloudAppVehicleID  Get cloudAppVehicleID data
 *  @param clusterModeStatus  Get clusterModeStatus data
 *  @param deviceStatus  Get deviceStatus data
 *  @param driverBraking  Get driverBraking data
 *  @param eCallInfo  Get eCallInfo data
 *  @param electronicParkBrakeStatus  Get electronicParkBrakeStatus data
 *  @param emergencyEvent  Get emergencyEvent data
 *  @param engineOilLife  Get engineOilLife data
 *  @param engineTorque  Get engineTorque data
 *  @param externalTemperature  Get externalTemperature data
 *  @param fuelLevel  Get fuelLevel data
 *  @param fuelLevelState  Get fuelLevelState data
 *  @param fuelRange  Get fuelRange data
 *  @param gps  Get gps data
 *  @param headLampStatus  Get headLampStatus data
 *  @param instantFuelConsumption  Get instantFuelConsumption data
 *  @param myKey  Get myKey data
 *  @param odometer  Get odometer data
 *  @param prndl  Get prndl data
 *  @param rpm  Get rpm data
 *  @param speed  Get speed data
 *  @param steeringWheelAngle  Get steeringWheelAngle data
 *  @param tirePressure  Get tirePressure data
 *  @param turnSignal  Get turnSignal data
 *  @param vin  Get vin data
 *  @param wiperStatus  Get wiperStatus data
 *  @param windowStatus  Get windowStatus data
 *  @return A SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus windowStatus:(BOOL)windowStatus;

/**
 * A boolean value. If true, requests GPS data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, requests Speed data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *speed;

/**
 * A boolean value. If true, requests RPM data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, requests Fuel Level data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel;

/**
 * A boolean value. If true, requests Fuel Level State data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State;

/**
 * A boolean value. If true, requests Fuel Range data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelRange;

/**
 * A boolean value. If true, requests Instant Fuel Consumption data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * A boolean value. If true, requests External Temperature data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *externalTemperature;

/**
 * A boolean value. If true, requests the Vehicle Identification Number.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *vin;

/**
 * A boolean value. If true, requests PRNDL data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl;

/**
 * A boolean value. If true, requests Tire Pressure data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, requests Odometer data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, requests Belt Status data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, requests Body Information data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, requests Device Status data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, requests Driver Braking data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *driverBraking;

/**
 * A boolean value. If true, requests Wiper Status data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *wiperStatus;

/**
 * A boolean value. If true, requests Head Lamp Status data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, requests Engine Oil Life data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineOilLife;

/**
 * A boolean value. If true, requests Engine Torque data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, requests Acc Pedal Position data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *accPedalPosition;

/**
 * A boolean value. If true, requests Steering Wheel Angle data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * A boolean value. If true, requests Emergency Call Info data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *eCallInfo;

/**
 * A boolean value. If true, requests Air Bag Status data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *airbagStatus;

/**
 * A boolean value. If true, requests Emergency Event (if it occurred) data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *emergencyEvent;

/**
 * A boolean value. If true, requests Cluster Mode Status data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *clusterModeStatus;

/**
 * A boolean value. If true, requests MyKey data.
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *myKey;

/**
 A boolean value. If true, requests Electronic Parking Brake status data.

 Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 A boolean value. If true, requests Turn Signal data.

 Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *turnSignal;

/**
 A boolean value. If true, requests the Cloud App Vehicle ID.

 Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *cloudAppVehicleID;

/**
 Sets the OEM custom vehicle data state for any given OEM custom vehicle data name.

 @param vehicleDataName The name of the OEM custom vehicle data item.
 @param vehicleDataState A boolean value.  If true, requests the OEM custom vehicle data item.

  Added in SmartDeviceLink 6.0
 */
- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(BOOL)vehicleDataState NS_SWIFT_NAME(setOEMCustomVehicleData(name:state:));

/**
 Gets the OEM custom vehicle data value for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @return The state of an OEM custom vehicle data item for the given vehicle data name.

  Added in SmartDeviceLink 6.0
 */
- (nullable NSNumber<SDLBool> *)getOEMCustomVehicleData:(NSString *)vehicleDataName;

/**
 * See WindowStatus
 *
 * Optional.
 *
 * @since SDL 6.2.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *windowStatus;

@end

NS_ASSUME_NONNULL_END
