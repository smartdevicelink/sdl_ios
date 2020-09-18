//  SDLWaypointType.h
//

#import "SDLEnum.h"

/**
 The type of a navigation waypoint. Used in GetWayPoints.
 */
typedef SDLEnum SDLWayPointType NS_TYPED_ENUM;

/**
 All other waypoint types
 */
extern SDLWayPointType const SDLWayPointTypeAll;

/**
 The destination waypoint
 */
extern SDLWayPointType const SDLWayPointTypeDestination;
