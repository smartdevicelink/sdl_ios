//  SDLPerformAudioPassThru.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCRequest.h"

#import "SDLSamplingRate.h"
#import "SDLBitsPerSample.h"
#import "SDLAudioType.h"

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
