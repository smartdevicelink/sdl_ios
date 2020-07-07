//
//  SDLRPCPermissionStatus.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 6/29/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLRPCPermissionStatus.h"

@implementation SDLRPCPermissionStatus

- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName isRPCAllowed:(BOOL)isRPCAllowed rpcParameters:(nullable NSMutableDictionary<NSString *,NSNumber *> *)rpcParameters {
    self = [super init];
    if (!self) { return nil; }
    
    _rpcName = rpcName;
    _rpcAllowed = isRPCAllowed;
    _rpcParameters = rpcParameters;

    return self;
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"RPC name: %@, allowed: %@, RPC parameters %@", self.rpcName, (self.isRPCAllowed ? @"YES" : @"NO"), self.rpcParameters];
}

@end
