//  SDLSpeechCapabilities.h
//


#import "SDLEnum.h"

/*
 * Contains information about TTS capabilities on the SDL platform.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLSpeechCapabilities SDL_SWIFT_ENUM;

/**
 * @abstract The SDL platform can speak text phrases.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesText;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSAPIPhonemes;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesLHPlusPhonemes;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesPrerecorded;

extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSilence;
