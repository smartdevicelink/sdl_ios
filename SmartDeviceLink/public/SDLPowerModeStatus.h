//  SDLPowerModeStatus.h
//


#import "SDLEnum.h"

/**
 The status of the car's power. Used in ClusterModeStatus.
 */
typedef SDLEnum SDLPowerModeStatus NS_TYPED_ENUM;

/**
 The key is not in the ignition, and the power is off
 */
extern SDLPowerModeStatus const SDLPowerModeStatusKeyOut;

/**
 The key is not in the ignition and it was just recently removed
 */
extern SDLPowerModeStatus const SDLPowerModeStatusKeyRecentlyOut;

/**
 The key is not in the ignition, but an approved key is available
 */
extern SDLPowerModeStatus const SDLPowerModeStatusKeyApproved;

/**
 We are in a post-accessory power situation
 */
extern SDLPowerModeStatus const SDLPowerModeStatusPostAccessory;

/**
 The car is in accessory power mode
 */
extern SDLPowerModeStatus const SDLPowerModeStatusAccessory;

/**
 We are in a post-ignition power situation
 */
extern SDLPowerModeStatus const SDLPowerModeStatusPostIgnition;

/**
 The ignition is on but the car is not yet running
 */
extern SDLPowerModeStatus const SDLPowerModeStatusIgnitionOn;

/**
 The ignition is on and the car is running
 */
extern SDLPowerModeStatus const SDLPowerModeStatusRunning;

/**
 We are in a crank power situation
 */
extern SDLPowerModeStatus const SDLPowerModeStatusCrank;
