//  SDLTTSChunk.h
//

#import "SDLRPCMessage.h"

@class SDLSpeechCapabilities;


/**
 *  Specifies what is to be spoken. This can be simply a text phrase, which SDL will speak according to its own rules. It can also be phonemes from either the Microsoft SAPI phoneme set, or from the LHPLUS phoneme set. It can also be a pre-recorded sound in WAV format (either developer-defined, or provided by the SDL platform).
 *
 *  In SDL, words, and therefore sentences, can be built up from phonemes and are used to explicitly provide the proper pronounciation to the TTS engine. For example, to have SDL pronounce the word "read" as "red", rather than as when it is pronounced like "reed", the developer would use phonemes to express this desired pronounciation.
 *
 *  For more information about phonemes, see <a href="http://en.wikipedia.org/wiki/Phoneme">http://en.wikipedia.org/wiki/Phoneme</a>.
 *
 *  Parameter List
 *  <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>text</td>
 * 			<td>String</td>
 * 			<td>Text to be spoken, or a phoneme specification, or the name of a pre-recorded sound. The contents of this field are indicated by the "type" field.</td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>type</td>
 * 			<td>SpeechCapabilities</td>
 * 			<td>Indicates the type of information in the "text" field (e.g. phrase to be spoken, phoneme specification, name of pre-recorded sound). </td>
 * 			<td>SmartDeviceLink 1.0</td>
 * 		</tr>
 *  </table>
 *
 *  @since SmartDeviceLink 1.0
 */
@interface SDLTTSChunk : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLTTSChunk object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLTTSChunk object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithText:(NSString *)text type:(SDLSpeechCapabilities *)type;

+ (NSMutableArray<SDLTTSChunk *> *)textChunksFromString:(NSString *)string;

+ (NSMutableArray<SDLTTSChunk *> *)sapiChunksFromString:(NSString *)string;

+ (NSMutableArray<SDLTTSChunk *> *)lhPlusChunksFromString:(NSString *)string;

+ (NSMutableArray<SDLTTSChunk *> *)prerecordedChunksFromString:(NSString *)string;

+ (NSMutableArray<SDLTTSChunk *> *)silenceChunks;


/**
 * @abstract Text to be spoken, or a phoneme specification, or the name of a pre-recorded sound. The contents of this field are indicated by the "type" field.
 *
 * Required, Max length 500
 */
@property (strong) NSString *text;

/**
 * @abstract The type of information in the "text" field (e.g. phrase to be spoken, phoneme specification, name of pre-recorded sound).
 *
 * Required
 */
@property (strong) SDLSpeechCapabilities *type;

@end
