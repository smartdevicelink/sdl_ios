//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary *store;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)init;

- (NSDictionary *)serializeAsDictionary:(Byte)version;

@end
