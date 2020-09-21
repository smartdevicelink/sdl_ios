//
//  SDLPermissionManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLHMILevel.h"
#import "SDLPermissionConstants.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCPermissionStatus.h"

@class SDLPermissionItem;
@class SDLRPCMessage;

NS_ASSUME_NONNULL_BEGIN

/// The permission manager monitoring RPC permissions.
@interface SDLPermissionManager : NSObject

/**
 *  Flag indicating if the app requires an encryption service to be active.
 */
@property (assign, nonatomic, readonly) BOOL requiresEncryption;

/**
 *  Start the manager with a completion block that will be called when startup completes. This is used internally. To use an SDLPermissionManager, you should use the manager found on `SDLManager`.
 *
 *  @param completionHandler The block to be called when the manager's setup is complete.
 */
- (void)startWithCompletionHandler:(void (^)(BOOL success, NSError *__nullable error))completionHandler;

/**
 *  Stop the manager. This method is used internally.
 */
- (void)stop;

/**
 * Determine if an individual RPC is allowed for the current HMI level
 *
 * @param rpcName The name of the RPC to be tested, for example, SDLRPCFunctionNameShow
 *
 * @return YES if the RPC is allowed at the current HMI level, NO if not
 */
- (BOOL)isRPCNameAllowed:(SDLRPCFunctionName)rpcName;

/**
 * Determine if all RPCs are allowed for the current HMI level
 *
 * @param rpcNames The RPCs to check
 *
 * @return AllAllowed if all of the permissions are allowed, AllDisallowed if all the permissions are disallowed, Any if some are allowed, and some are disallowed
*/
- (SDLPermissionGroupStatus)groupStatusOfRPCPermissions:(NSArray<SDLPermissionElement *> *)rpcNames;

/**
 * Retrieve a dictionary with keys that are the passed in RPC names, and objects of an NSNumber<BOOL> specifying if that RPC is currently allowed
 *
 * @param rpcNames An array of permission elements to check
 *
 * @return A dictionary with specific RPC info contained in a SDLRPCPermissionStatus
*/
- (NSDictionary<SDLRPCFunctionName, SDLRPCPermissionStatus *> *)statusesOfRPCPermissions:(NSArray<SDLPermissionElement *> *)rpcNames;

/**
 *  Subscribe to specified RPC names, with a callback that will be called whenever the value changes. Tthe callback will only return immediately if the groupType is set to SDLPermissionGroupTypeAny or if the groupType is set to SDLPermissionGroupTypeAllAllowed and all RPCs in the rpcNames parameter are allowed.
 *
 *  @warning The observer may be called before this method returns. Do not attempt to remove the observer from within the observer.
 *
 *  @param permissionElements The permission elements to be observed
 *  @param groupType Affects the times that the observer block will be called. If Any, any change to any RPC in rpcNames will cause the observer block to be called. If AllAllowed, the block will be called when: 1. Every RPC in rpcNames becomes allowed 2. The group of rpcNames goes from all being allowed to some or all being disallowed.
 *  @param handler The block that will be called whenever permissions change.
 *
 *  @return An identifier that can be passed to removeObserverForIdentifer: to remove the observer
 */
- (SDLPermissionObserverIdentifier)subscribeToRPCPermissions:(NSArray<SDLPermissionElement *> *)permissionElements groupType:(SDLPermissionGroupType)groupType withHandler:(SDLRPCPermissionStatusChangedHandler)handler;

/**
 *  Remove every current observer
 */
- (void)removeAllObservers;

/**
 *  Remove block observers for the specified RPC
 *
 *  @param identifier The identifier specifying which observer to remove
 */
- (void)removeObserverForIdentifier:(SDLPermissionObserverIdentifier)identifier;

/**
 *  Check whether or not an RPC needs encryption.
 */
- (BOOL)rpcNameRequiresEncryption:(SDLRPCFunctionName)rpcName;

/**
 * Check whether a parameter of an RPC is allowed
 *
 * @param rpcName The name of the RPC to be tested, for example, SDLRPCFunctionNameGetVehicleData
 * @param parameter The name of the parameter to be tested, for example, rpm
 *
 * @return True if the parameter is allowed, false if it is not
 */
- (BOOL)isPermissionParameterAllowed:(SDLRPCFunctionName)rpcName parameter:(NSString *)parameter;

@end

NS_ASSUME_NONNULL_END
