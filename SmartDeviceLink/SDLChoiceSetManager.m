//
//  SDLChoiceSetManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLChoiceSetManager.h"

#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLConnectionManagerType.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDeleteChoicesOperation.h"
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLStateMachine.h"
#import "SDLSystemContext.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLChoiceManagerState;
SDLChoiceManagerState *const SDLChoiceManagerStateShutdown = @"Shutdown";
SDLChoiceManagerState *const SDLChoiceManagerStateCheckingVoiceOptional = @"CheckingVoiceOptional";
SDLChoiceManagerState *const SDLChoiceManagerStateReady = @"Ready";
//SDLChoiceManagerState *const SDLChoiceManagerStatePreloading = @"Preloading";
//SDLChoiceManagerState *const SDLChoiceManagerStateDeleting = @"Deleting";
//SDLChoiceManagerState *const SDLChoiceManagerStatePresenting = @"Presenting";
SDLChoiceManagerState *const SDLChoiceManagerStateStartupError = @"StartupError";

typedef NSNumber * SDLChoiceId;

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLChoiceSetManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *preloadedMutableChoices;
@property (strong, nonatomic, readonly) NSSet<SDLChoiceCell *> *pendingPreloadChoices;
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *pendingMutablePreloadChoices;
@property (strong, nonatomic, nullable) SDLChoiceSet *pendingPresentationSet;

@property (assign, nonatomic, readonly) NSUInteger nextChoiceId;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

@end

UInt16 const ChoiceCellIdMin = 1;

@implementation SDLChoiceSetManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLChoiceManagerStateShutdown states:[self.class sdl_stateTransitionDictionary]];
    _transactionQueue = [[NSOperationQueue alloc] init];
    _transactionQueue.name = @"SDLFileManager Transaction Queue";
    _transactionQueue.maxConcurrentOperationCount = 1;

    _preloadedMutableChoices = [NSMutableSet set];
    _pendingMutablePreloadChoices = [NSMutableSet set];

    _nextChoiceId = ChoiceCellIdMin;
    _vrOptional = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)start {
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

#pragma mark - State Management

- (void)didEnterStateShutdown {
    _currentHMILevel = nil;
    _currentSystemContext = nil;
    _displayCapabilities = nil;

    [self.transactionQueue cancelAllOperations];
    _preloadedMutableChoices = [NSMutableSet set];
    _pendingMutablePreloadChoices = [NSMutableSet set];
    _pendingPresentationSet = nil;

    _vrOptional = YES;
    _nextChoiceId = ChoiceCellIdMin;
}

- (void)didEnterStateCheckingVoiceOptional {
    // Setup by sending a Choice Set without VR, seeing if there's an error. If there is, send one with VR. This choice set will be used for `presentKeyboard` interactions.
    [self.connectionManager sendConnectionRequest:[self.class sdl_testCellWithVR:NO] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            SDLLogD(@"Connected head unit supports choice cells without voice commands. Cells without voice will be sent without voice from now on (no placeholder voice).");

            self.vrOptional = YES;
            [self.stateMachine transitionToState:SDLChoiceManagerStateReady];

            return;
        }

        // Check for choice sets with VR
        [self.connectionManager sendConnectionRequest:[self.class sdl_testCellWithVR:YES] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                SDLLogW(@"Connected head unit does not support choice cells without voice commands. Cells without voice will be sent with placeholder voices from now on.");

                self.vrOptional = NO;
                [self.stateMachine transitionToState:SDLChoiceManagerStateReady];

                return;
            }

            SDLLogE(@"Connected head unit has rejected all choice cells, choice manager disabled. Error: %@, Response: %@", error, response);
            [self.stateMachine transitionToState:SDLChoiceManagerStateShutdown];
        }];
    }];
}

#pragma mark - Choice Management

#pragma mark Upload / Delete

- (void)preloadChoices:(NSArray<SDLChoiceCell *> *)choices withCompletionHandler:(nullable SDLPreloadChoiceCompletionHandler)handler {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }
    NSSet<SDLChoiceCell *> *choicesToUpload = [self sdl_choicesToBeUploadedWithArray:choices];

    // Add the preload cells to the pending preloads
    [self.pendingMutablePreloadChoices unionSet:choicesToUpload];

    // TODO: Upload pending preloads
}

- (void)deleteChoices:(NSArray<SDLChoiceCell *> *)choices {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }

    // Find cells to be deleted that are already uploaded or are pending upload
    NSSet<SDLChoiceCell *> *cellsToBeDeleted = [self sdl_choicesToBeDeletedWithArray:choices];
    NSSet<SDLChoiceCell *> *cellsToBeRemovedFromPending = [self sdl_choicesToBeRemovedFromPendingWithArray:choices];

    // If choices are deleted that are already uploaded or pending and are used by a pending presentation, cancel it and send an error
    NSSet<SDLChoiceCell *> *pendingPresentationSet = [NSSet setWithArray:self.pendingPresentationSet.choices];
    if ([cellsToBeDeleted intersectsSet:pendingPresentationSet] || [cellsToBeRemovedFromPending intersectsSet:pendingPresentationSet]) {
        if (self.pendingPresentationSet.delegate != nil) {
            [self.pendingPresentationSet.delegate choiceSet:self.pendingPresentationSet didReceiveError:[NSError sdl_choiceSetManager_choicesDeletedBeforePresentation:@{@"deletedChoices": choices}]];
        }

        self.pendingPresentationSet = nil;
    }

    // Remove the cells from pending and delete choices
    // TODO: Delete artworks
    [self.pendingMutablePreloadChoices minusSet:cellsToBeRemovedFromPending];
    SDLDeleteChoicesOperation *deleteOperation = [[SDLDeleteChoicesOperation alloc] initWithConnectionManager:self.connectionManager cellsToDelete:cellsToBeDeleted completionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Failed to delete choices: %@", error);
        }
    }];
    [self.transactionQueue addOperation:deleteOperation];
}

#pragma mark Present

- (void)presentChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }

    if (self.pendingPresentationSet != nil) {
        // TODO: Cancel
    }
    self.pendingPresentationSet = choiceSet;
    // TODO: Check which, if any, choices need to be uploaded to the head unit, and preload them
}

- (void)presentSearchableChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(id<SDLKeyboardDelegate>)delegate {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }

    if (self.pendingPresentationSet != nil) {
        // TODO: Cancel
    }
    self.pendingPresentationSet = choiceSet;
    // TODO: Check which, if any, choices need to be uploaded to the head unit, and preload them
}

- (void)presentKeyboardWithInitialText:(NSString *)initialText delegate:(id<SDLKeyboardDelegate>)delegate {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }

    // Present a keyboard with the choice set that we tested option VRs with
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] init];
    performInteraction.initialText = initialText;
    performInteraction.interactionMode = SDLInteractionModeManualOnly;
    performInteraction.interactionChoiceSetIDList = @[@0];
    performInteraction.interactionLayout = SDLLayoutModeKeyboard;

    // TODO: Present
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

+ (SDLCreateInteractionChoiceSet *)sdl_testCellWithVR:(BOOL)hasVR {
    SDLChoice *choice = [[SDLChoice alloc] init];
    choice.choiceID = @0;
    choice.menuName = @"Test Cell";
    choice.vrCommands = hasVR ? @[@"Test VR"] : nil;

    SDLCreateInteractionChoiceSet *choiceSet = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[choice]];

    return choiceSet;
}

#pragma mark - RPC Responses / Notifications

- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    // We can only present a choice set if we're in FULL
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    SDLHMILevel oldHMILevel = self.currentHMILevel;
    self.currentHMILevel = hmiStatus.hmiLevel;

    // We need to check for this to make sure we can currently present the dialog. If the current context is HMI_OBSCURED or ALERT, we have to wait for MAIN to present
    SDLSystemContext oldSystemContext = self.currentSystemContext;
    self.currentSystemContext = hmiStatus.systemContext;
}

@end

NS_ASSUME_NONNULL_END
