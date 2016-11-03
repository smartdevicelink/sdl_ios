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
@interface SDLUnsubscribeVehicleData : SDLRPCRequest

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus;

/**
 * @abstract A boolean value. If true, unsubscribes Gps data
 */
@property (strong) NSNumber<SDLBool> *gps;

/**
 * @abstract A boolean value. If true, unsubscribes speed data
 */
@property (strong) NSNumber<SDLBool> *speed;

/**
 * @abstract A boolean value. If true, unsubscribe data
 */
@property (strong) NSNumber<SDLBool> *rpm;

/**
 * @abstract A boolean value. If true, unsubscribes FuelLevel data
 */
@property (strong) NSNumber<SDLBool> *fuelLevel;

/**
 * @abstract A boolean value. If true, unsubscribes fuelLevel_State data
 */
@property (strong) NSNumber<SDLBool> *fuelLevel_State;

/**
 * @abstract A boolean value. If true, unsubscribes instantFuelConsumption data
 */
@property (strong) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * @abstract A boolean value. If true, unsubscribes externalTemperature data
 */
@property (strong) NSNumber<SDLBool> *externalTemperature;

/**
 * @abstract A boolean value. If true, unsubscribes Currently selected gear data
 */
@property (strong) NSNumber<SDLBool> *prndl;

/**
 * @abstract A boolean value. If true, unsubscribes tire pressure status data
 */
@property (strong) NSNumber<SDLBool> *tirePressure;

/**
 * @abstract A boolean value. If true, unsubscribes odometer data
 */
@property (strong) NSNumber<SDLBool> *odometer;

/**
 * @abstract A boolean value. If true, unsubscribes belt Status data
 */
@property (strong) NSNumber<SDLBool> *beltStatus;

/**
 * @abstract A boolean value. If true, unsubscribes body Information data
 */
@property (strong) NSNumber<SDLBool> *bodyInformation;

/**
 * @abstract A boolean value. If true, unsubscribes device Status data
 */
@property (strong) NSNumber<SDLBool> *deviceStatus;

/**
 * @abstract A boolean value. If true, unsubscribes driver Braking data
 */
@property (strong) NSNumber<SDLBool> *driverBraking;

/**
 * @abstract A boolean value. If true, unsubscribes wiper Status data
 */
@property (strong) NSNumber<SDLBool> *wiperStatus;

/**
 * @abstract A boolean value. If true, unsubscribes Head Lamp Status data
 */
@property (strong) NSNumber<SDLBool> *headLampStatus;

/**
 * @abstract A boolean value. If true, unsubscribes Engine Torque data
 */
@property (strong) NSNumber<SDLBool> *engineTorque;

/**
 * @abstract A boolean value. If true, unsubscribes accPedalPosition data
 */
@property (strong) NSNumber<SDLBool> *accPedalPosition;
@property (strong) NSNumber<SDLBool> *steeringWheelAngle;
@property (strong) NSNumber<SDLBool> *eCallInfo;
@property (strong) NSNumber<SDLBool> *airbagStatus;
@property (strong) NSNumber<SDLBool> *emergencyEvent;
@property (strong) NSNumber<SDLBool> *clusterModeStatus;
@property (strong) NSNumber<SDLBool> *myKey;

@end
