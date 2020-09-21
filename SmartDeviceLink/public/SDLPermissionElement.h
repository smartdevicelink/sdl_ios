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

/// An object containing the RPC name and its parameter names that should be checked when checking permissions
@interface SDLPermissionElement : NSObject <NSCopying>

/**
 * Name of the individual RPC.
 * Required
 */
@property (strong, nonatomic) SDLRPCFunctionName rpcName;

/**
 * RPC parameters for the individual RPC
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *parameterPermissions;

/**
 *  Creates a new permission element.
 *
 *  @param rpcName  The name of the RPC.
 *  @param parameterPermissions An array parameters for the RPC that should be checked if they are allowed. Note that not all head units may provide this data. If no parameter data is received, we assume that the parameter is not allowed.
 *
 *  @return An instance of `SDLPermissionElement`.
 */
- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName parameterPermissions:(nullable NSArray<NSString *> *)parameterPermissions;

@end

NS_ASSUME_NONNULL_END
