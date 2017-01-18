//  SDLKeyboardProperties.h
//

#import "SDLRPCMessage.h"

#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLLanguage.h"

@interface SDLKeyboardProperties : SDLRPCStruct

- (instancetype)initWithLanguage:(SDLLanguage)language layout:(SDLKeyboardLayout)layout keypressMode:(SDLKeypressMode)keypressMode limitedCharacterList:(NSArray<NSString *> *)limitedCharacterList autoCompleteText:(NSString *)autoCompleteText;

@property (strong, nonatomic) SDLLanguage language;
@property (strong, nonatomic) SDLKeyboardLayout keyboardLayout;
@property (strong, nonatomic) SDLKeypressMode keypressMode;
@property (strong, nonatomic) NSMutableArray<NSString *> *limitedCharacterList;
@property (strong, nonatomic) NSString *autoCompleteText;

@end
