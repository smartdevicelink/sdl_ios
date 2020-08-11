//  SDLSubscribeVehicleData.h
//


#import "SDLRPCRequest.h"

/**
 *  Subscribes to specific published vehicle data items. The data will be only sent if it has changed. The application will be notified by the `onVehicleData` notification whenever new data is available. The update rate is dependent on sensors, vehicle architecture and vehicle type.
 *
 *  @warning A vehicle may only support a subset of the vehicle data items. Be prepared for the situation where a signal is not available on a vehicle.
 *
 *  Function Group: Location, VehicleInfo and DrivingChara
 *  HMILevel needs to be FULL, LIMITED or BACKGROUND
 *  Since SmartDeviceLink 2.0
 *  See SDLUnsubscribeVehicleData, SDLGetVehicleData
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSubscribeVehicleData : SDLRPCRequest

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition    Subscribe to accelerationPedalPosition
 *  @param airbagStatus                 Subscribe to airbagStatus
 *  @param beltStatus                   Subscribe to beltStatus
 *  @param bodyInformation              Subscribe to bodyInformation
 *  @param clusterModeStatus            Subscribe to clusterModeStatus
 *  @param deviceStatus                 Subscribe to deviceStatus
 *  @param driverBraking                Subscribe to driverBraking
 *  @param eCallInfo                    Subscribe to eCallInfo
 *  @param emergencyEvent               Subscribe to emergencyEvent
 *  @param engineTorque                 Subscribe to engineTorque
 *  @param externalTemperature          Subscribe to externalTemperature
 *  @param fuelLevel                    Subscribe to fuelLevel
 *  @param fuelLevelState               Subscribe to fuelLevelState
 *  @param gps                          Subscribe to gps
 *  @param headLampStatus               Subscribe to headLampStatus
 *  @param instantFuelConsumption       Subscribe to instantFuelConsumption
 *  @param myKey                        Subscribe to myKey
 *  @param odometer                     Subscribe to odometer
 *  @param prndl                        Subscribe to prndl
 *  @param rpm                          Subscribe to rpm
 *  @param speed                        Subscribe to speed
 *  @param steeringWheelAngle           Subscribe to steeringWheelAngle
 *  @param tirePressure                 Subscribe to tirePressure
 *  @param wiperStatus                  Subscribe to wiperStatus
 *  @return                             A SDLSubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithGps:speed:rpm:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:gearStatus:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:handsOffSteering: instead");

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition    Subscribe to accelerationPedalPosition
 *  @param airbagStatus                 Subscribe to airbagStatus
 *  @param beltStatus                   Subscribe to beltStatus
 *  @param bodyInformation              Subscribe to bodyInformation
 *  @param clusterModeStatus            Subscribe to clusterModeStatus
 *  @param deviceStatus                 Subscribe to deviceStatus
 *  @param driverBraking                Subscribe to driverBraking
 *  @param eCallInfo                    Subscribe to eCallInfo
 *  @param electronicParkBrakeStatus    Subscribe to electronicParkBrakeStatus
 *  @param emergencyEvent               Subscribe to emergencyEvent
 *  @param engineOilLife                Subscribe to engineOilLife
 *  @param engineTorque                 Subscribe to engineTorque
 *  @param externalTemperature          Subscribe to externalTemperature
 *  @param fuelLevel                    Subscribe to fuelLevel
 *  @param fuelLevelState               Subscribe to fuelLevelState
 *  @param fuelRange                    Subscribe to fuelRange
 *  @param gps                          Subscribe to gps
 *  @param headLampStatus               Subscribe to headLampStatus
 *  @param instantFuelConsumption       Subscribe to instantFuelConsumption
 *  @param myKey                        Subscribe to myKey
 *  @param odometer                     Subscribe to odometer
 *  @param prndl                        Subscribe to prndl
 *  @param rpm                          Subscribe to rpm
 *  @param speed                        Subscribe to speed
 *  @param steeringWheelAngle           Subscribe to steeringWheelAngle
 *  @param tirePressure                 Subscribe to tirePressure
 *  @param turnSignal                   Subscribe to turnSignal
 *  @param wiperStatus                  Subscribe to wiperStatus
 *  @return                             A SDLSubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithGps:speed:rpm:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:gearStatus:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:handsOffSteering: instead");

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition    Subscribe to accelerationPedalPosition
 *  @param airbagStatus                 Subscribe to airbagStatus
 *  @param beltStatus                   Subscribe to beltStatus
 *  @param bodyInformation              Subscribe to bodyInformation
 *  @param cloudAppVehicleID            Subscribe to cloudAppVehicleID
 *  @param clusterModeStatus            Subscribe to clusterModeStatus
 *  @param deviceStatus                 Subscribe to deviceStatus
 *  @param driverBraking                Subscribe to driverBraking
 *  @param eCallInfo                    Subscribe to eCallInfo
 *  @param electronicParkBrakeStatus    Subscribe to electronicParkBrakeStatus
 *  @param emergencyEvent               Subscribe to emergencyEvent
 *  @param engineOilLife                Subscribe to engineOilLife
 *  @param engineTorque                 Subscribe to engineTorque
 *  @param externalTemperature          Subscribe to externalTemperature
 *  @param fuelLevel                    Subscribe to fuelLevel
 *  @param fuelLevelState               Subscribe to fuelLevelState
 *  @param fuelRange                    Subscribe to fuelRange
 *  @param gps                          Subscribe to gps
 *  @param headLampStatus               Subscribe to headLampStatus
 *  @param instantFuelConsumption       Subscribe to instantFuelConsumption
 *  @param myKey                        Subscribe to myKey
 *  @param odometer                     Subscribe to odometer
 *  @param prndl                        Subscribe to prndl
 *  @param rpm                          Subscribe to rpm
 *  @param speed                        Subscribe to speed
 *  @param steeringWheelAngle           Subscribe to steeringWheelAngle
 *  @param tirePressure                 Subscribe to tirePressure
 *  @param turnSignal                   Subscribe to turnSignal
 *  @param wiperStatus                  Subscribe to wiperStatus
 *  @return                             A SDLSubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithGps:speed:rpm:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:gearStatus:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:handsOffSteering: instead");

/**
 *  Convenience init for subscribing to all possible vehicle data items.
 *
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
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModeStatus - clusterModeStatus
 * @param myKey - myKey
 * @param handsOffSteering - handsOffSteering
 * @return A SDLSubscribeVehicleData object
 */
- (instancetype)initWithGps:(nullable NSNumber<SDLBool> *)gps speed:(nullable NSNumber<SDLBool> *)speed rpm:(nullable NSNumber<SDLBool> *)rpm instantFuelConsumption:(nullable NSNumber<SDLBool> *)instantFuelConsumption fuelRange:(nullable NSNumber<SDLBool> *)fuelRange externalTemperature:(nullable NSNumber<SDLBool> *)externalTemperature turnSignal:(nullable NSNumber<SDLBool> *)turnSignal gearStatus:(nullable NSNumber<SDLBool> *)gearStatus tirePressure:(nullable NSNumber<SDLBool> *)tirePressure odometer:(nullable NSNumber<SDLBool> *)odometer beltStatus:(nullable NSNumber<SDLBool> *)beltStatus bodyInformation:(nullable NSNumber<SDLBool> *)bodyInformation deviceStatus:(nullable NSNumber<SDLBool> *)deviceStatus driverBraking:(nullable NSNumber<SDLBool> *)driverBraking wiperStatus:(nullable NSNumber<SDLBool> *)wiperStatus headLampStatus:(nullable NSNumber<SDLBool> *)headLampStatus engineTorque:(nullable NSNumber<SDLBool> *)engineTorque accPedalPosition:(nullable NSNumber<SDLBool> *)accPedalPosition steeringWheelAngle:(nullable NSNumber<SDLBool> *)steeringWheelAngle engineOilLife:(nullable NSNumber<SDLBool> *)engineOilLife electronicParkBrakeStatus:(nullable NSNumber<SDLBool> *)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSNumber<SDLBool> *)cloudAppVehicleID eCallInfo:(nullable NSNumber<SDLBool> *)eCallInfo airbagStatus:(nullable NSNumber<SDLBool> *)airbagStatus emergencyEvent:(nullable NSNumber<SDLBool> *)emergencyEvent clusterModeStatus:(nullable NSNumber<SDLBool> *)clusterModeStatus myKey:(nullable NSNumber<SDLBool> *)myKey handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering;

/**
 * A boolean value. If true, subscribes for GearStatus data.
*/
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gearStatus;

/**
 * A boolean value. If true, subscribes GPS data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, subscribes Speed data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *speed;

/**
 * A boolean value. If true, subscribes RPM data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, subscribes Fuel Level data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel __deprecated_msg("use fuelRange instead on 7.0+ RPC version connections");

/**
 * A boolean value. If true, subscribes Fuel Level State data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State __deprecated_msg("use fuelRange instead on 7.0+ RPC version connections");

/**
 * A boolean value. If true, subscribes Fuel Range data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelRange;

/**
 * A boolean value. If true, subscribes Instant Fuel Consumption data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * A boolean value. If true, subscribes External Temperature data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *externalTemperature;

/**
 * A boolean value. If true, subscribes PRNDL data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl __deprecated_msg("use gearStatus instead on 7.0+ RPC version connections");

/**
 * A boolean value. If true, subscribes Tire Pressure status data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, subscribes Odometer data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, subscribes Belt Status data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, subscribes Body Information data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, subscribes Device Status data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, subscribes Driver Braking data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *driverBraking;

/**
 * A boolean value. If true, subscribes Wiper Status data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *wiperStatus;

/**
 * To indicate whether driver hands are off the steering wheel
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *handsOffSteering;

/**
 * A boolean value. If true, subscribes Head Lamp Status data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, subscribes to Engine Oil Life data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineOilLife;

/**
 * A boolean value. If true, subscribes Engine Torque data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, subscribes Acc Pedal Position data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *accPedalPosition;

/**
 * A boolean value. If true, subscribes Steering Wheel Angle data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * A boolean value. If true, subscribes eCall Info data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *eCallInfo;

/**
 * A boolean value. If true, subscribes Airbag Status data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *airbagStatus;

/**
 * A boolean value. If true, subscribes Emergency Event data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *emergencyEvent;

/**
 * A boolean value. If true, subscribes Cluster Mode Status data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *clusterModeStatus;

/**
 * A boolean value. If true, subscribes myKey data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *myKey;

/**
 * A boolean value. If true, subscribes to the electronic parking brake status.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 * A boolean value. If true, subscribes to the turn signal status.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *turnSignal;

/**
 * A boolean value. If true, subscribes to the cloud app vehicle ID.
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



@end

NS_ASSUME_NONNULL_END
