//  SDLLocationCoordinate.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes a coordinate on earth
 */
@interface SDLLocationCoordinate : SDLRPCStruct

/**
 *  Convenience init for location coordinates
 *
 *  @param latitudeDegrees Latitude of the location
 *  @param longitudeDegrees Latitude of the location
 *  @return A SDLLocationCoordinate object
 */
- (instancetype)initWithLatitudeDegrees:(float)latitudeDegrees longitudeDegrees:(float)longitudeDegrees;

/**
 *  Latitude of the location
 *
 *  Required, Double -90 - 90
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 *  Latitude of the location
 *
 *  Required, Double -180 - 180
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

@end

NS_ASSUME_NONNULL_END
