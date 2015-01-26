//  SDLTurn.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLImage.h"

@interface SDLTurn : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* navigationText;
@property(strong) SDLImage* turnIcon;

@end
