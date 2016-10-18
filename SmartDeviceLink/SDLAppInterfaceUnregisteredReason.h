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
 * @abstract Vehicle ignition turned off.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonIgnitionOff;

/**
 * @abstract Bluetooth was turned off, causing termination of a necessary Bluetooth connection.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonBluetoothOff;

/**
 * @abstract USB was disconnected, causing termination of a necessary iAP connection.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonUSBDisconnected;

/**
 * @abstract Application attempted SmartDeviceLink RPC request while HMILevel = NONE. App must have HMILevel other than NONE to issue RPC requests or get notifications or RPC responses.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonRequestWhileInNoneHMILevel;

/**
 * @abstract Either too many -- or too many per unit of time -- requests were made by the application.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonTooManyRequests;

/**
 * @abstract The application has issued requests which cause driver distraction rules to be violated.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonDriverDistractionViolation;

/**
 *  @abstract The user performed a language change on the SDL platform, causing the application to need to be reregistered for the new language.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonLanguageChange;

/**
 * @abstract The user performed a MASTER RESET on the SDL platform, causing removal of a necessary Bluetooth pairing.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonMasterReset;

/**
 * @abstract The user restored settings to FACTORY DEFAULTS on the SDL platform.
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonFactoryDefaults;

/**
 * @abstract The app is not being authorized to be connected to SDL.
 *
 * @since SDL 2.0
 */
extern SDLAppInterfaceUnregisteredReason const SDLAppInterfaceUnregisteredReasonAppUnauthorized;
