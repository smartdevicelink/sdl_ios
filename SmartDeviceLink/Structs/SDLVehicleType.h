//  SDLVehicleType.h
//


#import "SDLRPCMessage.h"

/**
 * Describes the type of vehicle the mobile phone is connected with.
 *
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLVehicleType : SDLRPCStruct

/**
 * @abstract The make of the vehicle
 *
 * @discussion For example, "Ford", "Lincoln", etc.
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *make;

/**
 * @abstract The model of the vehicle
 *
 * @discussion For example, "Fiesta", "Focus", etc.
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *model;

/**
 * @abstract The model year of the vehicle
 *
 * @discussion For example, "2013"
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *modelYear;

/**
 * @abstract The trim of the vehicle
 *
 * @discussion For example, "SE", "SEL"
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *trim;

@end

NS_ASSUME_NONNULL_END
