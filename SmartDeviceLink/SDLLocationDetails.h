//  SDLLocationDetails.h
//

#import "SDLRPCStruct.h"

@class SDLLocationCoordinate;
@class SDLImage;
@class SDLOasisAddress;

NS_ASSUME_NONNULL_BEGIN

/**
 Describes a location, including its coordinate, name, etc. Used in WayPoints.
 */
@interface SDLLocationDetails : SDLRPCStruct

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
