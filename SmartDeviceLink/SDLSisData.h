//  SDLSisData.h
//

#import "SDLRPCMessage.h"

@class SDLStationIDNumber;
@class SDLGPSLocation;

/**
 * HD radio Station Information Service (SIS) data.
 *
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSisData : SDLRPCStruct

- (instancetype)initWithStationShortName:(nullable NSString *)shortName stationID:(nullable SDLStationIDNumber *)id stationLongName:(nullable NSString *)longName stationLocation:(nullable SDLGPSLocation *)location stationMessage:(nullable NSString *)message;

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
 * Optional, SDLGPSLocation type
 */
@property (nullable, strong, nonatomic) SDLGPSLocation *stationLocation;

/**
 * @abstract May be used to convey textual information of general interest
 * to the consumer such as weather forecasts or public service announcements.
 *
 * Optional, String, minLength: 0characters maxlength: 56characters
 */
@property (nullable, strong, nonatomic) NSString *stationMessage;

@end

NS_ASSUME_NONNULL_END
