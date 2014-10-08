//  SDLDisplayCapabilities.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLDisplayType.h>
#import <AppLink/SDLScreenParams.h>

@interface SDLDisplayCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLDisplayType* displayType;
@property(strong) NSMutableArray* textFields;
@property(strong) NSMutableArray* imageFields;
@property(strong) NSMutableArray* mediaClockFormats;
@property(strong) NSNumber* graphicSupported;
@property(strong) NSMutableArray* templatesAvailable;
@property(strong) SDLScreenParams* screenParams;
@property(strong) NSNumber* numCustomPresetsAvailable;

@end
