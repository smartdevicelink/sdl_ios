//  SDLSRGBColor.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSRGBColor : SDLRPCStruct

- (instancetype)initWithRed:(UInt8)red green:(UInt8)green blue:(UInt8)blue;

/**
 * @abstract value of red in integer
 *
 * Required, Integer minValue:0 maxValue:255
 */
@property (strong, nonatomic) NSNumber<SDLInt> *red;

/**
 * @abstract value of red in integer
 *
 * Required, Integer minValue:0 maxValue:255
 */
@property (strong, nonatomic) NSNumber<SDLInt> *green;

/**
 * @abstract value of red in integer
 *
 * Required, Integer minValue:0 maxValue:255
 */
@property (strong, nonatomic) NSNumber<SDLInt> *blue;

@end

NS_ASSUME_NONNULL_END
