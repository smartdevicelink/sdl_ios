//  SDLOasisAddress.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Struct used in SendLocation describing an address
 */
@interface SDLOasisAddress : SDLRPCStruct

/// Convenience init to describe an oasis address
///
/// @param subThoroughfare Portion of thoroughfare (e.g. house number)
/// @param thoroughfare Hypernym for street, road etc
/// @param locality Hypernym for city/village
/// @param administrativeArea Portion of country (e.g. state)
/// @param postalCode PostalCode of location (PLZ, ZIP, PIN, CAP etc.)
/// @param countryCode CountryCode of the country(ISO 3166-2)
- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode;

/// Convenience init to describe an oasis address with all parameters
///
/// @param subThoroughfare Portion of thoroughfare (e.g. house number)
/// @param thoroughfare Hypernym for street, road etc
/// @param locality Hypernym for city/village
/// @param administrativeArea Portion of country (e.g. state)
/// @param postalCode PostalCode of location (PLZ, ZIP, PIN, CAP etc.)
/// @param countryCode CountryCode of the country(ISO 3166-2)
/// @param subAdministrativeArea Portion of administrativeArea (e.g. county)
/// @param subLocality Hypernym for district
- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode countryName:(nullable NSString *)countryName subAdministrativeArea:(nullable NSString *)subAdministrativeArea subLocality:(nullable NSString *)subLocality;

/**
 * Name of the country (localized)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *countryName;

/**
 * countryCode of the country(ISO 3166-2)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *countryCode;

/**
 * postalCode of location (PLZ, ZIP, PIN, CAP etc.)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *postalCode;

/**
 * Portion of country (e.g. state)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *administrativeArea;

/**
 * Portion of administrativeArea (e.g. county)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subAdministrativeArea;

/**
 * Hypernym for city/village
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *locality;

/**
 * Hypernym for district
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subLocality;

/**
 * Hypernym for street, road etc.
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *thoroughfare;

/**
 * Portion of thoroughfare (e.g. house number)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subThoroughfare;

@end

NS_ASSUME_NONNULL_END
