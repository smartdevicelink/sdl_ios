//  SDLGPSLocation.h
//

#import "SDLRPCMessage.h"

/**
 * Provides teh 3-dimensional geographic station location.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGPSLocation : SDLRPCStruct

- (instancetype)initWithLatitudeDegrees:(double)latitudeDegrees longitudeDegrees:(double)longitudeDegrees;

- (instancetype)initWithLatitudeDegrees:(double)latitudeDegrees longitudeDegrees:(double)longitudeDegrees altitudeMeters:(nullable NSNumber<SDLFloat> *)altitudeMeters;

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
