//  SDLSubscribeVehicleDataResponse.h
//

#import "SDLRPCResponse.h"

@class SDLVehicleDataResult;


/**
 * Subscribe Vehicle Data Response is sent, when SDLSubscribeVehicleData has been called
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSubscribeVehicleDataResponse : SDLRPCResponse

/**
 * @abstract A SDLVehicleDataResult* value. See GPSData.
 */
@property (nullable, strong) SDLVehicleDataResult *gps;

/**
 * @abstract A SDLVehicleDataResult* value. The vehicle speed in kilometers per hour.
 */
@property (nullable, strong) SDLVehicleDataResult *speed;

/**
 * @abstract A SDLVehicleDataResult* value. The number of revolutions per minute of the engine.
 */
@property (nullable, strong) SDLVehicleDataResult *rpm;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level in the tank (percentage)
 */
@property (nullable, strong) SDLVehicleDataResult *fuelLevel;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level state.
 */
@property (nullable, strong) SDLVehicleDataResult *fuelLevel_State;

/**
 * @abstract A SDLVehicleDataResult* value. The instantaneous fuel consumption in microlitres.
 */
@property (nullable, strong) SDLVehicleDataResult *instantFuelConsumption;

/**
 * @abstract A SDLVehicleDataResult* value. The external temperature in degrees celsius.
 */
@property (nullable, strong) SDLVehicleDataResult *externalTemperature;

/**
 * @abstract A SDLVehicleDataResult* value. See PRNDL.
 */
@property (nullable, strong) SDLVehicleDataResult *prndl;

/**
 * @abstract A SDLVehicleDataResult* value. See TireStatus.
 */
@property (nullable, strong) SDLVehicleDataResult *tirePressure;

/**
 * @abstract A SDLVehicleDataResult* value. Odometer in km.
 */
@property (nullable, strong) SDLVehicleDataResult *odometer;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the seat belts.
 */
@property (nullable, strong) SDLVehicleDataResult *beltStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The body information including power modes.
 */
@property (nullable, strong) SDLVehicleDataResult *bodyInformation;

/**
 * @abstract A SDLVehicleDataResult* value. The device status including signal and battery strength.
 */
@property (nullable, strong) SDLVehicleDataResult *deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property (nullable, strong) SDLVehicleDataResult *driverBraking;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the wipers.
 */
@property (nullable, strong) SDLVehicleDataResult *wiperStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Status of the head lamps.
 */
@property (nullable, strong) SDLVehicleDataResult *headLampStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Torque value for engine (in Nm) on non-diesel variants.
 */
@property (nullable, strong) SDLVehicleDataResult *engineTorque;

/**
 * @abstract A SDLVehicleDataResult* value. Accelerator pedal position (percentage depressed)
 */
@property (nullable, strong) SDLVehicleDataResult *accPedalPosition;

/**
 * @abstract A SDLVehicleDataResult* value. Current angle of the steering wheel (in deg)
 */
@property (nullable, strong) SDLVehicleDataResult *steeringWheelAngle;
@property (nullable, strong) SDLVehicleDataResult *eCallInfo;
@property (nullable, strong) SDLVehicleDataResult *airbagStatus;
@property (nullable, strong) SDLVehicleDataResult *emergencyEvent;
@property (nullable, strong) SDLVehicleDataResult *clusterModes;
@property (nullable, strong) SDLVehicleDataResult *myKey;

@end

NS_ASSUME_NONNULL_END
