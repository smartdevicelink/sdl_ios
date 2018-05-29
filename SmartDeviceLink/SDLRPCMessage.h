//  SDLRPCMessage.h
//

#import "SDLEnum.h"

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCMessage : SDLRPCStruct {
    NSMutableDictionary<NSString *, id> *function;
    NSMutableDictionary<NSString *, id> *parameters;
    NSString *messageType;
}

/**
 *  Convenience init
 *
 *  @param name    The name of the message
 *  @return        A SDLRPCMessage object
 */
- (instancetype)initWithName:(NSString *)name;

/**
 *  Convenience init
 *
 *  @param dict    A dictionary with the format @{messageType: @{parameters}}
 *  @return        A SDLRPCMessage object
 */
- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;

/**
 *  Returns the function name.
 *
 *  @return The function name
 */
- (nullable NSString *)getFunctionName;

/**
 *  Sets the function name.
 *
 *  @param functionName The function name
 */
- (void)setFunctionName:(nullable NSString *)functionName;

/**
 *  Returns the value associated with the provided key. If the key does not exist, null is returned.
 *
 *  @param functionName    The key name
 *  @return                The value associated with the function name
 */
- (nullable NSObject *)getParameters:(NSString *)functionName;

/**
 *  Sets a key-value pair using the function name as the key.
 *
 *  @param functionName    The name for the key
 *  @param value           The value associated with the function name
 */
- (void)setParameters:(NSString *)functionName value:(nullable NSObject *)value;

/**
 *  The data in the message
 */
@property (nullable, strong, nonatomic) NSData *bulkData;

/**
 *  The name of the message
 */
@property (strong, nonatomic, readonly) NSString *name;

/**
 *  The type of data in the message
 */
@property (strong, nonatomic, readonly) NSString *messageType;

@end

NS_ASSUME_NONNULL_END
