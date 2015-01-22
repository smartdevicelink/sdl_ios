//  SDLDisplayCapabilities.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLDisplayType.h>
#import <SmartDeviceLink/SDLScreenParams.h>

/**
 * Contains information about the display for the SDL system to which the application is currently connected.
 * <p><b> Parameter List </b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>displayType</td>
 * 			<td>SDLDisplayType * </td>
 * 			<td>The type of display
 *			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>textFields</td>
 * 			<td>NSMutableArray * </td>
 * 			<td>An array of TextField structures, each of which describes a field in the HMI which the application can write to using operations such as <i>SDLShow</i>, <i>SDLSetMediaClockTimer</i>, etc.
 *					 This array of TextField structures identify all the text fields to which the application can write on the current display (identified by DisplayType ).
 * 			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>mediaClockFormats</td>
 * 			<td>NSMutableArray * </td>
 * 			<td>An array of MediaClockFormat elements, defining the valid string formats used in specifying the contents of the media clock field</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>graphicSupported</td>
 * 			<td>NSNumber * </td>
 * 			<td>The display's persistent screen supports referencing a static or dynamic image.</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * </table>
 * Since <b>SmartDeviceLink 1.0</b><br>
 */
@interface SDLDisplayCapabilities : SDLRPCStruct {}

/**
 * Constructs a newly allocated SDLDisplayCapabilities object
 */
-(id) init;
/**
 * Constructs a newly allocated SDLDisplayCapabilities object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the type of display
 * @discussion
 */
@property(strong) SDLDisplayType* displayType;
/**
 * @abstract an array of SDLTextField structures, each of which describes a field in the HMI which the application can write to using operations such as <i>SDLShow</i>, <i>SDLSetMediaClockTimer</i>, etc.
 * @discussion  This array of SDLTextField structures identify all the text fields to which the application can write on the current display (identified by SDLDisplayType ).
 */
@property(strong) NSMutableArray* textFields;
/**
 * @abstract an array of SDLImageField elements
 * @discussion A set of all fields that support images. See SDLImageField.
 */
@property(strong) NSMutableArray* imageFields;
/**
 * @abstract an array of SDLMediaClockFormat elements, defining the valid string formats used in specifying the contents of the media clock field
 * @discussion
 */
@property(strong) NSMutableArray* mediaClockFormats;
/**
 * @abstract the display's persistent screen supports.
 * @discussion
 * Since <b>SmartDeviceLink 2.0</b>
 */
@property(strong) NSNumber* graphicSupported;
/**
 * @abstract Number of presets the screen supports.
 * @discussion The number of on-screen custom presets available (if any)
 */
@property(strong) NSMutableArray* templatesAvailable;
@property(strong) SDLScreenParams* screenParams;
@property(strong) NSNumber* numCustomPresetsAvailable;

@end
