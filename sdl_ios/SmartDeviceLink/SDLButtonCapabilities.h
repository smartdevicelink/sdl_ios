//  SDLButtonCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLButtonName.h>

/**
 * Provides information about the capabilities of a SYNC HMI button.
 * <p><b> Parameter List </b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>AppLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>name</td>
 * 			<td>SDLButtonName</td>
 * 			<td>The name of the SYNC HMI button.</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>shortPressAvailable</td>
 * 			<td>NSNumber * </td>
 * 			<td>The button supports a SHORT press. See SDLButtonPressMode for more information.</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>longPressAvailable</td>
 * 			<td>NSNumber * </td>
 * 			<td>The button supports a LONG press. See SDLButtonPressMode for more information.</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>upDownAvailable</td>
 * 			<td>NSNumber * </td>
 * 			<td>The button supports "button down" and "button up". When the button is depressed, the <i>SDLOnButtonEvent</i> notification will be invoked with a value of BUTTONDOWN.
 *                  <p> When the button is released, the <i>SDLOnButtonEvent</i> notification will be invoked with a value of BUTTONUP.</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 * </table>
 * Since <b>AppLink 1.0</b><br>
 */
@interface SDLButtonCapabilities : SDLRPCStruct {}

/**
 * Constructs a newly allocated SDLButtonCapabilities object
 */
-(id) init;
/**
 * Constructs a newly allocated SDLButtonCapabilities object indicated by the Hashtable parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The name of the SYNC HMI button.
 * @discussion
 */
@property(strong) SDLButtonName* name;
/**
 * @abstract A NSNumber value indicates whether the button supports a SHORT press
 * @discussion
 */
@property(strong) NSNumber* shortPressAvailable;
/**
 * @abstract A NSNumber value indicates whether the button supports a LONG press
 * @discussion
 */
@property(strong) NSNumber* longPressAvailable;
/**
 * @abstract A NSNumber value indicates whether the button supports "button down" and "button up"
 * @discussion
 */
@property(strong) NSNumber* upDownAvailable;

@end
