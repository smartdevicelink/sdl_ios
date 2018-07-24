//
//  SDLModuleType.h
//

#import "SDLEnum.h"

/**
 * The type of remote control data. Used in ButtonPress, GetInteriorVehicleData, and ModuleData
 */
typedef SDLEnum SDLModuleType SDL_SWIFT_ENUM;

/**
 * A SDLModuleType with the value of *CLIMATE*
 */
extern SDLModuleType const SDLModuleTypeClimate;

/**
 * A SDLModuleType with the value of *RADIO*
 */
extern SDLModuleType const SDLModuleTypeRadio;

/**
 * @abstract A SDLModuleType with the value of *AUDIO*
 */
extern SDLModuleType const SDLModuleTypeAudio;

/**
 * @abstract A SDLModuleType with the value of *LIGHT*
 */
extern SDLModuleType const SDLModuleTypeLight;

/**
 * @abstract A SDLModuleType with the value of *HMI_SETTINGS*
 */
extern SDLModuleType const SDLModuleTypeHMISettings;

