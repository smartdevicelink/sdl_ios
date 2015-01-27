//  SDLOnDriverDistraction.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLDriverDistractionState.h"

@interface SDLOnDriverDistraction : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLDriverDistractionState* state;

@end
