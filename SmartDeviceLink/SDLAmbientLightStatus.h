//  SDLAmbientLightStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of the ambient light sensor
 * @since SDL 3.0
 */
SDLEnum(SDLAmbientLightStatus);

extern SDLAmbientLightStatus const SDLAmbientLightStatusNight;
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight1;
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight2;
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight3;
extern SDLAmbientLightStatus const SDLAmbientLightStatusTwilight4;
extern SDLAmbientLightStatus const SDLAmbientLightStatusDay;
extern SDLAmbientLightStatus const SDLAmbientLightStatusUnknown;
extern SDLAmbientLightStatus const SDLAmbientLightStatusInvalid;
