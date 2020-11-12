//
//  SDLAlertManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLFileManager;
@class SDLPermissionManager;
@class SDLSystemCapabilityManager;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlertManager : NSObject

/// Initialize the manager with required dependencies
/// @param connectionManager The connection manager object for sending RPCs
/// @param fileManager The file manager object for uploading files
/// @param systemCapabilityManager The system capability manager object for reading window capabilities
/// @return The alert manager
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager permissionManager:(SDLPermissionManager *)permissionManager;

/// Starts the manager. This method is used internally.
- (void)start;

/// Stops the manager. This method is used internally.
- (void)stop;

@end

NS_ASSUME_NONNULL_END
