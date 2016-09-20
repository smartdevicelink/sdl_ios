//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary<NSString *, id> *store;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;
- (instancetype)init;

- (NSMutableDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version;

@end
