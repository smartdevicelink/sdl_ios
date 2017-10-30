//  SDLGetVehicleDataResponse.h
//

#import "SDLRPCResponse.h"

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
 * Get Vehicle Data Response is sent, when SDLGetVehicleData has been called
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetVehicleDataResponse : SDLRPCResponse

/**
 * @abstract A SDLGPSData* value. See GPSData.
 */
@property (nullable, strong, nonatomic) SDLGPSData *gps;

/**
 * @abstract The vehicle speed in kilometers per hour.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *speed;

/**
 * @abstract The number of revolutions per minute of the engine.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *rpm;

/**
 * @abstract The fuel level in the tank (percentage)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *fuelLevel;

/**
 * @abstract A SDLComponentVolumeStatus* value. The fuel level state.
 */
@property (nullable, strong, nonatomic) SDLComponentVolumeStatus fuelLevel_State;

/**
 * @abstract The instantaneous fuel consumption in microlitres.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *instantFuelConsumption;

/**
 * @abstract The external temperature in degrees celsius.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *externalTemperature;

/**
 * @abstract The Vehicle Identification Number
 */
@property (nullable, strong, nonatomic) NSString *vin;

/**
 * @abstract See PRNDL.
 */
@property (nullable, strong, nonatomic) SDLPRNDL prndl;

/**
 * @abstract A SDLTireStatus* value. See TireStatus.
 */
@property (nullable, strong, nonatomic) SDLTireStatus *tirePressure;

/**
 * @abstract Odometer reading in km.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *odometer;

/**
 * @abstract A SDLBeltStatus* value. The status of the seat belts.
 */
@property (nullable, strong, nonatomic) SDLBeltStatus *beltStatus;

/**
 * @abstract A SDLBodyInformation* value. The body information including power modes.
 */
@property (nullable, strong, nonatomic) SDLBodyInformation *bodyInformation;

/**
 * @abstract A SDLDeviceStatus* value. The device status including signal and battery strength.
 */
@property (nullable, strong, nonatomic) SDLDeviceStatus *deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property (nullable, strong, nonatomic) SDLVehicleDataEventStatus driverBraking;

/**
 * @abstract A SDLWiperStatus* value. The status of the wipers.
 */
@property (nullable, strong, nonatomic) SDLWiperStatus wiperStatus;

/**
 * @abstract A SDLHeadLampStatus* value. Status of the head lamps.
 */
@property (nullable, strong, nonatomic) SDLHeadLampStatus *headLampStatus;

/**
 * @abstract Torque value for engine (in Nm) on non-diesel variants.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *engineTorque;

/**
 * @abstract Accelerator pedal position (percentage depressed)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *accPedalPosition;

/**
 * @abstract Current angle of the steering wheel (in deg)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *steeringWheelAngle;
@property (nullable, strong, nonatomic) SDLECallInfo *eCallInfo;
@property (nullable, strong, nonatomic) SDLAirbagStatus *airbagStatus;
@property (nullable, strong, nonatomic) SDLEmergencyEvent *emergencyEvent;
@property (nullable, strong, nonatomic) SDLClusterModeStatus *clusterModeStatus;
@property (nullable, strong, nonatomic) SDLMyKey *myKey;

@end

NS_ASSUME_NONNULL_END
