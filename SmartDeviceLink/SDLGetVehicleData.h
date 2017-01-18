//  SDLGetVehicleData.h
//


#import "SDLRPCRequest.h"

/**
 * Requests surrent values of specific published vehicle data items.
 * <p>
 * Function Group: Location, VehicleInfo and DrivingChara
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 2.0<br/>
 * See SDLSubscribeVehicleData SDLUnsubscribeVehicleData
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetVehicleData : SDLRPCRequest

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus;
/**
 * @abstract A boolean value. If true, requests Gps data
 */
@property (nullable, strong) NSNumber<SDLBool> *gps;

/**
 * @abstract A boolean value. If true, requests speed data
 */
@property (nullable, strong) NSNumber<SDLBool> *speed;

/**
 * @abstract A boolean value. If true, requests rpm data
 */
@property (nullable, strong) NSNumber<SDLBool> *rpm;

/**
 * @abstract A boolean value. If true, requests FuelLevel data
 */
@property (nullable, strong) NSNumber<SDLBool> *fuelLevel;

/**
 * @abstract A boolean value. If true, requests fuelLevel_State data
 */
@property (nullable, strong) NSNumber<SDLBool> *fuelLevel_State;

/**
 * @abstract A boolean value. If true, requests instantFuelConsumption data
 */
@property (nullable, strong) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * @abstract A boolean value. If true, requests externalTemperature data
 */
@property (nullable, strong) NSNumber<SDLBool> *externalTemperature;

/**
 * @abstract A boolean value. If true, requests Vehicle Identification Number
 */
@property (nullable, strong) NSNumber<SDLBool> *vin;

/**
 * @abstract A boolean value. If true, requests Currently selected gear data
 */
@property (nullable, strong) NSNumber<SDLBool> *prndl;

/**
 * @abstract A boolean value. If true, requests tire pressure status data
 */
@property (nullable, strong) NSNumber<SDLBool> *tirePressure;

/**
 * @abstract A boolean value. If true, requests odometer data
 */
@property (nullable, strong) NSNumber<SDLBool> *odometer;

/**
 * @abstract A boolean value. If true, requests belt Status data
 */
@property (nullable, strong) NSNumber<SDLBool> *beltStatus;

/**
 * @abstract A boolean value. If true, requests body Information data
 */
@property (nullable, strong) NSNumber<SDLBool> *bodyInformation;

/**
 * @abstract A boolean value. If true, requests device Status data
 */
@property (nullable, strong) NSNumber<SDLBool> *deviceStatus;

/**
 * @abstract A boolean value. If true, requests driver Braking data
 */
@property (nullable, strong) NSNumber<SDLBool> *driverBraking;

/**
 * @abstract A boolean value. If true, requests wiper Status data
 */
@property (nullable, strong) NSNumber<SDLBool> *wiperStatus;

/**
 * @abstract A boolean value. If true, requests Head Lamp Status data
 */
@property (nullable, strong) NSNumber<SDLBool> *headLampStatus;

/**
 * @abstract A boolean value. If true, requests Engine Torque data
 */
@property (nullable, strong) NSNumber<SDLBool> *engineTorque;

/**
 * @abstract A boolean value. If true, means the accPedalPosition data has been
 * subscribed.
 */
@property (nullable, strong) NSNumber<SDLBool> *accPedalPosition;

/**
 * @abstract A boolean value. If true, means the steeringWheelAngle data has been
 * subscribed.
 */
@property (nullable, strong) NSNumber<SDLBool> *steeringWheelAngle;
@property (nullable, strong) NSNumber<SDLBool> *eCallInfo;
@property (nullable, strong) NSNumber<SDLBool> *airbagStatus;
@property (nullable, strong) NSNumber<SDLBool> *emergencyEvent;
@property (nullable, strong) NSNumber<SDLBool> *clusterModeStatus;
@property (nullable, strong) NSNumber<SDLBool> *myKey;

@end

NS_ASSUME_NONNULL_END
