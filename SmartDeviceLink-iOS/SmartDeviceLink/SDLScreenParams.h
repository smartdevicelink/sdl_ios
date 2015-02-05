//  SDLScreenParams.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLImageResolution.h"
#import "SDLTouchEventCapabilities.h"

@interface SDLScreenParams : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLImageResolution* resolution;
@property(strong) SDLTouchEventCapabilities* touchEventAvailable;

@end
