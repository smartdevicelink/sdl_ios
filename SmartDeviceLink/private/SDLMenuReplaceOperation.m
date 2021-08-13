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
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLMenuCell.h"
#import "SDLMenuConfiguration.h"
#import "SDLMenuManagerPrivateConstants.h"
#import "SDLTextFieldName.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

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

@interface SDLMenuReplaceOperation ()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) NSArray<SDLMenuCell *> *updatedMenu;
@property (strong, nonatomic) NSMutableArray<SDLMenuCell *> *mutableCurrentMenu;
@property (assign, nonatomic) BOOL compatibilityModeEnabled;
@property (copy, nonatomic) SDLCurrentMenuUpdatedBlock currentMenuUpdatedHandler;

// Internal properties
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLMenuReplaceOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability menuConfiguration:(SDLMenuConfiguration *)menuConfiguration currentMenu:(NSArray<SDLMenuCell *> *)currentMenu updatedMenu:(NSArray<SDLMenuCell *> *)updatedMenu compatibilityModeEnabled:(BOOL)compatibilityModeEnabled currentMenuUpdatedHandler:(SDLCurrentMenuUpdatedBlock)currentMenuUpdatedHandler {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _windowCapability = windowCapability;
    _menuConfiguration = menuConfiguration;
    _mutableCurrentMenu = [currentMenu mutableCopy];
    _updatedMenu = [updatedMenu copy];
    _compatibilityModeEnabled = compatibilityModeEnabled;
    _currentMenuUpdatedHandler = currentMenuUpdatedHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [SDLMenuReplaceUtilities updateIdsOnMenuCells:self.updatedMenu parentId:ParentIdNotFound];

    // Strip the "current menu" and the new menu of properties that are not displayed on the head unit
    NSArray<SDLMenuCell *> *updatedStrippedMenu = [self.class sdl_cellsWithRemovedPropertiesFromCells:self.updatedMenu basedOnWindowCapability:self.windowCapability];
    NSArray<SDLMenuCell *> *currentStrippedMenu = [self.class sdl_cellsWithRemovedPropertiesFromCells:self.mutableCurrentMenu basedOnWindowCapability:self.windowCapability];

    // Generate unique names and ensure that all menus we are tracking have them so that we can properly compare when using the dynamic algorithm
    BOOL supportsMenuUniqueness = [[SDLGlobals sharedGlobals].rpcVersion isGreaterThanOrEqualToVersion:[SDLVersion versionWithMajor:7 minor:1 patch:0]];
    [self.class sdl_generateUniqueNamesForCells:updatedStrippedMenu supportsMenuUniqueness:supportsMenuUniqueness];
    [self.class sdl_applyUniqueNamesOnCells:updatedStrippedMenu toCells:self.updatedMenu];

    SDLDynamicMenuUpdateRunScore *runScore = nil;
    if (self.compatibilityModeEnabled) {
        SDLLogV(@"Dynamic menu update inactive. Forcing the deletion of all old cells and adding all new ones, even if they're the same.");
        runScore = [SDLDynamicMenuUpdateAlgorithm compatibilityRunScoreWithOldMenuCells:currentStrippedMenu updatedMenuCells:updatedStrippedMenu];
    } else {
        SDLLogV(@"Dynamic menu update active. Running the algorithm to find the best way to delete / add cells.");
        runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:currentStrippedMenu updatedMenuCells:updatedStrippedMenu];
    }

    // If both old and new cells are empty, nothing needs to happen
    if (runScore.isEmpty) { return [self finishOperation]; }

    // Drop the cells into buckets based on the run score
    NSArray<SDLMenuCell *> *cellsToDelete = [self sdl_filterDeleteMenuItemsWithOldMenuItems:self.currentMenu basedOnStatusList:runScore.oldStatus];
    NSArray<SDLMenuCell *> *cellsToAdd = [self sdl_filterAddMenuItemsWithNewMenuItems:self.updatedMenu basedOnStatusList:runScore.updatedStatus];
    // These arrays should ONLY contain KEEPS. These will be used for SubMenu compares
    NSArray<SDLMenuCell *> *oldKeeps = [self sdl_filterKeepMenuItemsWithOldMenuItems:self.currentMenu basedOnStatusList:runScore.oldStatus];
    NSArray<SDLMenuCell *> *newKeeps = [self sdl_filterKeepMenuItemsWithNewMenuItems:self.updatedMenu basedOnStatusList:runScore.updatedStatus];

    // Since we are creating a new Menu but keeping old cells we must first transfer the old cellIDs to the new menus kept cells.
//    [self sdl_transferCellIDsFromOldCells:oldKeeps toKeptCells:newKeeps];

    // Upload the artworks, then we will start updating the main menu
    __weak typeof(self) weakSelf = self;
    [self sdl_uploadMenuArtworksWithCompletionHandler:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isCancelled) { return [strongSelf finishOperation]; }
        if (error != nil) { return [strongSelf finishOperationWithError:error]; }

        [strongSelf sdl_updateMenuWithCellsToDelete:cellsToDelete cellsToAdd:cellsToAdd completionHandler:^(NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.isCancelled) { return [strongSelf finishOperation]; }
            if (error != nil) { return [strongSelf finishOperationWithError:error]; }

            [strongSelf sdl_updateSubMenuWithOldKeptCells:oldKeeps newKeptCells:newKeeps atIndex:0 completionHandler:^(NSError * _Nullable error) {
                return [strongSelf finishOperationWithError:error];
            }];
        }];
    }];
}

#pragma mark - Update Main Menu / Submenu

- (void)sdl_uploadMenuArtworksWithCompletionHandler:(void(^)(NSError *_Nullable error))handler {
    NSArray<SDLArtwork *> *artworksToBeUploaded = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:self.updatedMenu fileManager:self.fileManager windowCapability:self.windowCapability];
    if (artworksToBeUploaded.count == 0) { return handler(nil); }

    __weak typeof(self) weakself = self;
    [self.fileManager uploadArtworks:artworksToBeUploaded progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
        // If we're cancelled, stop uploading
        return !weakself.isCancelled;
    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) { SDLLogE(@"Error uploading menu artworks: %@", error); }

        SDLLogD(@"Menu artwork upload completed, beginning upload of main menu");
        // Start updating the main menu cells
        handler(error);
    }];
}

/// Takes the main menu cells to delete and add, and deletes the current menu cells, then adds the new menu cells in the correct locations
/// @param deleteCells The cells that need to be deleted
/// @param addCells The cells that need to be added
/// @param handler A handler called when complete
- (void)sdl_updateMenuWithCellsToDelete:(NSArray<SDLMenuCell *> *)deleteCells cellsToAdd:(NSArray<SDLMenuCell *> *)addCells completionHandler:(void(^)(NSError *_Nullable error))handler {
    __weak typeof(self) weakSelf = self;
    [self sdl_sendDeleteCurrentMenu:deleteCells withCompletionHandler:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isCancelled) { return handler(error); }
        [strongSelf sdl_sendNewMenuCells:addCells oldMenu:strongSelf.currentMenu withCompletionHandler:^(NSError * _Nullable error) {
            handler(error);
        }];
    }];
}

/// Takes the submenu cells that are old keeps and new keeps and determines which cells need to be deleted or added
/// @param oldKeptCells The old kept cells
/// @param newKeptCells The new kept cells
/// @param startIndex The index of the main menu to use
- (void)sdl_updateSubMenuWithOldKeptCells:(NSArray<SDLMenuCell *> *)oldKeptCells newKeptCells:(NSArray<SDLMenuCell *> *)newKeptCells atIndex:(NSUInteger)startIndex completionHandler:(void(^)(NSError *_Nullable error))completionHandler {
    if (oldKeptCells.count == 0 || startIndex >= oldKeptCells.count) { return completionHandler(nil); }

    if (oldKeptCells[startIndex].subCells.count > 0) {
        SDLDynamicMenuUpdateRunScore *tempScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldKeptCells[startIndex].subCells updatedMenuCells:newKeptCells[startIndex].subCells];
        NSArray<NSNumber *> *deleteMenuStatus = tempScore.oldStatus;
        NSArray<NSNumber *> *addMenuStatus = tempScore.updatedStatus;

        NSArray<SDLMenuCell *> *cellsToDelete = [self sdl_filterDeleteMenuItemsWithOldMenuItems:oldKeptCells[startIndex].subCells basedOnStatusList:deleteMenuStatus];
        NSArray<SDLMenuCell *> *cellsToAdd = [self sdl_filterAddMenuItemsWithNewMenuItems:newKeptCells[startIndex].subCells basedOnStatusList:addMenuStatus];

        // TODO: These will be necessary once we do subcells of subcells
//        NSArray<SDLMenuCell *> *oldKeeps = [self sdl_filterKeepMenuItemsWithOldMenuItems:oldKeptCells[startIndex].subCells basedOnStatusList:deleteMenuStatus];
//        NSArray<SDLMenuCell *> *newKeeps = [self sdl_filterKeepMenuItemsWithNewMenuItems:newKeptCells[startIndex].subCells basedOnStatusList:addMenuStatus];
//
//        [self sdl_transferCellIDsFromOldCells:oldKeeps toKeptCells:newKeeps];

        __weak typeof(self) weakself = self;
        [self sdl_sendDeleteCurrentMenu:cellsToDelete withCompletionHandler:^(NSError * _Nullable error) {
            if (weakself.isCancelled) { return completionHandler([NSError sdl_menuManager_replaceOperationCancelled]); }
            if (error != nil) { return completionHandler(error); }

            [weakself sdl_sendNewMenuCells:cellsToAdd oldMenu:weakself.currentMenu[startIndex].subCells withCompletionHandler:^(NSError * _Nullable error) {
                if (weakself.isCancelled) { return completionHandler([NSError sdl_menuManager_replaceOperationCancelled]); }
                if (error != nil) { return completionHandler(error); }

                // After the first set of submenu cells were added and deleted we must find the next set of subcells until we loop through all the elements
                [weakself sdl_updateSubMenuWithOldKeptCells:oldKeptCells newKeptCells:newKeptCells atIndex:(startIndex + 1) completionHandler:^(NSError * _Nullable error) {
                    completionHandler(error);
                }];
            }];
        }];
    } else {
        // There are no subcells, we can skip to the next index.
        [self sdl_updateSubMenuWithOldKeptCells:oldKeptCells newKeptCells:newKeptCells atIndex:(startIndex + 1) completionHandler:^(NSError * _Nullable error) {
            completionHandler(error);
        }];
    }
}

#pragma mark - Adding / Deleting Cell RPCs

/// Send Delete RPCs for given menu cells
/// @param deleteMenuCells The menu cells to be deleted
/// @param completionHandler A handler called when the RPCs are finished with an error if any failed
- (void)sdl_sendDeleteCurrentMenu:(nullable NSArray<SDLMenuCell *> *)deleteMenuCells withCompletionHandler:(void(^)(NSError *_Nullable error))completionHandler {
    if (deleteMenuCells.count == 0) { return completionHandler(nil); }

    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    NSArray<SDLRPCRequest *> *deleteMenuCommands = [SDLMenuReplaceUtilities deleteCommandsForCells:deleteMenuCells];
    [self.connectionManager sendRequests:deleteMenuCommands progressHandler:^void(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        } else if (response.success.boolValue) {
            // Find the id of the successful request and remove it from the current menu list wherever it may have been
            UInt32 commandId = [SDLMenuReplaceUtilities commandIdForRPCRequest:request];
            [SDLMenuReplaceUtilities removeCellFromList:self.mutableCurrentMenu withCellId:commandId];
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
- (void)sdl_sendNewMenuCells:(NSArray<SDLMenuCell *> *)newMenuCells oldMenu:(NSArray<SDLMenuCell *> *)oldMenu withCompletionHandler:(void(^)(NSError *_Nullable error))completionHandler {
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
            // Find the id of the successful request and add it from the current menu list wherever it needs to be
            UInt32 commandId = [SDLMenuReplaceUtilities commandIdForRPCRequest:request];
            UInt16 position = [SDLMenuReplaceUtilities positionForRPCRequest:request];
            [SDLMenuReplaceUtilities addCellWithCellId:commandId position:position fromNewMenuList:newMenuCells toMainMenuList:weakSelf.mutableCurrentMenu];
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
                // Find the id of the successful request and add it from the current menu list wherever it needs to be
                UInt32 commandId = [SDLMenuReplaceUtilities commandIdForRPCRequest:request];
                UInt16 position = [SDLMenuReplaceUtilities positionForRPCRequest:request];
                [SDLMenuReplaceUtilities addCellWithCellId:commandId position:position fromNewMenuList:newMenuCells toMainMenuList:weakSelf.mutableCurrentMenu];
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

#pragma mark - Dynamic Menu Helpers

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
    // The index of the status should correlate 1-1 with the number of items in the menu
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

- (void)sdl_transferCellIDsFromOldCells:(NSArray<SDLMenuCell *> *)oldCells toKeptCells:(NSArray<SDLMenuCell *> *)newCells {
    if (oldCells.count == 0) { return; }
    for (NSUInteger i = 0; i < newCells.count; i++) {
        newCells[i].cellId = oldCells[i].cellId;
    }
}

#pragma mark - Menu Uniqueness

+ (NSArray<SDLMenuCell *> *)sdl_cellsWithRemovedPropertiesFromCells:(NSArray<SDLMenuCell *> *)menuCells basedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    NSArray<SDLMenuCell *> *removePropertiesCopy = [[NSArray alloc] initWithArray:menuCells copyItems:YES];
    for (SDLMenuCell *cell in removePropertiesCopy) {
        // Strip away fields that cannot be used to determine uniqueness visually including fields not supported by the HMI
        cell.voiceCommands = nil;

        // Don't check SDLImageFieldNameSubMenuIcon because it was added in 7.0 when the feature was added in 5.0. Just assume that if CommandIcon is not available, the submenu icon is not either.
        if (![windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon]) {
            cell.icon = nil;
        }

        if (cell.subCells != nil) {
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuSubMenuSecondaryText]) {
                cell.secondaryText = nil;
            }
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuSubMenuTertiaryText]) {
                cell.tertiaryText = nil;
            }
            if (![windowCapability hasImageFieldOfName:SDLImageFieldNameMenuSubMenuSecondaryImage]) {
                cell.secondaryArtwork = nil;
            }
            cell.subCells = [self sdl_cellsWithRemovedPropertiesFromCells:cell.subCells basedOnWindowCapability:windowCapability];
        } else {
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandSecondaryText]) {
                cell.secondaryText = nil;
            }
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandTertiaryText]) {
                cell.tertiaryText = nil;
            }
            if (![windowCapability hasImageFieldOfName:SDLImageFieldNameMenuCommandSecondaryImage]) {
                cell.secondaryArtwork = nil;
            }
        }
    }

    return removePropertiesCopy;
}

+ (void)sdl_generateUniqueNamesForCells:(NSArray<SDLMenuCell *> *)menuCells supportsMenuUniqueness:(BOOL)supportsMenuUniqueness {
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<id<NSCopying>, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];
    for (NSUInteger i = 0; i < menuCells.count; i++) {
        id<NSCopying> key = supportsMenuUniqueness ? menuCells[i] : menuCells[i].title;
        NSNumber *counter = dictCounter[key];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[key] = counter;
        } else {
            dictCounter[key] = @1;
        }

        counter = dictCounter[key];
        if (counter.intValue > 1) {
            menuCells[i].uniqueTitle = [NSString stringWithFormat: @"%@ (%d)", menuCells[i].title, counter.intValue];
        }

        if (menuCells[i].subCells.count > 0) {
            [self sdl_generateUniqueNamesForCells:menuCells[i].subCells supportsMenuUniqueness:supportsMenuUniqueness];
        }
    }
}

+ (void)sdl_applyUniqueNamesOnCells:(NSArray<SDLMenuCell *> *)fromMenuCells toCells:(NSArray<SDLMenuCell *> *)toMenuCells {
    NSParameterAssert(fromMenuCells.count == toMenuCells.count);

    for (NSUInteger i = 0; i < fromMenuCells.count; i++) {
        toMenuCells[i].uniqueTitle = fromMenuCells[i].uniqueTitle;
        if (fromMenuCells[i].subCells.count > 0) {
            [self sdl_applyUniqueNamesOnCells:fromMenuCells[i].subCells toCells:toMenuCells[i].subCells];
        }
    }
}

#pragma mark - Getter / Setters

- (void)setCurrentMenu:(NSArray<SDLMenuCell *> *)currentMenu {
    _mutableCurrentMenu = [currentMenu mutableCopy];
}

- (NSArray<SDLMenuCell *> *)currentMenu {
    return [_mutableCurrentMenu copy];
}

#pragma mark - Operation Overrides

- (void)finishOperationWithError:(nullable NSError *)error {
    if (error != nil) {
        self.internalError = error;
    }

    [self finishOperation];
}

- (void)finishOperation {
    SDLLogV(@"Finishing menu manager dynamic replace operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_menuManager_replaceOperationCancelled];
    }

    self.currentMenuUpdatedHandler(self.currentMenu, self.error);
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
