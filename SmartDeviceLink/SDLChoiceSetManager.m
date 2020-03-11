//
//  SDLChoiceSetManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLChoiceSetManager.h"

#import "SDLCheckChoiceVROptionalOperation.h"
#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLConnectionManagerType.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDeleteChoicesOperation.h"
#import "SDLDisplayCapability.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLKeyboardProperties.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLPredefinedWindows.h"
#import "SDLPreloadChoicesOperation.h"
#import "SDLPresentChoiceSetOperation.h"
#import "SDLPresentKeyboardOperation.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLStateMachine.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ShowManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

SDLChoiceManagerState *const SDLChoiceManagerStateShutdown = @"Shutdown";
SDLChoiceManagerState *const SDLChoiceManagerStateCheckingVoiceOptional = @"CheckingVoiceOptional";
SDLChoiceManagerState *const SDLChoiceManagerStateReady = @"Ready";
SDLChoiceManagerState *const SDLChoiceManagerStateStartupError = @"StartupError";

typedef NSNumber * SDLChoiceId;

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLChoiceSetManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *preloadedMutableChoices;
@property (strong, nonatomic, readonly) NSSet<SDLChoiceCell *> *pendingPreloadChoices;
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *pendingMutablePreloadChoices;
@property (strong, nonatomic, nullable) SDLChoiceSet *pendingPresentationSet;
@property (strong, nonatomic, nullable) SDLAsynchronousOperation *pendingPresentOperation;

@property (assign, nonatomic) UInt16 nextChoiceId;
@property (assign, nonatomic) UInt16 nextCancelId;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

@end

UInt16 const ChoiceCellIdMin = 1;
UInt16 const ChoiceCellCancelIdMin = 1;

@implementation SDLChoiceSetManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLChoiceManagerStateShutdown states:[self.class sdl_stateTransitionDictionary]];
    _transactionQueue = [self sdl_newTransactionQueue];

    _preloadedMutableChoices = [NSMutableSet set];
    _pendingMutablePreloadChoices = [NSMutableSet set];

    _nextChoiceId = ChoiceCellIdMin;
    _nextCancelId = ChoiceCellCancelIdMin;
    _vrOptional = YES;
    _keyboardConfiguration = [self sdl_defaultKeyboardConfiguration];
    _currentHMILevel = SDLHMILevelNone;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)start {
    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate:)];

    if ([self.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
        [self.stateMachine transitionToState:SDLChoiceManagerStateCheckingVoiceOptional];
    }

    // Else, we're already started
}

- (void)stop {
    [self.stateMachine transitionToState:SDLChoiceManagerStateShutdown];
}

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_stateTransitionDictionary {
    return @{
             SDLChoiceManagerStateShutdown: @[SDLChoiceManagerStateCheckingVoiceOptional],
             SDLChoiceManagerStateCheckingVoiceOptional: @[SDLChoiceManagerStateShutdown, SDLChoiceManagerStateReady, SDLChoiceManagerStateStartupError],
             SDLChoiceManagerStateReady: @[SDLChoiceManagerStateShutdown],
             SDLChoiceManagerStateStartupError: @[SDLChoiceManagerStateShutdown]
             };
}

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"com.sdl.screenManager.choiceSetManager.transactionQueue";
    queue.maxConcurrentOperationCount = 1;
    queue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    queue.suspended = YES;

    return queue;
}

/// Suspend the transaction queue if we are in HMI NONE
/// OR if we don't know what text fields are allowed, or if the text field name "menu name" (this is the primary choice text) we assume we cannot present a PI.
- (void)sdl_updateTransactionQueueSuspended {
    if ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone]
        || (![self.currentWindowCapability hasTextFieldOfName:SDLTextFieldNameMenuName])) {
        SDLLogD(@"Suspending the transaction queue. Current HMI level is: %@, window capability has MenuName (choice primary text): %@", self.currentHMILevel, ([self.currentWindowCapability hasTextFieldOfName:SDLTextFieldNameMenuName] ? @"YES" : @"NO"));
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}

#pragma mark - State Management

- (void)didEnterStateShutdown {
    _currentHMILevel = nil;

    [self.transactionQueue cancelAllOperations];
    self.transactionQueue = [self sdl_newTransactionQueue];
    _preloadedMutableChoices = [NSMutableSet set];
    _pendingMutablePreloadChoices = [NSMutableSet set];
    _pendingPresentationSet = nil;

    _vrOptional = YES;
    _nextChoiceId = ChoiceCellIdMin;
    _nextCancelId = ChoiceCellCancelIdMin;
}

- (void)didEnterStateCheckingVoiceOptional {
    // Setup by sending a Choice Set without VR, seeing if there's an error. If there is, send one with VR. This choice set will be used for `presentKeyboard` interactions.
    SDLCheckChoiceVROptionalOperation *checkOp = [[SDLCheckChoiceVROptionalOperation alloc] initWithConnectionManager:self.connectionManager];

    __weak typeof(self) weakself = self;
    __weak typeof(checkOp) weakOp = checkOp;
    checkOp.completionBlock = ^{
        if ([self.currentState isEqualToString:SDLChoiceManagerStateShutdown]) { return; }

        weakself.vrOptional = weakOp.isVROptional;
        if (weakOp.error != nil) {
            [weakself.stateMachine transitionToState:SDLChoiceManagerStateStartupError];
        } else {
            [weakself.stateMachine transitionToState:SDLChoiceManagerStateReady];
        }
    };

    [self.transactionQueue addOperation:checkOp];
}

- (void)didEnterStateStartupError {
    // TODO
}

#pragma mark - Choice Management

#pragma mark Upload / Delete

- (void)preloadChoices:(NSArray<SDLChoiceCell *> *)choices withCompletionHandler:(nullable SDLPreloadChoiceCompletionHandler)handler {
    SDLLogV(@"Request to preload choices: %@", choices);
    if ([self.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
        NSError *error = [NSError sdl_choiceSetManager_incorrectState:self.currentState];
        SDLLogE(@"Attempted to preload choices but the choice set manager is shut down: %@", error);
        if (handler != nil) {
            handler(error);
        }
        return;
    }

    NSMutableSet<SDLChoiceCell *> *choicesToUpload = [[self sdl_choicesToBeUploadedWithArray:choices] mutableCopy];
    [choicesToUpload minusSet:self.preloadedMutableChoices];
    [choicesToUpload minusSet:self.pendingMutablePreloadChoices];

    if (choicesToUpload.count == 0) {
        if (handler != nil) {
            handler(nil);
        }

        return;
    }

    [self sdl_updateIdsOnChoices:choicesToUpload];

    // Add the preload cells to the pending preloads
    [self.pendingMutablePreloadChoices unionSet:choicesToUpload];

    // Upload pending preloads
    // For backward compatibility with Gen38Inch display type head units
    SDLLogD(@"Preloading choices");
    SDLLogV(@"Choices to be uploaded: %@", choicesToUpload);
    NSString *displayName = self.systemCapabilityManager.displays.firstObject.displayName;
    SDLPreloadChoicesOperation *preloadOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager displayName:displayName windowCapability:self.systemCapabilityManager.defaultMainWindowCapability isVROptional:self.isVROptional cellsToPreload:choicesToUpload];

    __weak typeof(self) weakSelf = self;
    __weak typeof(preloadOp) weakPreloadOp = preloadOp;
    preloadOp.completionBlock = ^{
        SDLLogD(@"Choices finished preloading");
        [weakSelf.preloadedMutableChoices unionSet:choicesToUpload];
        [weakSelf.pendingMutablePreloadChoices minusSet:choicesToUpload];

        if (handler != nil) {
            handler(weakPreloadOp.error);
        }
    };
    [self.transactionQueue addOperation:preloadOp];
}

- (void)deleteChoices:(NSArray<SDLChoiceCell *> *)choices {
    SDLLogV(@"Request to delete choices: %@", choices);
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) {
        SDLLogE(@"Attempted to delete choices in an incorrect state: %@, they will not be deleted", self.currentState);
        return;
    }

    // Find cells to be deleted that are already uploaded or are pending upload
    NSSet<SDLChoiceCell *> *cellsToBeDeleted = [self sdl_choicesToBeDeletedWithArray:choices];
    NSSet<SDLChoiceCell *> *cellsToBeRemovedFromPending = [self sdl_choicesToBeRemovedFromPendingWithArray:choices];

    // If choices are deleted that are already uploaded or pending and are used by a pending presentation, cancel it and send an error
    NSSet<SDLChoiceCell *> *pendingPresentationChoices = [NSSet setWithArray:self.pendingPresentationSet.choices];
    if ((!self.pendingPresentOperation.isCancelled && !self.pendingPresentOperation.isFinished)
        && ([cellsToBeDeleted intersectsSet:pendingPresentationChoices] || [cellsToBeRemovedFromPending intersectsSet:pendingPresentationChoices])) {
        [self.pendingPresentOperation cancel];
        if (self.pendingPresentationSet.delegate != nil) {
            [self.pendingPresentationSet.delegate choiceSet:self.pendingPresentationSet didReceiveError:[NSError sdl_choiceSetManager_choicesDeletedBeforePresentation:@{@"deletedChoices": choices}]];
        }

        self.pendingPresentationSet = nil;
    }

    // Remove the cells from pending and delete choices
    [self.pendingMutablePreloadChoices minusSet:cellsToBeRemovedFromPending];
    for (SDLAsynchronousOperation *op in self.transactionQueue.operations) {
        if (![op isMemberOfClass:[SDLPreloadChoicesOperation class]]) { continue; }

        SDLPreloadChoicesOperation *preloadOp = (SDLPreloadChoicesOperation *)op;
        [preloadOp removeChoicesFromUpload:cellsToBeRemovedFromPending];
    }

    // Find choices to delete
    if (cellsToBeDeleted.count == 0) { return; }

    [self sdl_findIdsOnChoices:cellsToBeDeleted];
    SDLDeleteChoicesOperation *deleteOp = [[SDLDeleteChoicesOperation alloc] initWithConnectionManager:self.connectionManager cellsToDelete:cellsToBeDeleted];

    __weak typeof(self) weakself = self;
    __weak typeof(deleteOp) weakOp = deleteOp;
    deleteOp.completionBlock = ^{
        if (weakOp.error != nil) {
            SDLLogE(@"Failed to delete choices: %@", weakOp.error);
            return;
        }

        SDLLogD(@"Finished deleting choices");
        [weakself.preloadedMutableChoices minusSet:cellsToBeDeleted];
    };
    [self.transactionQueue addOperation:deleteOp];
}

#pragma mark Present

- (void)presentChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(nullable id<SDLKeyboardDelegate>)delegate {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) {
        SDLLogE(@"Attempted to present choices in an incorrect state: %@, it will not be presented", self.currentState);
        return;
    }

    if (choiceSet == nil) {
        SDLLogW(@"Attempted to present a nil choice set, ignoring.");
        return;
    }

    if (self.pendingPresentationSet != nil) {
        SDLLogW(@"A choice set is pending: %@. We will try to cancel it in favor of presenting a different choice set: %@. If it's already on screen it cannot be cancelled", self.pendingPresentationSet, choiceSet);
        [self.pendingPresentOperation cancel];
    }

    SDLLogD(@"Preloading and presenting choice set: %@", choiceSet);
    self.pendingPresentationSet = choiceSet;
    [self preloadChoices:self.pendingPresentationSet.choices withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            [choiceSet.delegate choiceSet:choiceSet didReceiveError:error];
            return;
        }
    }];

    [self sdl_findIdsOnChoiceSet:self.pendingPresentationSet];

    SDLPresentChoiceSetOperation *presentOp = nil;
    if (delegate == nil) {
        // Non-searchable choice set
        presentOp = [[SDLPresentChoiceSetOperation alloc] initWithConnectionManager:self.connectionManager choiceSet:self.pendingPresentationSet mode:mode keyboardProperties:nil keyboardDelegate:nil cancelID:self.nextCancelId++];
    } else {
        // Searchable choice set
        presentOp = [[SDLPresentChoiceSetOperation alloc] initWithConnectionManager:self.connectionManager choiceSet:self.pendingPresentationSet mode:mode keyboardProperties:self.keyboardConfiguration keyboardDelegate:delegate cancelID:self.nextCancelId++];
    }
    self.pendingPresentOperation = presentOp;

    __weak typeof(self) weakself = self;
    __weak typeof(presentOp) weakOp = presentOp;
    self.pendingPresentOperation.completionBlock = ^{
        __strong typeof(weakOp) strongOp = weakOp;

        SDLLogD(@"Finished presenting choice set: %@", strongOp.choiceSet);
        if (strongOp.error != nil && strongOp.choiceSet.delegate != nil) {
            [strongOp.choiceSet.delegate choiceSet:strongOp.choiceSet didReceiveError:strongOp.error];
        } else if (strongOp.selectedCell != nil && strongOp.choiceSet.delegate != nil) {
            [strongOp.choiceSet.delegate choiceSet:strongOp.choiceSet didSelectChoice:strongOp.selectedCell withSource:strongOp.selectedTriggerSource atRowIndex:strongOp.selectedCellRow];
        }

        weakself.pendingPresentationSet = nil;
        weakself.pendingPresentOperation = nil;
    };

    [self.transactionQueue addOperation:presentOp];
}

- (nullable NSNumber<SDLInt> *)presentKeyboardWithInitialText:(NSString *)initialText delegate:(id<SDLKeyboardDelegate>)delegate {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) {
        SDLLogE(@"Attempted to present keyboard in an incorrect state: %@, it will not be presented", self.currentState);
        return nil;
    }

    if (self.pendingPresentationSet != nil) {
        SDLLogW(@"There's already a pending presentation set, cancelling it in favor of a keyboard");
        [self.pendingPresentOperation cancel];
        self.pendingPresentationSet = nil;
    }

    SDLLogD(@"Presenting keyboard with initial text: %@", initialText);
    // Present a keyboard with the choice set that we used to test VR's optional state
    UInt16 keyboardCancelId = self.nextCancelId++;
    self.pendingPresentOperation = [[SDLPresentKeyboardOperation alloc] initWithConnectionManager:self.connectionManager keyboardProperties:self.keyboardConfiguration initialText:initialText keyboardDelegate:delegate cancelID:keyboardCancelId];
    [self.transactionQueue addOperation:self.pendingPresentOperation];
    return @(keyboardCancelId);
}

- (void)dismissKeyboardWithCancelID:(NSNumber<SDLInt> *)cancelID {
    for (SDLAsynchronousOperation *op in self.transactionQueue.operations) {
        if (![op isKindOfClass:SDLPresentKeyboardOperation.class]) { continue; }

        SDLPresentKeyboardOperation *keyboardOperation = (SDLPresentKeyboardOperation *)op;
        if (keyboardOperation.cancelId != cancelID.unsignedShortValue) { continue; }

        SDLLogD(@"Dismissing keyboard with cancel ID: %@", cancelID);
        [keyboardOperation dismissKeyboard];
        break;
    }
}

#pragma mark - Choice Management Helpers

- (NSSet<SDLChoiceCell *> *)sdl_choicesToBeUploadedWithArray:(NSArray<SDLChoiceCell *> *)choices {
    // Check if any of the choices already exist on the head unit and remove them from being preloaded
    NSMutableSet<SDLChoiceCell *> *choicesSet = [NSMutableSet setWithArray:choices];
    [choicesSet minusSet:self.preloadedChoices];

    return [choicesSet copy];
}

- (NSSet<SDLChoiceCell *> *)sdl_choicesToBeDeletedWithArray:(NSArray<SDLChoiceCell *> *)choices {
    NSMutableSet<SDLChoiceCell *> *choicesSet = [NSMutableSet setWithArray:choices];
    [choicesSet intersectSet:self.preloadedChoices];

    return [choicesSet copy];
}

- (NSSet<SDLChoiceCell *> *)sdl_choicesToBeRemovedFromPendingWithArray:(NSArray<SDLChoiceCell *> *)choices {
    NSMutableSet<SDLChoiceCell *> *choicesSet = [NSMutableSet setWithArray:choices];
    [choicesSet intersectSet:self.pendingPreloadChoices];

    return [choicesSet copy];
}

- (void)sdl_updateIdsOnChoices:(NSSet<SDLChoiceCell *> *)choices {
    for (SDLChoiceCell *cell in choices) {
        cell.choiceId = self.nextChoiceId;
        self.nextChoiceId++;
    }
}

- (void)sdl_findIdsOnChoiceSet:(SDLChoiceSet *)choiceSet {
    return [self sdl_findIdsOnChoices:[NSSet setWithArray:choiceSet.choices]];
}

- (void)sdl_findIdsOnChoices:(NSSet<SDLChoiceCell *> *)choices {
    for (SDLChoiceCell *cell in choices) {
        SDLChoiceCell *uploadCell = [self.pendingPreloadChoices member:cell] ?: [self.preloadedChoices member:cell];
        if (uploadCell != nil) {
            cell.choiceId = uploadCell.choiceId;
        }
    }
}

#pragma mark - Keyboard Configuration

- (void)setKeyboardConfiguration:(nullable SDLKeyboardProperties *)keyboardConfiguration {
    if (keyboardConfiguration == nil) {
        SDLLogD(@"Updating keyboard configuration to the default");
        _keyboardConfiguration = [self sdl_defaultKeyboardConfiguration];
    } else {
        SDLLogD(@"Updating keyboard configuration to a new configuration: %@", keyboardConfiguration);
        _keyboardConfiguration = [[SDLKeyboardProperties alloc] initWithLanguage:keyboardConfiguration.language layout:keyboardConfiguration.keyboardLayout keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:keyboardConfiguration.limitedCharacterList autoCompleteText:keyboardConfiguration.autoCompleteText autoCompleteList:keyboardConfiguration.autoCompleteList];

        if (keyboardConfiguration.keypressMode != SDLKeypressModeResendCurrentEntry) {
            SDLLogW(@"Attempted to set a keyboard configuration with an invalid keypress mode; only .resentCurrentEntry is valid. This value will be ignored, the rest of the properties will be set.");
        }
    }
}

- (SDLKeyboardProperties *)sdl_defaultKeyboardConfiguration {
    return [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs layout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteText:nil autoCompleteList:nil];
}

#pragma mark - Getters

- (NSSet<SDLChoiceCell *> *)preloadedChoices {
    return [_preloadedMutableChoices copy];
}

- (NSSet<SDLChoiceCell *> *)pendingPreloadChoices {
    return [_pendingMutablePreloadChoices copy];
}

- (NSString *)currentState {
    return self.stateMachine.currentState;
}

#pragma mark - RPC Responses / Notifications

- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability {
    NSArray<SDLDisplayCapability *> *capabilities = systemCapability.displayCapabilities;
    if (capabilities == nil || capabilities.count == 0) {
        self.currentWindowCapability = nil;
    } else {
        SDLDisplayCapability *mainDisplay = capabilities[0];
        for (SDLWindowCapability *windowCapability in mainDisplay.windowCapabilities) {
            NSUInteger currentWindowID = windowCapability.windowID != nil ? windowCapability.windowID.unsignedIntegerValue : SDLPredefinedWindowsDefaultWindow;
            if (currentWindowID == SDLPredefinedWindowsDefaultWindow) {
                self.currentWindowCapability = windowCapability;
            }
        }
    }

    [self sdl_updateTransactionQueueSuspended];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    // We can only present a choice set if we're in FULL
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    
    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }

    self.currentHMILevel = hmiStatus.hmiLevel;

    [self sdl_updateTransactionQueueSuspended];
}

@end

NS_ASSUME_NONNULL_END
