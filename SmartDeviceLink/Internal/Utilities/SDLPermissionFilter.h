//
//  SDLPermissionFilter.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/18/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLPermissionConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionFilter : NSObject <NSCopying>

/**
 *  An identifier for the permission filter to allow it to be removed at a later time.
 */
@property (copy, nonatomic, readonly) SDLPermissionObserverIdentifier identifier;

/**
 *  All of the RPC names in this filter group.
 */
@property (copy, nonatomic, readonly) NSArray<SDLPermissionRPCName> *rpcNames;

/**
 *  The type of this filter group.
 */
@property (assign, nonatomic, readonly) SDLPermissionGroupType groupType;

/**
 *  The block that will be called on status changes to this filter group.
 */
@property (copy, nonatomic, readonly) SDLPermissionsChangedHandler handler;

/**
 *  Create a new permission filter group.
 *
 *  @param rpcNames  The names of the RPCs to watch permissions of.
 *  @param groupType The type of notifications to be sent for this filter group.
 *  @param handler  The block observer to be called when changes occur.
 *
 *  @return An instance of `SDLPermissionFilter`.
 */
- (instancetype)initWithRPCNames:(NSArray<SDLPermissionRPCName> *)rpcNames groupType:(SDLPermissionGroupType)groupType observer:(SDLPermissionsChangedHandler)handler NS_DESIGNATED_INITIALIZER;

/**
 *  Create a new permission filter group.
 *
 *  @param rpcNames  The names of the RPCs to watch permissions of.
 *  @param groupType The type of notifications to be sent for this filter group.
 *  @param handler  The block observer to be called when changes occur.
 *
 *  @return An instance of `SDLPermissionFilter`.
 */
+ (instancetype)filterWithRPCNames:(NSArray<SDLPermissionRPCName> *)rpcNames groupType:(SDLPermissionGroupType)groupType observer:(SDLPermissionsChangedHandler)handler;

/**
 *  Whether the current filter is equivalent with another filter or not.
 *
 *  @param otherFilter The other filter to test equivalence with.
 *
 *  @return YES if this filter is equivalent with `otherFilter`, NO otherwise.
 */
- (BOOL)isEqualToFilter:(SDLPermissionFilter *)otherFilter;

@end

NS_ASSUME_NONNULL_END
