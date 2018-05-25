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

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus;

/**
 * A boolean value. If true, unsubscribes Gps data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, unsubscribes speed data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *speed;

/**
 * A boolean value. If true, unsubscribe data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, unsubscribes FuelLevel data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel;

/**
 * A boolean value. If true, unsubscribes fuelLevel_State data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State;

/**
 * A boolean value. If true, unsubscribes instantFuelConsumption data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * A boolean value. If true, unsubscribes externalTemperature data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *externalTemperature;

/**
 * A boolean value. If true, unsubscribes Currently selected gear data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl;

/**
 * A boolean value. If true, unsubscribes tire pressure status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, unsubscribes odometer data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, unsubscribes belt Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, unsubscribes body Information data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, unsubscribes device Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, unsubscribes driver Braking data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *driverBraking;

/**
 * A boolean value. If true, unsubscribes wiper Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *wiperStatus;

/**
 * A boolean value. If true, unsubscribes Head Lamp Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, unsubscribes Engine Torque data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, unsubscribes accPedalPosition data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *accPedalPosition;

/**
 If true, unsubscribes from steeringWheelAngle
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *steeringWheelAngle;

/**
 If true, unsubscribes from eCallInfo
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *eCallInfo;

/**
 If true, unsubscribes from airbagStatus
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *airbagStatus;

/**
 If true, unsubscribes from emergencyEvent
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *emergencyEvent;

/**
 If true, unsubscribes from clusterModeStatus
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *clusterModeStatus;

/**
 If true, unsubscribes from myKey
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *myKey;

@end

NS_ASSUME_NONNULL_END
