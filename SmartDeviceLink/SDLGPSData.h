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
 * @abstract longitude degrees
 *
 * Required, Float, -180 - 180
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

/**
 * @abstract latitude degrees
 *
 * Required, Float, -90 - 90
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 * @abstract utc year
 *
 * Required, Integer, 2010 - 2100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *utcYear;

/**
 * @abstract utc month
 *
 * Required, Integer, 1 - 12
 */
@property (strong, nonatomic) NSNumber<SDLInt> *utcMonth;

/**
 * @abstract utc day
 *
 * Required, Integer, 1 - 31
 */
@property (strong, nonatomic) NSNumber<SDLInt> *utcDay;

/**
 * @abstract utc hours
 *
 * Required, Integer, 0 - 23
 */
@property (strong, nonatomic) NSNumber<SDLInt> *utcHours;

/**
 * @abstract utc minutes
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *utcMinutes;

/**
 * @abstract utc seconds
 *
 * Required, Integer, 0 - 59
 */
@property (strong, nonatomic) NSNumber<SDLInt> *utcSeconds;

/**
 * Potential Compass Directions
 */
@property (strong, nonatomic) SDLCompassDirection compassDirection;

/**
 * @abstract The 3D positional dilution of precision.
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 10.0
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *pdop;

/**
 * @abstract The horizontal dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 10.0
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *hdop;

/**
 * @abstract the vertical dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 10.0
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *vdop;

/**
 * @abstract What the coordinates are based on
 *
 * @discussion YES, if coordinates are based on satellites. NO, if based on dead reckoning.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *actual;

/**
 * @abstract The number of satellites in view
 *
 * Required, Integer, 0 - 31
 */
@property (strong, nonatomic) NSNumber<SDLInt> *satellites;

/**
 * The supported dimensions of the GPS
 *
 * Required
 */
@property (strong, nonatomic) SDLDimension dimension;

/**
 * @abstract altitude in meters
 *
 * Required, Float, -10000.0 - 10000.0
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *altitude;

/**
 * @abstract Heading based on the GPS data.
 * 
 * @discussion North is 0, East is 90, etc. Resolution is 0.01
 *
 * Required, Float, 0.0 - 359.99
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *heading;

/**
 * @abstract speed in KPH
 *
 * Required, Float, 0.0 - 500.0
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *speed;

@end

NS_ASSUME_NONNULL_END
