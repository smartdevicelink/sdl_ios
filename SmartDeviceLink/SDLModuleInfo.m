//
//  SDLModuleInfo.m
//  SmartDeviceLink
//
//  Created by standa1 on 7/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLModuleInfo.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLModuleInfo

- (void)setModuleId:(NSString *)moduleId {
    [self.store sdl_setObject:moduleId forName:SDLRPCParameterNameModuleId];
}

- (NSString *)moduleId {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameModuleId ofClass:NSString.class error:&error];
}

- (void)setLocation:(nullable SDLGrid *)location {
    [self.store sdl_setObject:location forName:SDLRPCParameterNameLocation];
}

- (nullable SDLGrid *)location {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLocation ofClass:SDLGrid.class error:&error];
}

- (void)setServiceArea:(nullable SDLGrid *)serviceArea {
    [self.store sdl_setObject:serviceArea forName:SDLRPCParameterNameServiceArea];
}

- (nullable SDLGrid *)serviceArea {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameServiceArea ofClass:SDLGrid.class error:&error];
}

- (void)setAllowMultipleAccess:(nullable NSNumber<SDLBool> *)allowMultipleAccess {
    [self.store sdl_setObject:allowMultipleAccess forName:SDLRPCParameterNameAllowMultipleAccess];
}

- (nullable NSNumber<SDLBool> *)allowMultipleAccess {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameAllowMultipleAccess ofClass:NSNumber.class error:&error];
}

@end
