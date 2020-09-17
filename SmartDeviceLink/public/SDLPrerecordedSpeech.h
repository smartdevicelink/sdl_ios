//  SDLPrerecordedSpeech.h
//


#import "SDLEnum.h"

/**
 Contains information about the speech capabilities on the SDL platform. Used in RegisterAppInterfaceResponse to indicate capability.
 */
typedef SDLEnum SDLPrerecordedSpeech NS_TYPED_ENUM;

/**
 A prerecorded help prompt
 */
extern SDLPrerecordedSpeech const SDLPrerecordedSpeechHelp;

/**
 A prerecorded initial prompt
 */
extern SDLPrerecordedSpeech const SDLPrerecordedSpeechInitial;

/**
 A prerecorded listen prompt is available
 */
extern SDLPrerecordedSpeech const SDLPrerecordedSpeechListen;

/**
 A prerecorded positive indicator noise is available
 */
extern SDLPrerecordedSpeech const SDLPrerecordedSpeechPositive;

/**
 A prerecorded negative indicator noise is available
 */
extern SDLPrerecordedSpeech const SDLPrerecordedSpeechNegative;
