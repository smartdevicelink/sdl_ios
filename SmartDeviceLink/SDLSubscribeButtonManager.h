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

/// Subscribes to a subscribe button. The update handler will be called when the button has been selected. If there is an error subscribing to the subscribe button it will be returned in the `error` parameter of the updateHandler.
/// @param buttonName The name of the hard button to subscribe to
/// @param updateHandler The block run when the subscribe button is selected
/// @return An object that can be used to unsubscribe the block using `unsubscribeButtonWithObserver:withCompletionHandler:`.
- (id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(nullable SDLSubscribeButtonUpdateHandler)updateHandler;

/// Subscribes to a subscribe button. The selector will be called when the button has been selected. If there is an error subscribing to the subscribe button it will be returned in the `error` parameter of the selector.
///
/// The selector supports the following parameters:
///
/// 1. A selector with no parameters. The observer will be notified when a button press occurs (it will not know if a short or long press has occurred).
///
/// 2. A selector with one parameter, (SDLButtonName). The observer will be notified when a button press occurs (it will not know if a short or long press has occurred).
///
/// 3. A selector with two parameters, (SDLButtonName, NSError). The observer will be notified when a button press occurs (it will not know if a short or long press has occurred).
///
/// 4. A selector with three parameters, (SDLButtonName, NSError, SDLOnButtonPress). The observer will be notified when a long or short button press occurs, but not a button event.
///
/// 5. A selector with four parameters, (SDLButtonName, NSError, SDLOnButtonPress, SDLOnButtonEvent). The observer will be notified when any button press or any button event occurs.
///
/// To unsubscribe to the hard button, please call `unsubscribeButton:withObserver:withCompletionHandler:`.
///
/// @param buttonName The name of the hard button to subscribe to
/// @param observer The object that will have `selector` called whenever the button has been selected
/// @param selector The selector on `observer` that will be called whenever the button has been selected
- (void)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector;

/// Unsubscribes to a subscribe button. Please note that if a subscribe button has multiple subscribers the observer will no longer get notifications, however, the app will still be subscribed to the hard button until the last subscriber is removed.
/// @param buttonName The name of the hard button to subscribe to
/// @param observer The object that will be unsubscribed. If a block was subscribed, the return value should be passed. If a selector was subscribed, the observer object should be passed
/// @param completionHandler A handler called when the observer has been unsubscribed to the hard button
- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
