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
