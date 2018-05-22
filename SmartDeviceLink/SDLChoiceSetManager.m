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
#import "SDLConnectionManagerType.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLPerformInteraction.h"
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
SDLChoiceManagerState *const SDLChoiceManagerStateStartupError = @"StartupError";

@interface SDLChoiceSetManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (strong, nonatomic, readonly) NSSet<SDLChoiceCell *> *preloadedCells;
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *preloadedMutableCells;
@property (strong, nonatomic, readonly) NSSet<SDLChoiceCell *> *pendingPreloadCells;
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *pendingMutablePreloadCells;
@property (strong, nonatomic) SDLChoiceSet *pendingPresentationSet;

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

    _preloadedMutableCells = [NSMutableSet set];
    _pendingMutablePreloadCells = [NSMutableSet set];

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

    _preloadedMutableCells = [NSMutableSet set];
    _pendingMutablePreloadCells = [NSMutableSet set];
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
    NSSet<SDLChoiceCell *> *choicesToUpload = [self sdl_choicesToBeUploadedFromChoiceArray:choices];

    // Add the preload cells to the pending updates (this will automatically remove any in the process of being uploaded)
    [self.pendingMutablePreloadCells unionSet:choicesToUpload];
}

- (void)deleteChoices:(NSArray<SDLChoiceCell *> *)choices andAttachedImages:(BOOL)deleteImages {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }
    // Find these choices in either the already uploaded set or pending queue set
    // TODO: If choices are deleted from a pending queue,
}

#pragma mark Present

- (void)presentChoiceSet:(SDLChoiceSet *)set mode:(SDLInteractionMode)mode {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }
    // Check which, if any, choices need to be uploaded to the head unit
}

- (void)presentSearchableChoiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode withKeyboardDelegate:(id<SDLKeyboardDelegate>)delegate {
    if (![self.currentState isEqualToString:SDLChoiceManagerStateReady]) { return; }
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

#pragma mark - Helpers

- (NSSet<SDLChoiceCell *> *)sdl_choicesToBeUploadedFromChoiceArray:(NSArray<SDLChoiceCell *> *)choices {
    // Check if any of the choices already exist on the head unit and remove them from being preloaded
    NSMutableSet<SDLChoiceCell *> *choicesToUpload = [NSMutableSet set];
    [choices enumerateObjectsUsingBlock:^(SDLChoiceCell * _Nonnull choice, NSUInteger i, BOOL * _Nonnull stop) {
        if (![self.preloadedCells containsObject:choice]) {
            [choicesToUpload addObject:choice];
        }
    }];

    return [choicesToUpload copy];
}

#pragma mark - Getters

- (NSSet<SDLChoiceCell *> *)preloadedCells {
    return [_preloadedMutableCells copy];
}

- (NSSet<SDLChoiceCell *> *)pendingPreloadCells {
    return [_pendingMutablePreloadCells copy];
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
