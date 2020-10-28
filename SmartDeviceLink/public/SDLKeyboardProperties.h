/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "SDLRPCMessage.h"

#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLLanguage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Configuration of on-screen keyboard (if available)
 */
@interface SDLKeyboardProperties : SDLRPCStruct

/**
 * @param language - language
 * @param keyboardLayout - keyboardLayout
 * @param keypressMode - keypressMode
 * @param limitedCharacterList - limitedCharacterList
 * @param autoCompleteList - autoCompleteList
 * @return A SDLKeyboardProperties object
 */
- (instancetype)initWithLanguage:(nullable SDLLanguage)language keyboardLayout:(nullable SDLKeyboardLayout)keyboardLayout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList;

/**
 Create a Keyboard Properties RPC object

 @param language The language to set the keyboard to
 @param layout The layout of the keyboard
 @param keypressMode The mode of keypresses to use
 @param limitedCharacterList A list of characters restricting what the user is allowed to press
 @param autoCompleteText A string to show to user to complete what they are typing
 @param autoCompleteList A list of strings to show the user to complete what they are typing.
 @return The RPC object
 */
- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText autoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList __deprecated_msg("Use initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autocompleteList:");

/**
 The keyboard language

 Optional
 */
@property (nullable, strong, nonatomic) SDLLanguage language;

/**
 Desired keyboard layout

 Optional
 */
@property (nullable, strong, nonatomic) SDLKeyboardLayout keyboardLayout;

/**
 Desired keypress mode.

 If omitted, this value will be set to RESEND_CURRENT_ENTRY.

 Optional
 */
@property (nullable, strong, nonatomic) SDLKeypressMode keypressMode;

/**
 Array of keyboard characters to enable. All omitted characters will be greyed out (disabled) on the keyboard. If omitted, the entire keyboard will be enabled.

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *limitedCharacterList;

/**
 Allows an app to prepopulate the text field with a suggested or completed entry as the user types

 Optional
 */
@property (nullable, strong, nonatomic) NSString *autoCompleteText;

/**
 Allows an app to show a list of possible autocomplete suggestions as the user types

 Optional, 1-100 items, max string length 1000 characters (note that these may not all be displayed on the screen)
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *autoCompleteList;

@end

NS_ASSUME_NONNULL_END
