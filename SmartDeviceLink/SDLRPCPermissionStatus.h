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
 * Holds a dictionary of RPC parameters and their permission status
 */
@property (strong, nonatomic, nullable, readonly) NSMutableDictionary<NSString *, NSNumber *> *allowedParameters;

// to do add description
- (instancetype)initWithRPCName:(SDLRPCFunctionName)rpcName isRPCAllowed:(BOOL)isRPCAllowed allowedParameters:(nullable NSDictionary<NSString *, NSNumber *> *)allowedParameters;

@end

NS_ASSUME_NONNULL_END
