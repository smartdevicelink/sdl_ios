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

/// A handler run when the subscribe button has been selected.
/// @param buttonPress Indicates whether this is a long or short button press event
/// @param buttonEvent Indicates whether the button has been depressed or released
/// @param error The error, if one occurred, during the subscription
typedef void (^SDLSubscribeButtonUpdateHandler)(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error);

/// The handler run when the update has completed.
/// @param error An error if the update failed
typedef void(^SDLSubscribeButtonUpdateCompletionHandler)(NSError *__nullable error);

/// Manager for handling subscriptions to hard buttons.
@interface SDLSubscribeButtonManager : NSObject

/// Initialize the manager with required dependencies.
/// @param connectionManager The connection manager object for sending RPCs
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager;

/// Starts the manager. This method is used internally.
- (void)start;

/// Stops the manager. This method is used internally.
- (void)stop;

/// Subscribes to a subscribe button.
/// @param buttonName The name of the subscribe button
/// @param updateHandler The block run when the subscribe button is selected. If there is an error subscribing to the subscribe button it will be returned in the `error` parameter.
/// @return An object that can be used to unsubscribe the block using `unsubscribeButtonWithObserver:withCompletionHandler:`.
- (id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(nullable SDLSubscribeButtonUpdateHandler)updateHandler;

/// Subscribes to a subscribe button.
/// @param buttonName The name of the subscribe button
/// @param observer The object that will have `selector` called whenever the subscribe button is selected
/// @param selector The selector on `observer` that will be called whenever the subscribe button is selected
- (void)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector;

/// Unsubscribes to a subscribe button.
/// @param buttonName The name of the subscribe button
/// @param observer The object that will be unsubscribed. If a block was subscribed, the value returned by the subscription method should be passed. If a selector was subscribed, the observer object should be passed.
/// @param completionHandler The block run when the subscribe button is unsubscribed. If there is an error unsubscribing to the subscribe button it will be returned in the `error` parameter.
- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
