//  SDLDiagnosticMessage.h
//


#import "SDLRPCRequest.h"

/** 
 *  Non periodic vehicle diagnostic request
 *
 *  @since SDL 3.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDiagnosticMessage : SDLRPCRequest

/// Convenience init
/// 
/// @param targetId Name of target ECU
/// @param length Length of message (in bytes)
/// @param data Array of bytes comprising CAN message
/// @return An SDLDiagnosticMessage object
- (instancetype)initWithTargetId:(UInt16)targetId length:(UInt16)length data:(NSArray<NSNumber<SDLUInt> *> *)data;

/**
 *  Name of target ECU
 *
 *  Required, Integer, 0 - 65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *targetID;

/**
 *  Length of message (in bytes)
 *
 *  Required, Integer, 65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *messageLength;

/**
 *  Array of bytes comprising CAN message.
 *
 *  Required, Array of NSNumber (Integers), Array size 1 - 65535, Integer Size 0 - 255
 */
@property (strong, nonatomic) NSArray<NSNumber *> *messageData;

@end

NS_ASSUME_NONNULL_END
