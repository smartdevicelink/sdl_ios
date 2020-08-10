//
//  SDLRPCPermissionStatus.h
//  SmartDeviceLink
//
//  Created by James Lapinski on 6/29/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

/// An object containing the result status of a permission element request
@interface SDLRPCPermissionStatus : NSObject

/**
 Name of the individual RPC.

 Required
 */
@property (strong, nonatomic, readonly) SDLRPCFunctionName rpcName;

/**
 * Whether or not the RPC is allowed.
 */
@property (assign, nonatomic, readonly, getter=isRPCAllowed) BOOL rpcAllowed;

/**
 * Holds a dictionary of RPC parameters and objects of an NSNumber<BOOL> specifying if that RPC parameter is currently allowed
 */
@property (strong, nonatomic, nullable, readonly) NSDictionary<NSString *, NSNumber *> *rpcParameters;

/**
 *  Initializes a SDLRPCPermissionStatus object.
 *
 *  @param rpcName The name of the RPC.
 *  @param isRPCAllowed The permission status for the RPC.
 *  @param rpcParameters A dictionary of RPC parameters and objects of an NSNumber<BOOL> specifying if that RPC parameter is currently allowed
 *
 *  @return An instance of the SDLRPCPermissionStatus class.
 */
- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName isRPCAllowed:(BOOL)isRPCAllowed rpcParameters:(nullable NSDictionary<NSString *, NSNumber *> *)rpcParameters;

@end

NS_ASSUME_NONNULL_END
