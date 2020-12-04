//  SDLResult.h
//


#import "SDLEnum.h"

/**
 * Defines the possible result codes returned by SDL to the application in a response to a requested operation. Used in RPC responses
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLResult NS_TYPED_ENUM;

/**
 * The request succeeded
 */
extern SDLResult const SDLResultSuccess;

/**
 The request contained invalid data

 The data sent is invalid. For example:

 Invalid JSON syntax

 Parameters out of bounds (number or enum range)

 Mandatory parameters not provided

 Parameter provided with wrong type

 Invalid characters

 Empty string
 */
extern SDLResult const SDLResultInvalidData;

/**
 The request had a string containing too many characters
 */
extern SDLResult const SDLResultCharacterLimitExceeded;

/**
 The request is not supported by the IVI unit implementing SDL
 */
extern SDLResult const SDLResultUnsupportedRequest;

/**
 The system could not process the request because the necessary memory couldn't be allocated
 */
extern SDLResult const SDLResultOutOfMemory;

/**
 There are too many requests pending (means that the response has not been delivered yet).

 There is a limit of 1000 pending requests at a time.
 */
extern SDLResult const SDLResultTooManyPendingRequests;

/**
 One of the provided IDs is not valid.

 For example: CorrelationID, CommandID, MenuID
 */
extern SDLResult const SDLResultInvalidId;

/**
 The provided name or synonym is a duplicate of some already-defined name or synonym.
 */
extern SDLResult const SDLResultDuplicateName;

/**
 There are already too many registered applications.
 */
extern SDLResult const SDLResultTooManyApplications;

/**
 RegisterAppInterface has been called, but this app is already registered
 */
extern SDLResult const SDLResultApplicationRegisteredAlready;

/**
 The Head Unit doesn't support the SDL version that is requested by the mobile application.
 */
extern SDLResult const SDLResultUnsupportedVersion;

/**
 The requested language is currently not supported. This might be because of a mismatch of the currently active language on the head unit and the requested language.
 */
extern SDLResult const SDLResultWrongLanguage;

/**
 A command can not be executed because no application has been registered with RegisterApplication.
 */
extern SDLResult const SDLResultApplicationNotRegistered;

/**
 The data may not be changed, because it is currently in use. For example when trying to delete a choice set that is currently involved in an interaction.
 */
extern SDLResult const SDLResultInUse;

/**
 The user has turned off access to vehicle data, and it is globally unavailable to mobile applications.
 */
extern SDLResult const SDLResultVehicleDataNotAllowed;

/**
 The requested vehicle data is not available on this vehicle or is not published.
 */
extern SDLResult const SDLResultVehicleDataNotAvailable;

/**
 The requested command was rejected, e.g. because the mobile app is in background and cannot perform any HMI commands, or an HMI command (e.g. Speak) is rejected because a higher priority HMI command (e.g. Alert) is playing.
 */
extern SDLResult const SDLResultRejected;

/**
 A command was aborted, e.g. due to user interaction (user pressed button), or an HMI command (e.g. Speak) is aborted because a higher priority HMI command (e.g. Alert) was requested.
 */
extern SDLResult const SDLResultAborted;

/**
 A command was ignored, because the intended result is already in effect. For example, SetMediaClockTimer was used to pause the media clock although the clock is paused already.
 */
extern SDLResult const SDLResultIgnored;

/**
 A button that was requested for subscription is not supported under the current system.
 */
extern SDLResult const SDLResultUnsupportedResource;

/**
 A specified file could not be found on the head unit.
 */
extern SDLResult const SDLResultFileNotFound;

/**
 Provided data is valid but something went wrong in the lower layers.
 */
extern SDLResult const SDLResultGenericError;

/**
 RPC is not authorized in local policy table.
 */
extern SDLResult const SDLResultDisallowed;

/**
 RPC is included in a functional group explicitly blocked by the user.
 */
extern SDLResult const SDLResultUserDisallowed;

/**
 * Overlay reached the maximum timeout and closed.
 */
extern SDLResult const SDLResultTimedOut;

/**
 * User selected to Cancel Route.
 */
extern SDLResult const SDLResultCancelRoute;

/**
 * The data sent failed to pass CRC check in receiver end.
 */
extern SDLResult const SDLResultCorruptedData;

/**
 The RPC (e.g. ReadDID) executed successfully but the data exceeded the platform maximum threshold and thus, only part of the data is available.
 */
extern SDLResult const SDLResultTruncatedData;

/**
 The user interrupted the RPC (e.g. PerformAudioPassThru) and indicated to start over. Note, the app must issue the new RPC.
 */
extern SDLResult const SDLResultRetry;

/**
 The RPC (e.g. SubscribeVehicleData) executed successfully but one or more items have a warning or failure.
 */
extern SDLResult const SDLResultWarnings;

/**
 The RPC (e.g. Slider) executed successfully and the user elected to save the current position / value.
 */
extern SDLResult const SDLResultSaved;

/**
 The certificate provided during authentication is invalid.
 */
extern SDLResult const SDLResultInvalidCertificate;

/**
 The certificate provided during authentication is expired.
 */
extern SDLResult const SDLResultExpiredCertificate;

/**
 The provided hash ID does not match the hash of the current set of registered data or the core could not resume the previous data.
 */
extern SDLResult const SDLResultResumeFailed;

/**
 The requested data is not available on this vehicle or is not published for the connected app.
 */
extern SDLResult const SDLResultDataNotAvailable;

/**
 The requested data is read only thus cannot be change via remote control .
 */
extern SDLResult const SDLResultReadOnly;

/**
 The RPC request needs to be encrypted.
 */
extern SDLResult const SDLResultEncryptionNeeded;
