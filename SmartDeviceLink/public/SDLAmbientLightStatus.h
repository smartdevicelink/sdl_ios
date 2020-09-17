//  SDLAmbientLightStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of the ambient light sensor for headlamps
 *
 * @since SDL 3.0
 */
typedef SDLEnum SDLAmbientLightStatus NS_TYPED_ENUM;

/**
 * Represents a "night" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusNight;

/**
 * Represents a "twilight 1" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight1;

/**
 * Represents a "twilight 2" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight2;

/**
 * Represents a "twilight 3" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight3;

/**
 * Represents a "twilight 4" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight4;

/**
 * Represents a "day" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusDay;

/**
 * Represents an "unknown" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusUnknown;

/**
 * Represents a "invalid" ambient light status
 */
extern SDLAmbientLightStatus const SDLAmbientLightStatusInvalid;
