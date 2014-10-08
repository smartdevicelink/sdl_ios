//  SDLSetMediaClockTimer.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCRequest.h>

#import <AppLink/SDLStartTime.h>
#import <AppLink/SDLUpdateMode.h>

@interface SDLSetMediaClockTimer : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLStartTime* startTime;
@property(strong) SDLStartTime* endTime;
@property(strong) SDLUpdateMode* updateMode;

@end
