//
//  SDLSDLSubscribeButtonManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLSubscribeButtonManager.h"

#import "SDLError.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSubscribeButton.h"
#import "SDLSubscribeButtonObserver.h"
#import "SDLUnsubscribeButton.h"
#import "SDLUnsubscribeButtonResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSubscribeButtonManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic) NSMutableDictionary<SDLButtonName, NSMutableArray<SDLSubscribeButtonObserver *> *> *subscribeButtonObservers;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;

@end

@implementation SDLSubscribeButtonManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _systemCapabilityManager = systemCapabilityManager;

    _subscribeButtonObservers = [NSMutableDictionary dictionary];
    _currentHMILevel = nil;

    [self sdl_registerForNotifications];

    return self;
}

- (void)start { }

- (void)stop {
    [_subscribeButtonObservers removeAllObjects];

    _currentHMILevel = nil;
}

#pragma mark - Subscriptions

- (nullable id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(nullable SDLSubscribeButtonUpdateHandler)block {
    return nil;
}

- (BOOL)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector; {
    SDLLogD(@"Subscribing to subscribe button with name: %@, with observer: %@, selector: %@", buttonName, observer, NSStringFromSelector(selector));

    NSUInteger numberOfParametersInSelector = [NSStringFromSelector(selector) componentsSeparatedByString:@":"].count - 1;
    if (numberOfParametersInSelector > 4) {
        SDLLogE(@"Attempted to subscribe to a subscribe button using a selector that contains more than 4 parameters.");
        return NO;
    }

    if (observer == nil) {
        SDLLogE(@"Attempted to subscribe to subscribe button with name: %@ with a selector on a *nil* observer, which will always fail.", buttonName);
        return NO;
    }

    SDLSubscribeButtonObserver *observerObject = [[SDLSubscribeButtonObserver alloc] initWithObserver:observer selector:selector];
    if (self.subscribeButtonObservers[buttonName] == nil) {
        self.subscribeButtonObservers[buttonName] = [NSMutableArray arrayWithArray:@[observerObject]];
    } else {
        [self.subscribeButtonObservers[buttonName] addObject:observerObject];
        SDLLogD(@"Subscribe button with name, %@, is already subscribed", buttonName);
        return YES;
    }

    SDLSubscribeButton *subscribeButton = [[SDLSubscribeButton alloc] initWithButtonName:buttonName handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        for (SDLSubscribeButtonObserver *subscribeButtonObserver in self.subscribeButtonObservers[buttonName]) {
            [self sdl_invokeObserver:subscribeButtonObserver withButtonName:buttonName buttonPress:buttonPress buttonEvent:buttonEvent error:nil];
        }
    }];

    [self.connectionManager sendConnectionRequest:subscribeButton withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) { return; }
        // If there was an error during the subscription attempt, return the error message.
        [self sdl_invokeObserver:observerObject withButtonName:buttonName buttonPress:nil buttonEvent:nil error:error];
    }];

    return YES;
}

- (void)unsubscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer withCompletionHandler:(nullable SDLSubscribeButtonUpdateCompletionHandler)completionHandler {

    if (self.subscribeButtonObservers[buttonName] == nil) {
        SDLLogE(@"Attempting to unsubscribe to subscribe button, %@, that is not currently subscribed", buttonName);
        // TODO return custom error in the completion handler
        return;
    }

    SDLUnsubscribeButton *unsubscribeButton = [[SDLUnsubscribeButton alloc] initWithButtonName:buttonName];
    [self.connectionManager sendConnectionRequest:unsubscribeButton withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLUnsubscribeButtonResponse *unsubscribeButtonResponse = (SDLUnsubscribeButtonResponse *)response;
        if (unsubscribeButtonResponse == nil || unsubscribeButtonResponse.success == false) {
            SDLLogE(@"Attempt to unsubscribe to subscribe button, %@, failed", buttonName);
            return completionHandler(error);
        }

        SDLLogD(@"Successfully unsubscribed to subscribe button: %@", buttonName);
        self.subscribeButtonObservers[buttonName] = nil;
    }];
}

#pragma mark - Notifications

/// Registers for notifications and responses from Core
- (void)sdl_registerForNotifications {
    SDLLogV(@"Registering for notifications");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;

    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }

    self.currentHMILevel = hmiStatus.hmiLevel;
}

#pragma mark - Subscriptions

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
            [invocation setArgument:&buttonPress atIndex:3];
        }
        if (numberOfParametersInSelector >= 3) {
            [invocation setArgument:&buttonEvent atIndex:4];
        }
        if (numberOfParametersInSelector >= 4) {
            [invocation setArgument:&error atIndex:5];
        }
        if (numberOfParametersInSelector >= 5) {
            @throw [NSException sdl_invalidSelectorExceptionWithSelector:observer.selector];
        }

        [invocation invoke];
    }
}

@end

NS_ASSUME_NONNULL_END
