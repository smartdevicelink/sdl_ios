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
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic) NSMutableDictionary<SDLButtonName, NSMutableArray<SDLSubscribeButtonObserver *> *> *subscribeButtonObservers;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLHMIPermissions *subscribeButtonPermissions;

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_permissionStatusNotification:) name:SDLDidChangePermissionsNotification object:nil];

    return self;
}

- (void)start { }

- (void)stop {
    [_subscribeButtonObservers removeAllObjects];
    _currentHMILevel = nil;
}

#pragma mark - Subscriptions

- (nullable id<NSObject>)subscribeButton:(SDLButtonName)buttonName withUpdateHandler:(nullable SDLSubscribeButtonUpdateHandler)updateHandler {

    BOOL canSubscribe = [self sdl_canSubscribeToButtonNamed:buttonName];
    if (!canSubscribe) {
        return nil;
    }

    SDLSubscribeButtonObserver *observerObject = [[SDLSubscribeButtonObserver alloc] initWithObserver:[[NSObject alloc] init] updateHandler:updateHandler];

    if (self.subscribeButtonObservers[buttonName].count > 0) {
        [self.subscribeButtonObservers[buttonName] addObject:observerObject];
        SDLLogD(@"Subscribe button with name %@ is already subscribed", buttonName);
        return observerObject.observer;
    }

    [self sdl_subscribeToButtonNamed:buttonName withObserverObject:observerObject];

    return observerObject.observer;
}

- (BOOL)subscribeButton:(SDLButtonName)buttonName withObserver:(id<NSObject>)observer selector:(SEL)selector; {
    SDLLogD(@"Subscribing to subscribe button with name: %@, with observer: %@, selector: %@", buttonName, observer, NSStringFromSelector(selector));

    BOOL canSubscribe = [self sdl_canSubscribeToButtonNamed:buttonName];
    if (!canSubscribe) {
        return NO;
    }

    NSUInteger numberOfParametersInSelector = [NSStringFromSelector(selector) componentsSeparatedByString:@":"].count - 1;
    if (numberOfParametersInSelector > 4) {
        SDLLogE(@"Attempted to subscribe to a subscribe button using a selector that contains more than 4 parameters");
        return NO;
    }

    if (observer == nil) {
        SDLLogE(@"Attempted to subscribe to subscribe button with name %@ with a selector on a *nil* observer, which will always fail", buttonName);
        return NO;
    }

    SDLSubscribeButtonObserver *observerObject = [[SDLSubscribeButtonObserver alloc] initWithObserver:observer selector:selector];
    if (self.subscribeButtonObservers[buttonName].count > 0) {
        [self.subscribeButtonObservers[buttonName] addObject:observerObject];
        SDLLogD(@"Subscribe button with name %@ is already subscribed", buttonName);
        return YES;
    }

    [self sdl_subscribeToButtonNamed:buttonName withObserverObject:observerObject];

    return YES;
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

- (BOOL)sdl_canSubscribeToButtonNamed:(SDLButtonName)buttonName {
    if (![self.subscribeButtonPermissions.allowed containsObject:self.currentHMILevel]) {
        SDLLogE(@"Attempted to subscribe to subscribe button named %@ in HMI level %@, which is not allowed. Please wait until you have the right permissions before attempting to subscribe", buttonName, self.currentHMILevel);
        return NO;
    }

    return YES;
}

/// Helper method for sending a `SubscribeButton` request and notifying subscribers of button events.
/// @param buttonName The name of the subscribe button
/// @param observerObject The observer object
- (void)sdl_subscribeToButtonNamed:(SDLButtonName)buttonName withObserverObject:(SDLSubscribeButtonObserver *)observerObject {
    self.subscribeButtonObservers[buttonName] = [NSMutableArray arrayWithArray:@[observerObject]];
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
}

#pragma mark - Notifications

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;

    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }

    self.currentHMILevel = hmiStatus.hmiLevel;
}

- (void)sdl_permissionStatusNotification:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnPermissionsChange class]]) {
        return;
    }

    SDLOnPermissionsChange *onPermissionsChange = (SDLOnPermissionsChange *)notification.notification;
    NSArray<SDLPermissionItem *> *permissionItems = onPermissionsChange.permissionItem;
    for (SDLPermissionItem *item in permissionItems) {
        // TODO: does this need to be thread safe?
        if ([item.rpcName isEqualToEnum:SDLRPCFunctionNameSubscribeButton]) {
            self.subscribeButtonPermissions = item.hmiPermissions;
            break;
        }
    }
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
