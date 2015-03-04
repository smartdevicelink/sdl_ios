//  SDLAudioPassThruCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLSamplingRate.h"
#import "SDLBitsPerSample.h"
#import "SDLAudioType.h"

@interface SDLAudioPassThruCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLSamplingRate* samplingRate;
@property(strong) SDLBitsPerSample* bitsPerSample;
@property(strong) SDLAudioType* audioType;

@end
