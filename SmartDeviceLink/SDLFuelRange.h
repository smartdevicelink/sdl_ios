//  SDLFuelRange.h
//

#import "SDLRPCMessage.h"
#import "SDLFuelType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFuelRange : SDLRPCStruct

/**
 * Constructs a newly allocated SDLFuelRange object
 */
- (instancetype)init;

- (instancetype)initWithType:(SDLFuelType)type range:(double)range;

/**
 * @abstract Describes Kind of Fuel Type used
 *
 * Optional, FuelType
 */
@property (nullable, copy, nonatomic) SDLFuelType type;

/**
 * @abstract Describes The estimate range in KM
 * the vehicle can travel based on fuel level and consumption.
 *
 * Optional, Float 0 - 10000
 */
@property (nullable, copy, nonatomic) NSNumber<SDLFloat> *range;


@end
NS_ASSUME_NONNULL_END
