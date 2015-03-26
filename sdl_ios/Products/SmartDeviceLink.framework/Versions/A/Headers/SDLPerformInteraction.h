//  SDLPerformInteraction.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

#import <SmartDeviceLink/SDLInteractionMode.h>
#import <SmartDeviceLink/SDLLayoutMode.h>

@interface SDLPerformInteraction : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* initialText;
@property(strong) NSMutableArray* initialPrompt;
@property(strong) SDLInteractionMode* interactionMode;
@property(strong) NSMutableArray* interactionChoiceSetIDList;
@property(strong) NSMutableArray* helpPrompt;
@property(strong) NSMutableArray* timeoutPrompt;
@property(strong) NSNumber* timeout;
@property(strong) NSMutableArray* vrHelp;
@property(strong) SDLLayoutMode* interactionLayout;

@end
