//
//  SDLSendLocation.h
//  SmartDeviceLink

#import "SDLRPCRequest.h"

#import <CoreGraphics/CGBase.h>

#import "SDLDateTime.h"
#import "SDLDeliveryMode.h"
#import "SDLImage.h"
#import "SDLOasisAddress.h"

NS_ASSUME_NONNULL_BEGIN

/// SendLocation is used to send a location to the navigation system for navigation
///
/// @since RPC 3.0
@interface SDLSendLocation : SDLRPCRequest

/**
 Create a `SendLocation` request with an address object, without Lat/Long coordinates.

 @param address The address information to be passed to the nav system for determining the route
 @param addressLines The user-facing address
 @param locationName The user-facing name of the location
 @param locationDescription The user-facing description of the location
 @param phoneNumber The phone number for the location; the user could use this to call the location
 @param image A user-facing image for the location
 @param deliveryMode How the location should be sent to the nav system
 @param timeStamp The estimated arrival time for the location (this will also likely be calculated by the nav system later, and may be different than your estimate). This is used to show the user approximately how long it would take to navigate here
 @return A `SendLocation` object
 */
- (instancetype)initWithAddress:(SDLOasisAddress *)address addressLines:(nullable NSArray<NSString *> *)addressLines locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image deliveryMode:(nullable SDLDeliveryMode)deliveryMode timeStamp:(nullable SDLDateTime *)timeStamp;

/**
 Create a `SendLocation` request with Lat/Long coordinate, not an address object

 @param longitude The longitudinal coordinate of the location
 @param latitude The latitudinal coordinate of the location
 @param locationName The user-facing name of the location
 @param locationDescription The user-facing description of the location
 @param address The user-facing address
 @param phoneNumber The phone number for the location; the user could use this to call the location
 @param image A user-facing image for the location
 @return A `SendLocation` object
 */
- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription address:(nullable NSArray<NSString *> *)address phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image;

/**
 Create a `SendLocation` request with Lat/Long coordinate and an address object and let the nav system decide how to parse it

 @param longitude The longitudinal coordinate of the location
 @param latitude The latitudinal coordinate of the location
 @param locationName The user-facing name of the location
 @param locationDescription The user-facing description of the location
 @param displayAddressLines The user-facing address
 @param phoneNumber The phone number for the location; the user could use this to call the location
 @param image A user-facing image for the location
 @param deliveryMode How the location should be sent to the nav system
 @param timeStamp The estimated arrival time for the location (this will also likely be calculated by the nav system later, and may be different than your estimate). This is used to show the user approximately how long it would take to navigate here
 @param address The address information to be passed to the nav system for determining the route
 @return A `SendLocation` object
 */
- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription displayAddressLines:(nullable NSArray<NSString *> *)displayAddressLines phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image deliveryMode:(nullable SDLDeliveryMode)deliveryMode timeStamp:(nullable SDLDateTime *)timeStamp address:(nullable SDLOasisAddress *)address;

/**
 * The longitudinal coordinate of the location. Either the latitude / longitude OR the `address` must be provided.
 *
 * Float, Optional, -180.0 - 180.0
 */
@property (nullable, copy, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

/**
 * The latitudinal coordinate of the location. Either the latitude / longitude OR the `address` must be provided.
 *
 * Float, Optional, -90.0 - 90.0
 */
@property (nullable, copy, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 * Name / title of intended location
 *
 * Optional, Maxlength = 500 char
 */
@property (nullable, copy, nonatomic) NSString *locationName;

/**
 * Description of the intended location / establishment
 *
 * Optional, MaxLength = 500 char
 */
@property (nullable, copy, nonatomic) NSString *locationDescription;

/**
 * Location address for display purposes only.
 *
 * Contains String, Optional, Max Array Length = 4, Max String Length = 500
 */
@property (nullable, copy, nonatomic) NSArray<NSString *> *addressLines;

/**
 * Phone number of intended location / establishment
 *
 * Optional, Max Length = 500
 */
@property (nullable, copy, nonatomic) NSString *phoneNumber;

/**
 * Image / icon of intended location
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *locationImage;

/**
 * Mode in which the sendLocation request is sent
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLDeliveryMode deliveryMode;

/**
 * Arrival time of Location. If multiple SendLocations are sent, this will be used for sorting as well.
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *timeStamp;

/**
 * Address to be used for setting destination. Either the latitude / longitude OR the `address` must be provided.
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLOasisAddress *address;

@end

NS_ASSUME_NONNULL_END
