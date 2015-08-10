//  SDLSubscribeVehicleDataResponse.h
//

#import "SDLRPCResponse.h"

@class SDLVehicleDataResult;


/**
 * Subscribe Vehicle Data Response is sent, when SDLSubscribeVehicleData has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLSubscribeVehicleDataResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLSubscribeVehicleDataResponse object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLSubscribeVehicleDataResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;


/**
 * @abstract A SDLVehicleDataResult* value. See GPSData.
 */
@property (strong) SDLVehicleDataResult *gps;

/**
 * @abstract A SDLVehicleDataResult* value. The vehicle speed in kilometers per hour.
 */
@property (strong) SDLVehicleDataResult *speed;

/**
 * @abstract A SDLVehicleDataResult* value. The number of revolutions per minute of the engine.
 */
@property (strong) SDLVehicleDataResult *rpm;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level in the tank (percentage)
 */
@property (strong) SDLVehicleDataResult *fuelLevel;

/**
 * @abstract A SDLVehicleDataResult* value. The fuel level state.
 */
@property (strong) SDLVehicleDataResult *fuelLevel_State;

/**
 * @abstract A SDLVehicleDataResult* value. The instantaneous fuel consumption in microlitres.
 */
@property (strong) SDLVehicleDataResult *instantFuelConsumption;

/**
 * @abstract A SDLVehicleDataResult* value. The external temperature in degrees celsius.
 */
@property (strong) SDLVehicleDataResult *externalTemperature;

/**
 * @abstract A SDLVehicleDataResult* value. See PRNDL.
 */
@property (strong) SDLVehicleDataResult *prndl;

/**
 * @abstract A SDLVehicleDataResult* value. See TireStatus.
 */
@property (strong) SDLVehicleDataResult *tirePressure;

/**
 * @abstract A SDLVehicleDataResult* value. Odometer in km.
 */
@property (strong) SDLVehicleDataResult *odometer;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the seat belts.
 */
@property (strong) SDLVehicleDataResult *beltStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The body information including power modes.
 */
@property (strong) SDLVehicleDataResult *bodyInformation;

/**
 * @abstract A SDLVehicleDataResult* value. The device status including signal and battery strength.
 */
@property (strong) SDLVehicleDataResult *deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property (strong) SDLVehicleDataResult *driverBraking;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the wipers.
 */
@property (strong) SDLVehicleDataResult *wiperStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Status of the head lamps.
 */
@property (strong) SDLVehicleDataResult *headLampStatus;

/**
 * @abstract A SDLVehicleDataResult* value. Torque value for engine (in Nm) on non-diesel variants.
 */
@property (strong) SDLVehicleDataResult *engineTorque;

/**
 * @abstract A SDLVehicleDataResult* value. Accelerator pedal position (percentage depressed)
 */
@property (strong) SDLVehicleDataResult *accPedalPosition;

/**
 * @abstract A SDLVehicleDataResult* value. Current angle of the steering wheel (in deg)
 */
@property (strong) SDLVehicleDataResult *steeringWheelAngle;
@property (strong) SDLVehicleDataResult *eCallInfo;
@property (strong) SDLVehicleDataResult *airbagStatus;
@property (strong) SDLVehicleDataResult *emergencyEvent;
@property (strong) SDLVehicleDataResult *clusterModes;
@property (strong) SDLVehicleDataResult *myKey;

@end
