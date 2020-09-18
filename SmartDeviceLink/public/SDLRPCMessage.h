//  SDLRPCMessage.h
//

#import "SDLEnum.h"

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/// Parent class of all RPC messages.
///
/// Contains basic information about an RPC message.
@interface SDLRPCMessage : SDLRPCStruct <NSCopying>

/**
 *  Convenience init
 *
 *  @param name    The name of the message
 *  @return        A SDLRPCMessage object
 */
- (instancetype)initWithName:(NSString *)name __deprecated_msg("This is not intended to be a public facing API");

/**
 *  Sets the function name.
 *
 *  @param functionName The function name
 */
- (void)setFunctionName:(nullable NSString *)functionName __deprecated_msg("This is not intended to be a public facing API");

/**
 *  Sets a key-value pair using the function name as the key.
 *
 *  @param functionName    The name for the key
 *  @param value           The value associated with the function name
 */
- (void)setParameters:(NSString *)functionName value:(nullable NSObject *)value __deprecated_msg("This is not intended to be a public facing API");

/**
 *  The data in the message
 */
@property (nullable, strong, nonatomic) NSData *bulkData;

/**
 *  The name of the message
 */
@property (strong, nonatomic, readonly) NSString *name;

/**
 The JSON-RPC parameters
 */
@property (strong, nonatomic, readonly) NSMutableDictionary<NSString *, id> *parameters;

/**
 *  The type of data in the message
 */
@property (strong, nonatomic, readonly) NSString *messageType;

@end

NS_ASSUME_NONNULL_END
