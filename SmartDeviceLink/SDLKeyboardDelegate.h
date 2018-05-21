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

typedef void(^SDLKeyboardAutocompleteCompletionHandler)(NSString *updatedAutocompleteText);
typedef void(^SDLKeyboardCharacterSetCompletionHandler)(NSArray<NSString *> *updatedCharacterSet);

@protocol SDLKeyboardDelegate <NSObject>

// This will be sent upon ENTRY_SUBMITTED or ENTRY_VOICE
- (void)userDidSubmitInput:(NSString *)inputText withEvent:(SDLKeyboardEvent)source;

// This will be sent if the keyboard event ENTRY_CANCELLED or ENTRY_ABORTED is sent
- (void)userDidCancelInputWithReason:(SDLKeyboardEvent)event;

@optional
// If keyboard properties different than ScreenManager.keyboardConfiguration are desired, this can be implemented and customized. A SetGlobalProperties will be sent just before the PresentInteraction and the other properties restored after it completes.
- (SDLKeyboardProperties *)customKeyboardConfiguration;

// This will be sent upon KEYPRESS to update KeyboardProperties.autoCompleteText
- (void)updateAutocompleteWithInput:(NSString *)currentInputText completionHandler:(SDLKeyboardAutocompleteCompletionHandler)completionHandler;

// This will be sent upon KEYPRESS to update KeyboardProperties.limitedCharacterSet
-(void)updateCharacterSetWithInput:(NSString *)currentInputText completionHandler:(SDLKeyboardCharacterSetCompletionHandler)completionHandler;

// This will be sent for any event that occurs with the event and the current input text
- (void)keyboardDidSendEvent:(SDLKeyboardEvent)event text:(NSString *)currentInputText;

@end

NS_ASSUME_NONNULL_END
