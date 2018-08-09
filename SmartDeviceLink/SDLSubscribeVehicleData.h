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
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus: instead");

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
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus;

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
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel;

/**
 * A boolean value. If true, subscribes Fuel Level State data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State;

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
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl;

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


@end

NS_ASSUME_NONNULL_END
