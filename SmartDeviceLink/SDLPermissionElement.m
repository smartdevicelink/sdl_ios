//
//  SDLPermissionElement.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 6/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLPermissionElement.h"

@implementation SDLPermissionElement

- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName parameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    self = [super init];
    if (!self) { return nil; }

    self.rpcName = rpcName;
    self.parameterPermissions = parameterPermissions;

    return self;
}

- (SDLRPCFunctionName)getRPCName {
    return self.rpcName;
}

- (SDLParameterPermissions *)getParameters {
    return self.parameterPermissions;
}

@end
