//  SDLAddCommand.h


#import "SDLRPCRequest.h"

@class SDLMenuParams;
@class SDLImage;


/**
 *
 * This class will add a command to the application's Command Menu SDLMenuParams<br>
 * <b>Note:</b> A command will be added to the end of the list of elements in
 * the Command Menu under the following conditions:
 * <li>When a SDLCommand is added with no SDLMenuParams value provided</li>
 * <li>When a SDLMenuParams value is provided with a SDLMenuParam.position value
 * greater than or equal to the number of menu items currently defined in the
 * menu specified by the SDLMenuParam.parentID value</li>
 * <br/>
 * The set of choices which the application builds using SDLAddCommand can be a
 * mixture of:
 * <li>Choices having only VR synonym definitions, but no SDLMenuParams definitions
 * </li>
 * <li>Choices having only SDLMenuParams definitions, but no VR synonym definitions
 * </li>
 * <li>Choices having both SDLMenuParams and VR synonym definitions</li>
 *
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUD</b>
 * </p>
 * Since <b>SDL 1.0</b><br>
 * see SDLDeleteCommand SDLAddSubMenu SDLDeleteSubMenu
 */
@interface SDLAddCommand : SDLRPCRequest {}

/**
 * Constructs a new SDLAddCommand object
 */
-(instancetype) init;
/**
 *
 * Constructs a new SDLAddCommand object indicated by the NSMutableDictionary
 * parameter
 *
 *
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract an Unique Command ID that identifies the command
 * @discussion Is returned in an <i>SDLOnCommand</i> notification to identify the command
 * selected by the user
 * <p>
 * <b>Notes:</b> Min Value: 0; Max Value: 2000000000
 */
@property(strong) NSNumber* cmdID;
/**
 * @abstract a <I>SDLMenuParams</I> pointer which will defined the command and how
 * it is added to the Command Menu
 * @discussion  If provided, this will define the command and how it is added to the
 * Command Menu<br/>
 * If null, commands will not be accessible through the HMI application menu
 */
@property(strong) SDLMenuParams* menuParams;
/**
 * @abstract Voice Recognition Commands
 * @discussion If provided, defines one or more VR phrases the recognition of any of
 * which triggers the <i>SDLOnCommand</i> notification with this
 * cmdID<br/>
 * If null, commands will not be accessible by voice commands (when the user
 * hits push-to-talk)
 */
@property(strong) NSMutableArray* vrCommands;
/**
 * @abstract an Image obj representing the Image obj shown along with a command
 * @discussion If provided, defines the image to be be shown along with a  command
 * Notes:   If omitted on supported displays, no (or the
 *            default if applicable) icon will be displayed
 */
@property(strong) SDLImage* cmdIcon;

@end
