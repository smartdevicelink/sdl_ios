//  SDLAppInterfaceUnregisteredReason.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Indicates reason why app interface was unregistered. The application is being disconnected by SYNC.
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
@interface SDLAppInterfaceUnregisteredReason : SDLEnum {}

/**
 * @abstract Convert String to SDLAppInterfaceUnregisteredReason
 * @param value NSString
 * @result SDLAppInterfaceUnregisteredReason
 */
+(SDLAppInterfaceUnregisteredReason*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLAppInterfaceUnregisteredReason
 @result return an array that store all possible SDLAppInterfaceUnregisteredReason
 */
+(NSMutableArray*) values;

/**
 * @abstract  Vehicle ignition turned off.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>IGNITION_OFF</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) IGNITION_OFF;
/**
 * @abstract  Bluetooth was turned off, causing termination of a necessary Bluetooth connection.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>BLUETOOTH_OFF</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) BLUETOOTH_OFF;
/**
 * @abstract  USB was disconnected, causing termination of a necessary iAP connection.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>USB_DISCONNECTED</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) USB_DISCONNECTED;
/**
 * @abstract  Application attempted SmartDeviceLink RPC request while HMILevel
 * = NONE. App must have HMILevel other than NONE to issue RPC requests or
 * get notifications or RPC responses.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>REQUEST_WHILE_IN_NONE_HMI_LEVEL</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) REQUEST_WHILE_IN_NONE_HMI_LEVEL;
/**
 * @abstract  Either too many -- or too many per unit of time -- requests were made by
 * the application.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>TOO_MANY_REQUESTS</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) TOO_MANY_REQUESTS;
/**
 * @abstract  The application has issued requests which cause driver distraction rules
 * to be violated.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>DRIVER_DISTRACTION_VIOLATION</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) DRIVER_DISTRACTION_VIOLATION;
+(SDLAppInterfaceUnregisteredReason*) LANGUAGE_CHANGE;
/**
 * @abstract  The user performed a MASTER RESET on the SYNC platform, causing removal
 * of a necessary Bluetooth pairing.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>MASTER_RESET</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) MASTER_RESET;
/**
 * @abstract  The user restored settings to FACTORY DEFAULTS on the SYNC platform.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>FACTORY_DEFAULTS</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) FACTORY_DEFAULTS;
/**
 * @abstract  The app is not being authorized by Ford to be connected to SYNC.
 * @result SDLAppInterfaceUnregisteredReason with value <font color=gray><i>APP_UNAUTHORIZED</i></font>
 * @since <font color=red><b>SmartDeviceLink 2.0</b></font>
 */
+(SDLAppInterfaceUnregisteredReason*) APP_UNAUTHORIZED;

@end
