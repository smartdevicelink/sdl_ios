//
//  SDLNavigationAction.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  A navigation action.
 */
typedef SDLEnum SDLNavigationAction NS_TYPED_ENUM;

/**
 *  Using this action plus a supplied direction can give the type of turn.
 */
extern SDLNavigationAction const SDLNavigationActionTurn;

/**
 *  A navigation action of exit.
 */
extern SDLNavigationAction const SDLNavigationActionExit;

/**
 *  A navigation action of stay.
 */
extern SDLNavigationAction const SDLNavigationActionStay;

/**
 *  A navigation action of merge.
 */
extern SDLNavigationAction const SDLNavigationActionMerge;

/**
 *  A navigation action of ferry.
 */
extern SDLNavigationAction const SDLNavigationActionFerry;

/**
 *  A navigation action of car shuttle train.
 */
extern SDLNavigationAction const SDLNavigationActionCarShuttleTrain;

/**
 *  A navigation action of waypoint.
 */
extern SDLNavigationAction const SDLNavigationActionWaypoint;
