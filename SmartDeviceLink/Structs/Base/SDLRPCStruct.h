//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCStruct : NSObject <NSCopying> {
    NSMutableDictionary<NSString *, id> *store;
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;
- (instancetype)init;

- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version;

@end

NS_ASSUME_NONNULL_END
