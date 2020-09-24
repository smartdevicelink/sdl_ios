//
//  SDLPresentChoiceSetOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPresentChoiceSetOperation.h"

#import "SDLCancelInteraction.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLConnectionManagerType.h"
#import "SDLGlobals.h"
#import "SDLKeyboardDelegate.h"
#import "SDLKeyboardProperties.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnKeyboardInput.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetGlobalProperties.h"
#import "SDLVersion.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLChoiceSet()

@property (copy, nonatomic) SDLChoiceSetCanceledHandler canceledHandler;


@end

@interface SDLPresentChoiceSetOperation()

@property (strong, nonatomic) NSUUID *operationId;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic, readwrite) SDLChoiceSet *choiceSet;
@property (strong, nonatomic) SDLInteractionMode presentationMode;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *originalKeyboardProperties;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *keyboardProperties;
@property (weak, nonatomic) id<SDLKeyboardDelegate> keyboardDelegate;

@property (strong, nonatomic, readonly) SDLPerformInteraction *performInteraction;
@property (strong, nonatomic, readonly) SDLLayoutMode layoutMode;
@property (strong, nonatomic, readonly) NSArray<NSNumber<SDLInt> *> *choiceIds;
@property (assign, nonatomic) UInt16 cancelId;
@property (assign, nonatomic) BOOL updatedKeyboardProperties;

@property (copy, nonatomic, nullable) NSError *internalError;
@property (strong, nonatomic, readwrite, nullable) SDLChoiceCell *selectedCell;
@property (strong, nonatomic, readwrite, nullable) SDLTriggerSource selectedTriggerSource;
@property (assign, nonatomic, readwrite) NSUInteger selectedCellRow;

@end

@implementation SDLPresentChoiceSetOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode keyboardProperties:(nullable SDLKeyboardProperties *)originalKeyboardProperties keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate cancelID:(UInt16)cancelID {
    self = [super init];
    if (!self) { return self; }

    _connectionManager = connectionManager;
    _choiceSet = choiceSet;

    __weak typeof(self) weakSelf = self;
    self.choiceSet.canceledHandler = ^{
        [weakSelf sdl_cancelInteraction];
    };

    _presentationMode = mode;
    _operationId = [NSUUID UUID];

    _originalKeyboardProperties = originalKeyboardProperties;
    _keyboardProperties = originalKeyboardProperties;
    _keyboardDelegate = keyboardDelegate;
    _cancelId = cancelID;

    _selectedCellRow = NSNotFound;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_keyboardInputNotification:) name:SDLDidReceiveKeyboardInputNotification object:nil];

    [self sdl_start];
}

- (void)sdl_start {
    // Check if we're using a keyboard (searchable) choice set and setup keyboard properties if we need to
    if (self.keyboardDelegate != nil && [self.keyboardDelegate respondsToSelector:@selector(customKeyboardConfiguration)]) {
        SDLKeyboardProperties *customProperties = self.keyboardDelegate.customKeyboardConfiguration;
        if (customProperties != nil) {
            self.keyboardProperties = customProperties;
        }
    }

    [self sdl_updateKeyboardPropertiesWithCompletionHandler:^{
        if (self.isCancelled) {
            [self finishOperation];
            return;
        }

        [self sdl_presentChoiceSet];
    }];
}

#pragma mark - Sending Requests

- (void)sdl_updateKeyboardPropertiesWithCompletionHandler:(nullable void(^)(void))completionHandler {
    if (self.keyboardProperties == nil) {
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

- (void)sdl_presentChoiceSet {
    __weak typeof(self) weakself = self;
    [self.connectionManager sendConnectionRequest:self.performInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Presenting choice set failed with response: %@, error: %@", response, error);
            weakself.internalError = error;

            [weakself finishOperation];
            return;
        }

        SDLPerformInteractionResponse *performResponse = (SDLPerformInteractionResponse *)response;
        [weakself sdl_setSelectedCellWithId:performResponse.choiceID];
        weakself.selectedTriggerSource = performResponse.triggerSource;

        [weakself finishOperation];
    }];
}

#pragma mark - Helpers

- (void)sdl_setSelectedCellWithId:(NSNumber<SDLInt> *)cellId {
    __weak typeof(self) weakself = self;
    [self.choiceSet.choices enumerateObjectsUsingBlock:^(SDLChoiceCell * _Nonnull cell, NSUInteger i, BOOL * _Nonnull stop) {
        if (cell.choiceId == cellId.unsignedIntValue) {
            weakself.selectedCell = cell;
            weakself.selectedCellRow = i;
        }
    }];
}

/**
 * Cancels the choice set. If the choice set has not yet been sent to Core, it will not be sent. If the choice set is already presented on Core, the choice set will be immediately dismissed. Canceling an already presented choice set will only work if connected to Core versions 6.0+. On older versions of Core, the choice set will not be dismissed.
 */
- (void)sdl_cancelInteraction {
    if (self.isFinished) {
        SDLLogW(@"This operation has already finished so it can not be canceled.");
        return;
    } else if (self.isCancelled) {
        SDLLogW(@"This operation has already been canceled. It will be finished at some point during the operation.");
        return;
    } else if (self.isExecuting) {
        if ([SDLGlobals.sharedGlobals.rpcVersion isLessThanVersion:[[SDLVersion alloc] initWithMajor:6 minor:0 patch:0]]) {
            SDLLogE(@"Canceling a choice set is not supported on this head unit");
            return;
        }

        SDLLogD(@"Canceling the presented choice set interaction");

        SDLCancelInteraction *cancelInteraction = [[SDLCancelInteraction alloc] initWithPerformInteractionCancelID:self.cancelId];

        __weak typeof(self) weakSelf = self;
        [self.connectionManager sendConnectionRequest:cancelInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                weakSelf.internalError = error;
                SDLLogE(@"Error canceling the presented choice set: %@, with error: %@", request, error);
                return;
            }
            SDLLogD(@"The presented choice set was canceled successfully");
        }];
    } else {
        SDLLogD(@"Canceling a choice set that has not yet been sent to Core");
        [self cancel];
    }
}

#pragma mark - Getters

- (SDLPerformInteraction *)performInteraction {
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] init];
    performInteraction.interactionMode = self.presentationMode;
    performInteraction.initialText = self.choiceSet.title;
    performInteraction.initialPrompt = self.choiceSet.initialPrompt;
    performInteraction.helpPrompt = self.choiceSet.helpPrompt;
    performInteraction.timeoutPrompt = self.choiceSet.timeoutPrompt;
    performInteraction.vrHelp = self.choiceSet.helpList;
    performInteraction.timeout = @((NSUInteger)(self.choiceSet.timeout * 1000));
    performInteraction.interactionLayout = self.layoutMode;
    performInteraction.interactionChoiceSetIDList = self.choiceIds;
    performInteraction.cancelID = @(self.cancelId);

    return performInteraction;
}

- (SDLLayoutMode)layoutMode {
    switch (self.choiceSet.layout) {
        case SDLChoiceSetLayoutList:
            return self.keyboardDelegate ? SDLLayoutModeListWithSearch : SDLLayoutModeListOnly;
        case SDLChoiceSetLayoutTiles:
            return self.keyboardDelegate ? SDLLayoutModeIconWithSearch : SDLLayoutModeIconOnly;
    }
}

- (NSArray<NSNumber<SDLInt> *> *)choiceIds {
    NSMutableArray<NSNumber<SDLInt> *> *choiceIds = [NSMutableArray arrayWithCapacity:self.choiceSet.choices.count];
    for (SDLChoiceCell *cell in self.choiceSet.choices) {
        [choiceIds addObject:@(cell.choiceId)];
    }

    return [choiceIds copy];
}

#pragma mark - SDL Notifications

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
        if ([self.keyboardDelegate respondsToSelector:@selector(updateAutocompleteWithInput:autoCompleteResultsHandler:)]) {
            [self.keyboardDelegate updateAutocompleteWithInput:onKeyboard.data autoCompleteResultsHandler:^(NSArray<NSString *> * _Nullable updatedAutoCompleteList) {
                NSArray<NSString *> *newList = nil;
                if (updatedAutoCompleteList.count > 100) {
                    newList = [updatedAutoCompleteList subarrayWithRange:NSMakeRange(0, 100)];
                } else {
                    newList = updatedAutoCompleteList;
                }

                weakself.keyboardProperties.autoCompleteList = (newList.count > 0) ? newList : @[];
                weakself.keyboardProperties.autoCompleteText = (newList.count > 0) ? newList.firstObject : nil;
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

- (void)finishOperation {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (self.keyboardProperties == nil) {
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

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.operationId];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
