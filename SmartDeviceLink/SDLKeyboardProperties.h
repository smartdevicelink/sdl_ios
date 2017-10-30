//  SDLKeyboardProperties.h
//

#import "SDLRPCMessage.h"

#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLLanguage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLKeyboardProperties : SDLRPCStruct

- (instancetype)initWithLanguage:(nullable SDLLanguage)language layout:(nullable SDLKeyboardLayout)layout keypressMode:(nullable SDLKeypressMode)keypressMode limitedCharacterList:(nullable NSArray<NSString *> *)limitedCharacterList autoCompleteText:(nullable NSString *)autoCompleteText;

@property (nullable, strong, nonatomic) SDLLanguage language;
@property (nullable, strong, nonatomic) SDLKeyboardLayout keyboardLayout;
@property (nullable, strong, nonatomic) SDLKeypressMode keypressMode;
@property (nullable, strong, nonatomic) NSArray<NSString *> *limitedCharacterList;
@property (nullable, strong, nonatomic) NSString *autoCompleteText;

@end

NS_ASSUME_NONNULL_END
