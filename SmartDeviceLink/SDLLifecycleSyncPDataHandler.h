//
//  SDLLifecycleSyncPDataHandler.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/8/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLConnectionManagerType;

/// Handles decoding OnSyncPData RPCs, then performing network requests and creating a SyncPData RPC request for legacy head units.
@interface SDLLifecycleSyncPDataHandler : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initialize the object
/// @param manager The connection manager to send RPCs through
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager;

/// Stops the manager cancels all URL session tasks
- (void)stop;

@end

NS_ASSUME_NONNULL_END
