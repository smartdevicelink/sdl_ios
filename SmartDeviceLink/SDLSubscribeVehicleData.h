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
 * Subscribes for specific published data items. The data will be only sent if it has changed. The application will
 * be notified by the onVehicleData notification whenever new data is available. To unsubscribe the notifications,
 * use unsubscribe with the same subscriptionType.
 *
 * @since SDL 2.0.0
 */
@interface SDLSubscribeVehicleData : SDLRPCRequest

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition Subscribe to accelerationPedalPosition
 *  @param airbagStatus Subscribe to airbagStatus
 *  @param beltStatus Subscribe to beltStatus
 *  @param bodyInformation Subscribe to bodyInformation
 *  @param clusterModeStatus Subscribe to clusterModeStatus
 *  @param deviceStatus Subscribe to deviceStatus
 *  @param driverBraking Subscribe to driverBraking
 *  @param eCallInfo Subscribe to eCallInfo
 *  @param emergencyEvent Subscribe to emergencyEvent
 *  @param engineTorque Subscribe to engineTorque
 *  @param externalTemperature Subscribe to externalTemperature
 *  @param fuelLevel Subscribe to fuelLevel
 *  @param fuelLevelState Subscribe to fuelLevelState
 *  @param gps Subscribe to gps
 *  @param headLampStatus Subscribe to headLampStatus
 *  @param instantFuelConsumption Subscribe to instantFuelConsumption
 *  @param myKey Subscribe to myKey
 *  @param odometer Subscribe to odometer
 *  @param prndl Subscribe to prndl
 *  @param rpm Subscribe to rpm
 *  @param speed Subscribe to speed
 *  @param steeringWheelAngle Subscribe to steeringWheelAngle
 *  @param tirePressure Subscribe to tirePressure
 *  @param wiperStatus Subscribe to wiperStatus
 *  @return A SDLSubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithGps:(nullable NSNumber<SDLBool> *)gps speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:stabilityControlsStatus:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey: instead");

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition Subscribe to accelerationPedalPosition
 *  @param airbagStatus Subscribe to airbagStatus
 *  @param beltStatus Subscribe to beltStatus
 *  @param bodyInformation Subscribe to bodyInformation
 *  @param clusterModeStatus Subscribe to clusterModeStatus
 *  @param deviceStatus Subscribe to deviceStatus
 *  @param driverBraking Subscribe to driverBraking
 *  @param eCallInfo Subscribe to eCallInfo
 *  @param electronicParkBrakeStatus Subscribe to electronicParkBrakeStatus
 *  @param emergencyEvent Subscribe to emergencyEvent
 *  @param engineOilLife Subscribe to engineOilLife
 *  @param engineTorque Subscribe to engineTorque
 *  @param externalTemperature Subscribe to externalTemperature
 *  @param fuelLevel Subscribe to fuelLevel
 *  @param fuelLevelState Subscribe to fuelLevelState
 *  @param fuelRange Subscribe to fuelRange
 *  @param gps Subscribe to gps
 *  @param headLampStatus Subscribe to headLampStatus
 *  @param instantFuelConsumption Subscribe to instantFuelConsumption
 *  @param myKey Subscribe to myKey
 *  @param odometer Subscribe to odometer
 *  @param prndl Subscribe to prndl
 *  @param rpm Subscribe to rpm
 *  @param speed Subscribe to speed
 *  @param steeringWheelAngle Subscribe to steeringWheelAngle
 *  @param tirePressure Subscribe to tirePressure
 *  @param turnSignal Subscribe to turnSignal
 *  @param wiperStatus Subscribe to wiperStatus
 *  @return A SDLSubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithGps:(nullable NSNumber<SDLBool> *)gps speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:stabilityControlsStatus:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey: instead");

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition Subscribe to accelerationPedalPosition
 *  @param airbagStatus Subscribe to airbagStatus
 *  @param beltStatus Subscribe to beltStatus
 *  @param bodyInformation Subscribe to bodyInformation
 *  @param cloudAppVehicleID Subscribe to cloudAppVehicleID
 *  @param clusterModeStatus Subscribe to clusterModeStatus
 *  @param deviceStatus Subscribe to deviceStatus
 *  @param driverBraking Subscribe to driverBraking
 *  @param eCallInfo Subscribe to eCallInfo
 *  @param electronicParkBrakeStatus Subscribe to electronicParkBrakeStatus
 *  @param emergencyEvent Subscribe to emergencyEvent
 *  @param engineOilLife Subscribe to engineOilLife
 *  @param engineTorque Subscribe to engineTorque
 *  @param externalTemperature Subscribe to externalTemperature
 *  @param fuelLevel Subscribe to fuelLevel
 *  @param fuelLevelState Subscribe to fuelLevelState
 *  @param fuelRange Subscribe to fuelRange
 *  @param gps Subscribe to gps
 *  @param headLampStatus Subscribe to headLampStatus
 *  @param instantFuelConsumption Subscribe to instantFuelConsumption
 *  @param myKey Subscribe to myKey
 *  @param odometer Subscribe to odometer
 *  @param prndl Subscribe to prndl
 *  @param rpm Subscribe to rpm
 *  @param speed Subscribe to speed
 *  @param steeringWheelAngle Subscribe to steeringWheelAngle
 *  @param tirePressure Subscribe to tirePressure
 *  @param turnSignal Subscribe to turnSignal
 *  @param wiperStatus Subscribe to wiperStatus
 *  @return A SDLSubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithGps:(nullable NSNumber<SDLBool> *)gps speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:stabilityControlsStatus:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey: instead");

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
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
 * @param stabilityControlsStatus - stabilityControlsStatus
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @return A SDLSubscribeVehicleData object
 */
- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm fuelLevel:(nullable NSNumber<SDLBool> *)fuelLevel fuelLevel_State:(nullable NSNumber<SDLBool> *)fuelLevel_State instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange externalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature turnSignal:(nullable NSNumber<SDLBool> *)turnSignal prndl:(nullable NSNumber<SDLBool> *)prndl tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID stabilityControlsStatus:(nullable NSNumber<SDLBool> *)stabilityControlsStatus eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey;

/**
 * A boolean value. If true, subscribes Acc Pedal Position data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *accPedalPosition;

/**
 * A boolean value. If true, subscribes Airbag Status data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *airbagStatus;

/**
 * A boolean value. If true, subscribes Belt Status data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, subscribes Body Information data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, subscribes to the cloud app vehicle ID.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *cloudAppVehicleID;

/**
 * A boolean value. If true, subscribes Cluster Mode Status data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *clusterModeStatus;

/**
 * A boolean value. If true, subscribes Device Status data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, subscribes Driver Braking data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverBraking;

/**
 * A boolean value. If true, subscribes eCall Info data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *eCallInfo;

/**
 * A boolean value. If true, subscribes to the electronic parking brake status.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 * A boolean value. If true, subscribes Emergency Event data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *emergencyEvent;

/**
 * A boolean value. If true, subscribes to Engine Oil Life data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *engineOilLife;

/**
 * A boolean value. If true, subscribes Engine Torque data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, subscribes External Temperature data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *externalTemperature;

/**
 * A boolean value. If true, subscribes Fuel Level data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel;

/**
 * A boolean value. If true, subscribes Fuel Level State data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel_State;

/**
 * A boolean value. If true, subscribes Fuel Range data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelRange;

/**
 * A boolean value. If true, subscribes GPS data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, subscribes Head Lamp Status data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, subscribes Instant Fuel Consumption data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * A boolean value. If true, subscribes myKey data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *myKey;

/**
 * A boolean value. If true, subscribes Odometer data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, subscribes PRNDL data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *prndl;

/**
 * A boolean value. If true, subscribes RPM data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, subscribes Speed data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *speed;

/**
 * See StabilityControlsStatus
 *
 * Optional.
 *
 * @since SDL 7.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *stabilityControlsStatus;

/**
 * A boolean value. If true, subscribes Steering Wheel Angle data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * A boolean value. If true, subscribes Tire Pressure status data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, subscribes to the turn signal status.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *turnSignal;

/**
 * A boolean value. If true, subscribes Wiper Status data.
 *
 * Optional.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *wiperStatus;

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

@end

NS_ASSUME_NONNULL_END
