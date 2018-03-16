//
//  SDLSoftButtonManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLConnectionManagerType;

@class SDLFileManager;
@class SDLSoftButtonObject;
@class SDLSoftButtonState;

NS_ASSUME_NONNULL_BEGIN

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLSoftButtonUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLSoftButtonManager : NSObject

/**
 HAX: This is necessary due to a Ford Sync 3 bug that doesn't like Show requests without a main field being set (it will accept them, but with a GENERIC_ERROR, and 10-15 seconds late...)
 */
@property (copy, nonatomic, nullable) NSString *currentMainField1;

/**
 An array of soft button wrappers containing soft button states. This is the current set of soft buttons in the process of being displayed or that are currently displayed.
 */
@property (copy, nonatomic) NSArray<SDLSoftButtonObject *> *softButtonObjects;

@property (assign, nonatomic, getter=isBatchingUpdates) BOOL batchUpdates;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a soft button manager with a connection manager

 @param connectionManager The manager that forwards RPCs
 @param fileManager The manager that updates images
 @return A new instance of a soft button manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

/**
 Cause all transitions in between `beginUpdates` and this method call to occur in one RPC update.

 @param handler The handler called once the update is completed.
 */
- (void)updateWithCompletionHandler:(nullable SDLSoftButtonUpdateCompletionHandler)handler;

/**
 Returns a soft button object associated with the manager that is named the specified name or nil if nothing corresponds.

 @param name The name to find a soft button for
 @return The soft button associated with that name or nil if none exists
 */
- (nullable SDLSoftButtonObject *)softButtonObjectNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
