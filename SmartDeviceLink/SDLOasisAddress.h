//  SDLOasisAddress.h
//

#import "SDLRPCStruct.h"

@interface SDLOasisAddress : SDLRPCStruct

- (instancetype)initWithSubThoroughfare:(NSString *)subThoroughfare thoroughfare:(NSString *)thoroughfare locality:(NSString *)locality administrativeArea:(NSString *)administrativeArea postalCode:(NSString *)postalCode countryCode:(NSString *)countryCode;

- (instancetype)initWithSubThoroughfare:(NSString *)subThoroughfare thoroughfare:(NSString *)thoroughfare locality:(NSString *)locality administrativeArea:(NSString *)administrativeArea postalCode:(NSString *)postalCode countryCode:(NSString *)countryCode countryName:(NSString *)countryName subAdministrativeArea:(NSString *)subAdministrativeArea subLocality:(NSString *)subLocality;

/**
 * @abstract Name of the country (localized)
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *countryName;

/**
 * @abstract countryCode of the country(ISO 3166-2)
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *countryCode;

/**
 * @abstract postalCode of location (PLZ, ZIP, PIN, CAP etc.)
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *postalCode;

/**
 * @abstract Portion of country (e.g. state)
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *administrativeArea;

/**
 * @abstract Portion of administrativeArea (e.g. county)
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *subAdministrativeArea;

/**
 * @abstract Hypernym for city/village
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *locality;

/**
 * @abstract Hypernym for district
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *subLocality;

/**
 * @abstract Hypernym for street, road etc.
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *thoroughfare;

/**
 * @abstract Portion of thoroughfare (e.g. house number)
 *
 * Optional, max length = 200
 */
@property (copy, nonatomic) NSString *subThoroughfare;

@end
