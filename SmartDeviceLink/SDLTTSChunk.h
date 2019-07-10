//  SDLTTSChunk.h
//

#import "SDLRPCMessage.h"

#import "SDLSpeechCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Specifies what is to be spoken. This can be simply a text phrase, which SDL will speak according to its own rules. It can also be phonemes from either the Microsoft SAPI phoneme set, or from the LHPLUS phoneme set. It can also be a pre-recorded sound in WAV format (either developer-defined, or provided by the SDL platform).

 In SDL, words, and therefore sentences, can be built up from phonemes and are used to explicitly provide the proper pronounciation to the TTS engine. For example, to have SDL pronounce the word "read" as "red", rather than as when it is pronounced like "reed", the developer would use phonemes to express this desired pronounciation.

 For more information about phonemes, see <a href="http://en.wikipedia.org/wiki/Phoneme">http://en.wikipedia.org/wiki/Phoneme</a>.

 @since SmartDeviceLink 1.0
 */
@interface SDLTTSChunk : SDLRPCStruct

/**
 Initialize with text and a type

 @param text The string to be spoken
 @param type The type of text the string is
 @return The RPC
 */
- (instancetype)initWithText:(NSString *)text type:(SDLSpeechCapabilities)type;

/**
 Create TTS using text

 @param string The text chunk
 @return The RPC
 */
+ (NSArray<SDLTTSChunk *> *)textChunksFromString:(NSString *)string;

/**
 Create TTS using SAPI

 @param string The SAPI chunk
 @return The RPC
 */
+ (NSArray<SDLTTSChunk *> *)sapiChunksFromString:(NSString *)string;

/**
 Create TTS using LH Plus

 @param string The LH Plus chunk
 @return The RPC
 */
+ (NSArray<SDLTTSChunk *> *)lhPlusChunksFromString:(NSString *)string;

/**
 Create TTS using prerecorded chunks

 @param string The prerecorded chunk
 @return The RPC
 */
+ (NSArray<SDLTTSChunk *> *)prerecordedChunksFromString:(NSString *)string;

/**
 Create TTS using silence

 @return The RPC
 */
+ (NSArray<SDLTTSChunk *> *)silenceChunks;

/**
 Create "TTS" to play an audio file previously uploaded to the system.

 @param fileName The name of the file used in the SDLFile or PutFile that was uploaded
 @return The RPC
 */
+ (NSArray<SDLTTSChunk *> *)fileChunksWithName:(NSString *)fileName;

/**
 * Text to be spoken, a phoneme specification, or the name of a pre-recorded / pre-uploaded sound. The contents of this field are indicated by the "type" field.
 *
 * Required, Max length 500
 */
@property (strong, nonatomic) NSString *text;

/**
 * The type of information in the "text" field (e.g. phrase to be spoken, phoneme specification, name of pre-recorded sound).
 *
 * Required
 */
@property (strong, nonatomic) SDLSpeechCapabilities type;

@end

NS_ASSUME_NONNULL_END
