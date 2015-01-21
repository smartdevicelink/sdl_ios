//  SDLSpeechCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Contains information about TTS capabilities on the SYNC platform.
 *
 * Avaliable since <font color=red><b> AppLink 1.0 </b></font>
 */
@interface SDLSpeechCapabilities : SDLEnum {}

/*!
 @abstract get SDLSpeechCapabilities according value string
 @param value NSString
 @result SDLSpeechCapabilities object
 */
+(SDLSpeechCapabilities*) valueOf:(NSString*) value;
/*!
 @abstract declare an array to store all possible SDLSpeechCapabilities values
 @result return the array
 */
+(NSMutableArray*) values;

/**
 * @abstract The SYNC platform can speak text phrases.
 * @result return SDLSpeechCapabilities of value : <font color=gray><i> TEXT </i></font>
 * @since AppLink 1.0
 */
+(SDLSpeechCapabilities*) TEXT;
/*!
 @abstract SAPI_PHONEMES
 */
+(SDLSpeechCapabilities*) SAPI_PHONEMES;
/*!
 @abstract LHPLUS_PHONEMES
 */
+(SDLSpeechCapabilities*) LHPLUS_PHONEMES;
/*!
 @abstract PRE_RECORDED
 */
+(SDLSpeechCapabilities*) PRE_RECORDED;
/*!
 @abstract SILENCE
 */
+(SDLSpeechCapabilities*) SILENCE;

@end
