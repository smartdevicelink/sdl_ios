//  SDLOnWayPointChange.h
//

#import "SDLRPCNotification.h"

@class SDLLocationDetails;

NS_ASSUME_NONNULL_BEGIN

/**
 Notification which provides the entire LocationDetails when there is a change to any waypoints or destination.
 */
@interface SDLOnWayPointChange : SDLRPCNotification

/**
 Location address for display purposes only

 Required, Array of Strings, Array size 1 - 10
 */
@property (copy, nonatomic) NSArray<SDLLocationDetails *> *waypoints;

@end

NS_ASSUME_NONNULL_END
