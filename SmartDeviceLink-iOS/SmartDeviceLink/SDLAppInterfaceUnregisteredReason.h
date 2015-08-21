//  SDLAppInterfaceUnregisteredReason.h
//


#import "SDLEnum.h"

/**
 * Indicates reason why app interface was unregistered. The application is being disconnected by SDL.
 *
 * @since SDL 1.0
 */
@interface SDLAppInterfaceUnregisteredReason : SDLEnum {
}

/**
 * @abstract Convert String to SDLAppInterfaceUnregisteredReason
 *
 * @param value String value to retrieve the object for
 *
 * @return SDLAppInterfaceUnregisteredReason
 */
+ (SDLAppInterfaceUnregisteredReason *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLAppInterfaceUnregisteredReason
 *
 * @return an array that stores all possible SDLAppInterfaceUnregisteredReason
 */
+ (NSArray *)values;

/**
 * @abstract Vehicle ignition turned off.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *IGNITION_OFF*
 */
+ (SDLAppInterfaceUnregisteredReason *)IGNITION_OFF;

/**
 * @abstract Bluetooth was turned off, causing termination of a necessary Bluetooth connection.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *BLUETOOTH_OFF*
 */
+ (SDLAppInterfaceUnregisteredReason *)BLUETOOTH_OFF;

/**
 * @abstract USB was disconnected, causing termination of a necessary iAP connection.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *USB_DISCONNECTED*
 */
+ (SDLAppInterfaceUnregisteredReason *)USB_DISCONNECTED;

/**
 * @abstract Application attempted SmartDeviceLink RPC request while HMILevel = NONE. App must have HMILevel other than NONE to issue RPC requests or get notifications or RPC responses.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *REQUEST_WHILE_IN_NONE_HMI_LEVEL*
 */
+ (SDLAppInterfaceUnregisteredReason *)REQUEST_WHILE_IN_NONE_HMI_LEVEL;

/**
 * @abstract Either too many -- or too many per unit of time -- requests were made by the application.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *TOO_MANY_REQUESTS*
 */
+ (SDLAppInterfaceUnregisteredReason *)TOO_MANY_REQUESTS;

/**
 * @abstract The application has issued requests which cause driver distraction rules to be violated.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *DRIVER_DISTRACTION_VIOLATION*
 */
+ (SDLAppInterfaceUnregisteredReason *)DRIVER_DISTRACTION_VIOLATION;

/**
 *  @abstract The user performed a language change on the SDL platform, causing the application to need to be reregistered for the new language.
 *
 *  @return SDLAppInterfaceUnregisteredReason with value *LANGUAGE_CHANGE*
 */
+ (SDLAppInterfaceUnregisteredReason *)LANGUAGE_CHANGE;

/**
 * @abstract The user performed a MASTER RESET on the SDL platform, causing removal of a necessary Bluetooth pairing.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *MASTER_RESET*
 */
+ (SDLAppInterfaceUnregisteredReason *)MASTER_RESET;

/**
 * @abstract The user restored settings to FACTORY DEFAULTS on the SDL platform.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *FACTORY_DEFAULTS*
 */
+ (SDLAppInterfaceUnregisteredReason *)FACTORY_DEFAULTS;

/**
 * @abstract The app is not being authorized to be connected to SDL.
 *
 * @return SDLAppInterfaceUnregisteredReason with value *APP_UNAUTHORIZED*
 *
 * @since SDL 2.0
 */
+ (SDLAppInterfaceUnregisteredReason *)APP_UNAUTHORIZED;

@end
