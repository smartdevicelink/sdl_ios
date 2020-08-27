//SDLStationIDNumber.h
//

#import "SDLRPCMessage.h"

/**
 * Describes the hour, minute and second values used to set the media clock.
 *
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLStationIDNumber : SDLRPCStruct

/// Convenience init

/// @param countryCode Binary Representation of ITU Country Code. USA Code is 001
/// @param id Binary representation  of unique facility ID assigned by the FCC
/// @return An SDLStationIDNumber object
- (instancetype)initWithCountryCode:(nullable NSNumber<SDLInt> *)countryCode fccFacilityId:(nullable NSNumber<SDLInt> *)id;

/**
 * @abstract Binary Representation of ITU Country Code. USA Code is 001.
 *
 * Optional, Integer, 0 - 999
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *countryCode;

/**
 * @abstract Binary representation  of unique facility ID assigned by the FCC
 * FCC controlled for U.S. territory
 *
 * Optional, Integer, 0 - 999
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *fccFacilityId;

@end

NS_ASSUME_NONNULL_END
