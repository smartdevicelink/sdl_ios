//  SDLSpeechCapabilities.h
//


#import "SDLEnum.h"

/*
 * Contains information about TTS capabilities on the SDL platform.
 *
 * @since SDL 1.0
 */
@interface SDLSpeechCapabilities : SDLEnum {
}

/**
 * @abstract get SDLSpeechCapabilities according value string
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLSpeechCapabilities object
 */
+ (SDLSpeechCapabilities *)valueOf:(NSString *)value;

/**
 * @abstract declare an array to store all possible SDLSpeechCapabilities values
 *
 * @return the array of all possible values
 */
+ (NSArray *)values;

/**
 * @abstract The SDL platform can speak text phrases.
 *
 * @return SDLSpeechCapabilities of value: *TEXT*
 */
+ (SDLSpeechCapabilities *)TEXT;

+ (SDLSpeechCapabilities *)SAPI_PHONEMES;

+ (SDLSpeechCapabilities *)LHPLUS_PHONEMES;

+ (SDLSpeechCapabilities *)PRE_RECORDED;

+ (SDLSpeechCapabilities *)SILENCE;

@end
