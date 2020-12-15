//
//  SDLPresentAlertOperation.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/12/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

@class SDLAlertView;
@class SDLFileManager;
@class SDLSystemCapabilityManager;
@class SDLWindowCapability;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentAlertOperation : SDLAsynchronousOperation

/// The current window capabilities
@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;

/// An operation to present an alert.
/// @param connectionManager The connection manager
/// @param fileManager The file manager
/// @param systemCapabilityManager The system capability manager
/// @param currentWindowCapability The current window capability
/// @param alertView The alert to be displayed
/// @param cancelID A unique ID for this specific choice set that allows cancellation through the `CancelInteraction` RPC
/// @return A SDLPresentAlertOperation object
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager currentWindowCapability:(nullable SDLWindowCapability *)currentWindowCapability alertView:(SDLAlertView *)alertView cancelID:(UInt16)cancelID;

@end

NS_ASSUME_NONNULL_END
