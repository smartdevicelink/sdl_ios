//  SDLSetGlobalProperties.h
//

#import "SDLRPCRequest.h"

#import "SDLMenuLayout.h"

@class SDLImage;
@class SDLKeyboardProperties;
@class SDLTTSChunk;
@class SDLVRHelpItem;
@class SDLSeatLocation;

NS_ASSUME_NONNULL_BEGIN

/**
 Sets global property values
 
 Since SmartDeviceLink 1.0

 See SDLResetGlobalProperties
 */
@interface SDLSetGlobalProperties : SDLRPCRequest

/**
 Initialize SetGlobalProperties with all possible items

 @param helpText A string that will be turned into TTS chunks for the help prompt
 @param timeoutText A string that will be turned into TTS chunks for the timeout prompt
 @param vrHelpTitle The title of the help interface prompt
 @param vrHelp The items of the help interface prompt
 @param menuTitle The title of the menu button
 @param menuIcon The icon on the menu button
 @param keyboardProperties The properties of a keyboard prompt
 @param menuLayout The layout of the top-level main menu
 @return The SetGlobalProperties RPC
 */
- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(nullable NSString *)menuTitle menuIcon:(nullable SDLImage *)menuIcon keyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties menuLayout:(nullable SDLMenuLayout)menuLayout __deprecated_msg("Use initWithUserLocation:helpPrompt:timeoutPrompt:vrHelpTitle:vrHelp:menuTitle:menuIcon:keyboardProperties:menuLayout: instead");

/**
* Convenience init for setting all possible global properties
*
* @param userLocation - userLocation
* @param helpPrompt - helpPrompt
* @param timeoutPrompt - timeoutPrompt
* @param vrHelpTitle - vrHelpTitle
* @param vrHelp - vrHelp
* @param menuTitle - menuTitle
* @param menuIcon - menuIcon
* @param keyboardProperties - keyboardProperties
* @param menuLayout - menuLayout
* @return A SDLSetGlobalProperties object
*/
- (instancetype)initWithUserLocation:(nullable SDLSeatLocation *)userLocation helpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt timeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(nullable NSString *)menuTitle menuIcon:(nullable SDLImage *)menuIcon keyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties menuLayout:(nullable SDLMenuLayout)menuLayout;

/**
 Help prompt for when the user asks for help with an interface prompt

 Optional
 */
@property (strong, nonatomic, nullable) NSArray<SDLTTSChunk *> *helpPrompt;

/**
 Help prompt for when an interface prompt times out

 Optional, Array, at least 1 item
 */
@property (strong, nonatomic, nullable) NSArray<SDLTTSChunk *> *timeoutPrompt;

/**
 Sets a voice recognition Help Title

 Optional
 */
@property (strong, nonatomic, nullable) NSString *vrHelpTitle;

/**
 Sets the items listed in the VR help screen used in an interaction started by Push to Talk

 @since SmartDeviceLink 2.0

 Optional
 */
@property (strong, nonatomic, nullable) NSArray<SDLVRHelpItem *> *vrHelp;

/**
 Text for the menu button label

 Optional
 */
@property (strong, nonatomic, nullable) NSString *menuTitle;

/**
 Icon for the menu button

 Optional
 */
@property (strong, nonatomic, nullable) SDLImage *menuIcon;

/**
 On-screen keyboard (perform interaction) configuration

 Optional
 */
@property (strong, nonatomic, nullable) SDLKeyboardProperties *keyboardProperties;

/**
 Location of the user's seat. Default is driver's seat location if it is not set yet
 
 Optional
 */
@property (strong, nonatomic, nullable) SDLSeatLocation *userLocation;

/**
 The main menu layout. If this is sent while a menu is already on-screen, the head unit will change the display to the new layout type. See available menu layouts on DisplayCapabilities.menuLayoutsAvailable. Defaults to the head unit default.
 */
@property (strong, nonatomic, nullable) SDLMenuLayout menuLayout;

@end

NS_ASSUME_NONNULL_END
