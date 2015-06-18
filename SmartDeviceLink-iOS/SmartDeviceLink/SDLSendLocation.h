//
//  SDLSendLocation.h
//  SmartDeviceLink

#import <Foundation/Foundation.h>

#import "SDLImage.h"
#import "SDLRPCRequest.h"


@interface SDLSendLocation : SDLRPCRequest

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * The longitudinal coordinate of the location.
 *
 * Float, Required, -180.0 - 180.0
 */
@property (copy, nonatomic) NSNumber *longitudeDegrees;

/**
 * The latitudinal coordinate of the location.
 *
 * Float, Required, -90.0 - 90.0
 */
@property (copy, nonatomic) NSNumber *latitudeDegrees;

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
 * Array of lines for the location address
 *
 * Contains String, Optional, Max Array Length = 4, Max String Length = 500
 */
@property (copy, nonatomic) NSArray *addressLines;

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

@end
