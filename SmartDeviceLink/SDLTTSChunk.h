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

- (instancetype)initWithText:(NSString *)text type:(SDLSpeechCapabilities)type;

+ (NSArray<SDLTTSChunk *> *)textChunksFromString:(NSString *)string;

+ (NSArray<SDLTTSChunk *> *)sapiChunksFromString:(NSString *)string;

+ (NSArray<SDLTTSChunk *> *)lhPlusChunksFromString:(NSString *)string;

+ (NSArray<SDLTTSChunk *> *)prerecordedChunksFromString:(NSString *)string;

+ (NSArray<SDLTTSChunk *> *)silenceChunks;


/**
 * Text to be spoken, or a phoneme specification, or the name of a pre-recorded sound. The contents of this field are indicated by the "type" field.
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
