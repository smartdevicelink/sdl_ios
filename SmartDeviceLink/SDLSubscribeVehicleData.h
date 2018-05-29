//  SDLSubscribeVehicleData.h
//


#import "SDLRPCRequest.h"

/**
 * Subscribes for specific published vehicle data items. The data will be only
 * sent, if it has changed. The application will be notified by the
 * onVehicleData notification whenever new data is available. The update rate is
 * very much dependent on sensors, vehicle architecture and vehicle type. Be
 * also prepared for the situation that a signal is not available on a vehicle
 * <p>
 * Function Group: Location, VehicleInfo and DrivingChara
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 2.0<br/>
 * See SDLUnsubscribeVehicleData SDLGetVehicleData
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSubscribeVehicleData : SDLRPCRequest

/**
 Initialize a subscribe RPC with various possible to describe to

 @param accelerationPedalPosition Subcribe to accelerationPedalPosition
 @param airbagStatus Subcribe to airbagStatus
 @param beltStatus Subcribe to beltStatus
 @param bodyInformation Subcribe to bodyInformation
 @param clusterModeStatus Subcribe to clusterModeStatus
 @param deviceStatus Subcribe to deviceStatus
 @param driverBraking Subcribe to driverBraking
 @param eCallInfo Subcribe to eCallInfo
 @param emergencyEvent Subcribe to v
 @param engineTorque Subcribe to engineTorque
 @param externalTemperature Subcribe to externalTemperature
 @param fuelLevel Subcribe to fuelLevel
 @param fuelLevelState Subcribe to fuelLevelState
 @param gps Subcribe to gps
 @param headLampStatus Subcribe to headLampStatus
 @param instantFuelConsumption Subcribe to instantFuelConsumption
 @param myKey Subcribe to myKey
 @param odometer Subcribe to odometer
 @param prndl Subcribe to prndl
 @param rpm Subcribe to rpm
 @param speed Subcribe to speed
 @param steeringWheelAngle Subcribe to steeringWheelAngle
 @param tirePressure Subcribe to tirePressure
 @param wiperStatus Subcribe to wiperStatus
 @return The RPC
 */
- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus;

/**
 * A boolean value. If true, subscribes Gps data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, subscribes speed data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *speed;

/**
 * A boolean value. If true, subscribes rpm data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, subscribes FuelLevel data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel;

/**
 * A boolean value. If true, subscribes fuelLevel_State data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State;

/**
 * A boolean value. If true, subscribes instantFuelConsumption data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * A boolean value. If true, subscribes externalTemperature data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *externalTemperature;

/**
 * A boolean value. If true, subscribes Currently selected gear data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl;

/**
 * A boolean value. If true, subscribes tire pressure status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, subscribes odometer data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, subscribes belt Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, subscribes body Information data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, subscribes device Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, subscribes driver Braking data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *driverBraking;

/**
 * A boolean value. If true, subscribes wiper Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *wiperStatus;

/**
 * A boolean value. If true, subscribes Head Lamp Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, subscribes Engine Torque data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, means the accPedalPosition data has been
 * subscribed.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *accPedalPosition;

/**
 * A boolean value. If true, means the steeringWheelAngle data has been
 * subscribed.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *steeringWheelAngle;

/**
 Subscribe to eCallInfo
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *eCallInfo;

/**
 Subscribe to airbagStatus
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *airbagStatus;

/**
 Subscribe to emergencyEvent
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *emergencyEvent;

/**
 Subscribe to clusterModeStatus
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *clusterModeStatus;

/**
 Subscribe to myKey
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *myKey;

@end

NS_ASSUME_NONNULL_END
