//  SDLGetVehicleDataResponse.h
//

#import "SDLRPCResponse.h"

#import "SDLComponentVolumeStatus.h"
#import "SDLElectronicParkBrakeStatus.h"
#import "SDLPRNDL.h"
#import "SDLTurnSignal.h"
#import "SDLVehicleDataEventStatus.h"
#import "SDLWiperStatus.h"

@class SDLAirbagStatus;
@class SDLBeltStatus;
@class SDLBodyInformation;
@class SDLClusterModeStatus;
@class SDLDeviceStatus;
@class SDLECallInfo;
@class SDLEmergencyEvent;
@class SDLFuelRange;
@class SDLGPSData;
@class SDLHeadLampStatus;
@class SDLMyKey;
@class SDLTireStatus;


/**
 * Response to SDLGetVehicleData
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetVehicleDataResponse : SDLRPCResponse

/**
  The car current GPS coordinates
 */
@property (nullable, strong, nonatomic) SDLGPSData *gps;

/**
 The vehicle speed in kilometers per hour
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *speed;

/**
 The number of revolutions per minute of the engine.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *rpm;

/**
 The fuel level in the tank (percentage)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *fuelLevel;

/**
 The fuel level state
 */
@property (nullable, strong, nonatomic) SDLComponentVolumeStatus fuelLevel_State;

/**
 The estimate range in KM the vehicle can travel based on fuel level and consumption

 Optional, Array of length 0 - 100, of SDLFuelRange
 */
@property (nullable, strong, nonatomic) NSArray<SDLFuelRange *> *fuelRange;

/**
 The instantaneous fuel consumption in microlitres
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *instantFuelConsumption;

/**
 The external temperature in degrees celsius.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *externalTemperature;

/**
 The Vehicle Identification Number
 */
@property (nullable, strong, nonatomic) NSString *vin;

/**
 The current gear shift state of the user's vehicle
 */
@property (nullable, strong, nonatomic) SDLPRNDL prndl;

/**
 The current pressure warnings for the user's vehicle
 */
@property (nullable, strong, nonatomic) SDLTireStatus *tirePressure;

/**
 Odometer reading in km
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *odometer;

/**
 The status of the seat belts
 */
@property (nullable, strong, nonatomic) SDLBeltStatus *beltStatus;

/**
 The body information including power modes
 */
@property (nullable, strong, nonatomic) SDLBodyInformation *bodyInformation;

/**
 The IVI system status including signal and battery strength
 */
@property (nullable, strong, nonatomic) SDLDeviceStatus *deviceStatus;

/**
 The status of the brake pedal
 */
@property (nullable, strong, nonatomic) SDLVehicleDataEventStatus driverBraking;

/**
 The status of the wipers
 */
@property (nullable, strong, nonatomic) SDLWiperStatus wiperStatus;

/**
 Status of the head lamps
 */
@property (nullable, strong, nonatomic) SDLHeadLampStatus *headLampStatus;

/**
 The estimated percentage (0% - 100%) of remaining oil life of the engine
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *engineOilLife;

/**
 Torque value for engine (in Nm) on non-diesel variants
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *engineTorque;

/**
 Accelerator pedal position (percentage depressed)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *accPedalPosition;

/**
 Current angle of the steering wheel (in deg)
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *steeringWheelAngle;

/**
 Emergency Call notification and confirmation data
 */
@property (nullable, strong, nonatomic) SDLECallInfo *eCallInfo;

/**
 The status of the air bags
 */
@property (nullable, strong, nonatomic) SDLAirbagStatus *airbagStatus;

/**
 Information related to an emergency event (and if it occurred)
 */
@property (nullable, strong, nonatomic) SDLEmergencyEvent *emergencyEvent;

/**
 The status modes of the cluster
 */
@property (nullable, strong, nonatomic) SDLClusterModeStatus *clusterModeStatus;

/**
 Information related to the MyKey feature
 */
@property (nullable, strong, nonatomic) SDLMyKey *myKey;

/**
 The status of the electronic parking brake
 */
@property (nullable, strong, nonatomic) SDLElectronicParkBrakeStatus electronicParkBrakeStatus;

/**
 The status of the turn signal
 */
@property (nullable, strong, nonatomic) SDLTurnSignal turnSignal;


@end

NS_ASSUME_NONNULL_END
