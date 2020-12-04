//
//  SDLChoiceSetManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLInteractionMode.h"
#import "NSNumber+NumberType.h"

@class SDLChoiceCell;
@class SDLChoiceSet;
@class SDLFileManager;
@class SDLKeyboardProperties;
@class SDLSystemCapabilityManager;

@protocol SDLConnectionManagerType;
@protocol SDLKeyboardDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLPreloadChoiceCompletionHandler)(NSError *__nullable error);

typedef NSString SDLChoiceManagerState;
extern SDLChoiceManagerState *const SDLChoiceManagerStateShutdown;
extern SDLChoiceManagerState *const SDLChoiceManagerStateCheckingVoiceOptional;
extern SDLChoiceManagerState *const SDLChoiceManagerStateReady;
extern SDLChoiceManagerState *const SDLChoiceManagerStateStartupError;

@interface SDLChoiceSetManager : NSObject

/**
 *  The state of the choice set manager.
 */
@property (copy, nonatomic, readonly) NSString *currentState;

/**
 The default keyboard configuration, this can be additionally customized by each SDLKeyboardDelegate.
 */
@property (strong, nonatomic, null_resettable) SDLKeyboardProperties *keyboardConfiguration;

/**
 Cells will be hashed by their text, image names, and VR command text. When assembling an SDLChoiceSet, you can pull objects from here, or recreate them. The preloaded versions will be used so long as their text, image names, and VR commands are the same.
 */
@property (copy, nonatomic, readonly) NSSet<SDLChoiceCell *> *preloadedChoices;

/**
 Initialize the manager with required dependencies

 @param connectionManager The connection manager object for sending RPCs
 @param fileManager The file manager object for uploading files
 @param systemCapabilityManager The system capability manager object for reading window capabilities
 @return The choice set manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager;

/**
 Start the manager and prepare to manage choice sets
 */
- (void)start;

/**
 Stop the manager and reset all properties
 */
- (void)stop;

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

 This presents the choice set as searchable when in a touch interaction. The user, when not in a distracted state, will have a keyboard available for searching this set. The user's input in the keyboard will be available in the SDLKeyboardDelegate.

 If the cells in the set are not already preloaded, they will be preloaded before the presentation occurs; this could take a while depending on the contents of the cells.

 If the cells have voice commands and images attached, this could take upwards of 10 seconds. If there are no cells on the set, this will fail, calling `choiceSet:didReceiveError:` on the choice set delegate.

 @param choiceSet The set to be displayed
 @param mode If the set should be presented for the user to interact via voice, touch, or both
 @param delegate The keyboard delegate called when the user interacts with the search field of the choice set, if not set, a non-searchable choice set will be used
 */
- (void)presentChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(nullable id<SDLKeyboardDelegate>)delegate;

/**
 Present a keyboard-only interface to the user and receive input. The user will be able to input text in the keyboard when in a non-driver distraction situation.

 @param initialText The initial text within the keyboard input field. It will disappear once the user selects the field in order to enter text
 @param delegate The keyboard delegate called when the user interacts with the keyboard
 @return A unique id that can be used to cancel this keyboard. If `null`, no keyboard was created.
 */
- (nullable NSNumber<SDLInt> *)presentKeyboardWithInitialText:(NSString *)initialText delegate:(id<SDLKeyboardDelegate>)delegate;

/**
 Cancels the keyboard-only interface if it is currently showing. If the keyboard has not yet been sent to Core, it will not be sent.
 
 This will only dismiss an already presented keyboard if connected to head units running SDL 6.0+.

 @param cancelID The unique ID assigned to the keyboard, passed as the return value from `presentKeyboardWithInitialText:keyboardDelegate:`
 */
- (void)dismissKeyboardWithCancelID:(NSNumber<SDLInt> *)cancelID;

@end

NS_ASSUME_NONNULL_END
