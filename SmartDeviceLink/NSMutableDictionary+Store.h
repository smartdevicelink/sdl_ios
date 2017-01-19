//
//  NSMutableDictionary+Store.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 11/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString* SDLName SDL_SWIFT_ENUM;
typedef NSString* SDLEnum SDL_SWIFT_ENUM;

@interface NSMutableDictionary (Store)

- (void)sdl_setObject:(NSObject *)object forName:(SDLName)name;
- (nullable id)sdl_objectForName:(SDLName)name;
- (nullable id)sdl_objectForName:(SDLName)name ofClass:(Class)classType;
- (NSMutableArray *)sdl_objectsForName:(SDLName)name ofClass:(Class)classType;
- (NSMutableArray<SDLEnum> *)sdl_enumsForName:(SDLName)name;

@end

NS_ASSUME_NONNULL_END
