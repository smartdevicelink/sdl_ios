//  SDLAudioPassThruCapabilities.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLSamplingRate.h>
#import <SmartDeviceLink/SDLBitsPerSample.h>
#import <SmartDeviceLink/SDLAudioType.h>

@interface SDLAudioPassThruCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLSamplingRate* samplingRate;
@property(strong) SDLBitsPerSample* bitsPerSample;
@property(strong) SDLAudioType* audioType;

@end
