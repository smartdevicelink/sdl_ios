//  SDLVrHelpItem.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLImage.h>

@interface SDLVrHelpItem : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* text;
@property(strong) SDLImage* image;
@property(strong) NSNumber* position;

@end
