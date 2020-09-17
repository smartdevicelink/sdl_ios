//  SDLTBTState.h
//


#import "SDLEnum.h"

/**
 The turn-by-turn state, used in OnTBTClientState.
 */
typedef SDLEnum SDLTBTState NS_TYPED_ENUM;

/**
 The route should be updated
 */
extern SDLTBTState const SDLTBTStateRouteUpdateRequest;

/**
 The route is accepted
 */
extern SDLTBTState const SDLTBTStateRouteAccepted;

/**
 The route is refused
 */
extern SDLTBTState const SDLTBTStateRouteRefused;

/**
 The route is cancelled
 */
extern SDLTBTState const SDLTBTStateRouteCancelled;

/**
 The route should update its Estimated Time of Arrival
 */
extern SDLTBTState const SDLTBTStateETARequest;

/**
 The route should update its next turn
 */
extern SDLTBTState const SDLTBTStateNextTurnRequest;

/**
 The route should update its status
 */
extern SDLTBTState const SDLTBTStateRouteStatusRequest;

/**
 The route update its summary
 */
extern SDLTBTState const SDLTBTStateRouteSummaryRequest;

/**
 The route should update the trip's status
 */
extern SDLTBTState const SDLTBTStateTripStatusRequest;

/**
 The route update timed out
 */
extern SDLTBTState const SDLTBTStateRouteUpdateRequestTimeout;
