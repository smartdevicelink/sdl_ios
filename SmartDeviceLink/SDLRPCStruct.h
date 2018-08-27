//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCStruct : NSObject <NSCopying> {
    NSMutableDictionary<NSString *, id> *store;
}

/**
 *  Convenience init
 *
 *  @param dict A dictionary
 *  @return     A SDLRPCStruct object
 */
- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;

/**
 *  Init
 *
 *  @return A SDLRPCStruct object
 */
- (instancetype)init;

/**
 *  Converts struct to JSON formatted data
 *
 *  @param version The protocol version
 *  @return        JSON formatted data
 */
- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version;

@end

NS_ASSUME_NONNULL_END
