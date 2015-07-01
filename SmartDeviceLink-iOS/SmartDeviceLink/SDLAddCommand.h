//  SDLAddCommand.h


#import "SDLRPCRequest.h"

@class SDLMenuParams;
@class SDLImage;


/**
 * This class will add a command to the application's Command Menu SDLMenuParams
 *
 * A command will be added to the end of the list of elements in
 * the Command Menu under the following conditions:
 * <li>When a SDLCommand is added with no SDLMenuParams value provided</li>
 * <li>When a SDLMenuParams value is provided with a SDLMenuParam.position value
 * greater than or equal to the number of menu items currently defined in the
 * menu specified by the SDLMenuParam.parentID value</li>
 *
 * The set of choices which the application builds using SDLAddCommand can be a
 * mixture of:
 * <li>Choices having only VR synonym definitions, but no SDLMenuParams definitions
 * </li>
 * <li>Choices having only SDLMenuParams definitions, but no VR synonym definitions
 * </li>
 * <li>Choices having both SDLMenuParams and VR synonym definitions</li>
 *
 * HMILevel needs to be FULL, LIMITED or BACKGROUD
 *
 * @since SDL 1.0
 *
 * @see SDLDeleteCommand SDLAddSubMenu SDLDeleteSubMenu
 */
@interface SDLAddCommand : SDLRPCRequest {
}

/**
 * Constructs a new SDLAddCommand object
 */
- (instancetype)init;

/**
 * Constructs a new *SDLAddCommand* object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract A Unique Command ID that identifies the command
 *
 * @discussion Is returned in an *SDLOnCommand* notification to identify the command selected by the user
 *
 * Required, Integer, 0 - 2,000,000,000
 */
@property (strong) NSNumber *cmdID;

/**
 * @abstract a *SDLMenuParams* pointer which will defined the command and how it is added to the Command Menu
 *
 * @discussion  If provided, this will define the command and how it is added to the
 * Command Menu
 *
 * If null, commands will not be accessible through the HMI application menu
 *
 * Optional
 */
@property (strong) SDLMenuParams *menuParams;

/**
 * @abstract An array of strings to be used as VR synonyms for this command.
 *
 * @discussion If provided, defines one or more VR phrases the recognition of any of which triggers the *SDLOnCommand* notification with this cmdID
 *
 * If null, commands will not be accessible by voice commands (when the user hits push-to-talk)
 *
 * Optional, Array of Strings, Max String length 99 chars, Array size 1 - 100
 */
@property (strong) NSMutableArray *vrCommands;

/**
 * @abstract Image struct containing a static or dynamic icon
 *
 * @discussion If provided, defines the image to be be shown along with a command
 * 
 * If omitted on supported displays, no (or the default if applicable) icon will be displayed
 *
 * Optional
 */
@property (strong) SDLImage *cmdIcon;

@end
