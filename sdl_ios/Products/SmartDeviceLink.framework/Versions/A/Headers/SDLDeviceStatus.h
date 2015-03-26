//  SDLDeviceStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLDeviceLevelStatus.h>
#import <SmartDeviceLink/SDLPrimaryAudioSource.h>

@interface SDLDeviceStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* voiceRecOn;
@property(strong) NSNumber* btIconOn;
@property(strong) NSNumber* callActive;
@property(strong) NSNumber* phoneRoaming;
@property(strong) NSNumber* textMsgAvailable;
@property(strong) SDLDeviceLevelStatus* battLevelStatus;
@property(strong) NSNumber* stereoAudioOutputMuted;
@property(strong) NSNumber* monoAudioOutputMuted;
@property(strong) SDLDeviceLevelStatus* signalLevelStatus;
@property(strong) SDLPrimaryAudioSource* primaryAudioSource;
@property(strong) NSNumber* eCallEventActive;

@end
