//
//  SDLSDLSubscribeButtonManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLSubscribeButtonManager.h"

#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLHMIPermissions.h"
#import "SDLLogMacros.h"
#import "SDLOnButtonPress.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnPermissionsChange.h"
#import "SDLPermissionItem.h"
#import "SDLPredefinedWindows.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSubscribeButton.h"
#import "SDLSubscribeButtonObserver.h"
#import "SDLUnsubscribeButton.h"
#import "SDLUnsubscribeButtonResponse.h"
#import "SDLOnButtonEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSubscribeButtonManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) NSMutableDictionary<SDLButtonName, NSMutableArray<SDLSubscribeButtonObserver *> *> *subscribeButtonObservers;
@property (copy, nonatomic) dispatch_queue_t readWriteQueue;

@end

@implementation SDLSubscribeButtonManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager {
    self = [super init];
    if (!self) { return nil; }

    if (@available(iOS 10.0, *)) {
        _readWriteQueue = dispatch_queue_create_with_target("com.sdl.subscribeButtonManager.readWriteQueue", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    } else {
        _readWriteQueue = [SDLGlobals sharedGlobals].sdlProcessingQueue;
    }

    _connectionManager = connectionManager;
    _subscribeButtonObservers = [NSMutableDictionary dictionary];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_handleButtonEvent:) name:SDLDidReceiveButtonEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_handleButtonPress:) name:SDLDidReceiveButtonPressNotification object:nil];

    return self;
}

- (void)start { }

- (void)stop {
    __weak typeof(self) weakSelf = self;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        __strong typeof(weakSelf) strongself = weakSelf;
        [strongself->_subscribeButtonObservers removeAllObjects];
    }];
}

#pragma mark - Subscribe

- (id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(nullable SDLSubscribeButtonUpdateHandler)updateHandler {
    SDLLogD(@"Subscribing to subscribe button with name: %@, with block", buttonName);

    NSObject *observer = [[NSObject alloc] init];
    SDLSubscribeButtonObserver *observerObject = [[SDLSubscribeButtonObserver alloc] initWithObserver:observer updateHandler:updateHandler];

    if (self.subscribeButtonObservers[buttonName].count > 0) {
        // The app has already subscribed to the button, simply add the observer to the list of observers for the button name.
        [self sdl_addSubscribedObserver:observerObject forButtonName:buttonName];
    } else {
        // The app has not yet subscribed to the button, send the `SubscribeButton` request for the button name.
        [self sdl_subscribeToButtonNamed:buttonName withObserverObject:observerObject];
    }

    return observer;
}

- (void)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector; {
    SDLLogD(@"Subscribing to subscribe button with name: %@, observer object: %@, selector: %@", buttonName, observer, NSStringFromSelector(selector));

    NSUInteger numberOfParametersInSelector = [NSStringFromSelector(selector) componentsSeparatedByString:@":"].count - 1;
    if (numberOfParametersInSelector > 4) {
        SDLLogE(@"Attempted to subscribe to a subscribe button using a selector that contains more than 4 parameters");
        return;
    }

    if (observer == nil) {
        SDLLogE(@"Attempted to subscribe to subscribe button with name %@ with a selector on a *nil* observer, which will always fail", buttonName);
        return;
    }

    SDLSubscribeButtonObserver *observerObject = [[SDLSubscribeButtonObserver alloc] initWithObserver:observer selector:selector];
    if (self.subscribeButtonObservers[buttonName].count > 0) {
        [self sdl_addSubscribedObserver:observerObject forButtonName:buttonName];
        return;
    }

    [self sdl_subscribeToButtonNamed:buttonName withObserverObject:observerObject];
}

/// Helper method for checking if the observer is currently subscribed to the button
/// @param observer The observer
/// @param buttonName The name of the button
/// @return True if the observer is currently subscribed to the button; false if not
- (BOOL)sdl_isSubscribedObserver:(id<NSObject>)observer forButtonName:(SDLButtonName)buttonName {
    BOOL isSubscribedObserver = NO;
    for (SDLSubscribeButtonObserver *subscribedObserver in self.subscribeButtonObservers[buttonName]) {
        if (subscribedObserver.observer != observer ) { continue; }
        isSubscribedObserver = YES;
        break;
    }

    return isSubscribedObserver;
}

/// Helper method for adding an observer for the button
/// @param subscribedObserver The observer
/// @param buttonName The name of the button
- (void)sdl_addSubscribedObserver:(SDLSubscribeButtonObserver *)subscribedObserver forButtonName:(SDLButtonName)buttonName {
    __weak typeof(self) weakSelf = self;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.subscribeButtonObservers[buttonName] == nil) {
            SDLLogV(@"Adding first subscriber for button: %@", buttonName);
            strongSelf.subscribeButtonObservers[buttonName] = [NSMutableArray arrayWithObject:subscribedObserver];
        } else {
            SDLLogV(@"Adding another subscriber for button: %@", buttonName);
            [strongSelf.subscribeButtonObservers[buttonName] addObject:subscribedObserver];
        }
    }];
}

#pragma mark Send Subscribe Request

/// Helper method for sending a `SubscribeButton` request and notifying subscribers of button events.
/// @param buttonName The name of the subscribe button
/// @param observerObject The observer object
- (void)sdl_subscribeToButtonNamed:(SDLButtonName)buttonName withObserverObject:(SDLSubscribeButtonObserver *)observerObject {
    SDLSubscribeButton *subscribeButton = [[SDLSubscribeButton alloc] initWithButtonName:buttonName handler:nil];
    __weak typeof(self) weakSelf = self;

    [self.connectionManager sendConnectionRequest:subscribeButton withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // Check if the request was successful. If a subscription request got sent for a button that is already subscribed then the module will respond with `IGNORED` so just act as if subscription succeeded.
        if (!response.success.boolValue && ![response.resultCode isEqualToEnum:SDLResultIgnored]) {
            [strongSelf sdl_invokeObserver:observerObject withButtonName:buttonName buttonPress:nil buttonEvent:nil error:error];
            return;
        }

        [strongSelf sdl_addSubscribedObserver:observerObject forButtonName:buttonName];
    }];
}

#pragma mark - Unsubscribe
#pragma mark Send Unsubscribe Request

- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)completionHandler {
    if (self.subscribeButtonObservers[buttonName] == nil || ![self sdl_isSubscribedObserver:observer forButtonName:buttonName]) {
        SDLLogE(@"Attempting to unsubscribe to the %@ subscribe button which is not currently subscribed", buttonName);
        return completionHandler([NSError sdl_subscribeButtonManager_notSubscribed]);
    }

    // If we have more than one observer, just remove this observer
    if (self.subscribeButtonObservers[buttonName].count > 1) {
        [self sdl_removeSubscribedObserver:observer forButtonName:buttonName];
        return completionHandler(nil);
    }

    // If there's only one observer, unsubscribe from the button
    SDLUnsubscribeButton *unsubscribeButton = [[SDLUnsubscribeButton alloc] initWithButtonName:buttonName];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendConnectionRequest:unsubscribeButton withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!response.success.boolValue) {
            SDLLogE(@"Attempt to unsubscribe from subscribe button %@ failed", buttonName);
            return completionHandler(error);
        }

        SDLLogD(@"Successfully unsubscribed from subscribe button named %@", buttonName);
        [strongSelf sdl_removeSubscribedObserver:observer forButtonName:buttonName];
        return completionHandler(error);
    }];
}

/// Helper method for removing an observer for the button
/// @param observer The observer
/// @param buttonName The name of the button
- (void)sdl_removeSubscribedObserver:(id<NSObject>)observer forButtonName:(SDLButtonName)buttonName {
    __weak typeof(self) weakSelf = self;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (NSUInteger i = 0; i < strongSelf.subscribeButtonObservers[buttonName].count; i++) {
            SDLSubscribeButtonObserver *subscribedObserver = (SDLSubscribeButtonObserver *)strongSelf.subscribeButtonObservers[buttonName][i];
            if (subscribedObserver.observer != observer) { continue; }
            // Okay to mutate because we will break immediately afterward
            [strongSelf.subscribeButtonObservers[buttonName] removeObjectAtIndex:i];
            break;
        }
    }];
}

#pragma mark - Notifications

/// Button event notification from the module
/// @param notification Information about the button event
- (void)sdl_handleButtonEvent:(SDLRPCNotificationNotification *)notification {
    SDLOnButtonEvent *buttonEvent = (SDLOnButtonEvent *)notification.notification;
    if (buttonEvent == nil) { return; }

    SDLButtonName buttonName = buttonEvent.buttonName;
    for (SDLSubscribeButtonObserver *subscribeButtonObserver in self.subscribeButtonObservers[buttonName]) {
        [self sdl_invokeObserver:subscribeButtonObserver withButtonName:buttonName buttonPress:nil buttonEvent:buttonEvent error:nil];
    }
}

/// Button press notification from the module
/// @param notification Information about the button press
- (void)sdl_handleButtonPress:(SDLRPCNotificationNotification *)notification {
    SDLOnButtonPress *buttonPress = (SDLOnButtonPress *)notification.notification;
    if (buttonPress == nil) { return; }

    SDLButtonName buttonName = buttonPress.buttonName;
    for (SDLSubscribeButtonObserver *subscribeButtonObserver in self.subscribeButtonObservers[buttonName]) {
        [self sdl_invokeObserver:subscribeButtonObserver withButtonName:buttonName buttonPress:buttonPress buttonEvent:nil error:nil];
    }
}

/// Helper method for notifying subscribers of button events.
/// @param observer The object that will have `selector` called
/// @param buttonName The name of the subscribe button
/// @param buttonPress Indicates whether this is a long or short button press event
/// @param buttonEvent Indicates that the button has been depressed or released
/// @param error The error, if one occurred; nil if not
- (void)sdl_invokeObserver:(SDLSubscribeButtonObserver *)observer withButtonName:(SDLButtonName)buttonName buttonPress:(nullable SDLOnButtonPress *)buttonPress buttonEvent:(nullable SDLOnButtonEvent *)buttonEvent error:(nullable NSError *)error {
    if (observer.updateBlock != nil) {
        observer.updateBlock(buttonPress, buttonEvent, error);
    } else {
        if (![observer.observer respondsToSelector:observer.selector]) {
            @throw [NSException sdl_invalidSubscribeButtonSelectorExceptionWithSelector:observer.selector];
        }

        NSUInteger numberOfParametersInSelector = [NSStringFromSelector(observer.selector) componentsSeparatedByString:@":"].count - 1;

        // If a selector has 0, 1, 2, or 3 parameters and only a button event has occured, do not notify the observer of the button event.
        if (buttonEvent != nil && numberOfParametersInSelector <= 3) {
            return;
        }

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[(NSObject *)observer.observer methodSignatureForSelector:observer.selector]];
        [invocation setSelector:observer.selector];
        [invocation setTarget:observer.observer];

        if (numberOfParametersInSelector >= 1) {
            [invocation setArgument:&buttonName atIndex:2];
        }
        if (numberOfParametersInSelector >= 2) {
            [invocation setArgument:&error atIndex:3];
        }
        if (numberOfParametersInSelector >= 3) {
            [invocation setArgument:&buttonPress atIndex:4];
        }
        if (numberOfParametersInSelector >= 4) {
            [invocation setArgument:&buttonEvent atIndex:5];
        }
        if (numberOfParametersInSelector >= 5) {
            @throw [NSException sdl_invalidSubscribeButtonSelectorExceptionWithSelector:observer.selector];
        }

        [invocation invoke];
    }
}

#pragma mark - Getters

- (NSMutableDictionary<SDLButtonName, NSMutableArray<SDLSubscribeButtonObserver *> *> *)subscribeButtonObservers {
    __block NSMutableDictionary<SDLButtonName, NSMutableArray<SDLSubscribeButtonObserver *> *> *dict = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        dict = self->_subscribeButtonObservers;
    }];

    return dict;
}

@end

NS_ASSUME_NONNULL_END
