//
//  SDLModuleType.h
//

#import "SDLEnum.h"

/**
 * The type of remote control data. Used in ButtonPress, GetInteriorVehicleData, and ModuleData
 */
typedef SDLEnum SDLModuleType NS_TYPED_ENUM;

/**
 * A SDLModuleType with the value of *CLIMATE*
 */
extern SDLModuleType const SDLModuleTypeClimate;

/**
 * A SDLModuleType with the value of *RADIO*
 */
extern SDLModuleType const SDLModuleTypeRadio;

/**
 * A SDLModuleType with the value of *SEAT*
 */
extern SDLModuleType const SDLModuleTypeSeat;

/**
 * A SDLModuleType with the value of *AUDIO*
 */
extern SDLModuleType const SDLModuleTypeAudio;

/**
 * A SDLModuleType with the value of *LIGHT*
 */
extern SDLModuleType const SDLModuleTypeLight;

/**
 * A SDLModuleType with the value of *HMI_SETTINGS*
 */
extern SDLModuleType const SDLModuleTypeHMISettings;

