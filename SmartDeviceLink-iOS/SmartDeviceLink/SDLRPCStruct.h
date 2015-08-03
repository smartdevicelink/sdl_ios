//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary *store;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;
- (instancetype)init;

- (NSMutableDictionary *)serializeAsDictionary:(Byte)version;

@end
