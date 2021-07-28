//
//  SDLVoiceCommandManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLVoiceCommandManager.h"

#import "SDLAddCommand.h"
#import "SDLConnectionManagerType.h"
#import "SDLDeleteCommand.h"
#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnCommand.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCRequest.h"
#import "SDLVoiceCommand.h"
#import "SDLVoiceCommandUpdateOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;
@property (copy, nonatomic, readwrite) NSArray<NSString *> *voiceCommands;

@end

@interface SDLVoiceCommandManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;

@property (assign, nonatomic) UInt32 lastVoiceCommandId;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *currentVoiceCommands;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *originalVoiceCommands;

@end

UInt32 const VoiceCommandIdMin = 1900000000;

@implementation SDLVoiceCommandManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _lastVoiceCommandId = VoiceCommandIdMin;
    _transactionQueue = [self sdl_newTransactionQueue];
    _voiceCommands = @[];
    _currentVoiceCommands = @[];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_commandNotification:) name:SDLDidReceiveCommandNotification object:nil];

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;

    return self;
}

- (void)stop {
    _lastVoiceCommandId = VoiceCommandIdMin;
    _voiceCommands = @[];
    _currentVoiceCommands = @[];
    _transactionQueue = [self sdl_newTransactionQueue];

    _currentLevel = nil;
}

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SDLVoiceCommandManager Transaction Queue";
    queue.maxConcurrentOperationCount = 1;
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    queue.suspended = YES;

    return queue;
}

/// Suspend the queue if the HMI level is NONE since we want to delay sending RPCs until we're in non-NONE
- (void)sdl_updateTransactionQueueSuspended {
    if ([self.currentLevel isEqualToEnum:SDLHMILevelNone]) {
        SDLLogD(@"Suspending the transaction queue. Current HMI level is NONE: %@", ([self.currentLevel isEqualToEnum:SDLHMILevelNone] ? @"YES" : @"NO"));
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}

#pragma mark - Setters

- (void)setVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    if (voiceCommands == self.originalVoiceCommands) {
        SDLLogD(@"New voice commands are equal to the existing voice commands, skipping...");
        return;
    }

    // Validate the voiceCommand's strings. In the rare case that the user has set only empty whitespace strings, abort the update operation.
    NSArray<SDLVoiceCommand *> *validatedVoiceCommands = [self sdl_removeEmptyVoiceCommands:voiceCommands];
    if (validatedVoiceCommands.count == 0 && voiceCommands.count > 0) {
        SDLLogE(@"New voice commands are invalid, skipping...");
        return;
    }

    // Check if all new voice commands have unique strings
    if (![self.class sdl_arePendingVoiceCommandsUnique:voiceCommands]) {
        SDLLogE(@"Not all voice command strings are unique across all voice commands. Voice commands will not be set.");
        return;
    }

    // Set the new voice commands internally
    _originalVoiceCommands = voiceCommands;
    _voiceCommands = validatedVoiceCommands;
    // Set the ids
    [self sdl_updateIdsOnVoiceCommands:self.voiceCommands];

    // Create the operation, cancel previous ones and set this one
    __weak typeof(self) weakSelf = self;
    SDLVoiceCommandUpdateOperation *updateOperation = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:self.connectionManager pendingVoiceCommands:self.voiceCommands oldVoiceCommands:_currentVoiceCommands updateCompletionHandler:^(NSArray<SDLVoiceCommand *> *newCurrentVoiceCommands, NSError * _Nullable error) {
        weakSelf.currentVoiceCommands = newCurrentVoiceCommands;
        [weakSelf sdl_updatePendingOperationsWithNewCurrentVoiceCommands:newCurrentVoiceCommands];
    }];

    [self.transactionQueue cancelAllOperations];
    [self.transactionQueue addOperation:updateOperation];
}

/// Update currently pending operations with a new set of "current" voice commands (the current state of the head unit) based on a previous completed operation
/// @param currentVoiceCommands The new current voice commands
- (void)sdl_updatePendingOperationsWithNewCurrentVoiceCommands:(NSArray<SDLVoiceCommand *> *)currentVoiceCommands {
    for (NSOperation *operation in self.transactionQueue.operations) {
        if (operation.isExecuting) { continue; }

        SDLVoiceCommandUpdateOperation *updateOp = (SDLVoiceCommandUpdateOperation *)operation;
        updateOp.oldVoiceCommands = currentVoiceCommands;
    }
}

#pragma mark - Helpers
#pragma mark IDs

- (void)sdl_updateIdsOnVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    for (SDLVoiceCommand *voiceCommand in voiceCommands) {
        voiceCommand.commandId = self.lastVoiceCommandId++;
    }
}

/// Remove all voice command strings consisting of just whitespace characters as the module will reject any "empty" strings.
/// @param voiceCommands - array of SDLVoiceCommands that are to be uploaded
/// @return A list of voice commands with the empty voice commands removed
- (NSArray<SDLVoiceCommand *> *)sdl_removeEmptyVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    NSMutableArray<SDLVoiceCommand *> *validatedVoiceCommands = [[NSMutableArray alloc] init];
    for (SDLVoiceCommand *voiceCommand in voiceCommands) {
        NSMutableArray<NSString *> *voiceCommandStrings = [[NSMutableArray alloc] init];
        for (NSString *voiceCommandString in voiceCommand.voiceCommands) {
            NSString *trimmedString = [voiceCommandString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            // Updates voice command strings array by only adding ones that are not empty(e.g. "", " ", ...)
            if (trimmedString.length > 0) {
                [voiceCommandStrings addObject:voiceCommandString];
            }
        }
        if (voiceCommandStrings.count > 0) {
            voiceCommand.voiceCommands = voiceCommandStrings;
            [validatedVoiceCommands addObject:voiceCommand];
        }
    }
    return [validatedVoiceCommands copy];
}

/// Evaluate the pendingVoiceCommands to check if there is two or more voiceCommands with the same string
+ (BOOL)sdl_arePendingVoiceCommandsUnique:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    NSUInteger voiceCommandCount = 0;
    NSMutableSet<NSString *> *voiceCommandsSet = [[NSMutableSet alloc] init];
    for (SDLVoiceCommand *voiceCommand in voiceCommands) {
        [voiceCommandsSet addObjectsFromArray:voiceCommand.voiceCommands];
        voiceCommandCount += voiceCommand.voiceCommands.count;
    }

    return (voiceCommandsSet.count == voiceCommandCount);
}

#pragma mark - Observers

- (void)sdl_commandNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnCommand *onCommand = (SDLOnCommand *)notification.notification;

    for (SDLVoiceCommand *voiceCommand in self.currentVoiceCommands) {
        if (onCommand.cmdID.unsignedIntegerValue != voiceCommand.commandId) { continue; }

        voiceCommand.handler();
        break;
    }
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    if ((hmiStatus.windowID != nil) && (hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow)) { return; }

    self.currentLevel = hmiStatus.hmiLevel;
    [self sdl_updateTransactionQueueSuspended];
}

@end

NS_ASSUME_NONNULL_END
