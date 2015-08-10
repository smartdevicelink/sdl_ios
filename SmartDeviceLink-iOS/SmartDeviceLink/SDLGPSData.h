//  SDLGPSData.h
//

#import "SDLRPCMessage.h"

@class SDLCompassDirection;
@class SDLDimension;


/**
 * Describes the GPS data. Not all data will be available on all carlines.
 * 
 * @since SDL 2.0
 */
@interface SDLGPSData : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLGPSData object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLGPSData object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract longitude degrees
 *
 * Required, Float, -180 - 180
 */
@property (strong) NSNumber *longitudeDegrees;

/**
 * @abstract latitude degrees
 *
 * Required, Float, -90 - 90
 */
@property (strong) NSNumber *latitudeDegrees;

/**
 * @abstract utc year
 *
 * Required, Integer, 2010 - 2100
 */
@property (strong) NSNumber *utcYear;

/**
 * @abstract utc month
 *
 * Required, Integer, 1 - 12
 */
@property (strong) NSNumber *utcMonth;

/**
 * @abstract utc day
 *
 * Required, Integer, 1 - 31
 */
@property (strong) NSNumber *utcDay;

/**
 * @abstract utc hours
 *
 * Required, Integer, 0 - 23
 */
@property (strong) NSNumber *utcHours;

/**
 * @abstract utc minutes
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber *utcMinutes;

/**
 * @abstract utc seconds
 *
 * Required, Integer, 0 - 59
 */
@property (strong) NSNumber *utcSeconds;

/**
 * Potential Compass Directions
 */
@property (strong) SDLCompassDirection *compassDirection;

/**
 * @abstract The 3D positional dilution of precision.
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 10.0
 */
@property (strong) NSNumber *pdop;

/**
 * @abstract The horizontal dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 10.0
 */
@property (strong) NSNumber *hdop;

/**
 * @abstract the vertical dilution of precision
 *
 * @discussion If undefined or unavailable, then value shall be set to 0
 *
 * Required, Float, 0.0 - 10.0
 */
@property (strong) NSNumber *vdop;

/**
 * @abstract What the coordinates are based on
 *
 * @discussion YES, if coordinates are based on satellites. NO, if based on dead reckoning.
 *
 * Required, Boolean
 */
@property (strong) NSNumber *actual;

/**
 * @abstract The number of satellites in view
 *
 * Required, Integer, 0 - 31
 */
@property (strong) NSNumber *satellites;

/**
 * The supported dimensions of the GPS
 *
 * Required
 */
@property (strong) SDLDimension *dimension;

/**
 * @abstract altitude in meters
 *
 * Required, Float, -10000.0 - 10000.0
 */
@property (strong) NSNumber *altitude;

/**
 * @abstract Heading based on the GPS data.
 * 
 * @discussion North is 0, East is 90, etc. Resolution is 0.01
 *
 * Required, Float, 0.0 - 359.99
 */
@property (strong) NSNumber *heading;

/**
 * @abstract speed in KPH
 *
 * Required, Float, 0.0 - 500.0
 */
@property (strong) NSNumber *speed;

@end
