//
//  SDLSDLSubscribeButtonManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLSubscribeButtonManager.h"

#import "SDLError.h"
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

NS_ASSUME_NONNULL_BEGIN

@interface SDLSubscribeButtonManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) NSMutableDictionary<SDLButtonName, NSMutableArray<SDLSubscribeButtonObserver *> *> *subscribeButtonObservers;

@end

@implementation SDLSubscribeButtonManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _subscribeButtonObservers = [NSMutableDictionary dictionary];

    return self;
}

- (void)start { }

- (void)stop {
    [_subscribeButtonObservers removeAllObjects];
}

#pragma mark - Subscriptions

- (id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(nullable SDLSubscribeButtonUpdateHandler)updateHandler {
    SDLSubscribeButtonObserver *observerObject = [[SDLSubscribeButtonObserver alloc] initWithObserver:[[NSObject alloc] init] updateHandler:updateHandler];

    if (self.subscribeButtonObservers[buttonName].count > 0) {
        [self.subscribeButtonObservers[buttonName] addObject:observerObject];
        SDLLogV(@"Subscribe button with name %@ is already subscribed", buttonName);
        return observerObject.observer;
    }

    [self sdl_subscribeToButtonNamed:buttonName withObserverObject:observerObject];
    return observerObject.observer;
}

- (void)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector; {
    SDLLogV(@"Subscribing to subscribe button with name: %@, with observer: %@, selector: %@", buttonName, observer, NSStringFromSelector(selector));

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
        [self.subscribeButtonObservers[buttonName] addObject:observerObject];
        SDLLogD(@"Subscribe button with name %@ is already subscribed", buttonName);
    }

    [self sdl_subscribeToButtonNamed:buttonName withObserverObject:observerObject];
}

- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)completionHandler {

    if (self.subscribeButtonObservers[buttonName] == nil) {
        SDLLogE(@"Attempting to unsubscribe to the %@ subscribe button which is not currently subscribed", buttonName);
        return completionHandler(nil);
    }

    [self.subscribeButtonObservers[buttonName] removeObject:observer];
    if (self.subscribeButtonObservers[buttonName].count > 0) {
        return completionHandler(nil);
    }

    SDLUnsubscribeButton *unsubscribeButton = [[SDLUnsubscribeButton alloc] initWithButtonName:buttonName];
    [self.connectionManager sendConnectionRequest:unsubscribeButton withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLUnsubscribeButtonResponse *unsubscribeButtonResponse = (SDLUnsubscribeButtonResponse *)response;
        if (unsubscribeButtonResponse == nil || unsubscribeButtonResponse.success.boolValue == NO) {
            SDLLogE(@"Attempt to unsubscribe to subscribe button named %@ failed", buttonName);
        }

        SDLLogD(@"Successfully unsubscribed to subscribe button named %@", buttonName);
        return completionHandler(error);
    }];
}

#pragma mark - Helpers

/// Helper method for sending a `SubscribeButton` request and notifying subscribers of button events.
/// @param buttonName The name of the subscribe button
/// @param observerObject The observer object
- (void)sdl_subscribeToButtonNamed:(SDLButtonName)buttonName withObserverObject:(SDLSubscribeButtonObserver *)observerObject {
    self.subscribeButtonObservers[buttonName] = [NSMutableArray arrayWithArray:@[observerObject]];

    __weak typeof(self) weakSelf = self;
    SDLSubscribeButton *subscribeButton = [[SDLSubscribeButton alloc] initWithButtonName:buttonName handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (SDLSubscribeButtonObserver *subscribeButtonObserver in strongSelf.subscribeButtonObservers[buttonPress.buttonName]) {
            [strongSelf sdl_invokeObserver:subscribeButtonObserver withButtonName:buttonName buttonPress:buttonPress buttonEvent:buttonEvent error:nil];
        }
    }];

    [self.connectionManager sendConnectionRequest:subscribeButton withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) { return; }

        // If there was an error during the subscription attempt, return the error message.
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sdl_invokeObserver:observerObject withButtonName:buttonName buttonPress:nil buttonEvent:nil error:error];
    }];
}

#pragma mark - Subscriptions

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
            @throw [NSException sdl_invalidSelectorExceptionWithSelector:observer.selector];
        }

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[(NSObject *)observer.observer methodSignatureForSelector:observer.selector]];
        [invocation setSelector:observer.selector];
        [invocation setTarget:observer.observer];

        NSUInteger numberOfParametersInSelector = [NSStringFromSelector(observer.selector) componentsSeparatedByString:@":"].count - 1;
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
            @throw [NSException sdl_invalidSelectorExceptionWithSelector:observer.selector];
        }

        [invocation invoke];
    }
}

@end

NS_ASSUME_NONNULL_END
