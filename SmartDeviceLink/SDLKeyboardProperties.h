//  SDLKeyboardProperties.h
//

#import "SDLRPCMessage.h"

#import "SDLLanguage.h"
#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"

@interface SDLKeyboardProperties : SDLRPCStruct

@property (strong) SDLLanguage language;
@property (strong) SDLKeyboardLayout keyboardLayout;
@property (strong) SDLKeypressMode keypressMode;
@property (strong) NSMutableArray<NSString *> *limitedCharacterList;
@property (strong) NSString *autoCompleteText;

@end
