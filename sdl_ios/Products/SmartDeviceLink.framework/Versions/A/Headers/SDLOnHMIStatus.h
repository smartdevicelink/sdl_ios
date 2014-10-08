//  SDLOnHMIStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLHMILevel.h>
#import <SmartDeviceLink/SDLAudioStreamingState.h>
#import <SmartDeviceLink/SDLSystemContext.h>

@interface SDLOnHMIStatus : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLHMILevel* hmiLevel;
@property(strong) SDLAudioStreamingState* audioStreamingState;
@property(strong) SDLSystemContext* systemContext;

@end
