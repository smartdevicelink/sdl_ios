//  SDLVehicleType.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes the type of vehicle the mobile phone is connected with.
 *
 * @since SDL 2.0
 */
@interface SDLVehicleType : SDLRPCStruct

/**
 * The make of the vehicle
 *
 * For example, "Ford", "Lincoln", etc.
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *make;

/**
 * The model of the vehicle
 *
 * For example, "Fiesta", "Focus", etc.
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *model;

/**
 * The model year of the vehicle
 *
 * For example, "2013"
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *modelYear;

/**
 * The trim of the vehicle
 *
 * For example, "SE", "SEL"
 *
 * Optional, Max String length 500 chars
 */
@property (strong, nonatomic, nullable) NSString *trim;

/**
 * Initialize the object
 *
 * @param make - make
 * @param model - model
 * @param modelYear - modelYear
 * @param trim - trim
 * @return A SDLVehicleType object
 */
- (instancetype)initWithMake:(nullable NSString *)make model:(nullable NSString *)model modelYear:(nullable NSString *)modelYear trim:(nullable NSString *)trim;

@end

NS_ASSUME_NONNULL_END
