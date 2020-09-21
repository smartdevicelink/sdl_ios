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
 * The set of characters that are supported by this text field. All text is sent in UTF-8 format, but not all systems may support all of the characters expressed by UTF-8. All systems will support at least ASCII, but they may support more, either the LATIN-1 character set, or the full UTF-8 character set.
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

/// Convenience initalizer for the TextField RPC struct
/// @param name The name identifying this text field
/// @param characterSet The character set of this text field
/// @param width The number of characters per row allowed in this text field
/// @param rows The number of rows allowed in this text field
- (instancetype)initWithName:(SDLTextFieldName)name characterSet:(SDLCharacterSet)characterSet width:(NSUInteger)width rows:(NSUInteger)rows;

@end

NS_ASSUME_NONNULL_END
