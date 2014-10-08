//  SDLTurn.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLImage.h>

@interface SDLTurn : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* navigationText;
@property(strong) SDLImage* turnIcon;

@end
