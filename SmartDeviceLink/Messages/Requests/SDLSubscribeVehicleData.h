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

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus;

/**
 * @abstract A boolean value. If true, subscribes Gps data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *gps;

/**
 * @abstract A boolean value. If true, subscribes speed data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *speed;

/**
 * @abstract A boolean value. If true, subscribes rpm data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *rpm;

/**
 * @abstract A boolean value. If true, subscribes FuelLevel data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel;

/**
 * @abstract A boolean value. If true, subscribes fuelLevel_State data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *fuelLevel_State;

/**
 * @abstract A boolean value. If true, subscribes instantFuelConsumption data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * @abstract A boolean value. If true, subscribes externalTemperature data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *externalTemperature;

/**
 * @abstract A boolean value. If true, subscribes Currently selected gear data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *prndl;

/**
 * @abstract A boolean value. If true, subscribes tire pressure status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *tirePressure;

/**
 * @abstract A boolean value. If true, subscribes odometer data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *odometer;

/**
 * @abstract A boolean value. If true, subscribes belt Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *beltStatus;

/**
 * @abstract A boolean value. If true, subscribes body Information data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *bodyInformation;

/**
 * @abstract A boolean value. If true, subscribes device Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *deviceStatus;

/**
 * @abstract A boolean value. If true, subscribes driver Braking data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *driverBraking;

/**
 * @abstract A boolean value. If true, subscribes wiper Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *wiperStatus;

/**
 * @abstract A boolean value. If true, subscribes Head Lamp Status data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *headLampStatus;

/**
 * @abstract A boolean value. If true, subscribes Engine Torque data
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *engineTorque;

/**
 * @abstract A boolean value. If true, means the accPedalPosition data has been
 * subscribed.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *accPedalPosition;

/**
 * @abstract A boolean value. If true, means the steeringWheelAngle data has been
 * subscribed.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *steeringWheelAngle;
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *eCallInfo;
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *airbagStatus;
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *emergencyEvent;
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *clusterModeStatus;
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *myKey;

@end

NS_ASSUME_NONNULL_END
