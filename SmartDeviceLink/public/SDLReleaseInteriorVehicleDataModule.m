//
//  SDLReleaseInteriorVehicleDataModule.m
//  SmartDeviceLink
//
//  Created by standa1 on 7/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLReleaseInteriorVehicleDataModule.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

@implementation SDLReleaseInteriorVehicleDataModule

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameReleaseInteriorVehicleDataModule]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleId:(NSString *)moduleId {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.moduleType = moduleType;
    self.moduleId = moduleId;
    
    return self;
}

- (void)setModuleType:(SDLModuleType)moduleType {
    [self.parameters sdl_setObject:moduleType forName:SDLRPCParameterNameModuleType];
}

- (SDLModuleType)moduleType {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameModuleType error:&error];
}

- (void)setModuleId:(nullable NSString *)moduleId {
    [self.parameters sdl_setObject:moduleId forName:SDLRPCParameterNameModuleId];
}

- (nullable NSString *)moduleId {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameModuleId ofClass:NSString.class error:&error];
}

@end
