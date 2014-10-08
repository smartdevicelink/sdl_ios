//  SDLKeyboardProperties.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLLanguage.h>
#import <AppLink/SDLKeyboardLayout.h>
#import <AppLink/SDLKeypressMode.h>

@interface SDLKeyboardProperties : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLLanguage* language;
@property(strong) SDLKeyboardLayout* keyboardLayout;
@property(strong) SDLKeypressMode* keypressMode;
@property(strong) NSMutableArray* limitedCharacterList;
@property(strong) NSString* autoCompleteText;

@end
