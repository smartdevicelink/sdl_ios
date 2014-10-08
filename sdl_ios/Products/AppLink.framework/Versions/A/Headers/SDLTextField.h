//  SDLTextField.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLTextFieldName.h>
#import <AppLink/SDLCharacterSet.h>

@interface SDLTextField : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTextFieldName* name;
@property(strong) SDLCharacterSet* characterSet;
@property(strong) NSNumber* width;
@property(strong) NSNumber* rows;

@end
