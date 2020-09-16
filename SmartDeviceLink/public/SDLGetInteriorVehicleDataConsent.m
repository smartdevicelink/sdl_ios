//
//  SDLGetInteriorVehicleDataConsent.m
//  SmartDeviceLink
//
//  Created by standa1 on 7/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetInteriorVehicleDataConsent.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "NSMutableDictionary+Store.h"

@implementation SDLGetInteriorVehicleDataConsent

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetInteriorVehicleDataConsent]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleIds:(NSArray<NSString *> *)moduleIds {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.moduleType = moduleType;
    self.moduleIds = moduleIds;
    
    return self;
}

- (void)setModuleType:(SDLModuleType)moduleType {
    [self.parameters sdl_setObject:moduleType forName:SDLRPCParameterNameModuleType];
}

- (SDLModuleType)moduleType {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameModuleType error:&error];
}

- (void)setModuleIds:(NSArray<NSString *> *)moduleIds {
    [self.parameters sdl_setObject:moduleIds forName:SDLRPCParameterNameModuleIds];
}

- (NSArray<NSString *> *)moduleIds {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameModuleIds ofClass:NSString.class error:&error];
}

@end
