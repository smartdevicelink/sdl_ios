//  SDLGetVehicleData.h
//


#import "SDLRPCRequest.h"

/**
 *  Requests current values of specific published vehicle data items.
 *
 *  Function Group: Location, VehicleInfo and DrivingChara
 *  HMILevel needs to be FULL, LIMITED or BACKGROUND
 *  Since SmartDeviceLink 2.0
 *  See SDLSubscribeVehicleData, SDLUnsubscribeVehicleData
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetVehicleData : SDLRPCRequest

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition   Get accelerationPedalPosition data
 *  @param airbagStatus                Get airbagStatus data
 *  @param beltStatus                  Get beltStatus data
 *  @param bodyInformation             Get bodyInformation data
 *  @param clusterModeStatus           Get clusterModeStatus data
 *  @param deviceStatus                Get deviceStatus data
 *  @param driverBraking               Get driverBraking data
 *  @param eCallInfo                   Get eCallInfo data
 *  @param emergencyEvent              Get emergencyEvent data
 *  @param engineTorque                Get engineTorque data
 *  @param externalTemperature         Get externalTemperature data
 *  @param fuelLevel                   Get fuelLevel data
 *  @param fuelLevelState              Get fuelLevelState data
 *  @param gps                         Get gps data
 *  @param headLampStatus              Get headLampStatus data
 *  @param instantFuelConsumption      Get instantFuelConsumption data
 *  @param myKey                       Get myKey data
 *  @param odometer                    Get odometer data
 *  @param prndl                       Get prndl data
 *  @param rpm                         Get rpm data
 *  @param speed                       Get speed data
 *  @param steeringWheelAngle          Get steeringWheelAngle data
 *  @param tirePressure                Get tirePressure data
 *  @param vin                         Get vin data
 *  @param wiperStatus                 Get wiperStatus data
 *  @return                            A SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus: instead");

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition   Get accelerationPedalPosition data
 *  @param airbagStatus                Get airbagStatus data
 *  @param beltStatus                  Get beltStatus data
 *  @param bodyInformation             Get bodyInformation data
 *  @param clusterModeStatus           Get clusterModeStatus data
 *  @param deviceStatus                Get deviceStatus data
 *  @param driverBraking               Get driverBraking data
 *  @param eCallInfo                   Get eCallInfo data
 *  @param electronicParkBrakeStatus  Get electronicParkBrakeStatus data
 *  @param emergencyEvent              Get emergencyEvent data
 *  @param engineOilLife               Get engineOilLife data
 *  @param engineTorque                Get engineTorque data
 *  @param externalTemperature         Get externalTemperature data
 *  @param fuelLevel                   Get fuelLevel data
 *  @param fuelLevelState              Get fuelLevelState data
 *  @param fuelRange                   Get fuelRange data
 *  @param gps                         Get gps data
 *  @param headLampStatus              Get headLampStatus data
 *  @param instantFuelConsumption      Get instantFuelConsumption data
 *  @param myKey                       Get myKey data
 *  @param odometer                    Get odometer data
 *  @param prndl                       Get prndl data
 *  @param rpm                         Get rpm data
 *  @param speed                       Get speed data
 *  @param steeringWheelAngle          Get steeringWheelAngle data
 *  @param tirePressure                Get tirePressure data
 *  @param turnSignal                  Get turnSignal data
 *  @param vin                         Get vin data
 *  @param wiperStatus                 Get wiperStatus data
 *  @return                            A SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus __deprecated_msg("Use initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:fuelRange:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus: instead");

/**
 *  Convenience init for getting data for all possible vehicle data items.
 *
 *  @param accelerationPedalPosition   Get accelerationPedalPosition data
 *  @param airbagStatus                Get airbagStatus data
 *  @param beltStatus                  Get beltStatus data
 *  @param bodyInformation             Get bodyInformation data
 *  @param cloudAppVehicleID           Get cloudAppVehicleID data
 *  @param clusterModeStatus           Get clusterModeStatus data
 *  @param deviceStatus                Get deviceStatus data
 *  @param driverBraking               Get driverBraking data
 *  @param eCallInfo                   Get eCallInfo data
 *  @param electronicParkBrakeStatus   Get electronicParkBrakeStatus data
 *  @param emergencyEvent              Get emergencyEvent data
 *  @param engineOilLife               Get engineOilLife data
 *  @param engineTorque                Get engineTorque data
 *  @param externalTemperature         Get externalTemperature data
 *  @param fuelLevel                   Get fuelLevel data
 *  @param fuelLevelState              Get fuelLevelState data
 *  @param fuelRange                   Get fuelRange data
 *  @param gps                         Get gps data
 *  @param headLampStatus              Get headLampStatus data
 *  @param instantFuelConsumption      Get instantFuelConsumption data
 *  @param myKey                       Get myKey data
 *  @param odometer                    Get odometer data
 *  @param prndl                       Get prndl data
 *  @param rpm                         Get rpm data
 *  @param speed                       Get speed data
 *  @param steeringWheelAngle          Get steeringWheelAngle data
 *  @param tirePressure                Get tirePressure data
 *  @param turnSignal                  Get turnSignal data
 *  @param vin                         Get vin data
 *  @param wiperStatus                 Get wiperStatus data
 *  @return                            A SDLGetVehicleData object
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation cloudAppVehicleID:(BOOL)cloudAppVehicleID clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo electronicParkBrakeStatus:(BOOL)electronicParkBrakeStatus emergencyEvent:(BOOL)emergencyEvent engineOilLife:(BOOL)engineOilLife engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState fuelRange:(BOOL)fuelRange gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure turnSignal:(BOOL)turnSignal vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus;

/**
 * A boolean value. If true, requests GPS data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, requests Speed data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *speed;

/**
 * A boolean value. If true, requests RPM data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, requests Fuel Level data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel;

/**
 * A boolean value. If true, requests Fuel Level State data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel_State;

/**
 * A boolean value. If true, requests Fuel Range data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelRange;

/**
 * A boolean value. If true, requests Instant Fuel Consumption data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * A boolean value. If true, requests External Temperature data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *externalTemperature;

/**
 * A boolean value. If true, requests the Vehicle Identification Number.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *vin;

/**
 * A boolean value. If true, requests PRNDL data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *prndl;

/**
 * A boolean value. If true, requests Tire Pressure data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, requests Odometer data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, requests Belt Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, requests Body Information data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, requests Device Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, requests Driver Braking data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverBraking;

/**
 * A boolean value. If true, requests Wiper Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *wiperStatus;

/**
 * A boolean value. If true, requests Head Lamp Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, requests Engine Oil Life data.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineOilLife;

/**
 * A boolean value. If true, requests Engine Torque data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, requests Acc Pedal Position data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *accPedalPosition;

/**
 * A boolean value. If true, requests Steering Wheel Angle data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *steeringWheelAngle;

/**
 * A boolean value. If true, requests Emergency Call Info data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *eCallInfo;

/**
 * A boolean value. If true, requests Air Bag Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *airbagStatus;

/**
 * A boolean value. If true, requests Emergency Event (if it occurred) data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *emergencyEvent;

/**
 * A boolean value. If true, requests Cluster Mode Status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *clusterModeStatus;

/**
 * A boolean value. If true, requests MyKey data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *myKey;

/**
 A boolean value. If true, requests Electronic Parking Brake status data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *electronicParkBrakeStatus;

/**
 A boolean value. If true, requests Turn Signal data.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *turnSignal;

/**
 A boolean value. If true, requests the Cloud App Vehicle ID.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *cloudAppVehicleID;

- (void)setGenericNetworkData:(NSString *)vehicleDataName withVehicleDataState:(BOOL)vehicleDataState;

- (NSNumber<SDLBool> *)genericNetworkData:(NSString *)vehicleDataName;

@end

NS_ASSUME_NONNULL_END
