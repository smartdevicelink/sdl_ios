//  SDLKeyboardProperties.h
//

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
 Create a Keyboard Properties RPC object

 @param language The language to set the keyboard to
 @param layout The layout of the keyboard
 @param keypressMode The mode of keypresses to use
 @param limitedCharacterList A list of characters restricting what the user is allowed to press
 @param autoCompleteText A string to show to user to complete what they are typing
 @param autoCompleteList A list of strings to show the user to complete what they are typing.
 @return The RPC object
 */
- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText autoCompleteList:(nullable NSArray<NSString *> *)autoCompleteList __deprecated_msg("Use initWithLanguage:keyboardLayout:keypressMode:limitedCharacterList:autoCompleteList: instead");

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
 * Deprecated, use autoCompleteList instead.
 * {"string_min_length": 1, "string_max_length": 1000}
 *
 * @deprecated in SmartDeviceLink 6.0.0
 * @added in SmartDeviceLink 3.0.0
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nullable, strong, nonatomic) NSString *autoCompleteText __deprecated;
#pragma clang diagnostic pop

/**
 Allows an app to show a list of possible autocomplete suggestions as the user types

 Optional, 1-100 items, max string length 1000 characters (note that these may not all be displayed on the screen)
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *autoCompleteList;

@end

NS_ASSUME_NONNULL_END
