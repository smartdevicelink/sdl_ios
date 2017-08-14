//
//  SDLGetInteriorVehicleData.h
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleData : SDLRPCRequest

/**
 * The type of a RC module to retrieve module data from the vehicle.
 * In the future, this should be the Identification of a module.
 *
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 * If subscribe is true, the head unit will register onInteriorVehicleData notifications for the requested moduelType.
 * If subscribe is false, the head unit will unregister onInteriorVehicleData notifications for the requested moduelType.
 *
 * optional, Boolean, default Value = false
 */
@property (strong, nonatomic) NSNumber<SDLBool> *subscribe;

@end

NS_ASSUME_NONNULL_END
