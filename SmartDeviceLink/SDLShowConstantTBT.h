//  SDLShowConstantTBT.h
//

#import "SDLRPCRequest.h"

@class SDLImage;
@class SDLSoftButton;

/** This RPC is used to update the user with navigation information<br>
 *  for the constantly shown screen (base screen),but also for the<br>
 *  alert type screen.
 *<p>
 * @since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLShowConstantTBT : SDLRPCRequest

- (instancetype)initWithNavigationText1:(nullable NSString *)navigationText1 navigationText2:(nullable NSString *)navigationText2 eta:(nullable NSString *)eta timeToDestination:(nullable NSString *)timeToDestination totalDistance:(nullable NSString *)totalDistance turnIcon:(nullable SDLImage *)turnIcon nextTurnIcon:(nullable SDLImage *)nextTurnIcon distanceToManeuver:(double)distanceToManeuver distanceToManeuverScale:(double)distanceToManeuverScale maneuverComplete:(BOOL)maneuverComplete softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

@property (nullable, strong) NSString *navigationText1;
@property (nullable, strong) NSString *navigationText2;
@property (nullable, strong) NSString *eta;
@property (nullable, strong) NSString *timeToDestination;
@property (nullable, strong) NSString *totalDistance;
@property (nullable, strong) SDLImage *turnIcon;
@property (nullable, strong) SDLImage *nextTurnIcon;
@property (nullable, strong) NSNumber<SDLFloat> *distanceToManeuver;
@property (nullable, strong) NSNumber<SDLFloat> *distanceToManeuverScale;
@property (nullable, strong) NSNumber<SDLBool> *maneuverComplete;
@property (nullable, strong) NSMutableArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
