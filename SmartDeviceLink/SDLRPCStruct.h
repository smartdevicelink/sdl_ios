//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCStruct : NSObject <NSCopying>

@property (strong, nonatomic, readonly) NSMutableDictionary<NSString *, id> *store;

/**
 *  Convenience init
 *
 *  @param dict A dictionary
 *  @return     A SDLRPCStruct object
 */
- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict __deprecated_msg("This is not intended for public use");

/**
 *  Converts struct to JSON formatted data
 *
 *  @param version The protocol version
 *  @return        JSON formatted data
 */
- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version __deprecated_msg("This is not intended for public use");

@end

NS_ASSUME_NONNULL_END
