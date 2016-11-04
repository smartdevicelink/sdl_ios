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
@interface SDLGetVehicleData : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLGetVehicleData object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLGetVehicleData object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure vin:(BOOL)vin wiperStatus:(BOOL)wiperStatus;
/**
 * @abstract A boolean value. If true, requests Gps data
 */
@property (strong) NSNumber *gps;

/**
 * @abstract A boolean value. If true, requests speed data
 */
@property (strong) NSNumber *speed;

/**
 * @abstract A boolean value. If true, requests rpm data
 */
@property (strong) NSNumber *rpm;

/**
 * @abstract A boolean value. If true, requests FuelLevel data
 */
@property (strong) NSNumber *fuelLevel;

/**
 * @abstract A boolean value. If true, requests fuelLevel_State data
 */
@property (strong) NSNumber *fuelLevel_State;

/**
 * @abstract A boolean value. If true, requests instantFuelConsumption data
 */
@property (strong) NSNumber *instantFuelConsumption;

/**
 * @abstract A boolean value. If true, requests externalTemperature data
 */
@property (strong) NSNumber *externalTemperature;

/**
 * @abstract A boolean value. If true, requests Vehicle Identification Number
 */
@property (strong) NSNumber *vin;

/**
 * @abstract A boolean value. If true, requests Currently selected gear data
 */
@property (strong) NSNumber *prndl;

/**
 * @abstract A boolean value. If true, requests tire pressure status data
 */
@property (strong) NSNumber *tirePressure;

/**
 * @abstract A boolean value. If true, requests odometer data
 */
@property (strong) NSNumber *odometer;

/**
 * @abstract A boolean value. If true, requests belt Status data
 */
@property (strong) NSNumber *beltStatus;

/**
 * @abstract A boolean value. If true, requests body Information data
 */
@property (strong) NSNumber *bodyInformation;

/**
 * @abstract A boolean value. If true, requests device Status data
 */
@property (strong) NSNumber *deviceStatus;

/**
 * @abstract A boolean value. If true, requests driver Braking data
 */
@property (strong) NSNumber *driverBraking;

/**
 * @abstract A boolean value. If true, requests wiper Status data
 */
@property (strong) NSNumber *wiperStatus;

/**
 * @abstract A boolean value. If true, requests Head Lamp Status data
 */
@property (strong) NSNumber *headLampStatus;

/**
 * @abstract A boolean value. If true, requests Engine Torque data
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
