//  SDLLocationCoordinate.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLLocationCoordinate : SDLRPCStruct

/**
 * @abstract Latitude of the location
 *
 * Required, Double -90 - 90
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 * @abstract Longitude of the location
 *
 * Required, Double -180 - 180
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

@end

NS_ASSUME_NONNULL_END
