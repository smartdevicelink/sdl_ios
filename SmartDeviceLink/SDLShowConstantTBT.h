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

@property (strong) NSString *navigationText1;
@property (strong) NSString *navigationText2;
@property (strong) NSString *eta;
@property (strong) NSString *timeToDestination;
@property (strong) NSString *totalDistance;
@property (strong) SDLImage *turnIcon;
@property (strong) SDLImage *nextTurnIcon;
@property (strong) NSNumber<SDLFloat> *distanceToManeuver;
@property (strong) NSNumber<SDLFloat> *distanceToManeuverScale;
@property (strong) NSNumber<SDLBool> *maneuverComplete;
@property (strong) NSMutableArray<SDLSoftButton *> *softButtons;

@end
