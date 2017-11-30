//  SDLVehicleDataType.h
//


#import "SDLEnum.h"

/**
 * Defines the vehicle data types that can be published and/or subscribed to using SDLSubscribeVehicleData
 */
typedef SDLEnum SDLVehicleDataType SDL_SWIFT_ENUM;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_GPS*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeGPS;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_SPEED*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeSpeed;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_RPM*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeRPM;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_FUELLEVEL*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelLevel;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_FUELLEVEL_STATE*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelLevelState;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_FUELCONSUMPTION*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelConsumption;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_EXTERNTEMP*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeExternalTemperature;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_VIN*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVIN;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_PRNDL*
 */
extern SDLVehicleDataType const SDLVehicleDataTypePRNDL;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_TIREPRESSURE*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeTirePressure;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_ODOMETER*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeOdometer;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_BELTSTATUS*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBeltStatus;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_BODYINFO*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBodyInfo;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_DEVICESTATUS*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeDeviceStatus;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_ECALLINFO*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeECallInfo;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_AIRBAGSTATUS*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeAirbagStatus;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_EMERGENCYEVENT*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEmergencyEvent;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_CLUSTERMODESTATUS*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeClusterModeStatus;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_MYKEY*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeMyKey;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_BRAKING*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBraking;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_WIPERSTATUS*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeWiperStatus;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_HEADLAMPSTATUS*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeHeadlampStatus;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_BATTVOLTAGE*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBatteryVoltage;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_ENGINETORQUE*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEngineTorque;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_ACCPEDAL*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeAccelerationPedal;

/**
 * @abstract SDLVehicleDataType: *VEHICLEDATA_STEERINGWHEEL*
 */
extern SDLVehicleDataType const SDLVehicleDataTypeSteeringWheel;
