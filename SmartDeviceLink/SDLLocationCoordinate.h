//  SDLLocationCoordinate.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Describes a coordinate on earth
 */
@interface SDLLocationCoordinate : SDLRPCStruct

/**
 * Latitude of the location
 *
 * Required, Double -90 - 90
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 * Longitude of the location
 *
 * Required, Double -180 - 180
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

@end

NS_ASSUME_NONNULL_END
