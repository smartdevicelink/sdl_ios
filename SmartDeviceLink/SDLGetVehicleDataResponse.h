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
 * initializes a new allocated object of the SDLGetVehicleDataResponse class
 *
 *  @param accPedalPosition  Accelerator pedal position (percentage depressed), optional
 *  @param airbagStatus The status of the air bags, optional
 *  @param beltStatus  The status of the seat belts, optional
 *  @param bodyInformation The body information including power modes, optional
 *  @param cloudAppVehicleID The cloud app vehicle ID, optional
 *  @param clusterModeStatus The status modes of the cluster, optional
 *  @param deviceStatus The IVI system status including signal and battery strength, optional
 *  @param driverBraking The status of the brake pedal, optional
 *  @param eCallInfo Emergency Call notification and confirmation data, optional
 *  @param electronicParkBrakeStatus The status of the electronic parking brake, optional
 *  @param emergencyEvent Information related to an emergency event (and if it occurred), optional
 *  @param engineOilLife The estimated percentage (0% - 100%) of remaining oil life of the engine, optional
 *  @param engineTorque Torque value for engine (in Nm) on non-diesel variants, optional
 *  @param externalTemperature The external temperature in degrees celsius., optional
 *  @param fuelRange The estimate range in KM the vehicle can travel based on fuel level and consumption. Optional, Array of length 0 - 100, of SDLFuelRange
 *  @param gps The car current GPS coordinates, optional
 *  @param handsOffSteering To indicate whether driver hands are off the steering wheel, optional
 *  @param headLampStatus Status of the head lamps, optional
 *  @param instantFuelConsumption The instantaneous fuel consumption in microlitres, optional
 *  @param myKey Information related to the MyKey feature, optional
 *  @param odometer Odometer reading in km, optional
 *  @param prndl The current gear shift state of the user's vehicle, optional
 *  @param rpm The number of revolutions per minute of the engine., optional
 *  @param speed The vehicle speed in kilometers per hour, optional
 *  @param steeringWheelAngle Current angle of the steering wheel (in deg), optional
 *  @param tirePressure The current pressure warnings for the user's vehicle, optional
 *  @param turnSignal The status of the turn signal, optional
 *  @param vin The Vehicle Identification Number, optional
 *  @param wiperStatus The status of the wipers, optional
 *
 * @return an initialized object of the SDLGetVehicleDataResponse class or nil
 */
- (instancetype)initWithGps:(nullable SDLGPSData *)gps speed:(float)speed rpm:(nullable NSNumber<SDLUInt> *)rpm instantFuelConsumption:(float)instantFuelConsumption fuelRange:(nullable NSArray<SDLFuelRange *> *)fuelRange externalTemperature:(float)externalTemperature turnSignal:(nullable SDLTurnSignal)turnSignal vin:(nullable NSString *)vin prndl:(nullable SDLPRNDL)prndl tirePressure:(nullable SDLTireStatus *)tirePressure odometer:(nullable NSNumber<SDLUInt> *)odometer beltStatus:(nullable SDLBeltStatus *)beltStatus bodyInformation:(nullable SDLBodyInformation *)bodyInformation deviceStatus:(nullable SDLDeviceStatus *)deviceStatus driverBraking:(nullable SDLVehicleDataEventStatus)driverBraking wiperStatus:(nullable SDLWiperStatus)wiperStatus headLampStatus:(nullable SDLHeadLampStatus *)headLampStatus engineTorque:(float)engineTorque accPedalPosition:(float)accPedalPosition steeringWheelAngle:(float)steeringWheelAngle engineOilLife:(float)engineOilLife electronicParkBrakeStatus:(nullable SDLElectronicParkBrakeStatus)electronicParkBrakeStatus cloudAppVehicleID:(nullable NSString *)cloudAppVehicleID eCallInfo:(nullable SDLECallInfo *)eCallInfo airbagStatus:(nullable SDLAirbagStatus *)airbagStatus emergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent clusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus myKey:(nullable SDLMyKey *)myKey handsOffSteering:(nullable NSNumber<SDLBool> *)handsOffSteering;

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
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *fuelLevel __deprecated_msg("use fuelRange.level instead on 7.0+ RPC version connections");

/**
 The fuel level state
 */
@property (strong, nonatomic, nullable) SDLComponentVolumeStatus fuelLevel_State __deprecated_msg("use fuelRange.levelState instead on 7.0+ RPC version connections");

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
 To indicate whether driver hands are off the steering wheel
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *handsOffSteering;

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

/**
 The cloud app vehicle ID
 */
@property (nullable, strong, nonatomic) NSString *cloudAppVehicleID;

/**
 Sets the OEM custom vehicle data state for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @param vehicleDataState An object containing the OEM custom vehicle data item.

  Added in SmartDeviceLink 6.0
 */
- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(NSObject *)vehicleDataState NS_SWIFT_NAME(setOEMCustomVehicleData(name:state:));

/**
 Gets the OEM custom vehicle data item for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @return An OEM custom vehicle data object for the given vehicle data name.

  Added in SmartDeviceLink 6.0
 */
- (nullable NSObject *)getOEMCustomVehicleData:(NSString *)vehicleDataName;

@end

NS_ASSUME_NONNULL_END
