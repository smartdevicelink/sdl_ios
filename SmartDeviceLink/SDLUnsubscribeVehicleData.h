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
@interface SDLUnsubscribeVehicleData : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLUnsubscribeVehicleData object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLUnsubscribeVehicleData object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithAccelerationPedalPosition:(BOOL)accelerationPedalPosition airbagStatus:(BOOL)airbagStatus beltStatus:(BOOL)beltStatus bodyInformation:(BOOL)bodyInformation clusterModeStatus:(BOOL)clusterModeStatus deviceStatus:(BOOL)deviceStatus driverBraking:(BOOL)driverBraking eCallInfo:(BOOL)eCallInfo emergencyEvent:(BOOL)emergencyEvent engineTorque:(BOOL)engineTorque externalTemperature:(BOOL)externalTemperature fuelLevel:(BOOL)fuelLevel fuelLevelState:(BOOL)fuelLevelState gps:(BOOL)gps headLampStatus:(BOOL)headLampStatus instantFuelConsumption:(BOOL)instantFuelConsumption myKey:(BOOL)myKey odometer:(BOOL)odometer prndl:(BOOL)prndl rpm:(BOOL)rpm speed:(BOOL)speed steeringWheelAngle:(BOOL)steeringWheelAngle tirePressure:(BOOL)tirePressure wiperStatus:(BOOL)wiperStatus;

/**
 * @abstract A boolean value. If true, unsubscribes Gps data
 */
@property (strong) NSNumber *gps;

/**
 * @abstract A boolean value. If true, unsubscribes speed data
 */
@property (strong) NSNumber *speed;

/**
 * @abstract A boolean value. If true, unsubscribe data
 */
@property (strong) NSNumber *rpm;

/**
 * @abstract A boolean value. If true, unsubscribes FuelLevel data
 */
@property (strong) NSNumber *fuelLevel;

/**
 * @abstract A boolean value. If true, unsubscribes fuelLevel_State data
 */
@property (strong) NSNumber *fuelLevel_State;

/**
 * @abstract A boolean value. If true, unsubscribes instantFuelConsumption data
 */
@property (strong) NSNumber *instantFuelConsumption;

/**
 * @abstract A boolean value. If true, unsubscribes externalTemperature data
 */
@property (strong) NSNumber *externalTemperature;

/**
 * @abstract A boolean value. If true, unsubscribes Currently selected gear data
 */
@property (strong) NSNumber *prndl;

/**
 * @abstract A boolean value. If true, unsubscribes tire pressure status data
 */
@property (strong) NSNumber *tirePressure;

/**
 * @abstract A boolean value. If true, unsubscribes odometer data
 */
@property (strong) NSNumber *odometer;

/**
 * @abstract A boolean value. If true, unsubscribes belt Status data
 */
@property (strong) NSNumber *beltStatus;

/**
 * @abstract A boolean value. If true, unsubscribes body Information data
 */
@property (strong) NSNumber *bodyInformation;

/**
 * @abstract A boolean value. If true, unsubscribes device Status data
 */
@property (strong) NSNumber *deviceStatus;

/**
 * @abstract A boolean value. If true, unsubscribes driver Braking data
 */
@property (strong) NSNumber *driverBraking;

/**
 * @abstract A boolean value. If true, unsubscribes wiper Status data
 */
@property (strong) NSNumber *wiperStatus;

/**
 * @abstract A boolean value. If true, unsubscribes Head Lamp Status data
 */
@property (strong) NSNumber *headLampStatus;

/**
 * @abstract A boolean value. If true, unsubscribes Engine Torque data
 */
@property (strong) NSNumber *engineTorque;

/**
 * @abstract A boolean value. If true, unsubscribes accPedalPosition data
 */
@property (strong) NSNumber *accPedalPosition;
@property (strong) NSNumber *steeringWheelAngle;
@property (strong) NSNumber *eCallInfo;
@property (strong) NSNumber *airbagStatus;
@property (strong) NSNumber *emergencyEvent;
@property (strong) NSNumber *clusterModeStatus;
@property (strong) NSNumber *myKey;

@end
