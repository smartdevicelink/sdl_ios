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
- (nullable id)sdl_objectForName:(SDLRPCParameterName)name;
- (nullable id)sdl_objectForName:(SDLRPCParameterName)name ofClass:(Class)classType;
- (NSArray *)sdl_objectsForName:(SDLRPCParameterName)name ofClass:(Class)classType;

@end

NS_ASSUME_NONNULL_END
