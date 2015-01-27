//  SDLSetMediaClockTimer.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

#import "SDLStartTime.h"
#import "SDLUpdateMode.h"

@interface SDLSetMediaClockTimer : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLStartTime* startTime;
@property(strong) SDLStartTime* endTime;
@property(strong) SDLUpdateMode* updateMode;

@end
