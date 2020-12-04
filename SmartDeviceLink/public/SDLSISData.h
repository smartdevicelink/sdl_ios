//  SDLSISData.h
//

#import "SDLRPCMessage.h"

@class SDLStationIDNumber;
@class SDLGPSData;

/**
 * HD radio Station Information Service (SIS) data.
 *
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSISData : SDLRPCStruct

/// Convenience init to SISData
///
/// @param stationShortName Identifies the 4-alpha-character station call sign
/// @param id A SDLStationIDNumber
/// @param stationLongName Identifies the station call sign or other identifying
/// @param stationLocation Provides the 3-dimensional geographic station location
/// @param stationMessage May be used to convey textual information of general interest
/// @return An SDLSISData object
- (instancetype)initWithStationShortName:(nullable NSString *)stationShortName stationIDNumber:(nullable SDLStationIDNumber *)id stationLongName:(nullable NSString *)stationLongName stationLocation:(nullable SDLGPSData *)stationLocation stationMessage:(nullable NSString *)stationMessage;

/**
 * @abstract Identifies the 4-alpha-character station call sign
 * plus an optional (-FM) extension
 *
 * Optional, String, minLength: 4characters maxlength: 7characters
 */
@property (nullable, strong, nonatomic) NSString *stationShortName;

/**
 * @abstract Used for network Application.
 * Consists of Country Code and FCC Facility ID.
 *
 * Optional, SDLStationIDNumber type
 */
@property (nullable, strong, nonatomic) SDLStationIDNumber *stationIDNumber;

/**
 * @abstract Identifies the station call sign or other identifying
 * information in the long format.
 *
 * Optional, String, minLength: 0characters maxlength: 56characters
 */
@property (nullable, strong, nonatomic) NSString *stationLongName;

/**
 * @abstract Provides the 3-dimensional geographic station location
 *
 * Optional, SDLGPSData type
 */
@property (nullable, strong, nonatomic) SDLGPSData *stationLocation;

/**
 * @abstract May be used to convey textual information of general interest
 * to the consumer such as weather forecasts or public service announcements.
 *
 * Optional, String, minLength: 0characters maxlength: 56characters
 */
@property (nullable, strong, nonatomic) NSString *stationMessage;

@end

NS_ASSUME_NONNULL_END
