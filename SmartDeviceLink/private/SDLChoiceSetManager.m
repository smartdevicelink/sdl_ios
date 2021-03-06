//
//  SDLChoiceSetManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLChoiceSetManager.h"

#import "SmartDeviceLink.h"

#import "SDLCheckChoiceVROptionalOperation.h"
#import "SDLDeleteChoicesOperation.h"
#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLPreloadChoicesOperation.h"
#import "SDLPresentChoiceSetOperation.h"
#import "SDLPresentKeyboardOperation.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLStateMachine.h"
#import "SDLVersion.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

SDLChoiceManagerState *const SDLChoiceManagerStateShutdown = @"Shutdown";
SDLChoiceManagerState *const SDLChoiceManagerStateCheckingVoiceOptional = @"CheckingVoiceOptional";
SDLChoiceManagerState *const SDLChoiceManagerStateReady = @"Ready";
SDLChoiceManagerState *const SDLChoiceManagerStateStartupError = @"StartupError";

typedef NSNumber * SDLChoiceId;

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;
@property (strong, nonatomic, readwrite) NSString *uniqueText;
@property (copy, nonatomic, readwrite, nullable) NSString *secondaryText;
@property (copy, nonatomic, readwrite, nullable) NSString *tertiaryText;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *voiceCommands;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *artwork;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *secondaryArtwork;

@end

@interface SDLChoiceSetManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic) dispatch_queue_t readWriteQueue;

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

// Assigns a set range of unique cancel ids in order to prevent overlap with other sub-screen managers that use cancel ids. If the max cancel id is reached, generation starts over from the cancel id min value.
UInt16 const ChoiceCellCancelIdMin = 101;
UInt16 const ChoiceCellCancelIdMax = 200;

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

    _readWriteQueue = dispatch_queue_create_with_target("com.sdl.screenManager.choiceSetManager.readWriteQueue", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);

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
    SDLLogD(@"Starting manager");

    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate)];

    if ([self.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
        [self.stateMachine transitionToState:SDLChoiceManagerStateCheckingVoiceOptional];
    }

    // Else, we're already started
}

- (void)stop {
    SDLLogD(@"Stopping manager");
    
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        [self.stateMachine transitionToState:SDLChoiceManagerStateShutdown];
    }];
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
    queue.qualityOfService = NSQualityOfServiceUserInteractive;
    queue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    queue.suspended = YES;

    return queue;
}

/// Suspend the transaction queue if we are in HMI NONE
/// OR if the text field name "menu name" (i.e. is the primary choice text) cannot be used, we assume we cannot present a PI.
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
    SDLLogV(@"Manager shutting down");

    NSAssert(dispatch_get_specific(SDLProcessingQueueName) != nil, @"%@ must only be called on the SDL serial queue", NSStringFromSelector(_cmd));

    _currentHMILevel = SDLHMILevelNone;

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

    __weak typeof(self) weakSelf = self;
    __weak typeof(checkOp) weakOp = checkOp;
    checkOp.completionBlock = ^{
        if ([self.currentState isEqualToString:SDLChoiceManagerStateShutdown]) { return; }

        weakSelf.vrOptional = weakOp.isVROptional;
        if (weakOp.error != nil) {
            [weakSelf.stateMachine transitionToState:SDLChoiceManagerStateStartupError];
        } else {
            [weakSelf.stateMachine transitionToState:SDLChoiceManagerStateReady];
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

    NSMutableOrderedSet<SDLChoiceCell *> *mutableChoicesToUpload = [self sdl_choicesToBeUploadedWithArray:choices];
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        [mutableChoicesToUpload minusSet:self.preloadedMutableChoices];
        [mutableChoicesToUpload minusSet:self.pendingMutablePreloadChoices];
    }];

    NSOrderedSet<SDLChoiceCell *> *choicesToUpload = [mutableChoicesToUpload copy];
    if (choicesToUpload.count == 0) {
        SDLLogD(@"All choices already preloaded. No need to perform a preload");
        if (handler != nil) {
            handler(nil);
        }

        return;
    }

    [self sdl_updateIdsOnChoices:choicesToUpload];

    // Add the preload cells to the pending preloads
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        [self.pendingMutablePreloadChoices unionSet:choicesToUpload.set];
    }];

    // Upload pending preloads
    // For backward compatibility with Gen38Inch display type head units
    SDLLogD(@"Preloading choices");
    SDLLogV(@"Choices to be uploaded: %@", choicesToUpload);
    NSString *displayName = self.systemCapabilityManager.displays.firstObject.displayName;

    __weak typeof(self) weakSelf = self;
    SDLPreloadChoicesOperation *preloadOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager displayName:displayName windowCapability:self.systemCapabilityManager.defaultMainWindowCapability isVROptional:self.isVROptional cellsToPreload:choicesToUpload updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        // Find the `SDLChoiceCell`s that failed to upload using the `choiceId`s
        NSMutableSet<SDLChoiceCell *> *failedChoiceUploadSet = [NSMutableSet set];
        for (NSNumber *failedChoiceUploadID in failedChoiceUploadIDs) {
            NSUInteger failedChoiceUploadIndex = [choicesToUpload indexOfObjectPassingTest:^BOOL(SDLChoiceCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return obj.choiceId == failedChoiceUploadID.intValue;
            }];
            if (failedChoiceUploadIndex == NSNotFound) { continue; }
            [failedChoiceUploadSet addObject:choicesToUpload[failedChoiceUploadIndex]];
        }

        // Check if the manager has shutdown because the list of uploaded and pending choices should not be updated
        if ([strongSelf.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
            SDLLogD(@"Cancelling preloading choices because the manager is shut down");
            return;
        }

        // Update the list of `preloadedMutableChoices` and `pendingMutablePreloadChoices` with the successful choice uploads
        [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (failedChoiceUploadSet.count == 0) {
                [strongSelf.preloadedMutableChoices unionSet:choicesToUpload.set];
                [strongSelf.pendingMutablePreloadChoices minusSet:choicesToUpload.set];
            } else {
                // If some choices failed, remove the failed choices from the successful ones, then update the preloaded choices and pending choices
                NSMutableSet<SDLChoiceCell *> *successfulChoiceUploads = [NSMutableSet setWithSet:choicesToUpload.set];
                [successfulChoiceUploads minusSet:failedChoiceUploadSet];

                [strongSelf.preloadedMutableChoices unionSet:successfulChoiceUploads];
                [strongSelf.pendingMutablePreloadChoices minusSet:choicesToUpload.set];
            }
        }];
    }];

    __weak typeof(preloadOp) weakPreloadOp = preloadOp;
    preloadOp.completionBlock = ^{
        SDLLogD(@"Choices finished preloading");

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
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        [self.pendingMutablePreloadChoices minusSet:cellsToBeRemovedFromPending];
    }];

    for (SDLAsynchronousOperation *op in self.transactionQueue.operations) {
        if (![op isMemberOfClass:[SDLPreloadChoicesOperation class]]) { continue; }

        SDLPreloadChoicesOperation *preloadOp = (SDLPreloadChoicesOperation *)op;
        [preloadOp removeChoicesFromUpload:cellsToBeRemovedFromPending];
    }

    // Find choices to delete
    if (cellsToBeDeleted.count == 0) { return; }

    [self sdl_findIdsOnChoices:cellsToBeDeleted];
    SDLDeleteChoicesOperation *deleteOp = [[SDLDeleteChoicesOperation alloc] initWithConnectionManager:self.connectionManager cellsToDelete:cellsToBeDeleted];

    __weak typeof(self) weakSelf = self;
    __weak typeof(deleteOp) weakOp = deleteOp;
    deleteOp.completionBlock = ^{
        SDLLogD(@"Finished deleting choices");

        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (weakOp.error != nil) {
            SDLLogE(@"Failed to delete choices: %@", weakOp.error);
            return;
        }

        // Check if the manager has shutdown because the list of uploaded choices should not be updated
        if ([strongSelf.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
            SDLLogD(@"Cancelling deleting choices because manager is shut down");
            return;
        }

        [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.preloadedMutableChoices minusSet:cellsToBeDeleted];
        }];
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

    if (self.pendingPresentationSet != nil && !self.pendingPresentOperation.isFinished) {
        SDLLogW(@"A choice set is pending: %@. We will try to cancel it in favor of presenting a different choice set: %@. If it's already on screen it cannot be cancelled", self.pendingPresentationSet, choiceSet);
        [self.pendingPresentOperation cancel];
    }

    SDLLogD(@"Preloading and presenting choice set: %@", choiceSet);
    self.pendingPresentationSet = choiceSet;

    __weak typeof(self) weakSelf = self;
    [self preloadChoices:self.pendingPresentationSet.choices withCompletionHandler:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error != nil) {
            SDLLogE(@"Error preloading choice cells for choice set presentation; aborting. Error: %@", error);
            [choiceSet.delegate choiceSet:choiceSet didReceiveError:error];
            return;
        }

        if ([strongSelf.currentState isEqualToString:SDLChoiceManagerStateShutdown]) {
            SDLLogD(@"Cancelling presenting choices because the manager has shut down");
            strongSelf.pendingPresentOperation = nil;
            strongSelf.pendingPresentationSet = nil;
            return;
        }

        // The cells necessary for this presentation are now preloaded, so we will enqueue a presentation 
        [strongSelf sdl_presentChoiceSetWithMode:mode keyboardDelegate:delegate];
    }];
}

/// Helper method for presenting a choice set.
/// @param mode If the set should be presented for the user to interact via voice, touch, or both
/// @param delegate The keyboard delegate called when the user interacts with the search field of the choice set, if not set, a non-searchable choice set will be used
- (void)sdl_presentChoiceSetWithMode:(SDLInteractionMode)mode keyboardDelegate:(nullable id<SDLKeyboardDelegate>)delegate {
    [self sdl_findIdsOnChoiceSet:self.pendingPresentationSet];

    SDLPresentChoiceSetOperation *presentOp = nil;
    if (delegate == nil) {
        // Non-searchable choice set
        presentOp = [[SDLPresentChoiceSetOperation alloc] initWithConnectionManager:self.connectionManager choiceSet:self.pendingPresentationSet mode:mode keyboardProperties:nil keyboardDelegate:nil cancelID:self.nextCancelId windowCapability:self.currentWindowCapability];
    } else {
        // Searchable choice set
        presentOp = [[SDLPresentChoiceSetOperation alloc] initWithConnectionManager:self.connectionManager choiceSet:self.pendingPresentationSet mode:mode keyboardProperties:self.keyboardConfiguration keyboardDelegate:delegate cancelID:self.nextCancelId windowCapability:self.currentWindowCapability];
    }
    self.pendingPresentOperation = presentOp;

    __weak typeof(self) weakSelf = self;
    __weak typeof(presentOp) weakOp = presentOp;
    self.pendingPresentOperation.completionBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakOp) strongOp = weakOp;

        SDLLogD(@"Finished presenting choice set: %@", strongOp.choiceSet);
        if (strongOp.error != nil && strongOp.choiceSet.delegate != nil) {
            [strongOp.choiceSet.delegate choiceSet:strongOp.choiceSet didReceiveError:strongOp.error];
        } else if (strongOp.selectedCell != nil && strongOp.choiceSet.delegate != nil) {
            [strongOp.choiceSet.delegate choiceSet:strongOp.choiceSet didSelectChoice:strongOp.selectedCell withSource:strongOp.selectedTriggerSource atRowIndex:strongOp.selectedCellRow];
        }

        strongSelf.pendingPresentOperation = nil;
        strongSelf.pendingPresentationSet = nil;
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
    UInt16 keyboardCancelId = self.nextCancelId;
    self.pendingPresentOperation = [[SDLPresentKeyboardOperation alloc] initWithConnectionManager:self.connectionManager keyboardProperties:self.keyboardConfiguration initialText:initialText keyboardDelegate:delegate cancelID:keyboardCancelId windowCapability:self.currentWindowCapability];
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

/// Checks the passed list of choices to be uploaded and returns the items that have not yet been uploaded to the module.
/// @param choices The choices to be uploaded
/// @return The choices that have not yet been uploaded to the module
- (NSMutableOrderedSet<SDLChoiceCell *> *)sdl_choicesToBeUploadedWithArray:(NSArray<SDLChoiceCell *> *)choices {
    NSMutableOrderedSet<SDLChoiceCell *> *choicesCopy = [[NSMutableOrderedSet alloc] initWithArray:choices copyItems:YES];

    SDLVersion *choiceUniquenessSupportedVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    if ([[SDLGlobals sharedGlobals].rpcVersion isLessThanVersion:choiceUniquenessSupportedVersion]) {
        // If we're on < RPC 7.1, all primary texts need to be unique, so we don't need to check removed properties and duplicate cells
        [self sdl_addUniqueNamesToCells:choicesCopy];
    } else {
        // On > RPC 7.1, at this point all cells are unique when considering all properties, but we also need to check if any cells will _appear_ as duplicates when displayed on the screen. To check that, we'll remove properties from the set cells based on the system capabilities (we probably don't need to consider them changing between now and when they're actually sent to the HU) and check for uniqueness again. Then we'll add unique identifiers to primary text if there are duplicates. Then we transfer the primary text identifiers back to the main cells and add those to an operation to be sent.
        NSMutableOrderedSet<SDLChoiceCell *> *strippedCellsCopy = [self sdl_removeUnusedProperties:choicesCopy];
        [self sdl_addUniqueNamesBasedOnStrippedCells:strippedCellsCopy toUnstrippedCells:choicesCopy];
    }
    [choicesCopy minusSet:self.preloadedChoices];

    return choicesCopy;
}

- (NSMutableOrderedSet<SDLChoiceCell *> *)sdl_removeUnusedProperties:(NSMutableOrderedSet<SDLChoiceCell *> *)choiceCells {
    NSMutableOrderedSet<SDLChoiceCell *> *strippedCellsCopy = [[NSMutableOrderedSet alloc] initWithOrderedSet:choiceCells copyItems:YES];
    for (SDLChoiceCell *cell in strippedCellsCopy) {
        // Strip away fields that cannot be used to determine uniqueness visually including fields not supported by the HMI
        cell.voiceCommands = nil;

        // Don't check SDLImageFieldNameSubMenuIcon because it was added in 7.0 when the feature was added in 5.0. Just assume that if CommandIcon is not available, the submenu icon is not either.
        if (![self.currentWindowCapability hasImageFieldOfName:SDLImageFieldNameChoiceImage]) {
            cell.artwork = nil;
        }
        if (![self.currentWindowCapability hasTextFieldOfName:SDLTextFieldNameSecondaryText]) {
            cell.secondaryText = nil;
        }
        if (![self.currentWindowCapability hasTextFieldOfName:SDLTextFieldNameTertiaryText]) {
            cell.tertiaryText = nil;
        }
        if (![self.currentWindowCapability hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage]) {
            cell.secondaryArtwork = nil;
        }
    }

    return strippedCellsCopy;
}

- (void)sdl_addUniqueNamesBasedOnStrippedCells:(NSMutableOrderedSet<SDLChoiceCell *> *)strippedCells toUnstrippedCells:(NSMutableOrderedSet<SDLChoiceCell *> *)unstrippedCells {
    NSParameterAssert(strippedCells.count == unstrippedCells.count);
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<SDLChoiceCell *, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];
    for (NSUInteger i = 0; i < strippedCells.count; i++) {
        SDLChoiceCell *cell = strippedCells[i];
        NSNumber *counter = dictCounter[cell];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cell] = counter;
        } else {
            dictCounter[cell] = @1;
        }

        counter = dictCounter[cell];
        if (counter.intValue > 1) {
            unstrippedCells[i].uniqueText = [NSString stringWithFormat: @"%@ (%d)", unstrippedCells[i].text, counter.intValue];
        }
    }
}

/// Checks if 2 or more cells have the same text/title. In case this condition is true, this function will handle the presented issue by adding "(count)".
/// E.g. Choices param contains 2 cells with text/title "Address" will be handled by updating the uniqueText/uniqueTitle of the second cell to "Address (2)".
/// @param choices The choices to be uploaded.
- (void)sdl_addUniqueNamesToCells:(NSOrderedSet<SDLChoiceCell *> *)choices {
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<NSString *, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];
    for (SDLChoiceCell *cell in choices) {
        NSString *cellName = cell.text;
        NSNumber *counter = dictCounter[cellName];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cellName] = counter;
        } else {
            dictCounter[cellName] = @1;
        }
        if (counter.intValue > 1) {
            cell.uniqueText = [NSString stringWithFormat: @"%@ (%d)", cell.text, counter.intValue];
        }
    }
}

/// Checks the passed list of choices to be deleted and returns the items that have been uploaded to the module.
/// @param choices The choices to be deleted
/// @return The choices that have been uploaded to the module
- (NSSet<SDLChoiceCell *> *)sdl_choicesToBeDeletedWithArray:(NSArray<SDLChoiceCell *> *)choices {
    NSMutableSet<SDLChoiceCell *> *choicesSet = [NSMutableSet setWithArray:choices];
    [choicesSet intersectSet:self.preloadedChoices];

    return [choicesSet copy];
}

/// Checks the passed list of choices to be deleted and returns the items that are waiting to be uploaded to the module.
/// @param choices The choices to be deleted
/// @return The choices that are waiting to be uploaded to the module
- (NSSet<SDLChoiceCell *> *)sdl_choicesToBeRemovedFromPendingWithArray:(NSArray<SDLChoiceCell *> *)choices {
    NSMutableSet<SDLChoiceCell *> *choicesSet = [NSMutableSet setWithArray:choices];
    [choicesSet intersectSet:self.pendingPreloadChoices];

    return [choicesSet copy];
}

/// Assigns a unique id to each choice item.
/// @param choices An array of choices
- (void)sdl_updateIdsOnChoices:(NSOrderedSet<SDLChoiceCell *> *)choices {
    for (SDLChoiceCell *cell in choices) {
        cell.choiceId = self.nextChoiceId;
    }
}

/// Checks each choice item to find out if it has already been uploaded or if it is the the process of being uploaded. If so, the choice item is assigned the unique id of the uploaded item.
/// @param choiceSet A set of choice items
- (void)sdl_findIdsOnChoiceSet:(SDLChoiceSet *)choiceSet {
    [self sdl_findIdsOnChoices:[NSSet setWithArray:choiceSet.choices]];
}

/// Checks each choice item to find out if it has already been uploaded or if it is the the process of being uploaded. If so, the choice item is assigned the unique id of the uploaded item.
/// @param choices An array of choice items
- (void)sdl_findIdsOnChoices:(NSSet<SDLChoiceCell *> *)choices {
    for (SDLChoiceCell *cell in choices) {
        SDLChoiceCell *uploadCell = [self.pendingPreloadChoices member:cell] ?: [self.preloadedChoices member:cell];
        if (uploadCell == nil) { continue; }
        cell.choiceId = uploadCell.choiceId;
    }
}

#pragma mark - Keyboard Configuration

- (void)setKeyboardConfiguration:(nullable SDLKeyboardProperties *)keyboardConfiguration {
    if (keyboardConfiguration == nil) {
        SDLLogD(@"Updating keyboard configuration to the default");
        _keyboardConfiguration = [self sdl_defaultKeyboardConfiguration];
    } else {
        SDLLogD(@"Updating keyboard configuration to a new configuration: %@", keyboardConfiguration);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _keyboardConfiguration = [[SDLKeyboardProperties alloc] initWithLanguage:keyboardConfiguration.language layout:keyboardConfiguration.keyboardLayout keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:keyboardConfiguration.limitedCharacterList autoCompleteText:keyboardConfiguration.autoCompleteText autoCompleteList:keyboardConfiguration.autoCompleteList];
#pragma clang diagnostic pop

        if (keyboardConfiguration.keypressMode != SDLKeypressModeResendCurrentEntry) {
            SDLLogW(@"Attempted to set a keyboard configuration with an invalid keypress mode; only .resentCurrentEntry is valid. This value will be ignored, the rest of the properties will be set.");
        }
    }
}

- (SDLKeyboardProperties *)sdl_defaultKeyboardConfiguration {
    return [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs keyboardLayout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteList:nil maskInputCharacters:nil customKeys:nil];
}

#pragma mark - Getters

- (NSSet<SDLChoiceCell *> *)preloadedChoices {
    __block NSSet<SDLChoiceCell *> *set = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        set = [self->_preloadedMutableChoices copy];
    }];

    return set;
}

- (NSSet<SDLChoiceCell *> *)pendingPreloadChoices {
    __block NSSet<SDLChoiceCell *> *set = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        set = [self->_pendingMutablePreloadChoices copy];
    }];

    return set;
}

- (UInt16)nextChoiceId {
    __block UInt16 choiceId = 0;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        choiceId = self->_nextChoiceId;
        self->_nextChoiceId = choiceId + 1;
    }];

    return choiceId;
}

- (UInt16)nextCancelId {
    __block UInt16 cancelId = 0;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        cancelId = self->_nextCancelId;
        if (cancelId >= ChoiceCellCancelIdMax) {
            self->_nextCancelId = ChoiceCellCancelIdMin;
        } else {
            self->_nextCancelId = cancelId + 1;
        }
    }];

    return cancelId;
}

- (NSString *)currentState {
    return self.stateMachine.currentState;
}

#pragma mark - RPC Responses / Notifications

- (void)sdl_displayCapabilityDidUpdate {
    self.currentWindowCapability = self.systemCapabilityManager.defaultMainWindowCapability;
    [self sdl_updateTransactionQueueSuspended];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    // We can only present a choice set if we're in FULL
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) { return; }

    self.currentHMILevel = hmiStatus.hmiLevel;

    [self sdl_updateTransactionQueueSuspended];
}

@end

NS_ASSUME_NONNULL_END
