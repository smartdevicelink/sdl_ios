//  SDLOasisAddress.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOasisAddress : SDLRPCStruct

- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode;

- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode countryName:(nullable NSString *)countryName subAdministrativeArea:(nullable NSString *)subAdministrativeArea subLocality:(nullable NSString *)subLocality;

/**
 * @abstract Name of the country (localized)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *countryName;

/**
 * @abstract countryCode of the country(ISO 3166-2)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *countryCode;

/**
 * @abstract postalCode of location (PLZ, ZIP, PIN, CAP etc.)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *postalCode;

/**
 * @abstract Portion of country (e.g. state)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *administrativeArea;

/**
 * @abstract Portion of administrativeArea (e.g. county)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subAdministrativeArea;

/**
 * @abstract Hypernym for city/village
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *locality;

/**
 * @abstract Hypernym for district
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subLocality;

/**
 * @abstract Hypernym for street, road etc.
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *thoroughfare;

/**
 * @abstract Portion of thoroughfare (e.g. house number)
 *
 * Optional, max length = 200
 */
@property (nullable, copy, nonatomic) NSString *subThoroughfare;

@end

NS_ASSUME_NONNULL_END
