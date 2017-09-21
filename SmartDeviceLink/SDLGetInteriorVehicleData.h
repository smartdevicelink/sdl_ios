//
//  SDLGetInteriorVehicleData.h
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"

/**
 * Reads the current status value of specified remote control module (type).
 * When subscribe = true, subscribes for specific remote control module data items.
 * When subscribe=false, un-subscribes for specific remote control module data items.
 * Once subscribed, the application will be notified by the onInteriorVehicleData notification
 * whenever new data is available for the module.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleData : SDLRPCRequest

- (instancetype)initWithModuleType:(SDLModuleType)moduleType;

- (instancetype)initAndSubscribeToModuleType:(SDLModuleType)moduleType;

- (instancetype)initAndUnsubscribeToModuleType:(SDLModuleType)moduleType;

/**
 * The type of a RC module to retrieve module data from the vehicle.
 *
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 * If subscribe is true, the head unit will register onInteriorVehicleData notifications for the requested moduelType.
 * If subscribe is false, the head unit will unregister onInteriorVehicleData notifications for the requested moduelType.
 *
 * optional, Boolean, default Value = false
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *subscribe;

@end

NS_ASSUME_NONNULL_END
