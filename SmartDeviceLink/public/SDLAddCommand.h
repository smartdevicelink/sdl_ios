//  SDLAddCommand.h


#import "SDLRPCRequest.h"

#import "SDLImageType.h"
#import "SDLNotificationConstants.h"

@class SDLImage;
@class SDLMenuParams;

/**
 *  This class will add a command to the application's Command Menu
 *
 *  A command will be added to the end of the list of elements in the Command Menu under the following conditions:
 *  1. When a SDLAddCommand is added with no SDLMenuParams value provided.
 *  2. When a SDLMenuParams value is provided with a SDLMenuParam.position value greater than or equal to the number of menu items currently defined in the menu specified by the SDLMenuParam.parentID value.
 *
 *  The set of choices which the application builds using SDLAddCommand can be a mixture of:
 *  1. Choices having only VR synonym definitions, but no SDLMenuParams definitions
 *  2. Choices having only SDLMenuParams definitions, but no VR synonym definitions
 *  3. Choices having both SDLMenuParams and VR synonym definitions
 *
 *  HMILevel needs to be FULL, LIMITED or BACKGROUD
 *  @since SDL 1.0
 *  @see SDLDeleteCommand, SDLAddSubMenu, SDLDeleteSubMenu
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLAddCommand : SDLRPCRequest

/**
 *  Constructs a SDLAddCommand with a handler callback when an event occurs.
 *
 *  @param handler A callback that is called when a button event occurs for the command.
 *
 *  @return A SDLAddCommand object
 */
- (instancetype)initWithHandler:(nullable SDLRPCCommandNotificationHandler)handler;

/**
 *  Convenience init for creating a voice command menu item.
 *
 *  @discussion This menu item can only be triggered by the VR system and does not show up in the HMI application menu.
 *
 *  @param commandId   A unique id for the menu item.
 *  @param vrCommands  One or more voice recognition phrases. If recognized by the VR system, the handler will be called.
 *  @param handler     Called when the VR system recognizes a phrase in `vrCommands`
 *  @return            A SDLAddCommand object
 */
- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands handler:(nullable SDLRPCCommandNotificationHandler)handler;

/**
 *  Convenience init for creating a menu item with text.
 *
 *  @param commandId   A unique id for the menu item.
 *  @param vrCommands  One or more voice recognition phrases. If recognized by the VR system, the handler will be called.
 *  @param menuName    The text that will appear in the menu.
 *  @param handler     Called when the menu item is selected and/or when the VR system recognizes a phrase in `vrCommands`
 *  @return            A SDLAddCommand object
 */
- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName handler:(nullable SDLRPCCommandNotificationHandler)handler;

/**
 *  Convenience init for creating a menu item with text and a custom icon.
 *
 *  @warning The icon must be uploaded to Core before being displayed in the menu.
 *
 *  @param commandId       A unique id for the menu item.
 *  @param vrCommands      One or more voice recognition phrases. If recognized by the VR system, the handler will be called.
 *  @param menuName        The text that will appear in the menu.
 *  @param parentId        The command id of the parent menu if menu item is in a submenu. If not in a submenu, the parentId is 0.
 *  @param position        The menu item's row number in the menu.
 *  @param iconValue       The unique name used to upload the image to Core.
 *  @param iconType        Whether the image is static or dynamic.
 *  @param iconIsTemplate  Whether or not the image is a template that can be (re)colored by the SDL HMI
 *  @param handler         Called when the menu item is selected and/or when the VR system recognizes a phrase in `vrCommands`
 *  @return                A SDLAddCommand object
 */
- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position iconValue:(nullable NSString *)iconValue iconType:(nullable SDLImageType)iconType iconIsTemplate:(BOOL)iconIsTemplate handler:(nullable SDLRPCCommandNotificationHandler)handler;

/**
 *  Convenience init for creating a menu item with text and a custom icon.
 *
 *  @warning The icon must be uploaded to Core before being displayed in the menu.
 *
 *  @param commandId   A unique id for the menu item.
 *  @param vrCommands  One or more voice recognition phrases. If recognized by the VR system, the handler will be called.
 *  @param menuName    The text that will appear in the menu.
 *  @param parentId    The command id of the parent menu if menu item is in a submenu. If not in a submenu, the parentId is 0.
 *  @param position    The menu item's row number in the menu.
 *  @param icon        A image that appears next to the `menuName` text.
 *  @param handler     Called when the menu item is selected and/or when the VR system recognizes a phrase in `vrCommands`
 *  @return            A SDLAddCommand object
 */
- (instancetype)initWithId:(UInt32)commandId vrCommands:(nullable NSArray<NSString *> *)vrCommands menuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position icon:(nullable SDLImage *)icon handler:(nullable SDLRPCCommandNotificationHandler)handler;

/**
 *  A handler that will let you know when the button you created is subscribed.
 *
 *  @warning This will only work if you use `SDLManager`.
 */
@property (nullable, copy, nonatomic) SDLRPCCommandNotificationHandler handler;

/**
 *  A unique id that identifies the command.
 *
 *  @discussion Is returned in an `SDLOnCommand` notification to identify the command selected by the user
 *
 *  Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *cmdID;

/**
 *  A `SDLMenuParams` pointer which defines the command and how it is added to the command menu.
 *
 *  @discussion If provided, this will define the command and how it is added to the command menu. If null, commands will not be accessible through the HMI application menu.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLMenuParams *menuParams;

/**
 *  An array of strings to be used as VR synonyms for this command.
 *
 *  @discussion If provided, defines one or more VR phrases the recognition of any of which triggers the `SDLOnCommand` notification with this cmdID. If null, commands will not be accessible by voice commands (when the user hits push-to-talk).
 *
 *  Optional, Array of Strings, Max String length 99 chars, Array size 1 - 100
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *vrCommands;

/**
 *  Image struct containing a static or dynamic icon.
 *
 *  @discussion If provided, defines the image to be be shown along with a command. If omitted on supported displays, no (or the default if applicable) icon will be displayed
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLImage *cmdIcon;

@end

NS_ASSUME_NONNULL_END
