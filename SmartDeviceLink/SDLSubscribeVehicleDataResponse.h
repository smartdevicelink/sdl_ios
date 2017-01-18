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
@property (strong, nonatomic, nullable) SDLVehicleDataResult *gps;

/**
 * @abstract A SDLVehicleDataResult* value. The vehicle speed in kilometers per hour.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *speed;

/**
 * @abstract A SDLVehicleDataResult* value. The number of revolutions per minute of the engine.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *rpm;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level in the tank (percentage)
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelLevel;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level state.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelLevel_State;

/**
 * @abstract A SDLVehicleDataResult* value. The instantaneous fuel consumption in microlitres.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *instantFuelConsumption;

/**
 * @abstract A SDLVehicleDataResult* value. The external temperature in degrees celsius.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *externalTemperature;

/**
 * @abstract A SDLVehicleDataResult* value. See PRNDL.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *prndl;

/**
 * @abstract A SDLVehicleDataResult* value. See TireStatus.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *tirePressure;

/**
 * @abstract A SDLVehicleDataResult* value. Odometer in km.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *odometer;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the seat belts.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *beltStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The body information including power modes.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *bodyInformation;

/**
 * @abstract A SDLVehicleDataResult* value. The device status including signal and battery strength.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *driverBraking;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the wipers.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *wiperStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Status of the head lamps.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *headLampStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Torque value for engine (in Nm) on non-diesel variants.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *engineTorque;

/**
 * @abstract A SDLVehicleDataResult* value. Accelerator pedal position (percentage depressed)
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *accPedalPosition;

/**
 * @abstract A SDLVehicleDataResult* value. Current angle of the steering wheel (in deg)
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *steeringWheelAngle;
@property (strong, nonatomic, nullable) SDLVehicleDataResult *eCallInfo;
@property (strong, nonatomic, nullable) SDLVehicleDataResult *airbagStatus;
@property (strong, nonatomic, nullable) SDLVehicleDataResult *emergencyEvent;
@property (strong, nonatomic, nullable) SDLVehicleDataResult *clusterModes;
@property (strong, nonatomic, nullable) SDLVehicleDataResult *myKey;

@end

NS_ASSUME_NONNULL_END
