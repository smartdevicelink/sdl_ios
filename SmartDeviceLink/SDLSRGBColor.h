//  SDLSRGBColor.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSRGBColor : SDLRPCStruct

- (instancetype)initWithRed:(UInt32)red green:(UInt32)green blue:(UInt32)blue;

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
