//
//  SDLMenuReplaceDynamicOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/20/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuReplaceOperation.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLDynamicMenuUpdateAlgorithm.h"
#import "SDLDynamicMenuUpdateRunScore.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLMenuCell.h"
#import "SDLMenuConfiguration.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLMenuUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@interface SDLMenuReplaceOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) NSArray<SDLMenuCell *> *updatedMenu;
@property (assign, nonatomic) BOOL compatbilityModeEnabled;
@property (assign, nonatomic) SDLCurrentMenuUpdatedBlock currentMenuUpdatedBlock;

@property (strong, nonatomic) NSMutableArray<SDLMenuCell *> *mutableCurrentMenu;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLMenuReplaceOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability menuConfiguration:(SDLMenuConfiguration *)menuConfiguration currentMenu:(NSArray<SDLMenuCell *> *)currentMenu updatedMenu:(NSArray<SDLMenuCell *> *)updatedMenu compatibilityModeEnabled:(BOOL)compatbilityModeEnabled currentMenuUpdatedHandler:(SDLCurrentMenuUpdatedBlock)currentMenuUpdatedBlock {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _windowCapability = windowCapability;
    _menuConfiguration = menuConfiguration;
    _mutableCurrentMenu = [currentMenu mutableCopy];
    _updatedMenu = updatedMenu;
    _compatbilityModeEnabled = compatbilityModeEnabled;
    _currentMenuUpdatedBlock = currentMenuUpdatedBlock;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    SDLDynamicMenuUpdateRunScore *runScore = nil;
    if (self.compatbilityModeEnabled) {
        SDLLogV(@"Dynamic menu update inactive. Forcing the deletion of all old cells and adding all new ones, even if they're the same.");
        runScore = [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:[self sdl_buildAllDeleteStatusesForMenu:self.currentMenu] updatedStatus:[self sdl_buildAllAddStatusesForMenu:self.updatedMenu] score:self.updatedMenu.count];
    } else {
        SDLLogV(@"Dynamic menu update active. Running the algorithm to find the best way to delete / add cells.");
        runScore = [SDLDynamicMenuUpdateAlgorithm compareOldMenuCells:self.currentMenu updatedMenuCells:self.updatedMenu];
    }

    // If both old and new cells are empty, nothing needs to happen
    if ((runScore.oldStatus.count == 0) && (runScore.updatedStatus.count == 0)) {
        return [self finishOperation];
    }

    NSArray<SDLMenuCell *> *cellsToDelete = [self sdl_filterDeleteMenuItemsWithOldMenuItems:self.currentMenu basedOnStatusList:runScore.oldStatus];
    NSArray<SDLMenuCell *> *cellsToAdd = [self sdl_filterAddMenuItemsWithNewMenuItems:self.updatedMenu basedOnStatusList:runScore.updatedStatus];
    // These arrays should ONLY contain KEEPS. These will be used for SubMenu compares
    NSArray<SDLMenuCell *> *oldKeeps = [self sdl_filterKeepMenuItemsWithOldMenuItems:self.currentMenu basedOnStatusList:runScore.oldStatus];
    NSArray<SDLMenuCell *> *newKeeps = [self sdl_filterKeepMenuItemsWithNewMenuItems:self.updatedMenu basedOnStatusList:runScore.updatedStatus];

    // Since we are creating a new Menu but keeping old cells we must firt transfer the old cellIDs to the new menus kept cells.
    [self sdl_transferCellIDFromOldCells:oldKeeps toKeptCells:newKeeps];

    // Upload the artworks, then we will start updating the main menu
    __weak typeof(self) weakself = self;
    NSArray<SDLArtwork *> *artworksToBeUploaded = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:self.updatedMenu fileManager:self.fileManager windowCapability:self.windowCapability];
    if (artworksToBeUploaded.count > 0) {
        [self.fileManager uploadArtworks:artworksToBeUploaded progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
            if (weakself.isCancelled) {
                [weakself finishOperation];
                return NO;
            }

            return YES;
        } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
            if (weakself.isCancelled) { return; }
            if (error != nil) { SDLLogE(@"Error uploading menu artworks: %@", error); }

            SDLLogD(@"Menu artworks uploaded, beginning upload of main menu");
            // Start updating the main menu cells
            [weakself sdl_updateMenuWithCellsToDelete:cellsToDelete cellsToAdd:cellsToAdd completionHandler:^(NSError * _Nullable error) {
                if (weakself.isCancelled) { return [weakself finishOperation]; }
                // Start uploading the submenu cells
                [weakself sdl_updateSubMenuWithOldKeptCells:oldKeeps newKeptCells:newKeeps atIndex:0];
            }];
        }];
    } else {
        // Cells have no artwork to load
        [self sdl_updateMenuWithCellsToDelete:cellsToDelete cellsToAdd:cellsToAdd completionHandler:^(NSError * _Nullable error) {
            if (weakself.isCancelled) { return [weakself finishOperation]; }
            [weakself sdl_updateSubMenuWithOldKeptCells:oldKeeps newKeptCells:newKeeps atIndex:0];
        }];
    }
}

#pragma mark - Update Main Menu / Submenu

/// Takes the main menu cells to delete and add, and deletes the current menu cells, then adds the new menu cells in the correct locations
/// @param deleteCells The cells that need to be deleted
/// @param addCells The cells that need to be added
/// @param handler A handler called when complete
- (void)sdl_updateMenuWithCellsToDelete:(NSArray<SDLMenuCell *> *)deleteCells cellsToAdd:(NSArray<SDLMenuCell *> *)addCells completionHandler:(SDLMenuUpdateCompletionHandler)handler {
    __weak typeof(self) weakself = self;
    [self sdl_sendDeleteCurrentMenu:deleteCells withCompletionHandler:^(NSError * _Nullable error) {
        if (weakself.isCancelled) { return handler(error); }
        [weakself sdl_sendNewMenuCells:addCells oldMenu:weakself.currentMenu withCompletionHandler:^(NSError * _Nullable error) {
            handler(error);
        }];
    }];
}

/// Takes the submenu cells that are old keeps and new keeps and determines which cells need to be deleted or added
/// @param oldKeptCells The old kept cells
/// @param newKeptCells The new kept cells
/// @param startIndex The index of the main menu to use
- (void)sdl_updateSubMenuWithOldKeptCells:(NSArray<SDLMenuCell *> *)oldKeptCells newKeptCells:(NSArray<SDLMenuCell *> *)newKeptCells atIndex:(NSUInteger)startIndex {
    if (oldKeptCells.count == 0 || startIndex >= oldKeptCells.count) { return; }

    if (oldKeptCells[startIndex].subCells.count > 0) {
        SDLDynamicMenuUpdateRunScore *tempScore = [SDLDynamicMenuUpdateAlgorithm compareOldMenuCells:oldKeptCells[startIndex].subCells updatedMenuCells:newKeptCells[startIndex].subCells];
        NSArray<NSNumber *> *deleteMenuStatus = tempScore.oldStatus;
        NSArray<NSNumber *> *addMenuStatus = tempScore.updatedStatus;

        NSArray<SDLMenuCell *> *cellsToDelete = [self sdl_filterDeleteMenuItemsWithOldMenuItems:oldKeptCells[startIndex].subCells basedOnStatusList:deleteMenuStatus];
        NSArray<SDLMenuCell *> *cellsToAdd = [self sdl_filterAddMenuItemsWithNewMenuItems:newKeptCells[startIndex].subCells basedOnStatusList:addMenuStatus];

        NSArray<SDLMenuCell *> *oldKeeps = [self sdl_filterKeepMenuItemsWithOldMenuItems:oldKeptCells[startIndex].subCells basedOnStatusList:deleteMenuStatus];
        NSArray<SDLMenuCell *> *newKeeps = [self sdl_filterKeepMenuItemsWithNewMenuItems:newKeptCells[startIndex].subCells basedOnStatusList:addMenuStatus];

        [self sdl_transferCellIDFromOldCells:oldKeeps toKeptCells:newKeeps];

        __weak typeof(self) weakself = self;
        [self sdl_sendDeleteCurrentMenu:cellsToDelete withCompletionHandler:^(NSError * _Nullable error) {
            if (weakself.isCancelled) { return [weakself finishOperation]; }

            [weakself sdl_sendNewMenuCells:cellsToAdd oldMenu:weakself.currentMenu[startIndex].subCells withCompletionHandler:^(NSError * _Nullable error) {
                if (weakself.isCancelled) { return [weakself finishOperation]; }

                // After the first set of submenu cells were added and deleted we must find the next set of subcells until we loop through all the elements
                [weakself sdl_updateSubMenuWithOldKeptCells:oldKeptCells newKeptCells:newKeptCells atIndex:(startIndex + 1)];
            }];
        }];
    } else {
        // There are no subcells, we can skip to the next index.
        [self sdl_updateSubMenuWithOldKeptCells:oldKeptCells newKeptCells:newKeptCells atIndex:(startIndex + 1)];
    }
}

#pragma mark - Adding / Deleting cell RPCs

/// Send Delete RPCs for given menu cells
/// @param deleteMenuCells The menu cells to be deleted
/// @param completionHandler A handler called when the RPCs are finished with an error if any failed
- (void)sdl_sendDeleteCurrentMenu:(nullable NSArray<SDLMenuCell *> *)deleteMenuCells withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (deleteMenuCells.count == 0) { return completionHandler(nil); }

    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    NSArray<SDLRPCRequest *> *deleteMenuCommands = [SDLMenuReplaceUtilities deleteCommandsForCells:deleteMenuCells];
    [self.connectionManager sendRequests:deleteMenuCommands progressHandler:^void(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        } else if (response.success.boolValue) {
            // Find the id of the successful request and remove it from the current menu list whereever it may have been
            UInt32 commandId = [SDLMenuReplaceUtilities commandIdForRPCRequest:request];
            [SDLMenuReplaceUtilities removeMenuCellFromList:self.mutableCurrentMenu withCmdId:commandId];
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Unable to delete all old menu commands with errors: %@", errors);
            completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
        } else {
            SDLLogD(@"Finished deleting old menu");
            completionHandler(nil);
        }
    }];
}

/// Send Add RPCs for given new menu cells compared to old menu cells
/// @param newMenuCells The new menu cells we want displayed
/// @param oldMenu The old menu cells we no longer want displayed
/// @param completionHandler A handler called when the RPCs are finished with an error if any failed
- (void)sdl_sendNewMenuCells:(NSArray<SDLMenuCell *> *)newMenuCells oldMenu:(NSArray<SDLMenuCell *> *)oldMenu withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.updatedMenu.count == 0 || newMenuCells.count == 0) {
        SDLLogV(@"There are no cells to update.");
        return completionHandler(nil);
    }

    NSArray<SDLRPCRequest *> *mainMenuCommands = [SDLMenuReplaceUtilities mainMenuCommandsForCells:newMenuCells fileManager:self.fileManager usingIndexesFrom:self.updatedMenu windowCapability:self.windowCapability defaultSubmenuLayout:self.menuConfiguration.defaultSubmenuLayout];;
    NSArray<SDLRPCRequest *> *subMenuCommands = [SDLMenuReplaceUtilities subMenuCommandsForCells:newMenuCells fileManager:self.fileManager windowCapability:self.windowCapability defaultSubmenuLayout:self.menuConfiguration.defaultSubmenuLayout];

    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:mainMenuCommands progressHandler:^void(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        } else {
            // Find the id of the successful request and add it from the current menu list whereever it needs to be
            UInt32 commandId = [SDLMenuReplaceUtilities commandIdForRPCRequest:request];
            UInt16 position = [SDLMenuReplaceUtilities positionForRPCRequest:request];
            [SDLMenuReplaceUtilities addMenuRequestWithCommandId:commandId position:position fromNewMenuList:newMenuCells toMainMenuList:weakSelf.mutableCurrentMenu];
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send main menu commands: %@", errors);
            return completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
        }

        [weakSelf.connectionManager sendRequests:subMenuCommands progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
            if (error != nil) {
                errors[request] = error;
            } else {
                // Find the id of the successful request and add it from the current menu list whereever it needs to be
                UInt32 commandId = [SDLMenuReplaceUtilities commandIdForRPCRequest:request];
                UInt16 position = [SDLMenuReplaceUtilities positionForRPCRequest:request];
                [SDLMenuReplaceUtilities addMenuRequestWithCommandId:commandId position:position fromNewMenuList:newMenuCells toMainMenuList:weakSelf.mutableCurrentMenu];
            }
        } completionHandler:^(BOOL success) {
            if (!success) {
                SDLLogE(@"Failed to send sub menu commands: %@", errors);
                return completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
            }

            SDLLogD(@"Finished updating menu");
            completionHandler(nil);
        }];
    }];
}

#pragma mark Dynamic Menu Helpers

- (NSArray<SDLMenuCell *> *)sdl_filterDeleteMenuItemsWithOldMenuItems:(NSArray<SDLMenuCell *> *)oldMenuCells basedOnStatusList:(NSArray<NSNumber *> *)oldStatusList {
    NSMutableArray<SDLMenuCell *> *deleteCells = [[NSMutableArray alloc] init];
    // The index of the status should correlate 1-1 with the number of items in the menu
    // [2,0,2,0] => [A,B,C,D] = [B,D]
    for (NSUInteger index = 0; index < oldStatusList.count; index++) {
        if (oldStatusList[index].integerValue == SDLMenuCellUpdateStateDelete) {
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
        if (newStatusList[index].integerValue == SDLMenuCellUpdateStateAdd) {
            [addCells addObject:newMenuCells[index]];
        }
    }
    return [addCells copy];
}

- (NSArray<SDLMenuCell *> *)sdl_filterKeepMenuItemsWithOldMenuItems:(NSArray<SDLMenuCell *> *)oldMenuCells basedOnStatusList:(NSArray<NSNumber *> *)keepStatusList {
    NSMutableArray<SDLMenuCell *> *keepMenuCells = [[NSMutableArray alloc] init];

    for (NSUInteger index = 0; index < keepStatusList.count; index++) {
        if (keepStatusList[index].unsignedIntegerValue == SDLMenuCellUpdateStateKeep) {
            [keepMenuCells addObject:oldMenuCells[index]];
        }
    }
    return [keepMenuCells copy];
}

- (NSArray<SDLMenuCell *> *)sdl_filterKeepMenuItemsWithNewMenuItems:(NSArray<SDLMenuCell *> *)newMenuCells basedOnStatusList:(NSArray<NSNumber *> *)keepStatusList {
    NSMutableArray<SDLMenuCell *> *keepMenuCells = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < keepStatusList.count; index++) {
        if (keepStatusList[index].unsignedIntegerValue == SDLMenuCellUpdateStateKeep) {
            [keepMenuCells addObject:newMenuCells[index]];
        }
    }
    return [keepMenuCells copy];
}

- (void)sdl_transferCellIDFromOldCells:(NSArray<SDLMenuCell *> *)oldCells toKeptCells:(NSArray<SDLMenuCell *> *)newCells {
    if (oldCells.count == 0) { return; }
    for (NSUInteger i = 0; i < newCells.count; i++) {
        newCells[i].cellId = oldCells[i].cellId;
    }
}

- (NSArray<NSNumber *> *)sdl_buildAllDeleteStatusesForMenu:(NSArray<SDLMenuCell *> *)menuCells {
    NSMutableArray<NSNumber *> *mutableNumbers = [NSMutableArray arrayWithCapacity:menuCells.count];
    for (int i = 0; i < menuCells.count; i++) {
        [mutableNumbers addObject:@(SDLMenuCellUpdateStateDelete)];
    }

    return [mutableNumbers copy];
}

- (NSArray<NSNumber *> *)sdl_buildAllAddStatusesForMenu:(NSArray<SDLMenuCell *> *)menuCells {
    NSMutableArray<NSNumber *> *mutableNumbers = [NSMutableArray arrayWithCapacity:menuCells.count];
    for (int i = 0; i < menuCells.count; i++) {
        [mutableNumbers addObject:@(SDLMenuCellUpdateStateAdd)];
    }

    return [mutableNumbers copy];
}

#pragma mark - Getter / Setters

- (void)setCurrentMenu:(NSArray<SDLMenuCell *> *)currentMenu {
    _mutableCurrentMenu = [currentMenu mutableCopy];
}

- (NSArray<SDLMenuCell *> *)currentMenu {
    return [_mutableCurrentMenu copy];
}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing menu manager dynamic replace operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_menuManager_replaceOperationCancelled];
    }

    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.menuManager.replaceMenu.dynamic";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
