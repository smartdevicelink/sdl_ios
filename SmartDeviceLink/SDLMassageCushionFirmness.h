//  SDLMassageCushionFirmness.h
//

#import "SDLRPCStruct.h"
#import "SDLMassageCushion.h"
/**
 * The intensity or firmness of a cushion.
 */

NS_ASSUME_NONNULL_BEGIN
@interface SDLMassageCushionFirmness : SDLRPCStruct

/**
 * @abstract Constructs a newly allocated SDLMassageCushionFirmness object with cushion and firmness
 */
- (instancetype)initWithMassageCushion:(SDLMassageCushion)cushion firmness:(UInt16)firmness;

/**
 * @abstract cushion of a multi-contour massage seat.
 *
 * @see SDLMassageCushion
 */
@property (strong, nonatomic) SDLMassageCushion cushion;

/**
 * @abstract zone of a multi-contour massage seat.
 *
 * Required, MinValue- 0 MaxValue= 100
 *
 */
@property (strong, nonatomic) NSNumber<SDLInt> *firmness;
@end

NS_ASSUME_NONNULL_END

