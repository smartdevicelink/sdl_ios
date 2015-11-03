//
//  SDLPermissionManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLHMILevel;
@class SDLPermissionItem;

typedef NSString SDLPermissionRPCName;


NS_ASSUME_NONNULL_BEGIN

/**
 *  An observer that will be called whenever permissions change on the remote system
 *
 *  @param rpcName       The name of the SDLRPC whose permission changed
 *  @param oldPermission The permission state before it changed. If this is the first time the permission manager learned about this RPC, then this will be nil
 *  @param newPermission The current permission state of the RPC
 */
typedef void (^SDLPermissionObserver)(NSString *rpcName, SDLPermissionItem * __nullable oldPermission, SDLPermissionItem *newPermission);


@interface SDLPermissionManager : NSObject

/**
 *  Determine if an individual RPC is allowed for a specified HMI level
 *
 *  @param rpcName  The name of the RPC to be tested, // TODO: add an example
 *  @param hmiLevel The HMI level to test that the RPC is enabled for
 *
 *  @return YES if the RPC is allowed at the specified HMI level, NO if not
 */
- (BOOL)isRPCAllowed:(NSString *)rpcName forHMILevel:(SDLHMILevel *)hmiLevel;

/**
 *  Add an observer for a specified RPC name, with a callback that will be called whenever the value changes, as well as immediately if the RPC's current permissions are known.
 *
 *  @warning This block will be captured by the SDLPermissionsManager, be sure to use [weakself/strongself](http://www.logicsector.com/ios/avoiding-objc-retain-cycles-with-weakself-and-strongself-the-easy-way/) if you are referencing self within your observer block.
 *
 *  @param rpcName  The RPC to be observed
 *  @param observer The block that will be called whenever permissions change.
 */
- (void)addObserverForRPC:(NSString *)rpcName usingBlock:(SDLPermissionObserver)observer;

/**
 *  Add an observer for specified RPC names, with a callback that will be called whenever the value changes, as well as immediately if the RPC's current permissions are known.
 *
 *  @warning This block will be captured by the SDLPermissionsManager, be sure to use [weakself/strongself](http://www.logicsector.com/ios/avoiding-objc-retain-cycles-with-weakself-and-strongself-the-easy-way/) if you are referencing self within your observer block.
 *
 *  @param rpcNames  The RPCs to be observed
 *  @param observer The block that will be called whenever permissions change.
 */
- (void)addObserverForRPCs:(NSArray<SDLPermissionRPCName *> *)rpcNames usingBlock:(SDLPermissionObserver)observer;

/**
 *  Remove every current observer
 */
- (void)removeAllObservers;

/**
 *  Remove block observers for the specified RPC
 *
 *  @param rpcName The RPC to remove all observers for
 */
- (void)removeObserversForRPC:(NSString *)rpcName;

/**
 *  Remove block observers for the specified RPCs
 *
 *  @param rpcNames The RPCs to remove all observers for
 */
- (void)removeObserversForRPCs:(NSArray<SDLPermissionRPCName *> *)rpcNames;

@end

NS_ASSUME_NONNULL_END
