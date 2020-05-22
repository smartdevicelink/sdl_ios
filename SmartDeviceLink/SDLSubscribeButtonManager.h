//
//  SDLSubscribeButtonManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLButtonName.h"
#import "SDLConnectionManagerType.h"
#import "SDLNotificationConstants.h"

@class SDLSystemCapabilityManager;

NS_ASSUME_NONNULL_BEGIN

/// A handler run when the subscribe button has been selected
/// @param buttonPress Indicates whether this is a long or short button press event
/// @param buttonEvent Indicates that the button has been depressed or released
/// @param error The error, if one occurred, during the subscription
typedef void (^SDLSubscribeButtonUpdateHandler)(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error);

/// The handler run when the update has completed
/// @param error An error if the update failed and an error occurred
typedef void(^SDLSubscribeButtonUpdateCompletionHandler)(NSError *__nullable error);

/// TODO class description
@interface SDLSubscribeButtonManager : NSObject

/// Initialize the manager with required dependencies.
/// @param connectionManager The connection manager object for sending RPCs
/// @param systemCapabilityManager The system capability manager object for reading window capabilities
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager;

/// Starts the manager. This method is used internally.
- (void)start;

/// Stops the manager. This method is used internally.
- (void)stop;

/// Subscribes to a subscribe button with the button name.
/// @param buttonName The name of the subscribe button
/// @param block The block run when the subscribe button is selected
/// @return An object that can be used to unsubscribe the block using `unsubscribeButtonWithObserver:withCompletionHandler:`. If `nil` the manager was not able attempt the subscription for some reason (such as the app being in HMI_NONE).
- (nullable id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(nullable SDLSubscribeButtonUpdateHandler)block;

/// Subscribes to a subscribe button with the button name.
/// @param buttonName The name of the subscribe button
/// @param observer The object that will have `selector` called whenever the subscribe button is selected
/// @param selector The selector on `observer` that will be called whenever the subscribe button is selected
- (BOOL)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector;

/// Unsubscribes to a subscribed subscribe button.
/// @param buttonName The name of the subscribe button
/// @param observer The object that will be unsubscribed. If a block was subscribed, the value returned by the subscription method should be passed. If a selector was subscribed, the observer object should be passed.
/// @param completionHandler The block run when the subscribe button is unsubscribed
- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
