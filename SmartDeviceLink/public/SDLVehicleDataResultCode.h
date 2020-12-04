//  SDLVehicleDataResultCode.h
//


#import "SDLEnum.h"

/**
 Vehicle Data Result Code. Used in DIDResult.
 */
typedef SDLEnum SDLVehicleDataResultCode NS_TYPED_ENUM;

/**
 Individual vehicle data item / DTC / DID request or subscription successful
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeSuccess;

/**
 DTC / DID request successful, however, not all active DTCs or full contents of DID location available
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeTruncatedData;
   
/**
 This vehicle data item is not allowed for this app by SDL
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeDisallowed;

/**
 The user has not granted access to this type of vehicle data item at this time
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeUserDisallowed;

/**
 The ECU ID referenced is not a valid ID on the bus / system
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeInvalidId;

/**
 The requested vehicle data item / DTC / DID is not currently available or responding on the bus / system
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeVehicleDataNotAvailable;

/**
 The vehicle data item is already subscribed
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeDataAlreadySubscribed;

/**
 The vehicle data item cannot be unsubscribed because it is not currently subscribed
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeDataNotSubscribed;

/**
 The request for this item is ignored because it is already in progress
 */
extern SDLVehicleDataResultCode const SDLVehicleDataResultCodeIgnored;
