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
 * A boolean value. If true, requests Gps data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *gps;

/**
 * A boolean value. If true, requests speed data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *speed;

/**
 * A boolean value. If true, requests rpm data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rpm;

/**
 * A boolean value. If true, requests FuelLevel data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel;

/**
 * A boolean value. If true, requests fuelLevel_State data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fuelLevel_State;

/**
 * A boolean value. If true, requests instantFuelConsumption data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * A boolean value. If true, requests externalTemperature data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *externalTemperature;

/**
 * A boolean value. If true, requests Vehicle Identification Number
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *vin;

/**
 * A boolean value. If true, requests Currently selected gear data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *prndl;

/**
 * A boolean value. If true, requests tire pressure status data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *tirePressure;

/**
 * A boolean value. If true, requests odometer data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *odometer;

/**
 * A boolean value. If true, requests belt Status data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *beltStatus;

/**
 * A boolean value. If true, requests body Information data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *bodyInformation;

/**
 * A boolean value. If true, requests device Status data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *deviceStatus;

/**
 * A boolean value. If true, requests driver Braking data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverBraking;

/**
 * A boolean value. If true, requests wiper Status data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *wiperStatus;

/**
 * A boolean value. If true, requests Head Lamp Status data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headLampStatus;

/**
 * A boolean value. If true, requests Engine Torque data
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *engineTorque;

/**
 * A boolean value. If true, means the accPedalPosition data has been
 * subscribed.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *accPedalPosition;

/**
 * A boolean value. If true, means the steeringWheelAngle data has been
 * subscribed.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *steeringWheelAngle;

/**
 If true, the Emergency Call notification and confirmation data has been subscribed
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *eCallInfo;

/**
 If true, the status of the air bags has been subscribed
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *airbagStatus;

/**
 If true, information related to an emergency event (and if it occurred) has been subscribed
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *emergencyEvent;

/**
 If true, the status modes of the cluster have been subscribed
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *clusterModeStatus;

/**
 If true, information related to the MyKey feature has been subscribed
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *myKey;

@end

NS_ASSUME_NONNULL_END
