//  SDLTextField.h
//

#import "SDLRPCMessage.h"

#import "SDLCharacterSet.h"
#import "SDLTextFieldName.h"


NS_ASSUME_NONNULL_BEGIN

/**
 * Struct defining the characteristics of a displayed field on the HMI.
 *
 * @since SDL 1.0
 */
@interface SDLTextField : SDLRPCStruct

/**
 * The enumeration identifying the field.
 *
 * @see SDLTextFieldName
 *
 * Required
 */
@property (strong, nonatomic) SDLTextFieldName name;

/**
 * The character set that is supported in this field.
 *
 * @see SDLCharacterSet
 *
 * Required
 */
@property (strong, nonatomic) SDLCharacterSet characterSet;

/**
 * The number of characters in one row of this field.
 * 
 * Required, Integer 1 - 500
 */
@property (strong, nonatomic) NSNumber<SDLInt> *width;

/**
 * The number of rows for this text field.
 * 
 * Required, Integer 1 - 8
 */
@property (strong, nonatomic) NSNumber<SDLInt> *rows;

@end

NS_ASSUME_NONNULL_END
