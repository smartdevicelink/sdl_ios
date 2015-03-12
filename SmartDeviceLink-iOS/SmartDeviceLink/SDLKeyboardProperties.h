//  SDLKeyboardProperties.h
//

#import "SDLRPCMessage.h"

@class SDLLanguage;
@class SDLKeyboardLayout;
@class SDLKeypressMode;


@interface SDLKeyboardProperties : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLLanguage* language;
@property(strong) SDLKeyboardLayout* keyboardLayout;
@property(strong) SDLKeypressMode* keypressMode;
@property(strong) NSMutableArray* limitedCharacterList;
@property(strong) NSString* autoCompleteText;

@end
