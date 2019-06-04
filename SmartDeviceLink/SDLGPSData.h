//  SDLGPSData.h
//

#import "SDLRPCMessage.h"

#import "SDLCompassDirection.h"
#import "SDLDimension.h"


/**
 * Describes the GPS data. Not all data will be available on all carlines.
 * 
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGPSData : SDLRPCStruct

/**
 * longitude degrees
 *
 * Required, Float, -180 - 180
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

/**
 * latitude degrees
 *
 * Required, Float, -90 - 90
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 * utc year
 *
 * Optional, Integer, 2010 - 2100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcYear;

/**
 * utc month
 *
 * Optional, Integer, 1 - 12
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcMonth;

/**
 * utc day
 *
 * Optional, Integer, 1 - 31
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcDay;

/**
 * utc hours
 *
 * Optional, Integer, 0 - 23
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcHours;

/**
 * utc minutes
 *
 * Optional, Integer, 0 - 59
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcMinutes;

/**
 * utc seconds
 *
 * Optional, Integer, 0 - 59
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *utcSeconds;

/**
 * Optional, Potential Compass Directions
 */
@property (nullable, strong, nonatomic) SDLCompassDirection compassDirection;

/**
 * The 3D positional dilution of precision.
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 1000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *pdop;

/**
 * The horizontal dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 1000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *hdop;

/**
 * the vertical dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 1000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *vdop;

/**
 * What the coordinates are based on
 *
 * @discussion YES, if coordinates are based on satellites. NO, if based on dead reckoning.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *actual;

/**
 * The number of satellites in view
 *
 * Optional, Integer, 0 - 31
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *satellites;

/**
 * The supported dimensions of the GPS
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLDimension dimension;

/**
 * Altitude in meters
 *
 * Optional, Float, -10000.0 - 10000.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *altitude;

/**
 * Heading based on the GPS data.
 * 
 * @discussion North is 0, East is 90, etc. Resolution is 0.01
 *
 * Optional, Float, 0.0 - 359.99
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *heading;

/**
 * Speed in KPH
 *
 * Optional, Float, 0.0 - 500.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *speed;

/**
 * True, if GPS lat/long, time, and altitude have been purposefully shifted (requires a proprietary algorithm to unshift).
 * False, if the GPS data is raw and un-shifted.
 * If not provided, then value is assumed False.
 *
 * Optional, BOOL
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *shifted;

@end

NS_ASSUME_NONNULL_END
