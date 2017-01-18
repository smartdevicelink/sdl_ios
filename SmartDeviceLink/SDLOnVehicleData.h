//  SDLOnVehicleData.h
//

#import "SDLRPCNotification.h"

#import "SDLComponentVolumeStatus.h"
#import "SDLPRNDL.h"
#import "SDLVehicleDataEventStatus.h"
#import "SDLWiperStatus.h"

@class SDLAirbagStatus;
@class SDLBeltStatus;
@class SDLBodyInformation;
@class SDLClusterModeStatus;
@class SDLDeviceStatus;
@class SDLECallInfo;
@class SDLEmergencyEvent;
@class SDLGPSData;
@class SDLHeadLampStatus;
@class SDLMyKey;
@class SDLTireStatus;


/**
 * Request vehicle data.
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnVehicleData : SDLRPCNotification

/**
 * @abstract A SDLGPSData* value. See GPSData.
 */
@property (nullable, strong) SDLGPSData *gps;

/**
 * @abstract The vehicle speed in kilometers per hour.
 */
@property (nullable, strong) NSNumber<SDLFloat> *speed;

/**
 * @abstract The number of revolutions per minute of the engine.
 */
@property (nullable, strong) NSNumber<SDLInt> *rpm;

/**
 * @abstract The fuel level in the tank (percentage)
 */
@property (nullable, strong) NSNumber<SDLFloat> *fuelLevel;

/**
 * @abstract A SDLComponentVolumeStatus* value. The fuel level state.
 */
@property (nullable, strong) SDLComponentVolumeStatus fuelLevel_State;

/**
 * @abstract The instantaneous fuel consumption in microlitres.
 */
@property (nullable, strong) NSNumber<SDLFloat> *instantFuelConsumption;

/**
 * @abstract The external temperature in degrees celsius.
 */
@property (nullable, strong) NSNumber<SDLFloat> *externalTemperature;

/**
 * @abstract The Vehicle Identification Number
 */
@property (nullable, strong) NSString *vin;

/**
 * @abstract See PRNDL.
 */
@property (nullable, strong) SDLPRNDL prndl;

/**
 * @abstract A SDLTireStatus* value. See TireStatus.
 */
@property (nullable, strong) SDLTireStatus *tirePressure;

/**
 * @abstract Odometer reading in km.
 */
@property (nullable, strong) NSNumber<SDLInt> *odometer;

/**
 * @abstract A SDLBeltStatus* value. The status of the seat belts.
 */
@property (nullable, strong) SDLBeltStatus *beltStatus;

/**
 * @abstract A SDLBodyInformation* value. The body information including power modes.
 */
@property (nullable, strong) SDLBodyInformation *bodyInformation;

/**
 * @abstract A SDLDeviceStatus* value. The device status including signal and battery strength.
 */
@property (nullable, strong) SDLDeviceStatus *deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property (nullable, strong) SDLVehicleDataEventStatus driverBraking;

/**
 * @abstract A SDLWiperStatus* value. The status of the wipers.
 */
@property (nullable, strong) SDLWiperStatus wiperStatus;

/**
 * @abstract A SDLHeadLampStatus* value. Status of the head lamps.
 */
@property (nullable, strong) SDLHeadLampStatus *headLampStatus;

/**
 * @abstract Torque value for engine (in Nm) on non-diesel variants.
 */
@property (nullable, strong) NSNumber<SDLFloat> *engineTorque;

/**
 * @abstract Accelerator pedal position (percentage depressed)
 */
@property (nullable, strong) NSNumber<SDLFloat> *accPedalPosition;

/**
 * @abstract Current angle of the steering wheel (in deg)
 */
@property (nullable, strong) NSNumber<SDLFloat> *steeringWheelAngle;
@property (nullable, strong) SDLECallInfo *eCallInfo;
@property (nullable, strong) SDLAirbagStatus *airbagStatus;
@property (nullable, strong) SDLEmergencyEvent *emergencyEvent;
@property (nullable, strong) SDLClusterModeStatus *clusterModeStatus;
@property (nullable, strong) SDLMyKey *myKey;


@end

NS_ASSUME_NONNULL_END
