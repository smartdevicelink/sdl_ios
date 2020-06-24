//
//  SDLPermissionElement.h
//  SmartDeviceLink
//
//  Created by James Lapinski on 6/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLParameterPermissions.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionElement : NSObject <NSCopying>

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

/**
 *  Create a new permission element.
 *
 *  @param rpcName  The names of the RPC.
 *  @param parameterPermissions The parameter permissions associated with the RPC.
 *
 *  @return An instance of `SDLPermissionElement`.
 */
- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName parameterPermissions:(nullable SDLParameterPermissions *)parameterPermissions;

- (SDLRPCFunctionName)getRPCName;

- (SDLParameterPermissions*)getParameters;

@end

NS_ASSUME_NONNULL_END
