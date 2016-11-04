//
//  SDLSendLocation.h
//  SmartDeviceLink

#import "SDLRPCRequest.h"

#import <CoreGraphics/CGBase.h>

#import "SDLDateTime.h"
#import "SDLDeliveryMode.h"
#import "SDLImage.h"
#import "SDLOasisAddress.h"

@interface SDLSendLocation : SDLRPCRequest

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription address:(NSArray<NSString *> *)address phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image;

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription displayAddressLines:(NSArray<NSString *> *)displayAddressLines phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image deliveryMode:(SDLDeliveryMode *)deliveryMode timeStamp:(SDLDateTime *)timeStamp address:(SDLOasisAddress *)address;

/**
 * The longitudinal coordinate of the location.
 *
 * Float, Required, -180.0 - 180.0
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

/**
 * The latitudinal coordinate of the location.
 *
 * Float, Required, -90.0 - 90.0
 */
@property (copy, nonatomic) NSNumber<SDLFloat> *latitudeDegrees;

/**
 * Name / title of intended location
 *
 * Optional, Maxlength = 500 char
 */
@property (copy, nonatomic) NSString *locationName;

/**
 * Description of the intended location / establishment
 *
 * Optional, MaxLength = 500 char
 */
@property (copy, nonatomic) NSString *locationDescription;

/**
 * Location address for display purposes only
 *
 * Contains String, Optional, Max Array Length = 4, Max String Length = 500
 */
@property (copy, nonatomic) NSArray<NSString *> *addressLines;

/**
 * Phone number of intended location / establishment
 *
 * Optional, Max Length = 500
 */
@property (copy, nonatomic) NSString *phoneNumber;

/**
 * Image / icon of intended location
 *
 * Optional
 */
@property (strong, nonatomic) SDLImage *locationImage;

/**
 * Mode in which the sendLocation request is sent
 *
 * Optional
 */
@property (strong, nonatomic) SDLDeliveryMode *deliveryMode;

/**
 * Arrival time of Location. If multiple SendLocations are sent, this will be used for sorting as well.
 *
 * Optional
 */
@property (strong, nonatomic) SDLDateTime *timeStamp;

/**
 * Address to be used for setting destination
 *
 * Optional
 */
@property (strong, nonatomic) SDLOasisAddress *address;

@end
