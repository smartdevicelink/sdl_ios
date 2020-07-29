//
//  SDLScreenManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 3/5/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"
#import "SDLButtonName.h"
#import "SDLInteractionMode.h"
#import "SDLMenuManagerConstants.h"
#import "SDLMetadataType.h"
#import "SDLNotificationConstants.h"
#import "SDLTextAlignment.h"

@class SDLArtwork;
@class SDLChoiceCell;
@class SDLChoiceSet;
@class SDLFileManager;
@class SDLKeyboardProperties;
@class SDLMenuCell;
@class SDLMenuConfiguration;
@class SDLOnButtonEvent;
@class SDLOnButtonPress;
@class SDLSoftButtonObject;
@class SDLSystemCapabilityManager;
@class SDLVoiceCommand;

@protocol SDLConnectionManagerType;
@protocol SDLChoiceSetDelegate;
@protocol SDLKeyboardDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLScreenManagerUpdateCompletionHandler)(NSError *__nullable error);

/**
 Return an error with userinfo [key: SDLChoiceCell, value: NSError] if choices failed to upload

 @param error The error if one occurred
 */
typedef void(^SDLPreloadChoiceCompletionHandler)(NSError *__nullable error);

/// A handler run when the subscribe button has been selected
///
/// @param buttonPress Indicates whether this is a long or short button press event
/// @param buttonEvent Indicates that the button has been depressed or released
/// @param error The error if one occurred
typedef void (^SDLSubscribeButtonHandler)(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error);

/// The SDLScreenManager is a manager to control SDL UI features. Use the screen manager for setting up the UI of the template, creating a menu for your users, creating softbuttons, setting textfields, etc..
@interface SDLScreenManager : NSObject

#pragma mark Text and Graphics

/**
 The top text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField1;

/**
 The second text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField2;

/**
 The third text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField3;

/**
 The fourth text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField4;

/**
 The media text field available within the media layout. Often less emphasized than textField(1-4)
 */
@property (copy, nonatomic, nullable) NSString *mediaTrackTextField;

/**
 The primary graphic within a template layout
 */
@property (strong, nonatomic, nullable) SDLArtwork *primaryGraphic;

/**
 A secondary graphic used in some template layouts
 */
@property (strong, nonatomic, nullable) SDLArtwork *secondaryGraphic;

/**
 What alignment textField(1-4) should use
 */
@property (copy, nonatomic) SDLTextAlignment textAlignment;

/**
 The type of data textField1 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField1Type;

/**
 The type of data textField2 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField2Type;

/**
 The type of data textField3 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField3Type;

/**
 The type of data textField4 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField4Type;

/**
 The title of the current template layout.
 */
@property (copy, nonatomic, nullable) NSString *title;

#pragma mark Soft Buttons

/**
 The current list of soft buttons within a template layout. Set this array to change the displayed soft buttons.
 */
@property (copy, nonatomic) NSArray<SDLSoftButtonObject *> *softButtonObjects;

#pragma mark Menu

/**
 Configures the layout of the menu and sub-menus. If set after a menu already exists, the existing main menu layout will be updated.

 If set menu layouts don't match available menu layouts in WindowCapability, an error log will be emitted and the layout will not be set.

 Setting this parameter will send a message to the remote system. This value will be set immediately, but if that message is rejected, the original value will be re-set and an error log will be emitted.

 This only works on head units supporting RPC spec version 6.0 and newer. If the connected head unit does not support this feature, a warning log will be emitted and nothing will be set.
 */
@property (strong, nonatomic) SDLMenuConfiguration *menuConfiguration;

/**
 The current list of menu cells displayed in the app's menu.
 */
@property (copy, nonatomic) NSArray<SDLMenuCell *> *menu;

/**
Change the mode of the dynamic menu updater to be enabled, disabled, or enabled on known compatible head units.

The current status for dynamic menu updates. A dynamic menu update allows for smarter building of menu changes. If this status is set to `SDLDynamicMenuUpdatesModeForceOn`, menu updates will only create add commands for new items and delete commands for items no longer appearing in the menu. This helps reduce possible RPCs failures as there will be significantly less commands sent to the HMI.

If set to `SDLDynamicMenuUpdatesModeForceOff`, menu updates will work the legacy way. This means when a new menu is set the entire old menu is deleted and add commands are created for every item regarldess if the item appears in both the old and new menu. This method is RPCs heavy and may cause some failures when creating and updating large menus.

 We recommend using either `SDLDynamicMenuUpdatesModeOnWithCompatibility` or `SDLDynamicMenuUpdatesModeForceOn`. `SDLDynamicMenuUpdatesModeOnWithCompatibility` turns dynamic updates off for head units that we know have poor compatibility with dynamic updates (e.g. they have bugs that cause menu items to not be placed correctly).
 */
@property (assign, nonatomic) SDLDynamicMenuUpdatesMode dynamicMenuUpdatesMode;

/**
 The current list of voice commands available for the user to speak and be recognized by the IVI's voice recognition engine.
 */
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *voiceCommands;

#pragma mark Choice Sets

/**
 The default keyboard configuration, this can be additionally customized by each SDLKeyboardDelegate.
 */
@property (strong, nonatomic, null_resettable) SDLKeyboardProperties *keyboardConfiguration;

/**
 Cells will be hashed by their text, image names, and VR command text. When assembling an SDLChoiceSet, you can pull objects from here, or recreate them. The preloaded versions will be used so long as their text, image names, and VR commands are the same.
 */
@property (copy, nonatomic, readonly) NSSet<SDLChoiceCell *> *preloadedChoices;


#pragma mark - Methods

#pragma mark Lifecycle

/**
 Initialize a screen manager

 @warning For internal use

 @param connectionManager The connection manager used to send RPCs
 @param fileManager The file manager used to upload files
 @param systemCapabilityManager The system capability manager object for reading window capabilities
 @return The screen manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager;

/**
 Starts the manager and all sub-managers

 @param handler The handler called when setup is complete
 */
- (void)startWithCompletionHandler:(void(^)(NSError * _Nullable error))handler;

/**
 Stops the manager.

 @warning For internal use
 */
- (void)stop;

#pragma mark - Text and Graphic
/**
 Delays all screen updates until endUpdatesWithCompletionHandler: is called.
 */
- (void)beginUpdates;

/**
 Update text fields with new text set into the text field properties. Pass an empty string `\@""` to clear the text field.

 If the system does not support a full 4 fields, this will automatically be concatenated and properly send the field available.

 If 3 lines are available: [field1, field2, field3 - field 4]

 If 2 lines are available: [field1 - field2, field3 - field4]

 If 1 line is available: [field1 - field2 - field3 - field4]

 Also updates the primary and secondary images with new image(s) if new one(s) been set. This method will take care of naming the files (based on a hash). This is assumed to be a non-persistant image.

 If it needs to be uploaded, it will be. Once the upload is complete, the on-screen graphic will be updated.
 */
- (void)endUpdates;

/**
 Update text fields with new text set into the text field properties. Pass an empty string `\@""` to clear the text field.

 If the system does not support a full 4 fields, this will automatically be concatenated and properly send the field available.

 If 3 lines are available: [field1, field2, field3 - field 4]

 If 2 lines are available: [field1 - field2, field3 - field4]

 If 1 line is available: [field1 - field2 - field3 - field4]

 Also updates the primary and secondary images with new image(s) if new one(s) been set. This method will take care of naming the files (based on a hash). This is assumed to be a non-persistant image.

 If it needs to be uploaded, it will be. Once the upload is complete, the on-screen graphic will be updated.

 @param handler A handler run when the fields have finished updating, with an error if the update failed. This handler may be called multiple times when the text update is sent and the image update is sent.
 */
- (void)endUpdatesWithCompletionHandler:(nullable SDLScreenManagerUpdateCompletionHandler)handler;

#pragma mark - Soft Buttons

/// Retrieve a SoftButtonObject based on its name.
/// @param name The name of the button
- (nullable SDLSoftButtonObject *)softButtonObjectNamed:(NSString *)name;

#pragma mark - Subscribe Buttons

/// Subscribes to a subscribe button. The update handler will be called when the button has been selected. If there is an error subscribing to the subscribe button it will be returned in the `error` parameter of the updateHandler.
/// @param buttonName The name of the hard button to subscribe to
/// @param updateHandler The block run when the subscribe button is selected
/// @return An object that can be used to unsubscribe the block using `unsubscribeButtonWithObserver:withCompletionHandler:`.
- (id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(SDLSubscribeButtonHandler)updateHandler;

/// Subscribes to a subscribe button. The selector will be called when the button has been selected. If there is an error subscribing to the subscribe button it will be returned in the `error` parameter of the selector.
///
/// The selector supports the following parameters:
///
/// 1. A selector with no parameters. The observer will be notified when a button press occurs (it will not know if a short or long press has occurred).
///
/// 2. A selector with one parameter: (SDLButtonName). The observer will be notified when a button press occurs (both a short and long press will trigger the selector, but it will not be able to distinguish between them). It will not be notified of button events.
///
/// 3. A selector with two parameters: (SDLButtonName, NSError). The observer will be notified when a button press occurs (both a short and long press will trigger the selector, but it will not be able to distinguish between them). It will not be notified of button events.
///
/// 4. A selector with three parameters: (SDLButtonName, NSError, SDLOnButtonPress). The observer will be notified when a long or short button press occurs (and can distinguish between a short or long press), but will not be notified of individual button events.
///
/// 5. A selector with four parameters: (SDLButtonName, NSError, SDLOnButtonPress, SDLOnButtonEvent). The observer will be notified when any button press or any button event occurs (and can distinguish between them).
///
/// To unsubscribe from the hard button, call `unsubscribeButton:withObserver:withCompletionHandler:`.
///
/// @param buttonName The name of the hard button to subscribe to
/// @param observer The object that will have `selector` called whenever the button has been selected
/// @param selector The selector on `observer` that will be called whenever the button has been selected
- (void)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector;

/// Unsubscribes to a subscribe button. Please note that if a subscribe button has multiple subscribers the observer will no longer get notifications, however, the app will still be subscribed to the hard button until the last subscriber is removed.
/// @param buttonName The name of the hard button to subscribe to
/// @param observer The object that will be unsubscribed. If a block was subscribed, the return value should be passed. If a selector was subscribed, the observer object should be passed
/// @param completionHandler A handler called when the observer has been unsubscribed to the hard button
- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(SDLScreenManagerUpdateCompletionHandler)completionHandler;

#pragma mark - Choice Sets

/**
 Preload cells to the head unit. This will *greatly* reduce the time taken to present a choice set. Any already matching a choice already on the head unit will be ignored. You *do not* need to wait until the completion handler is called to present a choice set containing choices being loaded. The choice set will wait until the preload completes and then immediately present.

 @param choices The choices to be preloaded.
 @param handler The handler to be called when complete.
 */
- (void)preloadChoices:(NSArray<SDLChoiceCell *> *)choices withCompletionHandler:(nullable SDLPreloadChoiceCompletionHandler)handler;

/**
 Delete loaded cells from the head unit. If the cells don't exist on the head unit they will be ignored.

 @param choices The choices to be deleted. These will be matched via a hash of the text, image name(s), and VR commands.
 */
- (void)deleteChoices:(NSArray<SDLChoiceCell *> *)choices;

/**
 Present a choice set on the head unit with a certain interaction mode. You should present in VR only if the user reached this choice set by using their voice, in Manual only if the user used touch to reach this choice set. Use Both if you're lazy...for real though, it's kind of confusing to the user and isn't recommended.

 If the cells in the set are not already preloaded, they will be preloaded before the presentation occurs; this could take a while depending on the contents of the cells.

 If the cells have voice commands and images attached, this could take upwards of 10 seconds. If there are no cells on the set, this will fail, calling `choiceSet:didReceiveError:` on the choice set delegate.

 @param choiceSet The set to be displayed
 @param mode If the set should be presented for the user to interact via voice, touch, or both
 */
- (void)presentChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode;

/**
 Present a choice set on the head unit with a certain interaction mode. You should present in VR only if the user reached this choice set by using their voice, in Manual only if the user used touch to reach this choice set. Use Both if you're lazy...for real though, it's kind of confusing to the user and isn't recommended.

 This presents the choice set as searchable when in a touch interaction. The user, when not in a distracted state, will have a keyboard available for searching this set. The user's input in the keyboard will be available in the SDLKeyboardDelegate.

 If the cells in the set are not already preloaded, they will be preloaded before the presentation occurs; this could take a while depending on the contents of the cells.

 If the cells have voice commands and images attached, this could take upwards of 10 seconds. If there are no cells on the set, this will fail, calling `choiceSet:didReceiveError:` on the choice set delegate.

 @param choiceSet The set to be displayed
 @param mode If the set should be presented for the user to interact via voice, touch, or both
 @param delegate The keyboard delegate called when the user interacts with the search field of the choice set
 */
- (void)presentSearchableChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(id<SDLKeyboardDelegate>)delegate;

/**
 Present a keyboard-only interface to the user and receive input. The user will be able to input text in the keyboard when in a non-driver distraction situation.

 @param initialText The initial text within the keyboard input field. It will disappear once the user selects the field in order to enter text
 @param delegate The keyboard delegate called when the user interacts with the keyboard
 @return A unique cancelID that can be used to cancel this keyboard
 */
- (nullable NSNumber<SDLInt> *)presentKeyboardWithInitialText:(NSString *)initialText delegate:(id<SDLKeyboardDelegate>)delegate;

/**
 Cancels the keyboard-only interface if it is currently showing. If the keyboard has not yet been sent to Core, it will not be sent.

 This will only dismiss an already presented keyboard if connected to head units running SDL 6.0+.

 @param cancelID The unique ID assigned to the keyboard, passed as the return value from `presentKeyboardWithInitialText:keyboardDelegate:`
 */
- (void)dismissKeyboardWithCancelID:(NSNumber<SDLInt> *)cancelID;

#pragma mark - Menu

/**
 Present the top-level of your application menu. This method should be called if the menu needs to be opened programmatically because the built in menu button is hidden.
 */
- (BOOL)openMenu;

/**
 Present the application menu. This method should be called if the menu needs to be opened programmatically because the built in menu button is hidden. You must update the menu with the proper cells before calling this method. This RPC will fail if the cell does not contain a sub menu, or is not in the menu array.

@param cell The submenu cell that should be opened as a sub menu, with its sub cells as the options.
 */
- (BOOL)openSubmenu:(SDLMenuCell *)cell;

@end

NS_ASSUME_NONNULL_END
