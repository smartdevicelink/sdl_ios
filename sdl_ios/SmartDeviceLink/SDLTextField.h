//  SDLTextField.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLTextFieldName.h>
#import <SmartDeviceLink/SDLCharacterSet.h>

/**
 * Struct defining the characteristics of a displayed field on the HMI.
 * <p><b> Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>AppLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>name</td>
 * 			<td>TextFieldName</td>
 * 			<td>Enumeration identifying the field.	</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>characterSet</td>
 * 			<td>CharacterSet</td>
 * 			<td>The character set that is supported in this field.	</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>width</td>
 * 			<td>Int16</td>
 * 			<td>The number of characters in one row of this field.
 * 					<ul>
 *					<li>Minvalue="1"</li>
 *					<li>maxvalue="500"</li>
 *					</ul>
 *			</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>rows</td>
 * 			<td>Int16</td>
 * 			<td>The number of rows for this text field.
 * 					<ul>
 *					<li>Minvalue="1"</li>
 *					<li>maxvalue="3"</li>
 *					</ul>
 *			</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 *  </table>
 * Since AppLink 1.0
 */
@interface SDLTextField : SDLRPCStruct {}

/**
 * @abstract Constructs a newly allocated SDLTextField object
 */
-(id) init;
/**
 * @abstract Constructs a newly allocated SDLTextField object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The enumeration identifying the field.
 */
@property(strong) SDLTextFieldName* name;
/**
 * @abstract The character set that is supported in this field.
 */
@property(strong) SDLCharacterSet* characterSet;
/**
 * @abstract The number of characters in one row of this field.
 * 					<ul>
 *					<li>Minvalue="1"</li>
 *					<li>maxvalue="500"</li>
 *					</ul>
 */
@property(strong) NSNumber* width;
/**
 * @abstract The number of rows for this text field.
 * 					<ul>
 *					<li>Minvalue="1"</li>
 *					<li>maxvalue="3"</li>
 *					</ul>
 */
@property(strong) NSNumber* rows;

@end
