//  SDLSpeechCapabilities.h
//


#import "SDLEnum.h"

/*
 * Contains information about TTS capabilities on the SDL platform.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLSpeechCapabilities NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract The SDL platform can speak text phrases.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesText;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSapiPhonemes;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesLhplusPhonemes;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesPreRecorded;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSilence;
