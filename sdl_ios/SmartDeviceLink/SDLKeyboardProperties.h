//  SDLKeyboardProperties.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLLanguage.h>
#import <SmartDeviceLink/SDLKeyboardLayout.h>
#import <SmartDeviceLink/SDLKeypressMode.h>

@interface SDLKeyboardProperties : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLLanguage* language;
@property(strong) SDLKeyboardLayout* keyboardLayout;
@property(strong) SDLKeypressMode* keypressMode;
@property(strong) NSMutableArray* limitedCharacterList;
@property(strong) NSString* autoCompleteText;

@end
