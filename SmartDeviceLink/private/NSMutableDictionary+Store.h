//
//  NSMutableDictionary+Store.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 11/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString* SDLRPCParameterName NS_TYPED_ENUM;
typedef NSString* SDLEnum NS_TYPED_ENUM;

@interface NSDictionary (Store)

- (void)sdl_setObject:(nullable NSObject *)object forName:(SDLRPCParameterName)name;

- (nullable SDLEnum)sdl_enumForName:(SDLRPCParameterName)name error:(NSError * _Nullable *)error;
- (nullable NSArray<SDLEnum> *)sdl_enumsForName:(SDLRPCParameterName)name error:(NSError * _Nullable *)error;

/**
 *  @param classType expected class of returned object
 *  @param error if stored value isn't classType
 *  @return object of classType or nil
*/
- (nullable id)sdl_objectForName:(SDLRPCParameterName)name ofClass:(Class)classType error:(NSError * _Nullable *)error;

/**
 *  @param classType expected class of array objects
 *  @param error if array objects value isn't classType or stored objects aren't array
 *  @return return array of classType or nil
*/
- (nullable NSArray *)sdl_objectsForName:(SDLRPCParameterName)name ofClass:(Class)classType error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
