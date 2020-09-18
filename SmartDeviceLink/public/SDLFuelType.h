//
//  SDLFuelType.h
//  SmartDeviceLink
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  Enumeration listing possible fuel types.
 */
typedef SDLEnum SDLFuelType NS_TYPED_ENUM;

/**
 *  Fuel type: Gasoline
 */
extern SDLFuelType const SDLFuelTypeGasoline;

/**
 *  Fuel type: Diesel
 */
extern SDLFuelType const SDLFuelTypeDiesel;

/**
 *  Fuel type: CNG
 *
 *  @discussion For vehicles using compressed natural gas
 */
extern SDLFuelType const SDLFuelTypeCNG;

/**
 *  Fuel type: LPG
 *
 *  @discussion For vehicles using liquefied petroleum gas
 */
extern SDLFuelType const SDLFuelTypeLPG;

/**
 *  Fuel type: Hydrogen
 *
 *  @discussion For FCEV (fuel cell electric vehicle)
 */
extern SDLFuelType const SDLFuelTypeHydrogen;

/**
 *  Fuel type: Battery
 *
 *  @discussion For BEV (Battery Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), solar vehicles and other vehicles which run on a battery.
 */
extern SDLFuelType const SDLFuelTypeBattery;
