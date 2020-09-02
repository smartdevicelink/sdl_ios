//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

NS_ASSUME_NONNULL_BEGIN

/// Superclass of all RPC-related structs and messages
@interface SDLRPCStruct : NSObject <NSCopying>

/// The store that contains RPC data
@property (strong, nonatomic, readonly) NSMutableDictionary<NSString *, id> *store;

/// Declares if the RPC payload ought to be protected
@property (assign, nonatomic, getter=isPayloadProtected) BOOL payloadProtected;

/**
 *  Convenience init
 *
 *  @param dict A dictionary
 *  @return     A SDLRPCStruct object
 */
- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;

/**
 *  Converts struct to JSON formatted data
 *
 *  @param version The protocol version
 *  @return        JSON formatted data
 */
- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version;

@end

NS_ASSUME_NONNULL_END
