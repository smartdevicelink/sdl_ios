//  SDLOasisAddress.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Struct used in SendLocation describing an address
 */
@interface SDLOasisAddress : SDLRPCStruct

- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode;

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
