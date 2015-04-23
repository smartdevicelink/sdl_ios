//  SDLVehicleDataType.h
//



#import "SDLEnum.h"

/**
 * Defines the vehicle data types that can be published and subscribed to
 *
 */
@interface SDLVehicleDataType : SDLEnum {}

/**
 * Convert String to SDLVehicleDataType
 * @param value String
 * @return SDLVehicleDataType
 */
+(SDLVehicleDataType*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLVehicleDataType
 @result return an array that store all possible SDLVehicleDataType
 */
+(NSArray*) values;

/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_GPS </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_GPS;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_SPEED </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_SPEED;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_RPM </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_RPM;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_FUELLEVEL </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_FUELLEVEL;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_FUELLEVEL_STATE </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_FUELLEVEL_STATE;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_FUELCONSUMPTION </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_FUELCONSUMPTION;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_EXTERNTEMP </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_EXTERNTEMP;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_VIN </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_VIN;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_PRNDL </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_PRNDL;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_TIREPRESSURE </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_TIREPRESSURE;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_ODOMETER </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_ODOMETER;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_BELTSTATUS </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_BELTSTATUS;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_BODYINFO </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_BODYINFO;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_DEVICESTATUS </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_DEVICESTATUS;
+(SDLVehicleDataType*) VEHICLEDATA_ECALLINFO;
+(SDLVehicleDataType*) VEHICLEDATA_AIRBAGSTATUS;
+(SDLVehicleDataType*) VEHICLEDATA_EMERGENCYEVENT;
+(SDLVehicleDataType*) VEHICLEDATA_CLUSTERMODESTATUS;
+(SDLVehicleDataType*) VEHICLEDATA_MYKEY;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_BRAKING </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_BRAKING;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_WIPERSTATUS </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_WIPERSTATUS;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_HEADLAMPSTATUS </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_HEADLAMPSTATUS;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_BATTVOLTAGE </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_BATTVOLTAGE;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_ENGINETORQUE </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_ENGINETORQUE;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_ACCPEDAL </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_ACCPEDAL;
/*!
 @abstract SDLVehicleDataType : <font color=gray><i> VEHICLEDATA_STEERINGWHEEL </i></font>
 */
+(SDLVehicleDataType*) VEHICLEDATA_STEERINGWHEEL;

@end

