//
//  SDLPresentAlertOperation.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/12/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

@class SDLAlertView;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentAlertOperation : SDLAsynchronousOperation

@property (strong, nonatomic, readonly) SDLAlertView *alertView;

/// An operation to present an alert.
/// @param connectionManager The connection manager
/// @param alertView The alert to be displayed
/// @param cancelID A unique ID for this specific choice set that allows cancellation through the `CancelInteraction` RPC
/// @return A SDLPresentAlertOperation object
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager alertView:(SDLAlertView *)alertView cancelID:(UInt16)cancelID;

@end

NS_ASSUME_NONNULL_END
