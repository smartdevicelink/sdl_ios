//  SDLOnHMIStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCNotification.h"

#import "SDLHMILevel.h"
#import "SDLAudioStreamingState.h"
#import "SDLSystemContext.h"

@interface SDLOnHMIStatus : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLHMILevel* hmiLevel;
@property(strong) SDLAudioStreamingState* audioStreamingState;
@property(strong) SDLSystemContext* systemContext;

@end
