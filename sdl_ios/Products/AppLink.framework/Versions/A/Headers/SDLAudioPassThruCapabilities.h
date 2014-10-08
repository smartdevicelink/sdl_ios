//  SDLAudioPassThruCapabilities.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLSamplingRate.h>
#import <AppLink/SDLBitsPerSample.h>
#import <AppLink/SDLAudioType.h>

@interface SDLAudioPassThruCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLSamplingRate* samplingRate;
@property(strong) SDLBitsPerSample* bitsPerSample;
@property(strong) SDLAudioType* audioType;

@end
