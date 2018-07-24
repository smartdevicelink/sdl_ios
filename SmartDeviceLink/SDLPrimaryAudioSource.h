//  SDLPrimaryAudioSource.h
//


#import "SDLEnum.h"

/**
 * Reflects the current primary audio source of SDL (if selected). Used in DeviceStatus.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLPrimaryAudioSource SDL_SWIFT_ENUM;

/**
 * Currently no source selected
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceNoSourceSelected;

/**
 * USB is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceUSB;

/**
 * USB2 is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceUSB2;

/**
 * Bluetooth Stereo is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceBluetoothStereo;

/**
 * Line in is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceLineIn;

/**
 * iPod is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceIpod;

/**
 * Mobile app is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceMobileApp;

/**
 * @abstract CD is current source
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceCD;

/**
 * @abstract Radio Tuner is current source
 * Radio may be on AM, FM or XM
 */
extern SDLPrimaryAudioSource const SDLPrimaryAudioSourceRadioTuner;
