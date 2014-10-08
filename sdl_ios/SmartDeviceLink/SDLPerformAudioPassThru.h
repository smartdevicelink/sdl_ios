//  SDLPerformAudioPassThru.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

#import <SmartDeviceLink/SDLSamplingRate.h>
#import <SmartDeviceLink/SDLBitsPerSample.h>
#import <SmartDeviceLink/SDLAudioType.h>

@interface SDLPerformAudioPassThru : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* initialPrompt;
@property(strong) NSString* audioPassThruDisplayText1;
@property(strong) NSString* audioPassThruDisplayText2;
@property(strong) SDLSamplingRate* samplingRate;
@property(strong) NSNumber* maxDuration;
@property(strong) SDLBitsPerSample* bitsPerSample;
@property(strong) SDLAudioType* audioType;
@property(strong) NSNumber* muteAudio;

@end
