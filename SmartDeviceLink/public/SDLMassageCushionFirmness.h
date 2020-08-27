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
 Constructs a newly allocated SDLMassageCushionFirmness object with cushion and firmness

 @param cushion The cushion type for a multi-contour massage seat
 @param firmness The firmness value for the multi-contour massage seat, MinValue: 0 MaxValue: 100
 @return An instance of the SDLMassageCushionFirmness class
 */
- (instancetype)initWithMassageCushion:(SDLMassageCushion)cushion firmness:(UInt8)firmness;

/**
 * @abstract cushion of a multi-contour massage seat.
 *
 * @see SDLMassageCushion
 */
@property (strong, nonatomic) SDLMassageCushion cushion;

/**
 * @abstract zone of a multi-contour massage seat.
 *
 * Required, MinValue: 0 MaxValue: 100
 *
 */
@property (strong, nonatomic) NSNumber<SDLInt> *firmness;
@end

NS_ASSUME_NONNULL_END

