//
//  SDLPermissionElement.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 6/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLPermissionElement.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPermissionElement

- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName parameterPermissions:(nullable NSArray<NSString *> *)parameterPermissions {
    self = [super init];
    if (!self) { return nil; }

    self.rpcName = rpcName;
    self.parameterPermissions = parameterPermissions;

    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLPermissionElement *newElement =  [[self.class allocWithZone:zone] initWithRPCName:[_rpcName copyWithZone:zone] parameterPermissions:[_parameterPermissions copyWithZone:zone]];

    return newElement;
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"RPC name: %@, parameter permissions: %@", self.rpcName, self.parameterPermissions];
}

@end

NS_ASSUME_NONNULL_END
