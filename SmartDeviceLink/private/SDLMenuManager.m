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
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLMenuCell.h"
#import "SDLMenuConfiguration.h"
#import "SDLMenuParams.h"
#import "SDLDynamicMenuUpdateRunScore.h"
#import "SDLDynamicMenuUpdateAlgorithm.h"
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

@end

@interface SDLMenuManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;

@property (strong, nonatomic, nullable) NSArray<SDLRPCRequest *> *inProgressUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (assign, nonatomic) BOOL waitingOnHMIUpdate;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *waitingUpdateMenuCells;
@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;

@property (assign, nonatomic) UInt32 lastMenuId;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *oldMenuCells;

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
    _oldMenuCells = @[];
    _dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeOnWithCompatibility;

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
    _lastMenuId = MenuCellIdMin;
    _menuCells = @[];
    _oldMenuCells = @[];

    _currentHMILevel = nil;
    _currentSystemContext = SDLSystemContextMain;
    _inProgressUpdate = nil;
    _hasQueuedUpdate = NO;
    _waitingOnHMIUpdate = NO;
    _waitingUpdateMenuCells = @[];
}

#pragma mark - Setters

- (void)setMenuConfiguration:(SDLMenuConfiguration *)menuConfiguration {
    NSArray<SDLMenuLayout> *layoutsAvailable = self.windowCapability.menuLayoutsAvailable;

    if ([[SDLGlobals sharedGlobals].rpcVersion isLessThanVersion:[SDLVersion versionWithMajor:6 minor:0 patch:0]]) {
        SDLLogW(@"Menu configurations is only supported on head units with RPC spec version 6.0.0 or later. Currently connected head unit RPC spec version is %@", [SDLGlobals sharedGlobals].rpcVersion);
        return;
    } else if (layoutsAvailable == nil) {
        SDLLogW(@"Could not set the main menu configuration. Which menu layouts can be used is not available");
        return;
    } else if (![layoutsAvailable containsObject:menuConfiguration.mainMenuLayout]
              || ![layoutsAvailable containsObject:menuConfiguration.defaultSubmenuLayout]) {
        SDLLogE(@"One or more of the set menu layouts are not available on this system. The menu configuration will not be set. Available menu layouts: %@, set menu layouts: %@", layoutsAvailable, menuConfiguration);
        return;
    } else if (self.currentHMILevel == nil
        || [self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        SDLLogE(@"Could not set main menu configuration, HMI level: %@, required: 'Not-NONE', system context: %@, required: 'Not MENU'", self.currentHMILevel, self.currentSystemContext);
        return;
    }

    SDLMenuConfiguration *oldConfig = _menuConfiguration;
    _menuConfiguration = menuConfiguration;

    SDLSetGlobalProperties *setGlobalsRPC = [[SDLSetGlobalProperties alloc] init];
    setGlobalsRPC.menuLayout = menuConfiguration.mainMenuLayout;

    __weak typeof(self) weakself = self;
    [self.connectionManager sendConnectionRequest:setGlobalsRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakself) strongself = weakself;
        if (error != nil) {
            SDLLogE(@"Could not set main menu configuration: %@", error);
            strongself.menuConfiguration = oldConfig;
            return;
        }
    }];
}

- (void)setMenuCells:(NSArray<SDLMenuCell *> *)menuCells {
    // Check for cell lists with completely duplicate information, or any duplicate voiceCommands and return if it fails (logs are in the called method).
    if (![self sdl_menuCellsAreUnique:menuCells allVoiceCommands:[NSMutableArray array]]) { return; }

    if (self.currentHMILevel == nil
        || [self.currentHMILevel isEqualToEnum:SDLHMILevelNone]
        || [self.currentSystemContext isEqualToEnum:SDLSystemContextMenu]) {
        SDLLogD(@"Waiting for HMI update to send menu cells");
        self.waitingOnHMIUpdate = YES;
        self.waitingUpdateMenuCells = menuCells;
        return;
    }

    self.waitingOnHMIUpdate = NO;

    // If connected over RPC < 7.1, append unique identifiers to cell titles that are duplicates even if other properties are identical
    SDLVersion *menuUniquenessSupportedVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    if ([[SDLGlobals sharedGlobals].rpcVersion isLessThanVersion:menuUniquenessSupportedVersion]) {
        [self sdl_addUniqueNamesToCells:menuCells];
    }

    _oldMenuCells = _menuCells;
    _menuCells = menuCells;

    if ([self sdl_isDynamicMenuUpdateActive:self.dynamicMenuUpdatesMode]) {
        [self sdl_startDynamicMenuUpdate];
    } else {
        [self sdl_startNonDynamicMenuUpdate];
    }
}

#pragma mark - Open Menu

- (BOOL)openMenu {
    if ([SDLGlobals.sharedGlobals.rpcVersion isLessThanVersion:[[SDLVersion alloc] initWithMajor:6 minor:0 patch:0]]) {
        SDLLogE(@"The openMenu method is not supported on this head unit.");
        return NO;
    }

    SDLShowAppMenu *openMenu = [[SDLShowAppMenu alloc] init];
    [self.connectionManager sendConnectionRequest:openMenu withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if ([response.resultCode isEqualToEnum:SDLResultWarnings]) {
            SDLLogW(@"Warning opening application menu: %@", error);
        } else if (![response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogE(@"Error opening application menu: %@", error);
        } else {
            SDLLogD(@"Successfully opened application main menu");
        }
    }];

    return YES;
}

- (BOOL)openSubmenu:(SDLMenuCell *)cell {
    if (cell.subCells.count == 0) {
        SDLLogE(@"The cell %@ does not contain any sub cells, so no submenu can be opened", cell);
        return NO;
    } else if ([SDLGlobals.sharedGlobals.rpcVersion isLessThanVersion:[[SDLVersion alloc] initWithMajor:6 minor:0 patch:0]]) {
        SDLLogE(@"The openSubmenu method is not supported on this head unit.");
        return NO;
    } else if (![self.menuCells containsObject:cell]) {
        SDLLogE(@"This cell has not been sent to the head unit, so no submenu can be opened. Make sure that the cell exists in the SDLManager.menu array");
        return NO;
    }

    SDLShowAppMenu *subMenu = [[SDLShowAppMenu alloc] initWithMenuID:cell.cellId];
    [self.connectionManager sendConnectionRequest:subMenu withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if ([response.resultCode isEqualToEnum:SDLResultWarnings]) {
            SDLLogW(@"Warning opening application menu to submenu cell %@, with error: %@", cell, error);
        } else if (![response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogE(@"Error opening application menu to submenu cell %@, with error: %@", cell, error);
        } else {
            SDLLogD(@"Successfully opened application menu to submenu cell: %@", cell);
        }
    }];

    return YES;
}

#pragma mark - Build Deletes, Keeps, Adds

- (void)sdl_startSubMenuUpdatesWithOldKeptCells:(NSArray<SDLMenuCell *> *)oldKeptCells newKeptCells:(NSArray<SDLMenuCell *> *)newKeptCells atIndex:(NSUInteger)startIndex {
    if (oldKeptCells.count == 0 || startIndex >= oldKeptCells.count) {
        self.inProgressUpdate = nil;
        return;
    }

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

- (NSArray<SDLMenuCell *> *)sdl_filterDeleteMenuItemsWithOldMenuItems:(NSArray<SDLMenuCell *> *)oldMenuCells basedOnStatusList:(NSArray<NSNumber *> *)oldStatusList {
    NSMutableArray<SDLMenuCell *> *deleteCells = [[NSMutableArray alloc] init];
    // The index of the status should corrleate 1-1 with the number of items in the menu
    // [2,0,2,0] => [A,B,C,D] = [B,D]
    for (NSUInteger index = 0; index < oldStatusList.count; index++) {
        if (oldStatusList[index].integerValue == MenuCellStateDelete) {
            [deleteCells addObject:oldMenuCells[index]];
        }
    }
    return [deleteCells copy];
}

- (NSArray<SDLMenuCell *> *)sdl_filterAddMenuItemsWithNewMenuItems:(NSArray<SDLMenuCell *> *)newMenuCells basedOnStatusList:(NSArray<NSNumber *> *)newStatusList {
    NSMutableArray<SDLMenuCell *> *addCells = [[NSMutableArray alloc] init];
    // The index of the status should corrleate 1-1 with the number of items in the menu
    // [2,1,2,1] => [A,B,C,D] = [B,D]
    for (NSUInteger index = 0; index < newStatusList.count; index++) {
        if (newStatusList[index].integerValue == MenuCellStateAdd) {
            [addCells addObject:newMenuCells[index]];
        }
    }
    return [addCells copy];
}

- (NSArray<SDLMenuCell *> *)sdl_filterKeepMenuItemsWithOldMenuItems:(NSArray<SDLMenuCell *> *)oldMenuCells basedOnStatusList:(NSArray<NSNumber *> *)keepStatusList {
    NSMutableArray<SDLMenuCell *> *keepMenuCells = [[NSMutableArray alloc] init];

    for (NSUInteger index = 0; index < keepStatusList.count; index++) {
        if (keepStatusList[index].integerValue == MenuCellStateKeep) {
            [keepMenuCells addObject:oldMenuCells[index]];
        }
    }
    return [keepMenuCells copy];
}

- (NSArray<SDLMenuCell *> *)sdl_filterKeepMenuItemsWithNewMenuItems:(NSArray<SDLMenuCell *> *)newMenuCells basedOnStatusList:(NSArray<NSNumber *> *)keepStatusList {
    NSMutableArray<SDLMenuCell *> *keepMenuCells = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < keepStatusList.count; index++) {
        if (keepStatusList[index].integerValue == MenuCellStateKeep) {
            [keepMenuCells addObject:newMenuCells[index]];
        }
    }
    return [keepMenuCells copy];
}

- (void)transferCellIDFromOldCells:(NSArray<SDLMenuCell *> *)oldCells toKeptCells:(NSArray<SDLMenuCell *> *)newCells {
    if (oldCells.count == 0) { return; }
    for (NSUInteger i = 0; i < newCells.count; i++) {
        newCells[i].cellId = oldCells[i].cellId;
    }
}

#pragma mark - Updating System

- (void)sdl_startDynamicMenuUpdate {
    SDLDynamicMenuUpdateRunScore *runScore = [SDLDynamicMenuUpdateAlgorithm compareOldMenuCells:self.oldMenuCells updatedMenuCells:self.menuCells];

    NSArray<NSNumber *> *deleteMenuStatus = runScore.oldStatus;
    NSArray<NSNumber *> *addMenuStatus = runScore.updatedStatus;

    NSArray<SDLMenuCell *> *cellsToDelete = [self sdl_filterDeleteMenuItemsWithOldMenuItems:self.oldMenuCells basedOnStatusList:deleteMenuStatus];
    NSArray<SDLMenuCell *> *cellsToAdd = [self sdl_filterAddMenuItemsWithNewMenuItems:self.menuCells basedOnStatusList:addMenuStatus];
    // These arrays should ONLY contain KEEPS. These will be used for SubMenu compares
    NSArray<SDLMenuCell *> *oldKeeps = [self sdl_filterKeepMenuItemsWithOldMenuItems:self.oldMenuCells basedOnStatusList:deleteMenuStatus];
    NSArray<SDLMenuCell *> *newKeeps = [self sdl_filterKeepMenuItemsWithNewMenuItems:self.menuCells basedOnStatusList:addMenuStatus];

    // Cells that will be added need new ids
    [self sdl_updateIdsOnMenuCells:cellsToAdd parentId:ParentIdNotFound];

    // Since we are creating a new Menu but keeping old cells we must firt transfer the old cellIDs to the new menus kept cells.
    [self transferCellIDFromOldCells:oldKeeps toKeptCells:newKeeps];

    // Upload the artworks
    NSArray<SDLArtwork *> *artworksToBeUploaded = [self sdl_findAllArtworksToBeUploadedFromCells:cellsToAdd];
    if (artworksToBeUploaded.count > 0) {
        [self.fileManager uploadArtworks:artworksToBeUploaded completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
            if (error != nil) {
                SDLLogE(@"Error uploading menu artworks: %@", error);
            }
            SDLLogD(@"Menu artworks uploaded");
            // Update cells with artworks once they're uploaded
            __weak typeof(self) weakself = self;
            [self sdl_updateMenuWithCellsToDelete:cellsToDelete cellsToAdd:cellsToAdd completionHandler:^(NSError * _Nullable error) {
                [weakself sdl_startSubMenuUpdatesWithOldKeptCells:oldKeeps newKeptCells:newKeeps atIndex:0];
            }];
        }];
    } else {
        // Cells have no artwork to load
        __weak typeof(self) weakself = self;
        [self sdl_updateMenuWithCellsToDelete:cellsToDelete cellsToAdd:cellsToAdd completionHandler:^(NSError * _Nullable error) {
            [weakself sdl_startSubMenuUpdatesWithOldKeptCells:oldKeeps newKeptCells:newKeeps atIndex:0];
        }];
    }
}

- (void)sdl_startNonDynamicMenuUpdate {
    [self sdl_updateIdsOnMenuCells:self.menuCells parentId:ParentIdNotFound];

    NSArray<SDLArtwork *> *artworksToBeUploaded = [self sdl_findAllArtworksToBeUploadedFromCells:self.menuCells];
    if (artworksToBeUploaded.count > 0) {
        [self.fileManager uploadArtworks:artworksToBeUploaded completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
            if (error != nil) {
                SDLLogE(@"Error uploading menu artworks: %@", error);
            }

            SDLLogD(@"Menu artworks uploaded");
            [self sdl_updateMenuWithCellsToDelete:self.oldMenuCells cellsToAdd:self.menuCells completionHandler:nil];
        }];
    } else {
        // Cells have no artwork to load
        [self sdl_updateMenuWithCellsToDelete:self.oldMenuCells cellsToAdd:self.menuCells completionHandler:nil];
    }
}

- (void)sdl_updateMenuWithCellsToDelete:(NSArray<SDLMenuCell *> *)deleteCells cellsToAdd:(NSArray<SDLMenuCell *> *)addCells completionHandler:(nullable SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.currentHMILevel == nil
        || [self.currentHMILevel isEqualToEnum:SDLHMILevelNone]
        || [self.currentSystemContext isEqualToEnum:SDLSystemContextMenu]) {
        self.waitingOnHMIUpdate = YES;
        self.waitingUpdateMenuCells = self.menuCells;
        return;
    }

    if (self.inProgressUpdate != nil) {
        // There's an in progress update, we need to put this on hold
        self.hasQueuedUpdate = YES;
        return;
    }
    __weak typeof(self) weakself = self;
    [self sdl_sendDeleteCurrentMenu:deleteCells withCompletionHandler:^(NSError * _Nullable error) {
        [weakself sdl_sendUpdatedMenu:addCells usingMenu:weakself.menuCells withCompletionHandler:^(NSError * _Nullable error) {
            weakself.inProgressUpdate = nil;

            if (completionHandler != nil) {
                completionHandler(error);
            }

            if (weakself.hasQueuedUpdate) {
                [weakself sdl_updateMenuWithCellsToDelete:deleteCells cellsToAdd:addCells completionHandler:nil];
                weakself.hasQueuedUpdate = NO;
            }
        }];
    }];
}

#pragma mark Delete Old Menu Items

- (void)sdl_sendDeleteCurrentMenu:(nullable NSArray<SDLMenuCell *> *)deleteMenuCells withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (deleteMenuCells.count == 0) {
        completionHandler(nil);
        return;
    }

    NSArray<SDLRPCRequest *> *deleteMenuCommands = [self sdl_deleteCommandsForCells:deleteMenuCells];
    [self.connectionManager sendRequests:deleteMenuCommands progressHandler:nil completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogW(@"Unable to delete all old menu commands");
        } else {
            SDLLogD(@"Finished deleting old menu");
        }

        completionHandler(nil);
    }];
}

#pragma mark Send New Menu Items

/**
 Creates add commands

 @param updatedMenu The cells you will be adding
 @param menu The list of all cells. This may be different then self.menuCells since this function is called on subcell cells as well. When comparing 2 sub menu cells this function will be passed the list of all subcells on that cell.
 @param completionHandler handler
 */
- (void)sdl_sendUpdatedMenu:(NSArray<SDLMenuCell *> *)updatedMenu usingMenu:(NSArray<SDLMenuCell *> *)menu withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.menuCells.count == 0 || updatedMenu.count == 0) {
        SDLLogD(@"There are no cells to update.");
        completionHandler(nil);
        return;
    }

    NSArray<SDLRPCRequest *> *mainMenuCommands = nil;
    NSArray<SDLRPCRequest *> *subMenuCommands = nil;

    if (![self sdl_shouldRPCsIncludeImages:self.menuCells] || ![self.windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon]) {
        // Send artwork-less menu
        mainMenuCommands = [self sdl_mainMenuCommandsForCells:updatedMenu withArtwork:NO usingIndexesFrom:menu];
        subMenuCommands =  [self sdl_subMenuCommandsForCells:updatedMenu withArtwork:NO];
    } else {
        // Send full artwork menu
        mainMenuCommands = [self sdl_mainMenuCommandsForCells:updatedMenu withArtwork:YES usingIndexesFrom:menu];
        subMenuCommands = [self sdl_subMenuCommandsForCells:updatedMenu withArtwork:YES];
    }

    self.inProgressUpdate = [mainMenuCommands arrayByAddingObjectsFromArray:subMenuCommands];
    
    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:mainMenuCommands progressHandler:^void(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send main menu commands: %@", errors);
            completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
            return;
        }
        
        [weakSelf.connectionManager sendRequests:subMenuCommands progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
            if (error != nil) {
                errors[request] = error;
            }
        } completionHandler:^(BOOL success) {
            if (!success) {
                SDLLogE(@"Failed to send sub menu commands: %@", errors);
                completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
                return;
            }

            SDLLogD(@"Finished updating menu");
            completionHandler(nil);
        }];
    }];
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

/// Checks if 2 or more cells have the same text/title. In case this condition is true, this function will handle the presented issue by adding "(count)".
/// E.g. Choices param contains 2 cells with text/title "Address" will be handled by updating the uniqueText/uniqueTitle of the second cell to "Address (2)".
/// @param choices The choices to be uploaded.
- (void)sdl_addUniqueNamesToCells:(nullable NSArray<SDLMenuCell *> *)choices {
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<NSString *, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];
    for (SDLMenuCell *cell in choices) {
        NSString *cellName = cell.title;
        NSNumber *counter = dictCounter[cellName];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cellName] = counter;
        } else {
            dictCounter[cellName] = @1;
        }

        counter = dictCounter[cellName];
        if (counter.intValue > 1) {
            cell.uniqueTitle = [NSString stringWithFormat: @"%@ (%d)", cell.title, counter.intValue];
        }

        if (cell.subCells.count > 0) {
            [self sdl_addUniqueNamesToCells:cell.subCells];
        }
    }
}

/// Check for cell lists with completely duplicate information, or any duplicate voiceCommands
///
/// @param cells The cells you will be adding
/// @return Boolean that indicates whether menuCells are unique or not
 */
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

#pragma mark Artworks

/// Get an array of artwork that needs to be uploaded form a list of menu cells
/// @param cells The menu cells to get artwork from
/// @returns The array of artwork that needs to be uploaded
- (NSArray<SDLArtwork *> *)sdl_findAllArtworksToBeUploadedFromCells:(NSArray<SDLMenuCell *> *)cells {
    if (![self.windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon]) {
        return @[];
    }

    NSMutableSet<SDLArtwork *> *mutableArtworks = [NSMutableSet set];
    for (SDLMenuCell *cell in cells) {
        if ([self.fileManager fileNeedsUpload:cell.icon]) {
            [mutableArtworks addObject:cell.icon];
        }

        if (cell.subCells.count > 0 && [self.windowCapability hasImageFieldOfName:SDLImageFieldNameMenuSubMenuSecondaryImage]) {
            if ([self.fileManager fileNeedsUpload:cell.secondaryArtwork]) {
                [mutableArtworks addObject:cell.secondaryArtwork];
            }
        } else if (cell.subCells.count == 0 && [self.windowCapability hasImageFieldOfName:SDLImageFieldNameMenuCommandSecondaryImage]) {
            if ([self.fileManager fileNeedsUpload:cell.secondaryArtwork]) {
                [mutableArtworks addObject:cell.secondaryArtwork];
            }
        }

        if (cell.subCells.count > 0) {
            [mutableArtworks addObjectsFromArray:[self sdl_findAllArtworksToBeUploadedFromCells:cell.subCells]];
        }
    }

    return [mutableArtworks allObjects];
}

/// Determine if cells should or should not be uploaded to the head unit with artworks.
///
/// No artworks will be uploaded if:
///
/// 1. If any cell has a dynamic artwork that is not uploaded
/// 2. If any cell contains a secondary artwork may be used on the head unit, and the cell has a dynamic secondary artwork that is not uploaded
/// 3. If any cell's subcells fails check (1) or (2)
/// @param cells The cells to check
/// @return True if the cells should be uploaded with artwork, false if they should not
- (BOOL)sdl_shouldRPCsIncludeImages:(NSArray<SDLMenuCell *> *)cells {
    for (SDLMenuCell *cell in cells) {
        SDLArtwork *artwork = cell.icon;
        SDLArtwork *secondaryArtwork = cell.secondaryArtwork;
        if (artwork != nil && !artwork.isStaticIcon && ![self.fileManager hasUploadedFile:artwork]) {
            return NO;
        } else if (cell.subCells.count > 0 && [self.windowCapability hasImageFieldOfName:SDLImageFieldNameMenuSubMenuSecondaryImage]) {
            if (secondaryArtwork != nil && !secondaryArtwork.isStaticIcon && ![self.fileManager hasUploadedFile:secondaryArtwork]) {
                return NO;
            }
        } else if (cell.subCells.count == 0 && [self.windowCapability hasImageFieldOfName:SDLImageFieldNameMenuCommandSecondaryImage]) {
            if (secondaryArtwork != nil && !secondaryArtwork.isStaticIcon && ![self.fileManager hasUploadedFile:secondaryArtwork]) {
                return NO;
            }
        } else if (cell.subCells.count > 0 && ![self sdl_shouldRPCsIncludeImages:cell.subCells]) {
            return NO;
        }
    }

    return YES;
}

#pragma mark IDs

/// Assign cell ids on an array of menu cells given a parent id (or no parent id)
/// @param menuCells The array of menu cells to update
/// @param parentId The parent id to assign if needed
- (void)sdl_updateIdsOnMenuCells:(NSArray<SDLMenuCell *> *)menuCells parentId:(UInt32)parentId {
    for (SDLMenuCell *cell in menuCells) {
        cell.cellId = self.lastMenuId++;
        cell.parentCellId = parentId;
        if (cell.subCells.count > 0) {
            [self sdl_updateIdsOnMenuCells:cell.subCells parentId:cell.cellId];
        }
    }
}

#pragma mark Deletes

/// Create an array of DeleteCommand and DeleteSubMenu RPCs from an array of menu cells
/// @param cells The array of menu cells to use
- (NSArray<SDLRPCRequest *> *)sdl_deleteCommandsForCells:(NSArray<SDLMenuCell *> *)cells {
    NSMutableArray<SDLRPCRequest *> *mutableDeletes = [NSMutableArray array];
    for (SDLMenuCell *cell in cells) {
        if (cell.subCells == nil) {
            SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:cell.cellId];
            [mutableDeletes addObject:delete];
        } else {
            SDLDeleteSubMenu *delete = [[SDLDeleteSubMenu alloc] initWithId:cell.cellId];
            [mutableDeletes addObject:delete];
        }
    }

    return [mutableDeletes copy];
}

#pragma mark Commands / SubMenu RPCs

/// This method will receive the cells to be added and the updated menu array. It will then build an array of add commands using the correct index to position the new items in the correct location.
/// e.g. If the new menu array is [A, B, C, D] but only [C, D] are new we need to pass [A, B , C , D] so C and D can be added to index 2 and 3 respectively.
///
/// @param cells that will be added to the menu, this array must contain only cells that are not already in the menu.
/// @param shouldHaveArtwork artwork bool
/// @param menu the new menu array, this array should contain all the values the developer has set to be included in the new menu. This is used for placing the newly added cells in the correct location.
/// @return list of SDLRPCRequest addCommands
 */
- (NSArray<SDLRPCRequest *> *)sdl_mainMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork usingIndexesFrom:(NSArray<SDLMenuCell *> *)menu {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];

    for (NSUInteger menuInteger = 0; menuInteger < menu.count; menuInteger++) {
        for (NSUInteger updateCellsIndex = 0; updateCellsIndex < cells.count; updateCellsIndex++) {
            if ([menu[menuInteger] isEqual:cells[updateCellsIndex]]) {
                if (cells[updateCellsIndex].subCells.count > 0) {
                    [mutableCommands addObject:[self sdl_subMenuCommandForMenuCell:cells[updateCellsIndex] withArtwork:shouldHaveArtwork position:(UInt16)menuInteger]];
                } else {
                    [mutableCommands addObject:[self sdl_commandForMenuCell:cells[updateCellsIndex] withArtwork:shouldHaveArtwork position:(UInt16)menuInteger]];
                }
            }
        }
    }

    return [mutableCommands copy];
}

/// Creates SDLAddSubMenu RPCs for the passed array of menu cells, AND all of those cells' subcell RPCs, both SDLAddCommands and SDLAddSubMenus
/// @param cells The cells to create RPCs for
/// @param shouldHaveArtwork Whether artwork should be applied to the RPCs
/// @returns An array of RPCs of SDLAddSubMenus and their associated subcell RPCs
- (NSArray<SDLRPCRequest *> *)sdl_subMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];
    for (SDLMenuCell *cell in cells) {
        if (cell.subCells.count > 0) {
            [mutableCommands addObjectsFromArray:[self sdl_allCommandsForCells:cell.subCells withArtwork:shouldHaveArtwork]];
        }
    }

    return [mutableCommands copy];
}

/// Creates SDLAddCommand and SDLAddSubMenu RPCs for a passed array of cells, AND all of those cells' subcell RPCs, both SDLAddCommands and SDLAddSubmenus
/// @param cells The cells to create RPCs for
/// @param shouldHaveArtwork Whether artwork should be applied to the RPCs
/// @returns An array of RPCs of SDLAddCommand and SDLAddSubMenus for the array of menu cells and their subcells, recursively
- (NSArray<SDLRPCRequest *> *)sdl_allCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];

    for (NSUInteger cellIndex = 0; cellIndex < cells.count; cellIndex++) {
        if (cells[cellIndex].subCells.count > 0) {
            [mutableCommands addObject:[self sdl_subMenuCommandForMenuCell:cells[cellIndex] withArtwork:shouldHaveArtwork position:(UInt16)cellIndex]];
            [mutableCommands addObjectsFromArray:[self sdl_allCommandsForCells:cells[cellIndex].subCells withArtwork:shouldHaveArtwork]];
        } else {
            [mutableCommands addObject:[self sdl_commandForMenuCell:cells[cellIndex] withArtwork:shouldHaveArtwork position:(UInt16)cellIndex]];
        }
    }

    return [mutableCommands copy];
}

/// An individual SDLAddCommand RPC for a given SDLMenuCell
/// @param cell The cell to create the RPC for
/// @param shouldHaveArtwork Whether artwork should be applied to the RPC
/// @param position The position the SDLAddCommand RPC should be given
/// @returns The SDLAddCommand RPC
- (SDLAddCommand *)sdl_commandForMenuCell:(SDLMenuCell *)cell withArtwork:(BOOL)shouldHaveArtwork position:(UInt16)position {
    SDLAddCommand *command = [[SDLAddCommand alloc] init];

    SDLMenuParams *params = [[SDLMenuParams alloc] init];
    params.menuName = cell.uniqueTitle;
    params.parentID = cell.parentCellId != UINT32_MAX ? @(cell.parentCellId) : nil;
    params.position = @(position);
    params.secondaryText = (cell.secondaryText.length > 0 && [self.windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandSecondaryText]) ? cell.secondaryText : nil;
    params.tertiaryText = (cell.tertiaryText.length > 0 && [self.windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandTertiaryText]) ? cell.tertiaryText : nil;

    command.menuParams = params;
    command.vrCommands = (cell.voiceCommands.count == 0) ? nil : cell.voiceCommands;
    command.cmdIcon = (cell.icon && shouldHaveArtwork) ? cell.icon.imageRPC : nil;
    command.cmdID = @(cell.cellId);
    command.secondaryImage = (cell.secondaryArtwork && shouldHaveArtwork && ![self.fileManager fileNeedsUpload:cell.secondaryArtwork]) ? cell.secondaryArtwork.imageRPC : nil;

    return command;
}

/// An individual SDLAddSubMenu RPC for a given SDLMenuCell
/// @param cell The cell to create the RPC for
/// @param shouldHaveArtwork Whether artwork should be applied to the RPC
/// @param position The position the SDLAddSubMenu RPC should be given
/// @returns The SDLAddSubMenu RPC
- (SDLAddSubMenu *)sdl_subMenuCommandForMenuCell:(SDLMenuCell *)cell withArtwork:(BOOL)shouldHaveArtwork position:(UInt16)position {
    SDLImage *icon = (shouldHaveArtwork && (cell.icon.name != nil)) ? cell.icon.imageRPC : nil;
    SDLImage *secondaryImage = (shouldHaveArtwork && ![self.fileManager fileNeedsUpload:cell.secondaryArtwork] && (cell.secondaryArtwork.name != nil)) ? cell.secondaryArtwork.imageRPC : nil;

    SDLMenuLayout submenuLayout = nil;
    if (cell.submenuLayout && [self.systemCapabilityManager.defaultMainWindowCapability.menuLayoutsAvailable containsObject:cell.submenuLayout]) {
        submenuLayout = cell.submenuLayout;
    } else {
        submenuLayout = self.menuConfiguration.defaultSubmenuLayout;
    }
    
    NSString *secondaryText = (cell.secondaryText.length > 0 && [self.windowCapability hasTextFieldOfName:SDLTextFieldNameMenuSubMenuSecondaryText]) ? cell.secondaryText : nil;
    NSString *tertiaryText = (cell.tertiaryText.length > 0 && [self.windowCapability hasTextFieldOfName:SDLTextFieldNameMenuSubMenuTertiaryText]) ? cell.tertiaryText : nil;
    return [[SDLAddSubMenu alloc] initWithMenuID:cell.cellId menuName:cell.uniqueTitle position:@(position) menuIcon:icon menuLayout:submenuLayout parentID:nil secondaryText:secondaryText tertiaryText:tertiaryText secondaryImage:secondaryImage];
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

    [self sdl_callHandlerForCells:self.menuCells command:onCommand];
}

- (void)sdl_displayCapabilityDidUpdate {
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
