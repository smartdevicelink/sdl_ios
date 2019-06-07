//  SDLUnsubscribeVehicleData.h
//


#import "SDLRPCRequest.h"

/**
 * This function is used to unsubscribe the notifications from the
 * subscribeVehicleData function
 * <p>
 * Function Group: Location, VehicleInfo and DrivingChara
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * @since SmartDeviceLink 2.0<br/>
 * See SDLSubscribeVehicleData SDLGetVehicleData
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLUnsubscribeVehicleData : SDLRPCRequest

/**
 *  Convenience init for unsubscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition    Unsubscribe to accelerationPedalPosition
 *  @param airbagStatus                 Unsubscribe to airbagStatus
 *  @param beltStatus                   Unsubscribe to beltStatus
 *  @param bodyInformation              Unsubscribe to bodyInformation
 *  @param clusterModeStatus            Unsubscribe to clusterModeStatus
 *  @param deviceStatus                 Unsubscribe to deviceStatus
 *  @param driverBraking                Unsubscribe to driverBraking
 *  @param eCallInfo                    Unsubscribe to eCallInfo
 *  @param emergencyEvent               Unsubscribe to emergencyEvent
 *  @param engineTorque                 Unsubscribe to engineTorque
 *  @param externalTemperature          Unsubscribe to externalTemperature
 *  @param fuelLevel                    Unsubscribe to fuelLevel
 *  @param fuelLevelState               Unsubscribe to fuelLevelState
 *  @param gps                          Unsubscribe to gps
 *  @param headLampStatus               Unsubscribe to headLampStatus
 *  @param instantFuelConsumption       Unsubscribe to instantFuelConsumption
 *  @param myKey                        Unsubscribe to myKey
 *  @param odometer                     Unsubscribe to odometer
 *  @param prndl                        Unsubscribe to prndl
 *  @param rpm                          Unsubscribe to rpm
 *  @param speed                        Unsubscribe to speed
 *  @param steeringWheelAngle           Unsubscribe to steeringWheelAngle
 *  @param tirePressure                 Unsubscribe to tirePressure
 *  @param wiperStatus                  Unsubscribe to wiperStatus
 *  @return                             A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus: instead");

/**
 *  Convenience init for unsubscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition    Unsubscribe to accelerationPedalPosition
 *  @param airbagStatus                 Unsubscribe to airbagStatus
 *  @param beltStatus                   Unsubscribe to beltStatus
 *  @param bodyInformation              Unsubscribe to bodyInformation
 *  @param clusterModeStatus            Unsubscribe to clusterModeStatus
 *  @param deviceStatus                 Unsubscribe to deviceStatus
 *  @param driverBraking                Unsubscribe to driverBraking
 *  @param eCallInfo                    Unsubscribe to eCallInfo
 *  @param electronicParkBrakeStatus    Unsubscribe to electronicParkBrakeStatus
 *  @param emergencyEvent               Unsubscribe to emergencyEvent
 *  @param engineOilLife                Unsubscribe to engineOilLife
 *  @param engineTorque                 Unsubscribe to engineTorque
 *  @param externalTemperature          Unsubscribe to externalTemperature
 *  @param fuelLevel                    Unsubscribe to fuelLevel
 *  @param fuelLevelState               Unsubscribe to fuelLevelState
 *  @param fuelRange                    Unsubscribe to fuelRange
 *  @param gps                          Unsubscribe to gps
 *  @param headLampStatus               Unsubscribe to headLampStatus
 *  @param instantFuelConsumption       Unsubscribe to instantFuelConsumption
 *  @param myKey                        Unsubscribe to myKey
 *  @param odometer                     Unsubscribe to odometer
 *  @param prndl                        Unsubscribe to prndl
 *  @param rpm                          Unsubscribe to rpm
 *  @param speed                        Unsubscribe to speed
 *  @param steeringWheelAngle           Unsubscribe to steeringWheelAngle
 *  @param tirePressure                 Unsubscribe to tirePressure
 *  @param turnSignal                   Unsubscribe to turnSignal
 *  @param wiperStatus                  Unsubscribe to wiperStatus
 *  @return                             A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus: instead");

/**
 *  Convenience init for unsubscribing to all possible vehicle data items.
 *
 *  @param accelerationPedalPosition    Unsubscribe to accelerationPedalPosition
 *  @param airbagStatus                 Unsubscribe to airbagStatus
 *  @param beltStatus                   Unsubscribe to beltStatus
 *  @param bodyInformation              Unsubscribe to bodyInformation
 *  @param cloudAppVehicleID            Unsubscribe to cloudAppVehicleID
 *  @param clusterModeStatus            Unsubscribe to clusterModeStatus
 *  @param deviceStatus                 Unsubscribe to deviceStatus
 *  @param driverBraking                Unsubscribe to driverBraking
 *  @param eCallInfo                    Unsubscribe to eCallInfo
 *  @param electronicParkBrakeStatus    Unsubscribe to electronicParkBrakeStatus
 *  @param emergencyEvent               Unsubscribe to emergencyEvent
 *  @param engineOilLife                Unsubscribe to engineOilLife
 *  @param engineTorque                 Unsubscribe to engineTorque
 *  @param externalTemperature          Unsubscribe to externalTemperature
 *  @param fuelLevel                    Unsubscribe to fuelLevel
 *  @param fuelLevelState               Unsubscribe to fuelLevelState
 *  @param fuelRange                    Unsubscribe to fuelRange
 *  @param gps                          Unsubscribe to gps
 *  @param headLampStatus               Unsubscribe to headLampStatus
 *  @param instantFuelConsumption       Unsubscribe to instantFuelConsumption
 *  @param myKey                        Unsubscribe to myKey
 *  @param odometer                     Unsubscribe to odometer
 *  @param prndl                        Unsubscribe to prndl
 *  @param rpm                          Unsubscribe to rpm
 *  @param speed                        Unsubscribe to speed
 *  @param steeringWheelAngle           Unsubscribe to steeringWheelAngle
 *  @param tirePressure                 Unsubscribe to tirePressure
 *  @param turnSignal                   Unsubscribe to turnSignal
 *  @param wiperStatus                  Unsubscribe to wiperStatus
 *  @return                             A SDLUnsubscribeVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation  cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal wiperStatus:(BOOL)wiperStatus;

/**
 * If true, unsubscribes from GPS
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gps;

/**
 * If true, unsubscribes from Speed
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *speed;

/**
 * If true, unsubscribes from RPM
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *rpm;

/**
 * If true, unsubscribes from Fuel Level
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel;

/**
 * If true, unsubscribes from Fuel Level State
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State;

/**
 * If true, unsubscribes from Fuel Range
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelRange;

/**
 * If true, unsubscribes from Instant Fuel Consumption
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * If true, unsubscribes from External Temperature
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *externalTemperature;

/**
 * If true, unsubscribes from PRNDL
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl;

/**
 * If true, unsubscribes from Tire Pressure
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *tirePressure;

/**
 * If true, unsubscribes from Odometer
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *odometer;

/**
 * If true, unsubscribes from Belt Status
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *beltStatus;

/**
 * If true, unsubscribes from Body Information
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *bodyInformation;

/**
 * If true, unsubscribes from Device Status
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *deviceStatus;

/**
 * If true, unsubscribes from Driver Braking
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *driverBraking;

/**
 * If true, unsubscribes from Wiper Status
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *wiperStatus;

/**
 * If true, unsubscribes from Head Lamp Status
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *headLampStatus;

/**
 * If true, unsubscribes from Engine Oil Life
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineOilLife;

/**
 * If true, unsubscribes from Engine Torque
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineTorque;

/**
 * If true, unsubscribes from Acc Pedal Position
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *accPedalPosition;

/**
 * If true, unsubscribes from Steering Wheel Angle data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * If true, unsubscribes from eCallInfo
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *eCallInfo;

/**
 * If true, unsubscribes from Airbag Status
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *airbagStatus;

/**
 * If true, unsubscribes from Emergency Event
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *emergencyEvent;

/**
 * If true, unsubscribes from Cluster Mode Status
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *clusterModeStatus;

/**
 * If true, unsubscribes from My Key
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *myKey;

/**
 A boolean value. If true, unsubscribes to the Electronic Parking Brake Status
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 A boolean value. If true, unsubscribes to the Turn Signal
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *turnSignal;

/**
 A boolean value. If true, unsubscribes to the Cloud App Vehicle ID
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *cloudAppVehicleID;

- (void)setGenericNetworkData:(NSString *)vehicleDataName withVehicleDataState:(BOOL)vehicleDataState;

- (NSNumber<SDLBool> *)genericNetworkData:(NSString *)vehicleDataName;

@end

NS_ASSUME_NONNULL_END
