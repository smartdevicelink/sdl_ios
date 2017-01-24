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

@property (strong, nonatomic, nullable) NSString *navigationText1;
@property (strong, nonatomic, nullable) NSString *navigationText2;
@property (strong, nonatomic, nullable) NSString *eta;
@property (strong, nonatomic, nullable) NSString *timeToDestination;
@property (strong, nonatomic, nullable) NSString *totalDistance;
@property (strong, nonatomic, nullable) SDLImage *turnIcon;
@property (strong, nonatomic, nullable) SDLImage *nextTurnIcon;
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *distanceToManeuver;
@property (strong, nonatomic, nullable) NSNumber<SDLFloat> *distanceToManeuverScale;
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *maneuverComplete;
@property (strong, nonatomic, nullable) NSArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
