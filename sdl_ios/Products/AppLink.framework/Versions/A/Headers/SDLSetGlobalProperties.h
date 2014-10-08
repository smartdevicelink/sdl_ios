//  SDLSetGlobalProperties.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCRequest.h>

#import <AppLink/SDLImage.h>
#import <AppLink/SDLKeyboardProperties.h>

@interface SDLSetGlobalProperties : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* helpPrompt;
@property(strong) NSMutableArray* timeoutPrompt;
@property(strong) NSString* vrHelpTitle;
@property(strong) NSMutableArray* vrHelp;
@property(strong) NSString* menuTitle;
@property(strong) SDLImage* menuIcon;
@property(strong) SDLKeyboardProperties* keyboardProperties;

@end
