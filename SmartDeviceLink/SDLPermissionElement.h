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
 * Name of the individual RPC.
 * Required
 */
@property (strong, nonatomic) SDLRPCFunctionName rpcName;

/**
 * RPC parameters for the individual RPC
 */
@property (strong, nonatomic) NSArray<NSString *> *parameterPermissions;

/**
 *  Creates a new permission element.
 *
 *  @param rpcName  The name of the RPC.
 *  @param parameterPermissions An array parameters for the RPC.
 *
 *  @return An instance of `SDLPermissionElement`.
 */
- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName parameterPermissions:(nullable NSArray<NSString *> *)parameterPermissions;

@end

NS_ASSUME_NONNULL_END
