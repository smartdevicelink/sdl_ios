//  SDLShowConstantTBT.h
//

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

/// Convenience init to create navigation directions
///
/// @param navigationText1 The first line of text in a multi-line overlay screen
/// @param navigationText2 The second line of text in a multi-line overlay screen
/// @param eta Estimated Time of Arrival time at final destination
/// @param timeToDestination The amount of time needed to reach the final destination
/// @param totalDistance The distance to the final destination
/// @param turnIcon An icon to show with the turn description
/// @param nextTurnIcon An icon to show with the next turn description
/// @param distanceToManeuver Fraction of distance till next maneuver
/// @param distanceToManeuverScale Distance till next maneuver
/// @param maneuverComplete If and when a maneuver has completed while an AlertManeuver is active, the app must send this value set to TRUE in order to clear the AlertManeuver overlay. If omitted the value will be assumed as FALSE
/// @param softButtons Three dynamic SoftButtons available (first SoftButton is fixed to "Turns")
/// @return An SDLShowConstantTBT object
- (instancetype)initWithNavigationText1:(nullable NSString *)navigationText1 navigationText2:(nullable NSString *)navigationText2 eta:(nullable NSString *)eta timeToDestination:(nullable NSString *)timeToDestination totalDistance:(nullable NSString *)totalDistance turnIcon:(nullable SDLImage *)turnIcon nextTurnIcon:(nullable SDLImage *)nextTurnIcon distanceToManeuver:(double)distanceToManeuver distanceToManeuverScale:(double)distanceToManeuverScale maneuverComplete:(BOOL)maneuverComplete softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

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
 *  Fraction of distance till next maneuver (starting from when AlertManeuver is triggered). Used to calculate progress bar.
 *
 *  Optional, Float, 0 - 1,000,000,000
 */
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *distanceToManeuver;

/**
 *  Distance till next maneuver (starting from) from previous maneuver. Used to calculate progress bar.
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
