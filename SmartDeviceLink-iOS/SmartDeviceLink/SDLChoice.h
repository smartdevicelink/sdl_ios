//  SDLChoice.h
//

#import "SDLRPCMessage.h"

@class SDLImage;


/**
 * A choice is an option which a user can select either via the menu or via voice recognition (VR) during an application initiated interaction.
 * <p><b> Parameter List</b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>choiceID</td>
 * 			<td>NSNumber * </td>
 * 			<td>Application-scoped identifier that uniquely identifies this choice.
 *             <br/>Min: 0
 *				<br/>Max: 65535
 *			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>menuName</td>
 * 			<td>NSString * </td>
 * 			<td>Text which appears in menu, representing this choice.
 *				<br/>Min: 1
 *				<br/>Max: 100
 * 			</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>vrCommands</td>
 * 			<td>NSMutableArray *</td>
 * 			<td>An array of strings to be used as VR synonyms for this choice. If this array is provided, it must have at least one non-empty element</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *     <tr>
 * 			<td>image</td>
 * 			<td>SDLImage * </td>
 * 			<td>Either a static hex icon value or a binary image file  name identifier (sent by PutFile).</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * </table>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 */
@interface SDLChoice : SDLRPCStruct {}

/**
 * Constructs a newly allocated SDLChoice object
 */
-(instancetype) init;
/**
 * Constructs a newly allocated SDLChoice object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the application-scoped identifier that uniquely identifies this choice
 * @discussion <b>Note:</b>Min: 0  Max: 65535
 */
@property(strong) NSNumber* choiceID;
/**
 * @abstract Text which appears in menu, representing this choice
 *				<br/>Min: 1
 *				<br/>Max: 100
 * @discussion
 */
@property(strong) NSString* menuName;
/**
 * @abstract an array of strings to be used as VR synonyms for this choice
 * @discussion if this array is provided, it must have at least one non-empty element
 */
@property(strong) NSMutableArray* vrCommands;
/**
 * @abstract the image of the choice
 * @discussion
 */
@property(strong) SDLImage* image;
@property(strong) NSString* secondaryText;
@property(strong) NSString* tertiaryText;
@property(strong) SDLImage* secondaryImage;

@end
