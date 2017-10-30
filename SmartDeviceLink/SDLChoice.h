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
 * 			<td>NSArray *</td>
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
NS_ASSUME_NONNULL_BEGIN

@interface SDLChoice : SDLRPCStruct

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands;

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands image:(nullable SDLImage *)image secondaryText:(nullable NSString *)secondaryText secondaryImage:(nullable SDLImage *)secondaryImage tertiaryText:(nullable NSString *)tertiaryText;

/**
 * @abstract the application-scoped identifier that uniquely identifies this choice
 * 
 * Required, Integer 0 - 65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *choiceID;

/**
 * @abstract Text which appears in menu, representing this choice
 *
 * Required, Max string length 500 chars
 */
@property (strong, nonatomic) NSString *menuName;

/**
 * @abstract VR synonyms for this choice
 *
 * Required, Array of Strings, Array length 1 - 100, Max String length 99 chars
 */
@property (strong, nonatomic) NSArray<NSString *> *vrCommands;

/**
 * @abstract The image of the choice
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *image;

/**
 * @abstract Optional secondary text to display; e.g. address of POI in a search result entry
 *
 * Optional, Max String length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *secondaryText;

/**
 * @abstract Optional tertiary text to display; e.g. distance to POI for a search result entry
 *
 * Optional, Max String length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *tertiaryText;

/**
 * @abstract Optional secondary image for choice
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *secondaryImage;

@end

NS_ASSUME_NONNULL_END
