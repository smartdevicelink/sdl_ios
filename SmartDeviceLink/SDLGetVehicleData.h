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
@interface SDLGetVehicleData : SDLRPCRequest

/**
 * @abstract A boolean value. If true, requests Gps data
 */
@property (strong) NSNumber<SDLBool> *gps;

/**
 * @abstract A boolean value. If true, requests speed data
 */
@property (strong) NSNumber<SDLBool> *speed;

/**
 * @abstract A boolean value. If true, requests rpm data
 */
@property (strong) NSNumber<SDLBool> *rpm;

/**
 * @abstract A boolean value. If true, requests FuelLevel data
 */
@property (strong) NSNumber<SDLBool> *fuelLevel;

/**
 * @abstract A boolean value. If true, requests fuelLevel_State data
 */
@property (strong) NSNumber<SDLBool> *fuelLevel_State;

/**
 * @abstract A boolean value. If true, requests instantFuelConsumption data
 */
@property (strong) NSNumber<SDLBool> *instantFuelConsumption;

/**
 * @abstract A boolean value. If true, requests externalTemperature data
 */
@property (strong) NSNumber<SDLBool> *externalTemperature;

/**
 * @abstract A boolean value. If true, requests Vehicle Identification Number
 */
@property (strong) NSNumber<SDLBool> *vin;

/**
 * @abstract A boolean value. If true, requests Currently selected gear data
 */
@property (strong) NSNumber<SDLBool> *prndl;

/**
 * @abstract A boolean value. If true, requests tire pressure status data
 */
@property (strong) NSNumber<SDLBool> *tirePressure;

/**
 * @abstract A boolean value. If true, requests odometer data
 */
@property (strong) NSNumber<SDLBool> *odometer;

/**
 * @abstract A boolean value. If true, requests belt Status data
 */
@property (strong) NSNumber<SDLBool> *beltStatus;

/**
 * @abstract A boolean value. If true, requests body Information data
 */
@property (strong) NSNumber<SDLBool> *bodyInformation;

/**
 * @abstract A boolean value. If true, requests device Status data
 */
@property (strong) NSNumber<SDLBool> *deviceStatus;

/**
 * @abstract A boolean value. If true, requests driver Braking data
 */
@property (strong) NSNumber<SDLBool> *driverBraking;

/**
 * @abstract A boolean value. If true, requests wiper Status data
 */
@property (strong) NSNumber<SDLBool> *wiperStatus;

/**
 * @abstract A boolean value. If true, requests Head Lamp Status data
 */
@property (strong) NSNumber<SDLBool> *headLampStatus;

/**
 * @abstract A boolean value. If true, requests Engine Torque data
 */
@property (strong) NSNumber<SDLBool> *engineTorque;

/**
 * @abstract A boolean value. If true, means the accPedalPosition data has been
 * subscribed.
 */
@property (strong) NSNumber<SDLBool> *accPedalPosition;

/**
 * @abstract A boolean value. If true, means the steeringWheelAngle data has been
 * subscribed.
 */
@property (strong) NSNumber<SDLBool> *steeringWheelAngle;
@property (strong) NSNumber<SDLBool> *eCallInfo;
@property (strong) NSNumber<SDLBool> *airbagStatus;
@property (strong) NSNumber<SDLBool> *emergencyEvent;
@property (strong) NSNumber<SDLBool> *clusterModeStatus;
@property (strong) NSNumber<SDLBool> *myKey;

@end
