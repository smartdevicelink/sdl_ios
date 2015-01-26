//  SDLStartTime.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

@interface SDLStartTime : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* hours;
@property(strong) NSNumber* minutes;
@property(strong) NSNumber* seconds;

@end
