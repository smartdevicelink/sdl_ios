//  SDLKeyboardProperties.h
//

#import "SDLRPCMessage.h"

@class SDLLanguage;
@class SDLKeyboardLayout;
@class SDLKeypressMode;


@interface SDLKeyboardProperties : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) SDLLanguage *language;
@property (strong) SDLKeyboardLayout *keyboardLayout;
@property (strong) SDLKeypressMode *keypressMode;
@property (strong) NSMutableArray<NSString *> *limitedCharacterList;
@property (strong) NSString *autoCompleteText;

@end
