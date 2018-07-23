//  SDLVehicleDataType.h
//


#import "SDLEnum.h"

/**
 * Defines the vehicle data types that can be published and/or subscribed to using SDLSubscribeVehicleData. Used in VehicleDataResult
 */
typedef SDLEnum SDLVehicleDataType SDL_SWIFT_ENUM;

/**
 GPS vehicle data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeGPS;

/**
 Vehicle speed data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeSpeed;

/**
 Vehicle RPM data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeRPM;

/**
 Vehicle fuel level data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelLevel;

/**
 Vehicle fuel level state data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelLevelState;

/**
 Vehicle fuel consumption data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelConsumption;

/**
 Vehicle external temperature data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeExternalTemperature;

/**
 Vehicle VIN data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVIN;

/**
 Vehicle PRNDL data
 */
extern SDLVehicleDataType const SDLVehicleDataTypePRNDL;

/**
 Vehicle tire pressure data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeTirePressure;

/**
 Vehicle odometer data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeOdometer;

/**
 Vehicle belt status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBeltStatus;

/**
 Vehicle body info data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBodyInfo;

/**
 Vehicle device status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeDeviceStatus;

/**
 Vehicle emergency call info data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeECallInfo;

/**
 Vehicle fuel range data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelRange;

/**
 Vehicle airbag status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeAirbagStatus;

/**
 Vehicle emergency event info
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEmergencyEvent;

/**
 Vehicle cluster mode status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeClusterModeStatus;

/**
 Vehicle MyKey data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeMyKey;

/**
 Vehicle braking data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBraking;

/**
 Vehicle wiper status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeWiperStatus;

/**
 Vehicle headlamp status
 */
extern SDLVehicleDataType const SDLVehicleDataTypeHeadlampStatus;

/**
 Vehicle battery voltage data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBatteryVoltage;

/**
 Vehicle engine oil life data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEngineOilLife;

/**
 Vehicle engine torque data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEngineTorque;

/**
 Vehicle accleration pedal data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeAccelerationPedal;

/**
 Vehicle steering wheel data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeSteeringWheel;

/**
 Vehicle electronic parking brake status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeElectronicParkBrakeStatus;

/**
 Vehicle turn signal data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeTurnSignal;
