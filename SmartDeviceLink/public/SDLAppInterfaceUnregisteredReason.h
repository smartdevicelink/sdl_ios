//  SDLAppInterfaceUnregisteredReason.h
//


#import "SDLEnum.h"

/**
 * Indicates reason why app interface was unregistered. The application is being disconnected by SDL.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLAppInterfaceUnregisteredReason SDL_SWIFT_ENUM;


/**
 * Vehicle ignition turned off.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonIgnitionOff;

/**
 * Bluetooth was turned off, causing termination of a necessary Bluetooth connection.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonBluetoothOff;

/**
 * USB was disconnected, causing termination of a necessary iAP connection.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonUSBDisconnected;

/**
 * Application attempted SmartDeviceLink RPC request while HMILevel = NONE. App must have HMILevel other than NONE to issue RPC requests or get notifications or RPC responses.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonRequestWhileInNoneHMILevel;

/**
 * Either too many -- or too many per unit of time -- requests were made by the application.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonTooManyRequests;

/**
 * The application has issued requests which cause driver distraction rules to be violated.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonDriverDistractionViolation;

/**
 *  The user performed a language change on the SDL platform, causing the application to need to be reregistered for the new language.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonLanguageChange;

/**
 * The user performed a MASTER RESET on the SDL platform, causing removal of a necessary Bluetooth pairing.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonMasterReset;

/**
 * The user restored settings to FACTORY DEFAULTS on the SDL platform.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonFactoryDefaults;

/**
 * The app is not being authorized to be connected to SDL.
 *
 * @since SDL 2.0
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonAppUnauthorized;

/// The app could not register due to a protocol violation
///
/// @since RPC 4.0
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonProtocolViolation;

/// The HMI resource is unsupported
///
/// @since RPC 4.1
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonUnsupportedHMIResource;


/// The application is unregistered due to hardware resource constraints. The system will shortly close the application to free up hardware resources.
///
/// @since RPC 7.0
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonResourceConstraint;
