//  SDLTextField.h
//

#import "SDLRPCMessage.h"

@class SDLCharacterSet;
@class SDLTextFieldName;


/**
 * Struct defining the characteristics of a displayed field on the HMI.
 * 
 * Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>name</td>
 * 			<td>TextFieldName</td>
 * 			<td>Enumeration identifying the field.	</td>
 * 			<td>SDL 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>characterSet</td>
 * 			<td>CharacterSet</td>
 * 			<td>The character set that is supported in this field.	</td>
 * 			<td>SDL 1.0</td>
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
 * 			<td>SDL 1.0</td>
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
 * 			<td>SDL 1.0</td>
 * 		</tr>
 * </table>
 *
 * @since SDL 1.0
 */
@interface SDLTextField : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLTextField object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLTextField object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use to construct the object
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The enumeration identifying the field.
 *
 * @see SDLTextFieldName
 *
 * Required
 */
@property (strong) SDLTextFieldName *name;

/**
 * @abstract The character set that is supported in this field.
 *
 * @see SDLCharacterSet
 *
 * Required
 */
@property (strong) SDLCharacterSet *characterSet;

/**
 * @abstract The number of characters in one row of this field.
 * 
 * Required, Integer 1 - 500
 */
@property (strong) NSNumber *width;

/**
 * @abstract The number of rows for this text field.
 * 
 * Required, Integer 1 - 8
 */
@property (strong) NSNumber *rows;

@end
