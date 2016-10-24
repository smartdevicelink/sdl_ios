//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary *store;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;
- (instancetype)init;

- (NSMutableDictionary *)serializeAsDictionary:(Byte)version;

@end
