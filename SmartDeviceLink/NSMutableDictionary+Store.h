//
//  NSMutableDictionary+Store.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 11/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* SDLName;

@interface NSMutableDictionary (Store)

- (void)sdl_setObject:(NSObject *)object forName:(SDLName)name;
- (id)sdl_objectForName:(SDLName)name;
- (id)sdl_objectForName:(SDLName)name ofClass:(Class)classType;
- (NSMutableArray *)sdl_objectsForName:(SDLName)name ofClass:(Class)classType;

@end
