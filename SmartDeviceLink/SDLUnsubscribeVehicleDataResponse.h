//  SDLUnsubscribeVehicleDataResponse.h
//

#import "SDLRPCResponse.h"

@class SDLVehicleDataResult;


NS_ASSUME_NONNULL_BEGIN

/**
 Response to UnsubscribeVehicleData

 since SmartDeviceLink 2.0
 */
@interface SDLUnsubscribeVehicleDataResponse : SDLRPCResponse

/**
 * Convenience init for setting all possible values on vehicle data items.
 *
 * @param gps - gps
 * @param speed - speed
 * @param rpm - rpm
 * @param instantFuelConsumption - instantFuelConsumption
 * @param fuelRange - fuelRange
 * @param externalTemperature - externalTemperature
 * @param turnSignal - turnSignal
 * @param gearStatus - gearStatus
 * @param tirePressure - tirePressure
 * @param odometer - odometer
 * @param beltStatus - beltStatus
 * @param bodyInformation - bodyInformation
 * @param deviceStatus - deviceStatus
 * @param driverBraking - driverBraking
 * @param wiperStatus - wiperStatus
 * @param headLampStatus - headLampStatus
 * @param engineTorque - engineTorque
 * @param accPedalPosition - accPedalPosition
 * @param steeringWheelAngle - steeringWheelAngle
 * @param engineOilLife - engineOilLife
 * @param electronicParkBrakeStatus - electronicParkBrakeStatus
 * @param cloudAppVehicleID - cloudAppVehicleID
 * @param eCallInfo - eCallInfo
 * @param airbagStatus - airbagStatus
 * @param emergencyEvent - emergencyEvent
 * @param clusterModes - clusterModes
 * @param myKey - myKey
 * @param handsOffSteering - handsOffSteering
 * @return A SDLUnsubscribeVehicleDataResponse object
 */
- (instancetype)initWithGps:(nullable SDLVehicleDataResult *)gps speed:(nullable SDLVehicleDataResult *)speed rpm:(nullable SDLVehicleDataResult *)rpm instantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption fuelRange:(nullable SDLVehicleDataResult *)fuelRange externalTemperature:(nullable SDLVehicleDataResult *)externalTemperature turnSignal:(nullable SDLVehicleDataResult *)turnSignal gearStatus:(nullable SDLVehicleDataResult *)gearStatus tirePressure:(nullable SDLVehicleDataResult *)tirePressure odometer:(nullable SDLVehicleDataResult *)odometer beltStatus:(nullable SDLVehicleDataResult *)beltStatus bodyInformation:(nullable SDLVehicleDataResult *)bodyInformation deviceStatus:(nullable SDLVehicleDataResult *)deviceStatus driverBraking:(nullable SDLVehicleDataResult *)driverBraking wiperStatus:(nullable SDLVehicleDataResult *)wiperStatus headLampStatus:(nullable SDLVehicleDataResult *)headLampStatus engineTorque:(nullable SDLVehicleDataResult *)engineTorque accPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition steeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle engineOilLife:(nullable SDLVehicleDataResult *)engineOilLife electronicParkBrakeStatus:(nullable SDLVehicleDataResult *)electronicParkBrakeStatus cloudAppVehicleID:(nullable SDLVehicleDataResult *)cloudAppVehicleID eCallInfo:(nullable SDLVehicleDataResult *)eCallInfo airbagStatus:(nullable SDLVehicleDataResult *)airbagStatus emergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent clusterModes:(nullable SDLVehicleDataResult *)clusterModes myKey:(nullable SDLVehicleDataResult *)myKey handsOffSteering:(nullable SDLVehicleDataResult *)handsOffSteering;

/**
 The result of requesting to unsubscribe to the GearStatus.
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *gearStatus;

/**
 The result of requesting to unsubscribe to the GPSData.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *gps;

/**
 The result of requesting to unsubscribe to the vehicle speed in kilometers per hour.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *speed;

/**
 The result of requesting to unsubscribe to the number of revolutions per minute of the engine.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *rpm;

/**
 The result of requesting to unsubscribe to the fuel level in the tank (percentage)

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelLevel __deprecated_msg("use fuelRange instead on 7.0+ RPC version connections");

/**
 The result of requesting to unsubscribe to the fuel level state.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelLevel_State __deprecated_msg("use fuelRange instead on 7.0+ RPC version connections");

/**
 The result of requesting to unsubscribe to the fuel range.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *fuelRange;

/**
 The result of requesting to unsubscribe to the instantaneous fuel consumption in microlitres.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *instantFuelConsumption;

/**
 The result of requesting to unsubscribe to the external temperature in degrees celsius.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *externalTemperature;

/**
 The result of requesting to unsubscribe to the PRNDL status.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *prndl __deprecated_msg("use gearStatus instead on 7.0+ RPC version connections");

/**
 The result of requesting to unsubscribe to the tireStatus.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *tirePressure;

/**
 The result of requesting to unsubscribe to the odometer in km.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *odometer;

/**
 The result of requesting to unsubscribe to the status of the seat belts.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *beltStatus;

/**
 The result of requesting to unsubscribe to the body information including power modes.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *bodyInformation;

/**
 The result of requesting to unsubscribe to the device status including signal and battery strength.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *deviceStatus;

/**
 The result of requesting to unsubscribe to the status of the brake pedal.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *driverBraking;

/**
 The result of requesting to unsubscribe to the status of the wipers.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *wiperStatus;

/**
 The result of requesting to unsubscribe from the status of driver hands are off the steering wheel
 */
@property (nullable, strong, nonatomic) SDLVehicleDataResult *handsOffSteering;

/**
 The result of requesting to unsubscribe to the status of the head lamps.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *headLampStatus;

/**
 The result of requesting to unsubscribe to the estimated percentage of remaining oil life of the engine.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *engineOilLife;

/**
 The result of requesting to unsubscribe to the torque value for engine (in Nm) on non-diesel variants.

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *engineTorque;

/**
 The result of requesting to unsubscribe to the accelerator pedal position (percentage depressed)

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *accPedalPosition;

/**
 The result of requesting to unsubscribe to the current angle of the steering wheel (in deg)

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *steeringWheelAngle;

/**
 The result of requesting to unsubscribe to the emergency call info

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *eCallInfo;

/**
 The result of requesting to unsubscribe to the airbag status

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *airbagStatus;

/**
 The result of requesting to unsubscribe to the emergency event

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *emergencyEvent;

/**
 The result of requesting to unsubscribe to the cluster modes

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *clusterModes;

/**
 The result of requesting to unsubscribe to the myKey status

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *myKey;

/**
 The result of requesting to unsubscribe to the electronic parking brake status

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *electronicParkBrakeStatus;

/**
 The result of requesting to unsubscribe to the turn signal

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *turnSignal;

/**
 The result of requesting to unsubscribe to the cloud app vehicle id

 Optional
 */
@property (strong, nonatomic, nullable) SDLVehicleDataResult *cloudAppVehicleID;

/**
 Sets the OEM custom vehicle data state for any given OEM custom vehicle data name.

 @param vehicleDataName The name of the OEM custom vehicle data item.
 @param vehicleDataState SDLVehicleDataResult object containing custom data type and result code information.

 Added SmartDeviceLink 6.0
 */
- (void)setOEMCustomVehicleData:(NSString *)vehicleDataName withVehicleDataState:(SDLVehicleDataResult *)vehicleDataState NS_SWIFT_NAME(setOEMCustomVehicleData(name:state:));

/**
 Gets the OEM custom vehicle data state for any given OEM custom vehicle data name.
 
 @param vehicleDataName The name of the OEM custom vehicle data item.
 @return SDLVehicleDataResult object containing custom data type and result code information.

 Added SmartDeviceLink 6.0
 */
- (nullable SDLVehicleDataResult *)getOEMCustomVehicleData:(NSString *)vehicleDataName;

@end

NS_ASSUME_NONNULL_END
