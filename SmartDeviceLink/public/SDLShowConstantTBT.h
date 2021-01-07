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

#import "SDLRPCRequest.h"

@class SDLImage;
@class SDLSoftButton;

/**
 *  This RPC is used to update the user with navigation information for the constantly shown screen (base screen), but also for the alert maneuver screen.
 *
 *  @since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLShowConstantTBT : SDLRPCRequest

/**
 * @param navigationText1 - navigationText1
 * @param navigationText2 - navigationText2
 * @param eta - eta
 * @param timeToDestination - timeToDestination
 * @param totalDistance - totalDistance
 * @param turnIcon - turnIcon
 * @param nextTurnIcon - nextTurnIcon
 * @param distanceToManeuver - distanceToManeuver
 * @param distanceToManeuverScale - distanceToManeuverScale
 * @param maneuverComplete - maneuverComplete
 * @param softButtons - softButtons
 * @return A SDLShowConstantTBT object
 */
- (instancetype)initWithNavigationText1Param:(nullable NSString *)navigationText1 navigationText2:(nullable NSString *)navigationText2 eta:(nullable NSString *)eta timeToDestination:(nullable NSString *)timeToDestination totalDistance:(nullable NSString *)totalDistance turnIcon:(nullable SDLImage *)turnIcon nextTurnIcon:(nullable SDLImage *)nextTurnIcon distanceToManeuver:(nullable NSNumber<SDLFloat> *)distanceToManeuver distanceToManeuverScale:(nullable NSNumber<SDLFloat> *)distanceToManeuverScale maneuverComplete:(nullable NSNumber<SDLBool> *)maneuverComplete softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons __deprecated_msg("Eventually an initializer without param will be added");

/// Convenience init to create navigation directions
///
/// @param navigationText1 The first line of text in a multi-line overlay screen
/// @param navigationText2 The second line of text in a multi-line overlay screen
/// @param eta Estimated Time of Arrival time at final destination
/// @param timeToDestination The amount of time needed to reach the final destination
/// @param totalDistance The distance to the final destination
/// @param turnIcon An icon to show with the turn description
/// @param nextTurnIcon An icon to show with the next turn description
/// @param distanceToManeuver Distance (in meters) until next maneuver.
/// @param distanceToManeuverScale Distance (in meters) from previous maneuver to next maneuver.
/// @param maneuverComplete If and when a maneuver has completed while an AlertManeuver is active, the app must send this value set to TRUE in order to clear the AlertManeuver overlay. If omitted the value will be assumed as FALSE
/// @param softButtons Three dynamic SoftButtons available (first SoftButton is fixed to "Turns")
/// @return An SDLShowConstantTBT object
- (instancetype)initWithNavigationText1:(nullable NSString *)navigationText1 navigationText2:(nullable NSString *)navigationText2 eta:(nullable NSString *)eta timeToDestination:(nullable NSString *)timeToDestination totalDistance:(nullable NSString *)totalDistance turnIcon:(nullable SDLImage *)turnIcon nextTurnIcon:(nullable SDLImage *)nextTurnIcon distanceToManeuver:(double)distanceToManeuver distanceToManeuverScale:(double)distanceToManeuverScale maneuverComplete:(BOOL)maneuverComplete softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons __deprecated_msg("Eventually an initializer with different parameter types will be added");

/**
 *  The first line of text in a multi-line overlay screen.
 *
 *  Optional, Max length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *navigationText1;

/**
 *  The second line of text in a multi-line overlay screen.
 *
 *  Optional, 1 - 500 chars
 */
@property (strong, nonatomic, nullable) NSString *navigationText2;

/**
 *  Estimated Time of Arrival time at final destination
 *
 *  Optional, 1 - 500 chars
 */
@property (strong, nonatomic, nullable) NSString *eta;

/**
 *  The amount of time needed to reach the final destination
 *
 *  Optional, 1 - 500 chars
 */
@property (strong, nonatomic, nullable) NSString *timeToDestination;

/**
 *  The distance to the final destination
 *
 *  Optional, 1 - 500 chars
 */
@property (strong, nonatomic, nullable) NSString *totalDistance;

/**
 *  An icon to show with the turn description
 *
 *  Optional
 *
 *  @see SDLImage
 */
@property (strong, nonatomic, nullable) SDLImage *turnIcon;

/**
 *  An icon to show with the next turn description
 *
 *  Optional
 *
 *  @see SDLImage
 */
@property (strong, nonatomic, nullable) SDLImage *nextTurnIcon;

/**
 *  Distance (in meters) until next maneuver. May be used to calculate progress bar.
 *
 *  Optional, Float, 0 - 1,000,000,000
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *distanceToManeuver;

/**
 *  Distance (in meters) from previous maneuver to next maneuver. May be used to calculate progress bar.
 *
 *  Optional, Float, 0 - 1,000,000,000
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *distanceToManeuverScale;

/**
 * If and when a maneuver has completed while an AlertManeuver is active, the app must send this value set to TRUE in order to clear the AlertManeuver overlay. If omitted the value will be assumed as FALSE.
 *
 *  Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *maneuverComplete;

/**
 *  Three dynamic SoftButtons available (first SoftButton is fixed to "Turns"). If omitted on supported displays, the currently displayed SoftButton values will not change.
 *
 *  Optional, Array length 0 - 3
 *
 *  @see SDLSoftButton
 */
@property (strong, nonatomic, nullable) NSArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
