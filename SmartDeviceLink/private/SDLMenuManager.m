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
#import "SDLMenuParams.h"
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

@end

@interface SDLMenuManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *waitingUpdateMenuCells;
@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;

@property (assign, nonatomic) UInt32 lastMenuId;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *currentMenuCells;

@property (strong, nonatomic, nullable) SDLMenuConfiguration *oldMenuConfiguration;

@end

UInt32 const ParentIdNotFound = UINT32_MAX;
UInt32 const MenuCellIdMin = 1;

@implementation SDLMenuManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _lastMenuId = MenuCellIdMin;
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
    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate:)];
}

- (void)stop {
    _lastMenuId = MenuCellIdMin;
    _menuCells = @[];
    _currentMenuCells = @[];
    _transactionQueue = [self sdl_newTransactionQueue];

    _currentHMILevel = nil;
    _currentSystemContext = SDLSystemContextMain;
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
    if ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        SDLLogD(@"Suspending the transaction queue. Current HMI level is NONE: %@", ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone] ? @"YES" : @"NO"));
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}

#pragma mark - Setters

- (void)setMenuConfiguration:(SDLMenuConfiguration *)menuConfiguration {
    if (menuConfiguration == self.menuConfiguration) {
        SDLLogD(@"New menu configuration is equal to existing one, will not set new configuration");
        return;
    }

    // Keep the old configuration so that we can reset it if necessary
    self.oldMenuConfiguration = self.menuConfiguration;

    // Create the operation
    SDLMenuConfigurationUpdateOperation *configurationUpdateOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:self.connectionManager windowCapability:self.windowCapability newMenuConfiguration:menuConfiguration];

    __weak typeof(self) weakself = self;
    __weak typeof(configurationUpdateOp) weakOp = configurationUpdateOp;
    configurationUpdateOp.completionBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        if (weakOp.error != nil) {
            SDLLogE(@"Error setting new menu configuration with error: %@, info: %@. Will revert to old menu configuration: %@", weakOp.error, weakOp.error.userInfo, weakself.oldMenuConfiguration);
            strongself->_menuConfiguration = strongself.oldMenuConfiguration;
        } else {
            strongself.oldMenuConfiguration = nil;
        }
    };

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
    NSMutableSet *titleCheckSet = [NSMutableSet set];
    NSMutableSet<NSString *> *allMenuVoiceCommands = [NSMutableSet set];
    NSUInteger voiceCommandCount = 0;
    for (SDLMenuCell *cell in menuCells) {
        [titleCheckSet addObject:cell.title];
        if (cell.voiceCommands == nil) { continue; }
        [allMenuVoiceCommands addObjectsFromArray:cell.voiceCommands];
        voiceCommandCount += cell.voiceCommands.count;
    }

    // Check for duplicate titles
    if (titleCheckSet.count != menuCells.count) {
        SDLLogE(@"Not all cell titles are unique. The menu will not be set.");
        return;
    }

    // Check for duplicate voice recognition commands
    if (allMenuVoiceCommands.count != voiceCommandCount) {
        SDLLogE(@"Attempted to create a menu with duplicate voice commands. Voice commands must be unique. The menu will not be set.");
        return;
    }

    _currentMenuCells = _menuCells;
    _menuCells = menuCells;

    if ([self sdl_isDynamicMenuUpdateActive:self.dynamicMenuUpdatesMode]) {
        [self sdl_startDynamicMenuUpdate];
    } else {
        [self sdl_startStaticMenuUpdate];
    }
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
        SDLLogE(@"The openSubmenu method is not supported on this head unit.");
        return NO;
    }

    // Create the operation
    SDLMenuShowOperation *showMenuOp = [[SDLMenuShowOperation alloc] initWithConnectionManager:self.connectionManager toMenuCell:cell];
    __weak typeof(showMenuOp) weakMenuOp = showMenuOp;
    showMenuOp.completionBlock = ^{
        if (weakMenuOp.error != nil) {
            SDLLogE(@"Opening menu with error: %@, info: %@. Failed subcell (if nil, attempted to open to main menu): %@", weakMenuOp.error, weakMenuOp.error.userInfo, cell);
        }
    };

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

#pragma mark - Build Deletes, Keeps, Adds

- (void)sdl_startSubMenuUpdatesWithOldKeptCells:(NSArray<SDLMenuCell *> *)oldKeptCells newKeptCells:(NSArray<SDLMenuCell *> *)newKeptCells atIndex:(NSUInteger)startIndex {
    if (oldKeptCells.count == 0 || startIndex >= oldKeptCells.count) { return; }

    if (oldKeptCells[startIndex].subCells.count > 0) {
        SDLDynamicMenuUpdateRunScore *tempScore = [SDLDynamicMenuUpdateAlgorithm compareOldMenuCells:oldKeptCells[startIndex].subCells updatedMenuCells:newKeptCells[startIndex].subCells];
        NSArray<NSNumber *> *deleteMenuStatus = tempScore.oldStatus;
        NSArray<NSNumber *> *addMenuStatus = tempScore.updatedStatus;

        NSArray<SDLMenuCell *> *cellsToDelete = [self sdl_filterDeleteMenuItemsWithOldMenuItems:oldKeptCells[startIndex].subCells basedOnStatusList:deleteMenuStatus];
        NSArray<SDLMenuCell *> *cellsToAdd = [self sdl_filterAddMenuItemsWithNewMenuItems:newKeptCells[startIndex].subCells basedOnStatusList:addMenuStatus];

        NSArray<SDLMenuCell *> *oldKeeps = [self sdl_filterKeepMenuItemsWithOldMenuItems:oldKeptCells[startIndex].subCells basedOnStatusList:deleteMenuStatus];
        NSArray<SDLMenuCell *> *newKeeps = [self sdl_filterKeepMenuItemsWithNewMenuItems:newKeptCells[startIndex].subCells basedOnStatusList:addMenuStatus];

        [self sdl_updateIdsOnMenuCells:cellsToAdd parentId:newKeptCells[startIndex].cellId];
        [self transferCellIDFromOldCells:oldKeeps toKeptCells:newKeeps];

        __weak typeof(self) weakself = self;
        [self sdl_sendDeleteCurrentMenu:cellsToDelete withCompletionHandler:^(NSError * _Nullable error) {
            [weakself sdl_sendUpdatedMenu:cellsToAdd usingMenu:weakself.menuCells[startIndex].subCells withCompletionHandler:^(NSError * _Nullable error) {
                // After the first set of submenu cells were added and deleted we must find the next set of subcells untll we loop through all the elemetns
                [weakself sdl_startSubMenuUpdatesWithOldKeptCells:oldKeptCells newKeptCells:newKeptCells atIndex:(startIndex + 1)];
            }];
        }];
    } else {
        // After the first set of submenu cells were added and deleted we must find the next set of subcells untll we loop through all the elemetns
        [self sdl_startSubMenuUpdatesWithOldKeptCells:oldKeptCells newKeptCells:newKeptCells atIndex:(startIndex + 1)];
    }
}

#pragma mark - Updating System

- (void)sdl_startDynamicMenuUpdate {

}

- (void)sdl_startStaticMenuUpdate {

}

- (void)sdl_updateMenuWithCellsToDelete:(NSArray<SDLMenuCell *> *)deleteCells cellsToAdd:(NSArray<SDLMenuCell *> *)addCells completionHandler:(nullable SDLMenuUpdateCompletionHandler)completionHandler {
    __weak typeof(self) weakself = self;
    [self sdl_sendDeleteCurrentMenu:deleteCells withCompletionHandler:^(NSError * _Nullable error) {
        [weakself sdl_sendUpdatedMenu:addCells usingMenu:weakself.menuCells withCompletionHandler:^(NSError * _Nullable error) { }];
    }];
}

#pragma mark - Helpers

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

#pragma mark IDs

- (void)sdl_updateIdsOnMenuCells:(NSArray<SDLMenuCell *> *)menuCells parentId:(UInt32)parentId {
    for (SDLMenuCell *cell in menuCells) {
        cell.cellId = self.lastMenuId++;
        cell.parentCellId = parentId;
        if (cell.subCells.count > 0) {
            [self sdl_updateIdsOnMenuCells:cell.subCells parentId:cell.cellId];
        }
    }
}

#pragma mark - Calling handlers

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

    [self sdl_callHandlerForCells:self.menuCells command:onCommand];
}

- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability {
    // We won't use the object in the parameter but the convenience method of the system capability manager
    self.windowCapability = self.systemCapabilityManager.defaultMainWindowCapability;
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;

    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }
    
    SDLHMILevel oldHMILevel = self.currentHMILevel;
    self.currentHMILevel = hmiStatus.hmiLevel;

    // Auto-send an updated menu if we were in NONE and now we are not, and we need an update
    if ([oldHMILevel isEqualToString:SDLHMILevelNone] && ![self.currentHMILevel isEqualToString:SDLHMILevelNone] &&
        ![self.currentSystemContext isEqualToEnum:SDLSystemContextMenu]) {
        if (self.waitingOnHMIUpdate) {
            [self setMenuCells:self.waitingUpdateMenuCells];
            self.waitingUpdateMenuCells = @[];
            return;
        }
    }

    // If we don't check for this and only update when not in the menu, there can be IN_USE errors, especially with submenus. We also don't want to encourage changing out the menu while the user is using it for usability reasons.
    SDLSystemContext oldSystemContext = self.currentSystemContext;
    self.currentSystemContext = hmiStatus.systemContext;

    if ([oldSystemContext isEqualToEnum:SDLSystemContextMenu]
        && ![self.currentSystemContext isEqualToEnum:SDLSystemContextMenu]
        && ![self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        if (self.waitingOnHMIUpdate) {
            [self setMenuCells:self.waitingUpdateMenuCells];
            self.waitingUpdateMenuCells = @[];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
