//  SDLGPSData.h
//


#import "SDLRPCMessage.h"

#import "SDLCompassDirection.h"
#import "SDLDimension.h"

/**
 * Describes the GPS data. Not all data will be available on all carlines.
 * <p><b>Parameter List </b>
 * <table border="1" rules="all">
 * 		<tr>
 * 			<th>Name</th>
 * 			<th>Type</th>
 * 			<th>Description</th>
 * 			<th>SmartDeviceLink Ver. Available</th>
 * 		</tr>
 * 		<tr>
 * 			<td>longitudeDegrees</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: - 180
 * 					<br>Maxvalue: 180
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>latitudeDegrees</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: - 90<br>Maxvalue: 90
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>utcYear</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: 2010<br>Maxvalue: 2100
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>utcMonth</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: 1<br>Maxvalue: 12
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>utcDay</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: 1<br>Maxvalue: 31
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>utcHours</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: 1<br>Maxvalue: 23
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>utcMinutes</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: 1<br>Maxvalue: 59
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>utcSeconds</td>
 * 			<td>NSNumber * </td>
 * 			<td>Minvalue: 1<br>Maxvalue: 59
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>pdop</td>
 * 			<td>NSNumber * </td>
 * 			<td>Positional Dilution of Precision<br>Minvalue: 0<br>Maxvalue: 31
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>hdop</td>
 * 			<td>NSNumber * </td>
 * 			<td>Horizontal Dilution of Precision<br>Minvalue: 0<br>Maxvalue: 31
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>vdop</td>
 * 			<td>NSNumber * </td>
 * 			<td>Vertical  Dilution of Precision<br>Minvalue: 0<br>Maxvalue: 31
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>actual</td>
 * 			<td>NSNumber * </td>
 * 			<td>True, if coordinates are based on satellites.
 *					False, if based on dead reckoning
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>satellites</td>
 * 			<td>NSNumber * </td>
 * 			<td>Number of satellites in view
 *					<br>Minvalue: 0
 *					<br>Maxvalue: 31
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>altitude</td>
 * 			<td>NSNumber * </td>
 * 			<td>Altitude in meters
 *					<br>Minvalue: -10000
 *					<br>Maxvalue: 10000
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>heading</td>
 * 			<td>NSNumber * </td>
 * 			<td>The heading. North is 0, East is 90, etc.
 *					<br>Minvalue: 0
 *					<br>Maxvalue: 359.99
 *					<br>Resolution is 0.01
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 * 		<tr>
 * 			<td>speed</td>
 * 			<td>NSNumber * </td>
 * 			<td>The speed in KPH
 *					<br>Minvalue: 0
 *					<br>Maxvalue: 400
 * 			</td>
 * 			<td>SmartDeviceLink 2.0</td>
 * 		</tr>
 *  </table>
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLGPSData : SDLRPCStruct {
}

/**
 * Constructs a newly allocated SDLGPSData object
 */
- (id)init;

/**
 * Constructs a newly allocated SDLGPSData object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
- (id)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract longitude degrees
 * @discussion
 */
@property (strong) NSNumber *longitudeDegrees;

/**
 * @abstract latitude degrees
 * @discussion
 */
@property (strong) NSNumber *latitudeDegrees;

/**
 * @abstract utc year
 * @discussion
 */
@property (strong) NSNumber *utcYear;

/**
 * @abstract utc month
 * @discussion
 */
@property (strong) NSNumber *utcMonth;

/**
 * @abstract utc day
 * @discussion
 */
@property (strong) NSNumber *utcDay;

/**
 * @abstract utc hours
 * @discussion
 */
@property (strong) NSNumber *utcHours;

/**
 * @abstract utc minutes
 * @discussion
 */
@property (strong) NSNumber *utcMinutes;

/**
 * @abstract utc seconds
 * @discussion
 */
@property (strong) NSNumber *utcSeconds;

@property (strong) SDLCompassDirection *compassDirection;

/**
 * @abstract the positional dilution of precision
 * @discussion
 */
@property (strong) NSNumber *pdop;

/**
 * @abstract the horizontal dilution of precision
 * @discussion
 */
@property (strong) NSNumber *hdop;

/**
 * @abstract the vertical dilution of precision
 * @discussion
 */
@property (strong) NSNumber *vdop;

/**
 * @abstract the coordinates based on
 * @discussion 1, if coordinates are based on satellites. 0, if based on dead reckoning
 */
@property (strong) NSNumber *actual;

/**
 * @abstract the number of satellites in view
 * @discussion
 */
@property (strong) NSNumber *satellites;

@property (strong) SDLDimension *dimension;

/**
 * @abstract altitude in meters
 * @discussion
 */
@property (strong) NSNumber *altitude;

/**
 * @abstract  the heading.North is 0, East is 90, etc.
 * @discussion
 */
@property (strong) NSNumber *heading;

/**
 * @abstract speed in KPH
 * @discussion
 */
@property (strong) NSNumber *speed;

@end
