//
//  SDLTemperatureUnit.h
//


#import "SDLEnum.h"

/**
 The unit of temperature to display. Used in Temperature.
 */
typedef SDLEnum SDLTemperatureUnit NS_TYPED_ENUM;

/**
 Reflects the current HMI setting for temperature unit in Celsius
 */
extern SDLTemperatureUnit const SDLTemperatureUnitCelsius;

/**
 Reflects the current HMI setting for temperature unit in Fahrenheit
 */
extern SDLTemperatureUnit const SDLTemperatureUnitFahrenheit;
