//  SDLGPSLocation.h
//

#import "SDLRPCMessage.h"

/**
 * Describes the GPS data. Not all data will be available on all carlines.
 *
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGPSLocation : SDLRPCStruct

- (instancetype)initWithLatitudeDegrees:(double)latitude LongitudeDegrees:(double)longitude;


- (instancetype)initWithLatitudeDegrees:(double)latitude LongitudeDegrees:(double)longitude altitudeMeter:(nullable NSNumber<SDLFloat> *)altitudeMeters;

/**
 * @abstract longitude degrees
 *
 * Required, Float, -180 - 180
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

/**
 * @abstract latitude degrees
 *
 * Required, Float, -90 - 90
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;
/**
 * @abstract altitude in meters
 *
 * Optional, Float, -99999.0 - 99999
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *altitudeMeters;

@end

NS_ASSUME_NONNULL_END
