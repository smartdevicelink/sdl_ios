//  SDLLocationDetails.h
//

#import "SDLRPCStruct.h"

@class SDLLocationCoordinate;
@class SDLImage;
@class SDLOasisAddress;

@interface SDLLocationDetails : SDLRPCStruct

/**
 * @abstract Latitude/Longitude of the location
 *
 * @see SDLLocationCoordinate
 *
 * Optional
 */
@property (strong, nonatomic) SDLLocationCoordinate *coordinate;

/**
 * @abstract Name of location.
 *
 * Optional, Max length 500 chars
 */
@property (copy, nonatomic) NSString *locationName;

/**
 * @abstract Location address for display purposes only.
 *
 * Optional, Array of Strings, Array length 0 - 4, Max String length 500
 */
@property (copy, nonatomic) NSArray<NSString *> *addressLines;

/**
 * @abstract Description intended location / establishment.
 *
 * Optional, Max length 500 chars
 */
@property (copy, nonatomic) NSString *locationDescription;

/**
 * @abstract Phone number of location / establishment.
 *
 * Optional, Max length 500 chars
 */
@property (copy, nonatomic) NSString *phoneNumber;

/**
 * @abstract Image / icon of intended location.
 *
 * @see SDLImage
 *
 * Optional
 */
@property (strong, nonatomic) SDLImage *locationImage;

/**
 * @abstract Address to be used by navigation engines for search.
 *
 * @see SDLOASISAddress
 *
 * Optional
 */
@property (strong) SDLOasisAddress *searchAddress;


@end
