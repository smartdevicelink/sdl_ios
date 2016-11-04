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
@interface SDLSubscribeVehicleData : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLSubscribeVehicleData object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLSubscribeVehicleData object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus;

/**
 * @abstract A boolean value. If true, subscribes Gps data
 */
@property (strong) NSNumber *gps;

/**
 * @abstract A boolean value. If true, subscribes speed data
 */
@property (strong) NSNumber *speed;

/**
 * @abstract A boolean value. If true, subscribes rpm data
 */
@property (strong) NSNumber *rpm;

/**
 * @abstract A boolean value. If true, subscribes FuelLevel data
 */
@property (strong) NSNumber *fuelLevel;

/**
 * @abstract A boolean value. If true, subscribes fuelLevel_State data
 */
@property (strong) NSNumber *fuelLevel_State;

/**
 * @abstract A boolean value. If true, subscribes instantFuelConsumption data
 */
@property (strong) NSNumber *instantFuelConsumption;

/**
 * @abstract A boolean value. If true, subscribes externalTemperature data
 */
@property (strong) NSNumber *externalTemperature;

/**
 * @abstract A boolean value. If true, subscribes Currently selected gear data
 */
@property (strong) NSNumber *prndl;

/**
 * @abstract A boolean value. If true, subscribes tire pressure status data
 */
@property (strong) NSNumber *tirePressure;

/**
 * @abstract A boolean value. If true, subscribes odometer data
 */
@property (strong) NSNumber *odometer;

/**
 * @abstract A boolean value. If true, subscribes belt Status data
 */
@property (strong) NSNumber *beltStatus;

/**
 * @abstract A boolean value. If true, subscribes body Information data
 */
@property (strong) NSNumber *bodyInformation;

/**
 * @abstract A boolean value. If true, subscribes device Status data
 */
@property (strong) NSNumber *deviceStatus;

/**
 * @abstract A boolean value. If true, subscribes driver Braking data
 */
@property (strong) NSNumber *driverBraking;

/**
 * @abstract A boolean value. If true, subscribes wiper Status data
 */
@property (strong) NSNumber *wiperStatus;

/**
 * @abstract A boolean value. If true, subscribes Head Lamp Status data
 */
@property (strong) NSNumber *headLampStatus;

/**
 * @abstract A boolean value. If true, subscribes Engine Torque data
 */
@property (strong) NSNumber *engineTorque;

/**
 * @abstract A boolean value. If true, means the accPedalPosition data has been
 * subscribed.
 */
@property (strong) NSNumber *accPedalPosition;

/**
 * @abstract A boolean value. If true, means the steeringWheelAngle data has been
 * subscribed.
 */
@property (strong) NSNumber *steeringWheelAngle;
@property (strong) NSNumber *eCallInfo;
@property (strong) NSNumber *airbagStatus;
@property (strong) NSNumber *emergencyEvent;
@property (strong) NSNumber *clusterModeStatus;
@property (strong) NSNumber *myKey;

@end
