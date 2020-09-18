//
//  SDLTurnSignal.h
//  SmartDeviceLink
//
//  Created by Nicole on 7/19/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  Enumeration that describes the status of the turn light indicator.
 */
typedef SDLEnum SDLTurnSignal NS_TYPED_ENUM;

/**
 *  Turn signal is OFF
 */
extern SDLTurnSignal const SDLTurnSignalOff;

/**
 *  Left turn signal is on
 */
extern SDLTurnSignal const SDLTurnSignalLeft;

/**
 *  Right turn signal is on
 */
extern SDLTurnSignal const SDLTurnSignalRight;

/**
 *  Both signals (left and right) are on
 */
extern SDLTurnSignal const SDLTurnSignalBoth;
