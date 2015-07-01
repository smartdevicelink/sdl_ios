//  SDLVehicleType.h
//


#import "SDLRPCMessage.h"

/**
 * Describes the type of vehicle the mobile phone is connected with.
 *
 * @since SDL 2.0
 */
@interface SDLVehicleType : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLVehicleType object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLVehicleType object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The make of the vehicle
 *
 * @discussion For example, "Ford", "Lincoln", etc.
 *
 * Optional, Max String length 500 chars
 */
@property (strong) NSString *make;

/**
 * @abstract The model of the vehicle
 *
 * @discussion For example, "Fiesta", "Focus", etc.
 *
 * Optional, Max String length 500 chars
 */
@property (strong) NSString *model;

/**
 * @abstract The model year of the vehicle
 *
 * @discussion For example, "2013"
 *
 * Optional, Max String length 500 chars
 */
@property (strong) NSString *modelYear;

/**
 * @abstract The trim of the vehicle
 *
 * @discussion For example, "SE", "SEL"
 *
 * Optional, Max String length 500 chars
 */
@property (strong) NSString *trim;

@end
