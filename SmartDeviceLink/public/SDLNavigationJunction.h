//
//  SDLNavigationJunction.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  A navigation junction type.
 */
typedef SDLEnum SDLNavigationJunction NS_TYPED_ENUM;

/**
 *  A junction that represents a standard intersection with a single road crossing another.
 */
extern SDLNavigationJunction const SDLNavigationJunctionRegular;

/**
 *  A junction where the road splits off into two paths; a fork in the road.
 */
extern SDLNavigationJunction const SDLNavigationJunctionBifurcation;

/**
 *  A junction that has multiple intersections and paths.
 */
extern SDLNavigationJunction const SDLNavigationJunctionMultiCarriageway;

/**
 *  A junction where traffic moves in a single direction around a central, non-traversable point to reach one of the connecting roads.
 */
extern SDLNavigationJunction const SDLNavigationJunctionRoundabout;

/**
 *  Similar to a roundabout, however the center of the roundabout is fully traversable. Also known as a mini-roundabout.
 */
extern SDLNavigationJunction const SDLNavigationJunctionTraversableRoundabout;

/**
 *  A junction where lefts diverge to the right, then curve to the left, converting a left turn to a crossing maneuver.
 */
extern SDLNavigationJunction const SDLNavigationJunctionJughandle;

/**
 *   Multiple way intersection that allows traffic to flow based on priority; most commonly right of way and first in, first out.
 */
extern SDLNavigationJunction const SDLNavigationJunctionAllWayYield;

/**
 *  A junction designated for traffic turn arounds.
 */
extern SDLNavigationJunction const SDLNavigationJunctionTurnAround;
