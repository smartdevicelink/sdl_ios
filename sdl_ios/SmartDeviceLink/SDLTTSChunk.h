//  SDLTTSChunk.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLSpeechCapabilities.h>

/**
 * Specifies what is to be spoken. This can be simply a text phrase, which SYNC will speak according to its own rules.
 *  It can also be phonemes from either the Microsoft SAPI phoneme set, or from the LHPLUS phoneme set.
 *  It can also be a pre-recorded sound in WAV format (either developer-defined, or provided by the SYNC platform).
 *
 *  <p>In SYNC, words, and therefore sentences, can be built up from phonemes and are used to explicitly provide the proper pronounciation to the TTS engine.
 *   For example, to have SYNC pronounce the word "read" as "red", rather than as when it is pronounced like "reed",
 *   the developer would use phonemes to express this desired pronounciation.
 *  <p>For more information about phonemes, see <a href="http://en.wikipedia.org/wiki/Phoneme">http://en.wikipedia.org/wiki/Phoneme</a>.
 *  <p><b> Parameter List
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>AppLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>text</td>
 * 			<td>String</td>
 * 			<td>Text to be spoken, or a phoneme specification, or the name of a pre-recorded sound. The contents of this field are indicated by the "type" field.</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>type</td>
 * 			<td>SpeechCapabilities</td>
 * 			<td>Indicates the type of information in the "text" field (e.g. phrase to be spoken, phoneme specification, name of pre-recorded sound).	</td>
 * 			<td>AppLink 1.0</td>
 * 		</tr>
 *  </table>
 * Since AppLink 1.0
 */
@interface SDLTTSChunk : SDLRPCStruct {}

/**
 * @abstract Constructs a newly allocated SDLTTSChunk object
 */
-(id) init;
/**
 * @abstract Constructs a newly allocated SDLTTSChunk object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract Text to be spoken, or a phoneme specification, or the name of a pre-recorded sound. The contents of this field are indicated by the "type" field.
 */
@property(strong) NSString* text;
/**
 * @abstract The type of information in the "text" field (e.g. phrase to be spoken, phoneme specification, name of pre-recorded sound).
 */
@property(strong) SDLSpeechCapabilities* type;

@end
