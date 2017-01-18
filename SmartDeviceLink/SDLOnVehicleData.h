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
@interface SDLOnVehicleData : SDLRPCNotification

/**
 * @abstract A SDLGPSData* value. See GPSData.
 */
@property (strong, nonatomic) SDLGPSData *gps;

/**
 * @abstract The vehicle speed in kilometers per hour.
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *speed;

/**
 * @abstract The number of revolutions per minute of the engine.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *rpm;

/**
 * @abstract The fuel level in the tank (percentage)
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *fuelLevel;

/**
 * @abstract A SDLComponentVolumeStatus* value. The fuel level state.
 */
@property (strong, nonatomic) SDLComponentVolumeStatus fuelLevel_State;

/**
 * @abstract The instantaneous fuel consumption in microlitres.
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *instantFuelConsumption;

/**
 * @abstract The external temperature in degrees celsius.
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *externalTemperature;

/**
 * @abstract The Vehicle Identification Number
 */
@property (strong, nonatomic) NSString *vin;

/**
 * @abstract See PRNDL.
 */
@property (strong, nonatomic) SDLPRNDL prndl;

/**
 * @abstract A SDLTireStatus* value. See TireStatus.
 */
@property (strong, nonatomic) SDLTireStatus *tirePressure;

/**
 * @abstract Odometer reading in km.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *odometer;

/**
 * @abstract A SDLBeltStatus* value. The status of the seat belts.
 */
@property (strong, nonatomic) SDLBeltStatus *beltStatus;

/**
 * @abstract A SDLBodyInformation* value. The body information including power modes.
 */
@property (strong, nonatomic) SDLBodyInformation *bodyInformation;

/**
 * @abstract A SDLDeviceStatus* value. The device status including signal and battery strength.
 */
@property (strong, nonatomic) SDLDeviceStatus *deviceStatus;

/**
 * @abstract A SDLVehicleDataResult* value. The status of the brake pedal.
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverBraking;

/**
 * @abstract A SDLWiperStatus* value. The status of the wipers.
 */
@property (strong, nonatomic) SDLWiperStatus wiperStatus;

/**
 * @abstract A SDLHeadLampStatus* value. Status of the head lamps.
 */
@property (strong, nonatomic) SDLHeadLampStatus *headLampStatus;

/**
 * @abstract Torque value for engine (in Nm) on non-diesel variants.
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *engineTorque;

/**
 * @abstract Accelerator pedal position (percentage depressed)
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *accPedalPosition;

/**
 * @abstract Current angle of the steering wheel (in deg)
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *steeringWheelAngle;
@property (strong, nonatomic) SDLECallInfo *eCallInfo;
@property (strong, nonatomic) SDLAirbagStatus *airbagStatus;
@property (strong, nonatomic) SDLEmergencyEvent *emergencyEvent;
@property (strong, nonatomic) SDLClusterModeStatus *clusterModeStatus;
@property (strong, nonatomic) SDLMyKey *myKey;


@end
