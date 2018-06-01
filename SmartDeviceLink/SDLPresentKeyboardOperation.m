//
//  SDLPresentKeyboardOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPresentKeyboardOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLKeyboardDelegate.h"
#import "SDLKeyboardProperties.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnKeyboardInput.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetGlobalProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentKeyboardOperation()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) id<SDLKeyboardDelegate> keyboardDelegate;
@property (copy, nonatomic) NSString *initialText;
@property (strong, nonatomic) SDLKeyboardProperties *originalKeyboardProperties;
@property (strong, nonatomic) SDLKeyboardProperties *keyboardProperties;

@property (strong, nonatomic, readonly) SDLPerformInteraction *performInteraction;

@property (assign, nonatomic) BOOL updatedKeyboardProperties;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLPresentKeyboardOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager keyboardProperties:(SDLKeyboardProperties *)originalKeyboardProperties initialText:(NSString *)initialText keyboardDelegate:(id<SDLKeyboardDelegate>)keyboardDelegate {
    self = [super init];
    if (!self) { return self; }

    _connectionManager = connectionManager;
    _initialText = initialText;
    _keyboardDelegate = keyboardDelegate;
    _originalKeyboardProperties = originalKeyboardProperties;
    _keyboardProperties = originalKeyboardProperties;

    return self;
}

- (void)start {
    [super start];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_keyboardInputNotification:) name:SDLDidReceiveKeyboardInputNotification object:nil];

    [self sdl_start];
}

- (void)sdl_start {
    if (self.keyboardDelegate != nil) {
        SDLKeyboardProperties *customProperties = self.keyboardDelegate.customKeyboardConfiguration;
        if (customProperties != nil) {
            self.keyboardProperties = customProperties;
        }

        [self sdl_updateKeyboardPropertiesWithCompletionHandler:^{
            if (self.isCancelled) {
                [self finishOperation];
                return;
            }

            [self sdl_presentKeyboard];
        }];
    } else {
        // We cannot NOT have a keyboard delegate for this operation
        [self finishOperation];
    }
}

- (void)sdl_presentKeyboard {
    [self.connectionManager sendConnectionRequest:self.performInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (self.isCancelled) {
            [self finishOperation];
            return;
        }

        if (error != nil) {
            self.internalError = error;
        }

        [self finishOperation];
    }];
}

- (void)sdl_updateKeyboardPropertiesWithCompletionHandler:(nullable void(^)(void))completionHandler {
    // If these are equal, there were no updated keyboard properties, so we can skip to presenting the keyboard
    if (self.keyboardProperties == self.originalKeyboardProperties) {
        if (completionHandler != nil) {
            completionHandler();
        }
        return;
    }

    SDLSetGlobalProperties *setProperties = [[SDLSetGlobalProperties alloc] init];
    setProperties.keyboardProperties = self.keyboardProperties;

    __weak typeof(self) weakself = self;
    [self.connectionManager sendConnectionRequest:setProperties withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error setting keyboard properties to new value: %@, with error: %@", request, error);
        }

        weakself.updatedKeyboardProperties = YES;

        if (completionHandler != nil) {
            completionHandler();
        }
    }];
}

#pragma mark - Private Getters / Setters

- (SDLPerformInteraction *)performInteraction {
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] init];
    performInteraction.initialText = self.initialText;
    performInteraction.interactionMode = SDLInteractionModeManualOnly;
    performInteraction.interactionChoiceSetIDList = @[@0];
    performInteraction.interactionLayout = SDLLayoutModeKeyboard;

    return performInteraction;
}

#pragma mark - Notification Observers

- (void)sdl_keyboardInputNotification:(SDLRPCNotificationNotification *)notification {
    if (self.isCancelled) {
        [self finishOperation];
        return;
    }
    
    if (self.keyboardDelegate == nil) { return; }
    SDLOnKeyboardInput *onKeyboard = notification.notification;

    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardDidSendEvent:text:)]) {
        [self.keyboardDelegate keyboardDidSendEvent:onKeyboard.event text:onKeyboard.data];
    }

    __weak typeof(self) weakself = self;
    if ([onKeyboard.event isEqualToEnum:SDLKeyboardEventVoice] || [onKeyboard.event isEqualToEnum:SDLKeyboardEventSubmitted]) {
        // Submit voice or text
        [self.keyboardDelegate userDidSubmitInput:onKeyboard.data withEvent:onKeyboard.event];
    } else if ([onKeyboard.event isEqualToEnum:SDLKeyboardEventKeypress]) {
        // Notify of keypress
        if ([self.keyboardDelegate respondsToSelector:@selector(updateAutocompleteWithInput:completionHandler:)]) {
            [self.keyboardDelegate updateAutocompleteWithInput:onKeyboard.data completionHandler:^(NSString *updatedAutocompleteText) {
                weakself.keyboardProperties.autoCompleteText = updatedAutocompleteText;
                [weakself sdl_updateKeyboardPropertiesWithCompletionHandler:nil];
            }];
        }

        if ([self.keyboardDelegate respondsToSelector:@selector(updateCharacterSetWithInput:completionHandler:)]) {
            [self.keyboardDelegate updateCharacterSetWithInput:onKeyboard.data completionHandler:^(NSArray<NSString *> *updatedCharacterSet) {
                weakself.keyboardProperties.limitedCharacterList = updatedCharacterSet;
                [self sdl_updateKeyboardPropertiesWithCompletionHandler:nil];
            }];
        }
    } else if ([onKeyboard.event isEqualToEnum:SDLKeyboardEventAborted] || [onKeyboard.event isEqualToEnum:SDLKeyboardEventCancelled]) {
        // Notify of abort / cancellation
        [self.keyboardDelegate keyboardDidAbortWithReason:onKeyboard.event];
    }
}

#pragma mark - Property Overrides

- (nullable NSString *)name {
    return @"com.sdl.choicesetmanager.presentKeyboard";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (void)finishOperation {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // The keyboard properties were never updated and don't need to be reset
    if (!self.updatedKeyboardProperties) {
        [super finishOperation];
        return;
    }

    // We need to reset the keyboard properties
    SDLSetGlobalProperties *setProperties = [[SDLSetGlobalProperties alloc] init];
    setProperties.keyboardProperties = self.originalKeyboardProperties;

    [self.connectionManager sendConnectionRequest:setProperties withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error resetting keyboard properties to values: %@, with error: %@", request, error);
        }

        [super finishOperation];
    }];
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
