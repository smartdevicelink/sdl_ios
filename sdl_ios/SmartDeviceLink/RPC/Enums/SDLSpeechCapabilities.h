//  SDLSpeechCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLSpeechCapabilities : SDLEnum {}

+(SDLSpeechCapabilities*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLSpeechCapabilities*) TEXT;
+(SDLSpeechCapabilities*) SAPI_PHONEMES;
+(SDLSpeechCapabilities*) LHPLUS_PHONEMES;
+(SDLSpeechCapabilities*) PRE_RECORDED;
+(SDLSpeechCapabilities*) SILENCE;

@end
