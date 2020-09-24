//
//  SDLKeyboardDelegate.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLKeyboardEvent.h"

@class SDLKeyboardProperties;

NS_ASSUME_NONNULL_BEGIN

/**
 This handler is called when you wish to update your autocomplete text in response to the user's input

 @param updatedAutocompleteText The autocomplete results to use
 */
typedef void(^SDLKeyboardAutocompleteCompletionHandler)(NSString  *_Nullable updatedAutocompleteText);

/**
 This handler is called when you wish to update your autocomplete text in response to the user's input.

 @param updatedAutoCompleteList The list of autocomplete results to use, a max of 100 items are allowed
 */
typedef void(^SDLKeyboardAutoCompleteResultsHandler)(NSArray<NSString *> *_Nullable updatedAutoCompleteList);

/**
 This handler is called when you wish to update your keyboard's limitedCharacterSet in response to the user's input

 @param updatedCharacterSet The new set of characters to use
 */
typedef void(^SDLKeyboardCharacterSetCompletionHandler)(NSArray<NSString *> *_Nullable updatedCharacterSet);

/// They delegate of a keyboard popup allowing customization at runtime of the keyboard.
@protocol SDLKeyboardDelegate <NSObject>

/**
 The keyboard session completed with some input.

 This will be sent upon ENTRY_SUBMITTED or ENTRY_VOICE. If the event is ENTRY_VOICE, the user requested to start a voice session in order to submit input to this keyboard. This MUST be handled by you. Start an Audio Pass Thru session if supported.

 @param inputText The submitted input text on the keyboard
 @param source ENTRY_SUBMITTED if the user pressed the submit button on the keyboard, ENTRY_VOICE if the user requested that a voice session begin
 */
- (void)userDidSubmitInput:(NSString *)inputText withEvent:(SDLKeyboardEvent)source;

/**
 The keyboard session aborted.

 This will be sent if the keyboard event ENTRY_CANCELLED or ENTRY_ABORTED is sent

 @param event ENTRY_CANCELLED if the user cancelled the keyboard input, or ENTRY_ABORTED if the system aborted the input due to a higher priority event
 */
- (void)keyboardDidAbortWithReason:(SDLKeyboardEvent)event;

@optional
/**
 Implement this in order to provide a custom keyboard configuration to just this keyboard. To apply default settings to all keyboards, see SDLScreenManager.keyboardConfiguration

 @return The custom keyboard configuration to use.
 */
- (SDLKeyboardProperties *)customKeyboardConfiguration;

/**
 Implement this if you wish to updated the KeyboardProperties.autoCompleteList as the user updates their input. This is called upon a KEYPRESS event.

 This allows you to present a list of options that the user can use to fill in the search / text box with suggestions you provide.

 @param currentInputText The user's full current input text
 @param resultsHandler A completion handler to update the autoCompleteList
 */
- (void)updateAutocompleteWithInput:(NSString *)currentInputText autoCompleteResultsHandler:(SDLKeyboardAutoCompleteResultsHandler)resultsHandler;

/**
 Implement this if you wish to update the limitedCharacterSet as the user updates their input. This is called upon a KEYPRESS event.

 @param currentInputText The user's full current input text
 @param completionHandler A completion handler to update the limitedCharacterSet
 */
-(void)updateCharacterSetWithInput:(NSString *)currentInputText completionHandler:(SDLKeyboardCharacterSetCompletionHandler)completionHandler;

// This will be sent for any event that occurs with the event and the current input text

/**
 Implement this to be notified of all events occurring on the keyboard

 @param event The event that occurred
 @param currentInputText The user's full current input text
 */
- (void)keyboardDidSendEvent:(SDLKeyboardEvent)event text:(NSString *)currentInputText;

@end

NS_ASSUME_NONNULL_END
