//  SDLSingleTireStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLComponentVolumeStatus.h"

@interface SDLSingleTireStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLComponentVolumeStatus* status;

@end
