//
//  SDLRPCStruct.h


#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

// This is so we don't have to expose this to the project. (could also make the functions below an internal protocol).
typedef NSString* SDLName;

@interface SDLRPCStruct : NSObject {
    NSMutableDictionary<NSString *, id> *store;
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;
- (instancetype)init;

- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version;

- (void)setObject:(NSObject*)object forName:(SDLName)name inStorage:(NSMutableDictionary*)storage;
- (void)setObject:(NSObject *)object forName:(SDLName)name;
- (id)objectForName:(SDLName)name fromStorage:(NSMutableDictionary*)storage;
- (id)objectForName:(SDLName)name;
- (id)objectForName:(SDLName)name ofClass:(Class)classType;
- (NSMutableArray *)objectsForName:(SDLName)name ofClass:(Class)classType;

@end
