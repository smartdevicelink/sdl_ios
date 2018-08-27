//
//  SDLVentilationMode.h
//

#import "SDLEnum.h"

/**
 The ventilation mode. Used in ClimateControlCapabilities
 */
typedef SDLEnum SDLVentilationMode SDL_SWIFT_ENUM;

/**
 The upper ventilation mode
 */
extern SDLVentilationMode const SDLVentilationModeUpper;

/**
 The lower ventilation mode
 */
extern SDLVentilationMode const SDLVentilationModeLower;

/**
 The both ventilation mode
 */
extern SDLVentilationMode const SDLVentilationModeBoth;

/**
 No ventilation mode
 */
extern SDLVentilationMode const SDLVentilationModeNone;

