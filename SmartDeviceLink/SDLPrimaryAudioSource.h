//  SDLPrimaryAudioSource.h
//


#import "SDLEnum.h"

/**
 * Reflects the current primary audio source of SDL (if selected).
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLPrimaryAudioSource SDL_SWIFT_ENUM;

/**
 * @abstract Currently no source selected
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceNoSourceSelected;

/**
 * @abstract USB is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceUSB;

/**
 * @abstract USB2 is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceUSB2;

/**
 * @abstract Bluetooth Stereo is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceBluetoothStereo;

/**
 * @abstract Line in is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceLineIn;

/**
 * @abstract iPod is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceIpod;

/**
 * @abstract Mobile app is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceMobileApp;
