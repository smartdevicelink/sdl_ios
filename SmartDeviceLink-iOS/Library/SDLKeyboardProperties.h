//  SDLKeyboardProperties.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLLanguage.h"
#import "SDLKeyboardLayout.h"
#import "SDLKeypressMode.h"

@interface SDLKeyboardProperties : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLLanguage* language;
@property(strong) SDLKeyboardLayout* keyboardLayout;
@property(strong) SDLKeypressMode* keypressMode;
@property(strong) NSMutableArray* limitedCharacterList;
@property(strong) NSString* autoCompleteText;

@end
