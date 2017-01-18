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

@interface SDLSendLocation : SDLRPCRequest

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription address:(nullable NSArray<NSString *> *)address phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image;

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription displayAddressLines:(nullable NSArray<NSString *> *)displayAddressLines phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image deliveryMode:(nullable SDLDeliveryMode)deliveryMode timeStamp:(nullable SDLDateTime *)timeStamp address:(nullable SDLOasisAddress *)address;

/**
 * The longitudinal coordinate of the location.
 *
 * Float, Required, -180.0 - 180.0
 */
@property (nullable, copy, nonatomic) NSNumber<SDLFloat> *longitudeDegrees;

/**
 * The latitudinal coordinate of the location.
 *
 * Float, Required, -90.0 - 90.0
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
 * Location address for display purposes only
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
 * Address to be used for setting destination
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLOasisAddress *address;

@end

NS_ASSUME_NONNULL_END
