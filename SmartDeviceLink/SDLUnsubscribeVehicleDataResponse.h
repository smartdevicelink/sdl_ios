//  SDLUnsubscribeVehicleDataResponse.h
//

#import "SDLRPCResponse.h"

@class SDLVehicleDataResult;


/**
 * Unsubscribe Vehicle Data Response is sent, when UnsubscribeVehicleData has been called
 *
 * @since SmartDeviceLink 2.0
 */
@interface SDLUnsubscribeVehicleDataResponse : SDLRPCResponse

/**
 * @abstract A SDLVehicleDataResult* value. See GPSData.
 */
@property (strong, nonatomic) SDLVehicleDataResult *gps;

/**
 * @abstract A SDLVehicleDataResult* value. The vehicle speed in kilometers per hour.
 */
@property (strong, nonatomic) SDLVehicleDataResult *speed;

/**
 * @abstract A SDLVehicleDataResult* value. The number of revolutions per minute of the engine.
 */
@property (strong, nonatomic) SDLVehicleDataResult *rpm;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level in the tank (percentage)
 */
@property (strong, nonatomic) SDLVehicleDataResult *fuelLevel;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level state.
 */
@property (strong, nonatomic) SDLVehicleDataResult *fuelLevel_State;

/**
 * @abstract A SDLVehicleDataResult* value. The instantaneous fuel consumption in microlitres.
 */
@property (strong, nonatomic) SDLVehicleDataResult *instantFuelConsumption;

/**
 * @abstract A SDLVehicleDataResult* value. The external temperature in degrees celsius.
 */
@property (strong, nonatomic) SDLVehicleDataResult *externalTemperature;

/**
 * @abstract A SDLVehicleDataResult* value. See PRNDL.
 */
@property (strong, nonatomic) SDLVehicleDataResult *prndl;

/**
 * @abstract A SDLVehicleDataResult* value. See TireStatus.
 */
@property (strong, nonatomic) SDLVehicleDataResult *tirePressure;

/**
 * @abstract A SDLVehicleDataResult* value. Odometer in km.
 */
@property (strong, nonatomic) SDLVehicleDataResult *odometer;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the seat belts.
 */
@property (strong, nonatomic) SDLVehicleDataResult *beltStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The body information including power modes.
 */
@property (strong, nonatomic) SDLVehicleDataResult *bodyInformation;

/**
 * @abstract A SDLVehicleDataResult* value. The device status including signal and battery strength.
 */
@property (strong, nonatomic) SDLVehicleDataResult *deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property (strong, nonatomic) SDLVehicleDataResult *driverBraking;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the wipers.
 */
@property (strong, nonatomic) SDLVehicleDataResult *wiperStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Status of the head lamps.
 */
@property (strong, nonatomic) SDLVehicleDataResult *headLampStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Torque value for engine (in Nm) on non-diesel variants.
 */
@property (strong, nonatomic) SDLVehicleDataResult *engineTorque;

/**
 * @abstract A SDLVehicleDataResult* value. Accelerator pedal position (percentage depressed)
 */
@property (strong, nonatomic) SDLVehicleDataResult *accPedalPosition;

/**
 * @abstract A SDLVehicleDataResult* value. Current angle of the steering wheel (in deg)
 */
@property (strong, nonatomic) SDLVehicleDataResult *steeringWheelAngle;
@property (strong, nonatomic) SDLVehicleDataResult *eCallInfo;
@property (strong, nonatomic) SDLVehicleDataResult *airbagStatus;
@property (strong, nonatomic) SDLVehicleDataResult *emergencyEvent;
@property (strong, nonatomic) SDLVehicleDataResult *clusterModes;
@property (strong, nonatomic) SDLVehicleDataResult *myKey;

@end
