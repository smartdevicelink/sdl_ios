//  SDLLocationDetails.h
//

#import "SDLRPCStruct.h"

@class SDLLocationCoordinate;
@class SDLImage;
@class SDLOasisAddress;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes a location, including its coordinate, name, etc. Used in WayPoints.
 */
@interface SDLLocationDetails : SDLRPCStruct

/**
 *  Convenience init for location coordinate.
 *
 *  @param coordinate       Latitude/Longitude of the location
 *  @return                 A SDLLocationDetails object
 */
- (instancetype)initWithCoordinate:(SDLLocationCoordinate *)coordinate NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init for all parameters.
 *
 *  @param coordinate Latitude/Longitude of the location
 *  @param locationName Name of location
 *  @param addressLines Location address for display purposes only
 *  @param locationDescription Description intended location / establishment
 *  @param phoneNumber Phone number of location / establishment
 *  @param locationImage Image / icon of intended location
 *  @param searchAddress Address to be used by navigation engines for search
 *  @return A SDLLocationDetails object
 */
- (instancetype)initWithCoordinate:(SDLLocationCoordinate *)coordinate locationName:(nullable NSString *)locationName addressLines:(nullable NSArray<NSString *> *)addressLines locationDescription:(nullable NSString *)locationDescription phoneNumber:(nullable NSString*)phoneNumber locationImage:(nullable SDLImage *)locationImage searchAddress:(nullable SDLOasisAddress *)searchAddress;

/**
 * Latitude/Longitude of the location
 *
 * @see SDLLocationCoordinate
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLLocationCoordinate *coordinate;

/**
 * Name of location.
 *
 * Optional, Max length 500 chars
 */
@property (nullable, copy, nonatomic) NSString *locationName;

/**
 * Location address for display purposes only.
 *
 * Optional, Array of Strings, Array length 0 - 4, Max String length 500
 */
@property (nullable, copy, nonatomic) NSArray<NSString *> *addressLines;

/**
 * Description intended location / establishment.
 *
 * Optional, Max length 500 chars
 */
@property (nullable, copy, nonatomic) NSString *locationDescription;

/**
 * Phone number of location / establishment.
 *
 * Optional, Max length 500 chars
 */
@property (nullable, copy, nonatomic) NSString *phoneNumber;

/**
 * Image / icon of intended location.
 *
 * @see SDLImage
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *locationImage;

/**
 * Address to be used by navigation engines for search.
 *
 * @see SDLOASISAddress
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLOasisAddress *searchAddress;


@end

NS_ASSUME_NONNULL_END
