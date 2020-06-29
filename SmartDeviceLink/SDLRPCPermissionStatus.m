//
//  SDLRPCPermissionStatus.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 6/29/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLRPCPermissionStatus.h"

@implementation SDLRPCPermissionStatus

- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName isRPCAllowed:(BOOL)isRPCAllowed allowedParameters:(nullable NSMutableDictionary<NSString *,NSNumber *> *)allowedParameters {
    _rpcName = rpcName;
    _rpcAllowed = isRPCAllowed;
    _allowedParameters = allowedParameters;

    return self;
}

@end
