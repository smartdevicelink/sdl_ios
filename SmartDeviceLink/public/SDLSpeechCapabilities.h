//  SDLSpeechCapabilities.h
//


#import "SDLEnum.h"

/**
 * Contains information about TTS capabilities on the SDL platform. Used in RegisterAppInterfaceResponse, and TTSChunk.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLSpeechCapabilities NS_TYPED_ENUM;

/**
 The SDL platform can speak text phrases.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesText;

/**
 The SDL platform can speak SAPI Phonemes.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSAPIPhonemes;

/**
 The SDL platform can speak LHPlus Phonemes.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesLHPlusPhonemes;

/**
 The SDL platform can speak Prerecorded indicators and prompts.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesPrerecorded;

/**
 The SDL platform can speak Silence.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSilence;

/**
 The SDL platform can play a file
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesFile;
