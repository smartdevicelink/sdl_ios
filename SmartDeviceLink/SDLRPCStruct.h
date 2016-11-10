//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

#import "NSMutableDictionary+Store.h"

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary<NSString *, id> *store;
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;
- (instancetype)init;

- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version;

@end
