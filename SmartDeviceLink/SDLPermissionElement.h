//
//  SDLPermissionElement.h
//  SmartDeviceLink
//
//  Created by James Lapinski on 6/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLRPCFunctionNames.h"

@class SDLParameterPermissions;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionElement : NSObject

/**
 Name of the individual RPC in the policy table.

 Required
 */
@property (strong, nonatomic) SDLRPCFunctionName rpcName;

/**
 RPC parameters for the individual RPC

 Required
 */
@property (strong, nonatomic) SDLParameterPermissions *parameterPermissions;



- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName parameterPermissions:(nullable SDLParameterPermissions *)parameterPermissions;

- (SDLRPCFunctionName)getRPCName;

- (SDLParameterPermissions*)getParameters;

@end

NS_ASSUME_NONNULL_END
