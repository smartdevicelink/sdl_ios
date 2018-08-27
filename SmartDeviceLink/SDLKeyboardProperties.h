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

- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText;

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

@end

NS_ASSUME_NONNULL_END
