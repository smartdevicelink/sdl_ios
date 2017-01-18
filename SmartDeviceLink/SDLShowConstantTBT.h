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
@interface SDLShowConstantTBT : SDLRPCRequest

- (instancetype)initWithNavigationText1:(NSString *)navigationText1 navigationText2:(NSString *)navigationText2 eta:(NSString *)eta timeToDestination:(NSString *)timeToDestination totalDistance:(NSString *)totalDistance turnIcon:(SDLImage *)turnIcon nextTurnIcon:(SDLImage *)nextTurnIcon distanceToManeuver:(double)distanceToManeuver distanceToManeuverScale:(double)distanceToManeuverScale maneuverComplete:(BOOL)maneuverComplete softButtons:(NSArray<SDLSoftButton *> *)softButtons;

@property (strong, nonatomic) NSString *navigationText1;
@property (strong, nonatomic) NSString *navigationText2;
@property (strong, nonatomic) NSString *eta;
@property (strong, nonatomic) NSString *timeToDestination;
@property (strong, nonatomic) NSString *totalDistance;
@property (strong, nonatomic) SDLImage *turnIcon;
@property (strong, nonatomic) SDLImage *nextTurnIcon;
@property (strong, nonatomic) NSNumber<SDLFloat> *distanceToManeuver;
@property (strong, nonatomic) NSNumber<SDLFloat> *distanceToManeuverScale;
@property (strong, nonatomic) NSNumber<SDLBool> *maneuverComplete;
@property (strong, nonatomic) NSMutableArray<SDLSoftButton *> *softButtons;

@end
