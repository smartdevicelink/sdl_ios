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
 * @since SDL 2.0.0
 */
@interface SDLUnsubscribeVehicleData : SDLRPCRequest

/**
 *  Convenience init for unsubscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition Unsubscribe to accelerationPedalPosition
 *  @param airbagStatus Unsubscribe to airbagStatus
 *  @param beltStatus Unsubscribe to beltStatus
 *  @param bodyInformation Unsubscribe to bodyInformation
 *  @param clusterModeStatus Unsubscribe to clusterModeStatus
 *  @param deviceStatus Unsubscribe to deviceStatus
 *  @param driverBraking Unsubscribe to driverBraking
 *  @param eCallInfo Unsubscribe to eCallInfo
 *  @param emergencyEvent Unsubscribe to emergencyEvent
 *  @param engineTorque Unsubscribe to engineTorque
 *  @param externalTemperature Unsubscribe to externalTemperature
 *  @param fuelLevel Unsubscribe to fuelLevel
 *  @param fuelLevelState Unsubscribe to fuelLevelState
 *  @param gps Unsubscribe to gps
 *  @param headLampStatus Unsubscribe to headLampStatus
 *  @param instantFuelConsumption Unsubscribe to instantFuelConsumption
 *  @param myKey Unsubscribe to myKey
 *  @param odometer Unsubscribe to odometer
 *  @param prndl Unsubscribe to prndl
 *  @param rpm Unsubscribe to rpm
 *  @param speed Unsubscribe to speed
 *  @param steeringWheelAngle Unsubscribe to steeringWheelAngle
 *  @param tirePressure Unsubscribe to tirePressure
 *  @param wiperStatus Unsubscribe to wiperStatus
 *  @return A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation: cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:windowStatus:wiperStatus: instead");

/**
 *  Convenience init for unsubscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition Unsubscribe to accelerationPedalPosition
 *  @param airbagStatus Unsubscribe to airbagStatus
 *  @param beltStatus Unsubscribe to beltStatus
 *  @param bodyInformation Unsubscribe to bodyInformation
 *  @param clusterModeStatus Unsubscribe to clusterModeStatus
 *  @param deviceStatus Unsubscribe to deviceStatus
 *  @param driverBraking Unsubscribe to driverBraking
 *  @param eCallInfo Unsubscribe to eCallInfo
 *  @param electronicParkBrakeStatus Unsubscribe to electronicParkBrakeStatus
 *  @param emergencyEvent Unsubscribe to emergencyEvent
 *  @param engineOilLife Unsubscribe to engineOilLife
 *  @param engineTorque Unsubscribe to engineTorque
 *  @param externalTemperature Unsubscribe to externalTemperature
 *  @param fuelLevel Unsubscribe to fuelLevel
 *  @param fuelLevelState Unsubscribe to fuelLevelState
 *  @param fuelRange Unsubscribe to fuelRange
 *  @param gps Unsubscribe to gps
 *  @param headLampStatus Unsubscribe to headLampStatus
 *  @param instantFuelConsumption Unsubscribe to instantFuelConsumption
 *  @param myKey Unsubscribe to myKey
 *  @param odometer Unsubscribe to odometer
 *  @param prndl Unsubscribe to prndl
 *  @param rpm Unsubscribe to rpm
 *  @param speed Unsubscribe to speed
 *  @param steeringWheelAngle Unsubscribe to steeringWheelAngle
 *  @param tirePressure Unsubscribe to tirePressure
 *  @param turnSignal Unsubscribe to turnSignal
 *  @param wiperStatus Unsubscribe to wiperStatus
 *  @return A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation: cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:windowStatus:wiperStatus: instead");

/**
 *  Convenience init for unsubscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition Unsubscribe to accelerationPedalPosition
 *  @param airbagStatus Unsubscribe to airbagStatus
 *  @param beltStatus Unsubscribe to beltStatus
 *  @param bodyInformation Unsubscribe to bodyInformation
 *  @param cloudAppVehicleID Unsubscribe to cloudAppVehicleID
 *  @param clusterModeStatus Unsubscribe to clusterModeStatus
 *  @param deviceStatus Unsubscribe to deviceStatus
 *  @param driverBraking Unsubscribe to driverBraking
 *  @param eCallInfo Unsubscribe to eCallInfo
 *  @param electronicParkBrakeStatus Unsubscribe to electronicParkBrakeStatus
 *  @param emergencyEvent Unsubscribe to emergencyEvent
 *  @param engineOilLife Unsubscribe to engineOilLife
 *  @param engineTorque Unsubscribe to engineTorque
 *  @param externalTemperature Unsubscribe to externalTemperature
 *  @param fuelLevel Unsubscribe to fuelLevel
 *  @param fuelLevelState Unsubscribe to fuelLevelState
 *  @param fuelRange Unsubscribe to fuelRange
 *  @param gps Unsubscribe to gps
 *  @param headLampStatus Unsubscribe to headLampStatus
 *  @param instantFuelConsumption Unsubscribe to instantFuelConsumption
 *  @param myKey Unsubscribe to myKey
 *  @param odometer Unsubscribe to odometer
 *  @param prndl Unsubscribe to prndl
 *  @param rpm Unsubscribe to rpm
 *  @param speed Unsubscribe to speed
 *  @param steeringWheelAngle Unsubscribe to steeringWheelAngle
 *  @param tirePressure Unsubscribe to tirePressure
 *  @param turnSignal Unsubscribe to turnSignal
 *  @param wiperStatus Unsubscribe to wiperStatus
 *  @return A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation  cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation: cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:windowStatus:wiperStatus: instead");

/**
 *  Convenience init for unsubscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition Unsubscribe to accelerationPedalPosition
 *  @param airbagStatus Unsubscribe to airbagStatus
 *  @param beltStatus Unsubscribe to beltStatus
 *  @param bodyInformation Unsubscribe to bodyInformation
 *  @param cloudAppVehicleID Unsubscribe to cloudAppVehicleID
 *  @param clusterModeStatus Unsubscribe to clusterModeStatus
 *  @param deviceStatus Unsubscribe to deviceStatus
 *  @param driverBraking Unsubscribe to driverBraking
 *  @param eCallInfo Unsubscribe to eCallInfo
 *  @param electronicParkBrakeStatus Unsubscribe to electronicParkBrakeStatus
 *  @param emergencyEvent Unsubscribe to emergencyEvent
 *  @param engineOilLife Unsubscribe to engineOilLife
 *  @param engineTorque Unsubscribe to engineTorque
 *  @param externalTemperature Unsubscribe to externalTemperature
 *  @param fuelLevel Unsubscribe to fuelLevel
 *  @param fuelLevelState Unsubscribe to fuelLevelState
 *  @param fuelRange Unsubscribe to fuelRange
 *  @param gps Unsubscribe to gps
 *  @param headLampStatus Unsubscribe to headLampStatus
 *  @param instantFuelConsumption Unsubscribe to instantFuelConsumption
 *  @param myKey Unsubscribe to myKey
 *  @param odometer Unsubscribe to odometer
 *  @param prndl Unsubscribe to prndl
 *  @param rpm Unsubscribe to rpm
 *  @param speed Unsubscribe to speed
 *  @param steeringWheelAngle Unsubscribe to steeringWheelAngle
 *  @param tirePressure Unsubscribe to tirePressure
 *  @param turnSignal Unsubscribe to turnSignal
 *  @param windowStatus Unsubscribe from windowStatus
 *  @param wiperStatus Unsubscribe to wiperStatus
 *  @return A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation  cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal windowStatus:(BOOL)windowStatus wiperStatus:(BOOL)wiperStatus;

/**
 * note: RPC generator produced initializer
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
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @param windowStatus - windowStatus
 * @return A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm fuelLevel:(nullable NSNumber<SDLBool> *)fuelLevel fuelLevel_State:(nullable NSNumber<SDLBool> *)fuelLevel_State instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange externalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature turnSignal:(nullable NSNumber<SDLBool> *)turnSignal prndl:(nullable NSNumber<SDLBool> *)prndl tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey windowStatus:(nullable NSNumber<SDLBool> *)windowStatus;

/**
 * If true, unsubscribes from Acc Pedal Position
 *
 * Optional.
*/
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *accPedalPosition;

/**
 * If true, unsubscribes from Airbag Status
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *airbagStatus;

/**
 * If true, unsubscribes from Belt Status
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *beltStatus;

/**
 * If true, unsubscribes from Body Information
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *bodyInformation;

/**
 A boolean value. If true, unsubscribes to the Cloud App Vehicle ID

 Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *cloudAppVehicleID;

/**
 * If true, unsubscribes from Cluster Mode Status
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *clusterModeStatus;

/**
 * If true, unsubscribes from Device Status
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *deviceStatus;

/**
 * If true, unsubscribes from Driver Braking
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *driverBraking;

/**
 * If true, unsubscribes from eCallInfo
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *eCallInfo;

/**
 A boolean value. If true, unsubscribes to the Electronic Parking Brake Status

 Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 * If true, unsubscribes from Emergency Event
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *emergencyEvent;

/**
 * If true, unsubscribes from Engine Oil Life
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineOilLife;

/**
 * If true, unsubscribes from Engine Torque
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineTorque;

/**
 * If true, unsubscribes from External Temperature
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *externalTemperature;

/**
 * If true, unsubscribes from Fuel Level
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel;

/**
 * If true, unsubscribes from Fuel Level State
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State;

/**
 * If true, unsubscribes from Fuel Range
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelRange;

/**
 * If true, unsubscribes from GPS
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gps;

/**
 * If true, unsubscribes from Head Lamp Status
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *headLampStatus;

/**
 * If true, unsubscribes from Instant Fuel Consumption
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * If true, unsubscribes from My Key
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *myKey;

/**
 * If true, unsubscribes from Odometer
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *odometer;

/**
 * If true, unsubscribes from PRNDL
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl;

/**
 * If true, unsubscribes from RPM
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *rpm;

/**
 * If true, unsubscribes from Speed
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *speed;

/**
 * If true, unsubscribes from Steering Wheel Angle data
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * If true, unsubscribes from Tire Pressure
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *tirePressure;

/**
 A boolean value. If true, unsubscribes to the Turn Signal

 Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *turnSignal;

/**
 * See WindowStatus
 *
 * Optional.
 *
 * @since SDL 7.0.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *windowStatus;

/**
 * If true, unsubscribes from Wiper Status
 *
 * Optional.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *wiperStatus;

/**
 Sets the OEM custom vehicle data state for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @param vehicleDataState A boolean value.  If true, requests an unsubscribes of the OEM custom vehicle data item.

  Added SmartDeviceLink 6.0
 */
- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(BOOL)vehicleDataState NS_SWIFT_NAME(setOEMCustomVehicleData(name:state:));

/**
 Gets the OEM custom vehicle data state for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item to unsubscribe for.
 @return A boolean value indicating if an unsubscribe request will occur for the OEM custom vehicle data item.

  Added SmartDeviceLink 6.0
 */
- (nullable NSNumber<SDLBool> *)getOEMCustomVehicleData:(NSString *)vehicleDataName;

@end

NS_ASSUME_NONNULL_END
