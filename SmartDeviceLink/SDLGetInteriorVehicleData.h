//
//  SDLGetInteriorVehicleData.h
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleData : SDLRPCRequest

- (instancetype)initWithType:(SDLModuleType)moduleType subscribe:(BOOL)subscribe;

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
