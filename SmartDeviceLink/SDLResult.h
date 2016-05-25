//  SDLResult.h
//


#import "SDLEnum.h"

/**
 * Defines the possible result codes returned by SDL to the application in a response to a requested operation
 *
 * @since SDL 1.0
 */
@interface SDLResult : SDLEnum {
}

/**
 * @abstract get SDLResult according value string
 * @param value The value of the string to get an object for
 * @return SDLResult object
 */
+ (SDLResult *)valueOf:(NSString *)value;

/**
 @abstract declare an array to store all possible SDLResult values
 @return the array
 */
+ (NSArray *)values;

/**
 * @abstract The request succeeded
 */
+ (SDLResult *)SUCCESS;

/**
 * @abstract Result code : Invalid Data
 *
 * @discussion The data sent is invalid. For example:
 * <li>Invalid Json syntax</li>
 * <li>Parameters out of bounds (number or enum range)</li>
 * <li>Mandatory parameters not provided</li>
 * <li>Parameter provided with wrong type</li>
 * <li>Invalid characters</li>
 * <li>Empty string</li>
 */
+ (SDLResult *)INVALID_DATA;

+ (SDLResult *)CHAR_LIMIT_EXCEEDED;

/**
 * @abstract The request is not supported by SDL
 */
+ (SDLResult *)UNSUPPORTED_REQUEST;

/**
 * @abstract The system could not process the request because the necessary memory couldn't be allocated
 */
+ (SDLResult *)OUT_OF_MEMORY;

/**
 * @abstract There are too many requests pending (means that the response has not been delivered yet).
 *
 * @discussion There is a limit of 1000 pending requests at a time.
 */
+ (SDLResult *)TOO_MANY_PENDING_REQUESTS;

/**
 * @abstract One of the provided IDs is not valid.
 * @discussion For example:
 * <li>CorrelationID</li>
 * <li>CommandID</li>
 * <li>MenuID</li>
 */
+ (SDLResult *)INVALID_ID;

/**
 * @abstract The provided name or synonym is a duplicate of some already-defined name or synonym.
 */
+ (SDLResult *)DUPLICATE_NAME;

/**
 * There are already too many registered applications.
 */
+ (SDLResult *)TOO_MANY_APPLICATIONS;

/**
 * RegisterApplication has been called again, after a RegisterApplication was successful before.
 */
+ (SDLResult *)APPLICATION_REGISTERED_ALREADY;

/**
 * The Head Unit doesn't support the protocol that is requested by the mobile application.
 */
+ (SDLResult *)UNSUPPORTED_VERSION;

/**
 * The requested language is currently not supported. Might be because of a mismatch of the currently active language on the head unit and the requested language.
 */
+ (SDLResult *)WRONG_LANGUAGE;

/**
 * A command can not be executed because no application has been registered with RegisterApplication.
 */
+ (SDLResult *)APPLICATION_NOT_REGISTERED;

/**
 * The data may not be changed, because it is currently in use. For example when trying to delete a command set that is currently involved in an interaction.
 */
+ (SDLResult *)IN_USE;

/**
 * The user has turned off access to vehicle data, and it is globally unavailable to mobile applications.
 */
+ (SDLResult *)VEHICLE_DATA_NOT_ALLOWED;

/**
 * The requested vehicle data is not available on this vehicle or is not published.
 */
+ (SDLResult *)VEHICLE_DATA_NOT_AVAILABLE;

/**
 * The requested command was rejected, e.g. because mobile app is in background and cannot perform any HMI commands. Or an HMI command (e.g. Speak) is rejected because a higher priority HMI command (e.g. Alert) is playing.
 */
+ (SDLResult *)REJECTED;

/**
 * A command was aborted, for example due to user interaction (e.g. user pressed button). Or an HMI command (e.g. Speak) is aborted because a higher priority HMI command (e.g. Alert) was requested.
 */
+ (SDLResult *)ABORTED;

/**
 * A command was ignored, because the intended result is already in effect. For example, SetMediaClockTimer was used to pause the media clock although the clock is paused already.
 */
+ (SDLResult *)IGNORED;

/**
 *  A button that was requested for subscription is not supported under the current system.
 */
+ (SDLResult *)UNSUPPORTED_RESOURCE;

/**
 * A specified file could not be found on the head unit.
 */
+ (SDLResult *)FILE_NOT_FOUND;

/**
 * Provided data is valid but something went wrong in the lower layers.
 */
+ (SDLResult *)GENERIC_ERROR;

/**
 * RPC is not authorized in local policy table.
 */
+ (SDLResult *)DISALLOWED;

/**
 * RPC is included in a functional group explicitly blocked by the user.
 */
+ (SDLResult *)USER_DISALLOWED;

/**
 * Overlay reached the maximum timeout and closed.
 */
+ (SDLResult *)TIMED_OUT;

/**
 * User selected to Cancel Route.
 */
+ (SDLResult *)CANCEL_ROUTE;

/**
 * The RPC (e.g. ReadDID) executed successfully but the data exceeded the platform maximum threshold and thus, only part of the data is available.
 */
+ (SDLResult *)TRUNCATED_DATA;

/**
 * The user interrupted the RPC (e.g. PerformAudioPassThru) and indicated to start over. Note, the app must issue the new RPC.
 */
+ (SDLResult *)RETRY;

/**
 * The RPC (e.g. SubscribeVehicleData) executed successfully but one or more items have a warning or failure.
 */
+ (SDLResult *)WARNINGS;

/**
 * The RPC (e.g. Slider) executed successfully and the user elected to save the current position / value.
 */
+ (SDLResult *)SAVED;

/**
 * The certificate provided during authentication is invalid.
 */
+ (SDLResult *)INVALID_CERT;

/**
 * The certificate provided during authentication is expired.
 */
+ (SDLResult *)EXPIRED_CERT;

/**
 * The provided hash ID does not match the hash of the current set of registered data or the core could not resume the previous data.
 */
+ (SDLResult *)RESUME_FAILED;

@end
