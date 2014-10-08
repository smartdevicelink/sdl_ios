//  SDLScreenParams.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLImageResolution.h>
#import <AppLink/SDLTouchEventCapabilities.h>

@interface SDLScreenParams : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLImageResolution* resolution;
@property(strong) SDLTouchEventCapabilities* touchEventAvailable;

@end
