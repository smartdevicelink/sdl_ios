/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


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
