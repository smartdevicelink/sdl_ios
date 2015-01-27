//  SDLTextField.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLRPCMessage.h"

#import "SDLTextFieldName.h"
#import "SDLCharacterSet.h"

@interface SDLTextField : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTextFieldName* name;
@property(strong) SDLCharacterSet* characterSet;
@property(strong) NSNumber* width;
@property(strong) NSNumber* rows;

@end
