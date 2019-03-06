//
//  SDLPresentChoiceSetOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPresentChoiceSetOperation.h"

#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
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

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPresentChoiceSetOperation()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic, readwrite) SDLChoiceSet *choiceSet;
@property (strong, nonatomic) SDLInteractionMode presentationMode;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *originalKeyboardProperties;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *keyboardProperties;
@property (weak, nonatomic) id<SDLKeyboardDelegate> keyboardDelegate;

@property (strong, nonatomic, readonly) SDLPerformInteraction *performInteraction;
@property (strong, nonatomic, readonly) SDLLayoutMode layoutMode;
@property (strong, nonatomic, readonly) NSArray<NSNumber<SDLInt> *> *choiceIds;
@property (assign, nonatomic) BOOL updatedKeyboardProperties;

@property (copy, nonatomic, nullable) NSError *internalError;
@property (strong, nonatomic, readwrite, nullable) SDLChoiceCell *selectedCell;
@property (strong, nonatomic, readwrite, nullable) SDLTriggerSource selectedTriggerSource;
@property (assign, nonatomic, readwrite) NSUInteger selectedCellRow;

@end

@implementation SDLPresentChoiceSetOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode keyboardProperties:(nullable SDLKeyboardProperties *)originalKeyboardProperties keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate {
    self = [super init];
    if (!self) { return self; }

    _connectionManager = connectionManager;
    _choiceSet = choiceSet;
    _presentationMode = mode;

    _originalKeyboardProperties = originalKeyboardProperties;
    _keyboardProperties = originalKeyboardProperties;
    _keyboardDelegate = keyboardDelegate;

    _selectedCellRow = NSNotFound;

    return self;
}

- (void)start {
    [super start];

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
    return @"com.sdl.choicesetmanager.presentChoiceSet";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
