//
//  SDLLifecycleSystemRequestHandler.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/8/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLConnectionManagerType;

/// Handles decoding OnSystemRequest RPCs, then performing network requests and creating a SystemRequest RPC request for head units.
@interface SDLLifecycleSystemRequestHandler : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initialize the object
/// @param manager A connection manager to send RPCs
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager;

/// Stops the manager and clears all URL Session tasks
- (void)stop;

@end

NS_ASSUME_NONNULL_END
