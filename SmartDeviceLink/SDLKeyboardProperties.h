//  SDLKeyboardProperties.h
//

#import "SDLRPCMessage.h"

#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"
#import "SDLLanguage.h"

@interface SDLKeyboardProperties : SDLRPCStruct

- (instancetype)initWithLanguage:(SDLLanguage)language layout:(SDLKeyboardLayout)layout keypressMode:(SDLKeypressMode)keypressMode limitedCharacterList:(NSArray<NSString *> *)limitedCharacterList autoCompleteText:(NSString *)autoCompleteText;

@property (strong) SDLLanguage language;
@property (strong) SDLKeyboardLayout keyboardLayout;
@property (strong) SDLKeypressMode keypressMode;
@property (strong) NSMutableArray<NSString *> *limitedCharacterList;
@property (strong) NSString *autoCompleteText;

@end
