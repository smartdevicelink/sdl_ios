//
//  NSMutableDictionary+Store.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 11/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLMacros.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString* SDLRPCParameterName SDL_SWIFT_ENUM;
typedef NSString* SDLEnum SDL_SWIFT_ENUM;

@interface NSDictionary (Store)

- (void)sdl_setObject:(NSObject *)object forName:(SDLRPCParameterName)name;

- (nullable SDLEnum)sdl_enumForName:(SDLRPCParameterName)name error:(NSError **)error;
- (nullable NSArray<SDLRPCParameterName> *)sdl_enumsForName:(SDLRPCParameterName)name error:(NSError **)error;

/**
 *  @return object of classType or nil
 */
- (nullable id)sdl_objectForName:(SDLRPCParameterName)name ofClass:(Class)classType;

/**
 *  @return array of classType objects or nil
*/
- (nullable NSArray *)sdl_objectsForName:(SDLRPCParameterName)name ofClass:(Class)classType;

/**
 *  @param classType expected class of returned object
 *  @param error if stored value isn't classType
 *  @warning returned object can be not of classType
 *  @return object of classType overwise error would be filled
*/
- (nullable id)sdl_objectForName:(SDLRPCParameterName)name ofClass:(Class)classType error:(NSError **)error;

/**
 *  @param classType expected class of array objects
 *  @param error if array objects value isn't classType or stored objects aren't array
 *  @warning returned object can be not array or stored objects aren't of classType
 *  @return try to return array of classType objects overwise error would be filled
*/
- (nullable NSArray *)sdl_objectsForName:(SDLRPCParameterName)name ofClass:(Class)classType error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
