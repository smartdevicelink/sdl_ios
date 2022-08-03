//
//  SDLMenuManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLMenuManager.h"

#import "SDLAddCommand.h"
#import "SDLAddSubMenu.h"
#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteSubMenu.h"
#import "SDLDisplayCapability.h"
#import "SDLDisplayType.h"
#import "SDLDynamicMenuUpdateRunScore.h"
#import "SDLDynamicMenuUpdateAlgorithm.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLMenuCell.h"
#import "SDLMenuConfiguration.h"
#import "SDLMenuConfigurationUpdateOperation.h"
#import "SDLMenuManagerPrivateConstants.h"
#import "SDLMenuParams.h"
#import "SDLMenuReplaceOperation.h"
#import "SDLMenuShowOperation.h"
#import "SDLOnCommand.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSetGlobalProperties.h"
#import "SDLScreenManager.h"
#import "SDLShowAppMenu.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"
#import "SDLVersion.h"
#import "SDLVoiceCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;
@property (strong, nonatomic, readwrite) NSString *uniqueTitle;

@property (copy, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *icon;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *voiceCommands;
@property (copy, nonatomic, readwrite, nullable) NSString *secondaryText;
@property (copy, nonatomic, readwrite, nullable) NSString *tertiaryText;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *secondaryArtwork;
@property (copy, nonatomic, readwrite, nullable) NSArray<SDLMenuCell *> *subCells;
@property (copy, nonatomic, readwrite, nullable) SDLMenuCellSelectionHandler handler;

@end

@interface SDLMenuManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *currentMenuCells;
@property (strong, nonatomic, nullable) SDLMenuConfiguration *currentMenuConfiguration;

@end

@implementation SDLMenuManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _menuConfiguration = [[SDLMenuConfiguration alloc] init];
    _menuCells = @[];
    _currentMenuCells = @[];
    _dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeOnWithCompatibility;
    _transactionQueue = [self sdl_newTransactionQueue];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_commandNotification:) name:SDLDidReceiveCommandNotification object:nil];

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(nonnull SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;

    return self;
}

- (void)start {
    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate)];
}

- (void)stop {
    _menuCells = @[];
    _currentMenuCells = @[];
    _transactionQueue = [self sdl_newTransactionQueue];

    _currentHMILevel = nil;
    _currentSystemContext = nil;
    _currentMenuConfiguration = nil;
    _windowCapability = nil;
}

#pragma mark Transaction Queue

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SDLMenuManager Transaction Queue";
    queue.maxConcurrentOperationCount = 1;
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    queue.suspended = YES;

    return queue;
}

/// Suspend the queue if the HMI level is NONE since we want to delay sending RPCs until we're in non-NONE
- (void)sdl_updateTransactionQueueSuspended {
    if ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone] || [self.currentSystemContext isEqualToEnum:SDLSystemContextMenu]) {
        SDLLogD(@"Suspending the transaction queue. Current HMI level is NONE: %@, current system context is MENU: %@", ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone] ? @"YES" : @"NO"), ([self.currentSystemContext isEqualToEnum:SDLSystemContextMenu] ? @"YES" : @"NO"));
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}

#pragma mark - Setters

- (void)setMenuConfiguration:(SDLMenuConfiguration *)menuConfiguration {
    if ([menuConfiguration isEqual:self.menuConfiguration]) {
        SDLLogD(@"New menu configuration is equal to existing one, will not set new configuration");
        return;
    } else if ([[SDLGlobals sharedGlobals].rpcVersion isLessThanVersion:[SDLVersion versionWithMajor:6 minor:0 patch:0]]) {
        SDLLogE(@"Setting a menu configuration is not supported on this head unit. Only supported on RPC 6.0+, this version: %@", [SDLGlobals sharedGlobals].rpcVersion);
        return;
    }

    _menuConfiguration = menuConfiguration;

    // Create the operation
    __weak typeof(self) weakself = self;
    SDLMenuConfigurationUpdateOperation *configurationUpdateOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:self.connectionManager windowCapability:self.windowCapability newMenuConfiguration:menuConfiguration configurationUpdatedHandler:^(SDLMenuConfiguration *newMenuConfiguration, NSError *_Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error updating menu configuration: %@", error);
            return;
        } else {
            SDLLogD(@"Successfully updated menu configuration: %@", newMenuConfiguration);
        }

        weakself.currentMenuConfiguration = newMenuConfiguration;
        [weakself sdl_updateMenuReplaceOperationsWithNewMenuConfiguration];
    }];

    // Cancel previous menu configuration operations
    for (NSOperation *operation in self.transactionQueue.operations) {
        if ([operation isMemberOfClass:[SDLMenuConfigurationUpdateOperation class]]) {
            [operation cancel];
        }
    }

    // Add the new menu configuration operation to the queue
    [self.transactionQueue addOperation:configurationUpdateOp];
}

- (void)setMenuCells:(NSArray<SDLMenuCell *> *)menuCells {
    if (![self sdl_menuCellsAreUnique:menuCells allVoiceCommands:[NSMutableArray array]]) {
        SDLLogE(@"Not all set menu cells are unique, but that is required");
        return;
    }

    _menuCells = [[NSArray alloc] initWithArray:menuCells copyItems:YES];

    __weak typeof(self) weakself = self;
    SDLMenuReplaceOperation *menuReplaceOperation = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager windowCapability:self.windowCapability menuConfiguration:self.currentMenuConfiguration currentMenu:self.currentMenuCells updatedMenu:self.menuCells compatibilityModeEnabled:(![self sdl_isDynamicMenuUpdateActive:self.dynamicMenuUpdatesMode]) currentMenuUpdatedHandler:^(NSArray<SDLMenuCell *> * _Nonnull currentMenuCells, NSError *error) {
        weakself.currentMenuCells = currentMenuCells;
        [weakself sdl_updateMenuReplaceOperationsWithNewCurrentMenu];
        SDLLogD(@"Finished updating menu");
    }];

    // Cancel previous replace menu operations
    for (NSOperation *operation in self.transactionQueue.operations) {
        if ([operation isMemberOfClass:[SDLMenuReplaceOperation class]]) {
            [operation cancel];
        }
    }

    [self.transactionQueue addOperation:menuReplaceOperation];
}

#pragma mark - Open Menu

- (BOOL)openMenu:(nullable SDLMenuCell *)cell {
    if (cell != nil && cell.subCells.count == 0) {
        SDLLogE(@"The cell %@ does not contain any sub cells, so no submenu can be opened", cell);
        return NO;
    } else if (cell != nil && ![self.menuCells containsObject:cell]) {
        SDLLogE(@"This cell has not been sent to the head unit, so no submenu can be opened. Make sure that the cell exists in the SDLManager.menu array");
        return NO;
    } else if ([SDLGlobals.sharedGlobals.rpcVersion isLessThanVersion:[[SDLVersion alloc] initWithMajor:6 minor:0 patch:0]]) {
        SDLLogE(@"The openMenu / openSubmenu is not supported on this head unit.");
        return NO;
    }

    // Check if a passed cell is a "re-created" cell without a cellID. If it is, then try to find the equivalent cell and use it instead
    if (cell != nil && cell.cellId == UINT32_MAX) {
        for (SDLMenuCell *headUnitCell in self.menuCells) {
            if ([cell isEqual:headUnitCell]) {
                cell = headUnitCell;
                break;
            }
        }
    }
    
    // Create the operation
    SDLMenuShowOperation *showMenuOp = [[SDLMenuShowOperation alloc] initWithConnectionManager:self.connectionManager toMenuCell:cell completionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Opening menu with error: %@, info: %@. Failed subcell (if nil, attempted to open to main menu): %@", error, error.userInfo, cell);
        }
    }];

    // Cancel previous open menu operations
    for (NSOperation *operation in self.transactionQueue.operations) {
        if ([operation isMemberOfClass:[SDLMenuShowOperation class]]) {
            [operation cancel];
        }
    }

    // Add the new open menu operation to the queue
    [self.transactionQueue addOperation:showMenuOp];

    return YES;
}

#pragma mark - Updating System

- (void)sdl_updateMenuReplaceOperationsWithNewCurrentMenu {
    for (NSOperation *operation in self.transactionQueue.operations) {
        if ([operation isMemberOfClass:[SDLMenuReplaceOperation class]]) {
            SDLMenuReplaceOperation *op = (SDLMenuReplaceOperation *)operation;
            op.currentMenu = self.currentMenuCells;
        }
    }
}

- (void)sdl_updateMenuReplaceOperationsWithNewWindowCapability {
    for (NSOperation *operation in self.transactionQueue.operations) {
        if ([operation isMemberOfClass:[SDLMenuReplaceOperation class]]) {
            SDLMenuReplaceOperation *op = (SDLMenuReplaceOperation *)operation;
            op.windowCapability = self.windowCapability;
        }
    }
}

- (void)sdl_updateMenuReplaceOperationsWithNewMenuConfiguration {
    for (NSOperation *operation in self.transactionQueue.operations) {
        if ([operation isMemberOfClass:[SDLMenuReplaceOperation class]]) {
            SDLMenuReplaceOperation *op = (SDLMenuReplaceOperation *)operation;
            op.menuConfiguration = self.currentMenuConfiguration;
        }
    }
}

#pragma mark - Helpers

/// Determine if the dynamic mode is active based on the set value.
/// @param dynamicMenuUpdatesMode The set dynamic mode
/// @returns YES if dynamic mode is forced on, or is on with compatibility, which only turns it on for Ford's Sync Gen 3 8-inch display type
- (BOOL)sdl_isDynamicMenuUpdateActive:(SDLDynamicMenuUpdatesMode)dynamicMenuUpdatesMode {
    switch (dynamicMenuUpdatesMode) {
        case SDLDynamicMenuUpdatesModeForceOn:
            return YES;
        case SDLDynamicMenuUpdatesModeForceOff:
            return NO;
        case SDLDynamicMenuUpdatesModeOnWithCompatibility:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return ![self.systemCapabilityManager.displays.firstObject.displayName isEqualToString:SDLDisplayTypeGen38Inch];
#pragma clang diagnostic pop
    }
}

/// Check for cell lists with completely duplicate information, or any duplicate voiceCommands
///
/// @param cells The cells you will be adding
/// @return Boolean that indicates whether menuCells are unique or not
- (BOOL)sdl_menuCellsAreUnique:(NSArray<SDLMenuCell *> *)cells allVoiceCommands:(NSMutableArray<NSString *> *)allVoiceCommands {
    ///Check all voice commands for identical items and check each list of cells for identical cells
    NSMutableSet<SDLMenuCell *> *identicalCellsCheckSet = [NSMutableSet set];
    for (SDLMenuCell *cell in cells) {
        [identicalCellsCheckSet addObject:cell];

        // Recursively check the subcell lists to see if they are all unique as well. If anything is not, this will chain back up the list to return false.
        if (cell.subCells.count > 0) {
            BOOL subcellsAreUnique = [self sdl_menuCellsAreUnique:cell.subCells allVoiceCommands:allVoiceCommands];
            if (!subcellsAreUnique) { return NO; }
        }

        // Voice commands have to be identical across all lists
        if (cell.voiceCommands == nil) { continue; }
        [allVoiceCommands addObjectsFromArray:cell.voiceCommands];
    }

    // Check for duplicate cells
    if (identicalCellsCheckSet.count != cells.count) {
        SDLLogE(@"Not all cells are unique. Cells in each list (such as main menu or subcell list) must have some differentiating property other than the subcells within a cell. The menu will not be set.");
        return NO;
    }

    // All the VR commands must be unique
    if (allVoiceCommands.count != [NSSet setWithArray:allVoiceCommands].count) {
        SDLLogE(@"Attempted to create a menu with duplicate voice commands, but voice commands must be unique across all menu items including main menu and subcell lists. The menu will not be set.");
        return NO;
    }

    return YES;
}

#pragma mark - Calling handlers

/// Call a handler for a currently displayed SDLMenuCell based on the incoming SDLOnCommand notification
/// @param cells The menu cells to check (including their subcells)
/// @param onCommand The notification retrieved
/// @returns True if the handler was found, false if it was not found
- (BOOL)sdl_callHandlerForCells:(NSArray<SDLMenuCell *> *)cells command:(SDLOnCommand *)onCommand {
    for (SDLMenuCell *cell in cells) {
        if (cell.cellId == onCommand.cmdID.unsignedIntegerValue && cell.handler != nil) {
            cell.handler(onCommand.triggerSource);
            return YES;
        }

        if (cell.subCells.count > 0) {
            BOOL succeeded = [self sdl_callHandlerForCells:cell.subCells command:onCommand];
            if (succeeded) { return YES; }
        }
    }

    return NO;
}

#pragma mark - Observers

- (void)sdl_commandNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnCommand *onCommand = (SDLOnCommand *)notification.notification;
    [self sdl_callHandlerForCells:self.currentMenuCells command:onCommand];
}

- (void)sdl_displayCapabilityDidUpdate {
    self.windowCapability = self.systemCapabilityManager.defaultMainWindowCapability;
    [self sdl_updateMenuReplaceOperationsWithNewWindowCapability];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    if ((hmiStatus.windowID != nil) && (hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow)) { return; }

    self.currentHMILevel = hmiStatus.hmiLevel;
    self.currentSystemContext = hmiStatus.systemContext;

    [self sdl_updateTransactionQueueSuspended];
}

@end

NS_ASSUME_NONNULL_END
