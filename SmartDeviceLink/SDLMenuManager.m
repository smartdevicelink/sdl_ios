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
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLMenuCell.h"
#import "SDLMenuParams.h"
#import "SDLMenuRunScore.h"
#import "SDLMenuUpdateAlgorithm.h"
#import "SDLOnCommand.h"
#import "SDLOnHMIStatus.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLVoiceCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@interface SDLMenuManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (strong, nonatomic, nullable) NSArray<SDLRPCRequest *> *inProgressUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (assign, nonatomic) BOOL waitingOnHMIUpdate;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *waitingUpdateMenuCells;

@property (assign, nonatomic) UInt32 lastMenuId;
@property (copy, nonatomic) NSArray<SDLMenuCell *> *oldMenuCells;
@property (copy, nonatomic, nullable) SDLMenuRunScore *runScore;
@end

UInt32 const ParentIdNotFound = UINT32_MAX;
UInt32 const MenuCellIdMin = 1;

@implementation SDLMenuManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _lastMenuId = MenuCellIdMin;
    _menuCells = @[];
    _oldMenuCells = @[];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_commandNotification:) name:SDLDidReceiveCommandNotification object:nil];

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;

    return self;
}

- (void)stop {
    _lastMenuId = MenuCellIdMin;
    _menuCells = @[];
    _oldMenuCells = @[];

    _currentHMILevel = nil;
    _currentSystemContext = SDLSystemContextMain;
    _displayCapabilities = nil;
    _inProgressUpdate = nil;
    _hasQueuedUpdate = NO;
    _waitingOnHMIUpdate = NO;
    _waitingUpdateMenuCells = @[];
    _runScore = nil;
}

#pragma mark - Setters

- (void)setMenuCells:(NSArray<SDLMenuCell *> *)menuCells {
    if (self.currentHMILevel == nil
        || [self.currentHMILevel isEqualToEnum:SDLHMILevelNone]
        || [self.currentSystemContext isEqualToEnum:SDLSystemContextMenu]) {
        self.waitingOnHMIUpdate = YES;
        self.waitingUpdateMenuCells = menuCells;
        return;
    }

    self.waitingOnHMIUpdate = NO;

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

    _oldMenuCells = _menuCells;
    _menuCells = menuCells;

    // RunScore will contain the best possible combination of ADD and Delete Commmands. There will be 2 arrays, OldCell(Deletes/Keeps) NewCells(Adds/Keeps),
    // When the Adds and Deletes are removed from their respetive arrays the KEEPS should match at index in both arrays.
    _runScore = [SDLMenuUpdateAlgorithm compareOldMenuCells:self.oldMenuCells updatedMenuCells:self.menuCells];

    // Here we create a temproaray array to store the values from the RunScore object.
    NSArray<NSNumber *> *deleteMenuStatus = self.runScore.oldStatus;
    NSArray<NSNumber *> *addMenuStatus = self.runScore.updatedStatus;

    // The following arrays are going to be sets of ONLY cells we want DELETE and cells we want to ADD
    NSArray<SDLMenuCell *> *cellsToDelete = [self buildDeleteMenuItems: deleteMenuStatus compareTo:self.oldMenuCells];
    NSArray<SDLMenuCell *> *cellsToAdd = [self buildAddMenuItems:addMenuStatus compareTo:self.menuCells];

    // The following arrays are going to be contain cells we wish to keep. We will use these to compare the submenus of each cell
    NSArray<SDLMenuCell *> *oldKeeps = [self buildOldKeepMenuItems: deleteMenuStatus compareTo:self.oldMenuCells];
    NSArray<SDLMenuCell *> *newKeeps = [self buildKeepNewMenuItems: addMenuStatus compareTo:self.menuCells];
    // Since we may be addnig cells to the list we need to update those cells to have a cellID
    [self sdl_updateIdsOnMenuCells:cellsToAdd parentId:ParentIdNotFound];
    // Since we are creating a new Menu but keeping old cells we must firt transfer the old cellIDs to the new menus kept cells.
    [self transferCellIDFromOldCells:oldKeeps toKeptCells:newKeeps];

    // Upload the artworks
    NSArray<SDLArtwork *> *artworksToBeUploaded = [self sdl_findAllArtworksToBeUploadedFromCells:self.menuCells];
    if (artworksToBeUploaded.count > 0) {
        [self.fileManager uploadArtworks:artworksToBeUploaded completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
            if (error != nil) {
                SDLLogE(@"Error uploading menu artworks: %@", error);
            }
            SDLLogD(@"Menu artworks uploaded");
            [self sdl_updateCellsToDelete:cellsToDelete cellsToAdd:cellsToAdd withCompletionHandler:nil];
        }];
    }

    __weak typeof(self) weakself = self;
    [self sdl_updateCellsToDelete:cellsToDelete cellsToAdd:cellsToAdd withCompletionHandler:^(NSError * _Nullable error) {
        [weakself sendSubMenuUpdates:oldKeeps newKeepCell:newKeeps atIndex:0];
    }];
}

#pragma mark - Build Deletes, Keeps, Adds
- (void)sendSubMenuUpdates:(NSArray<SDLMenuCell *> *)oldKeptCells newKeepCell:(NSArray<SDLMenuCell *> *)newKeptCells atIndex:(NSUInteger)startIndex { //add an atIndex to be able to recursive this but keep track of the index we were at to do next set
    //for(NSUInteger index = startIndex; index < oldKeptCells.count; index++) {
    if(oldKeptCells.count == 0 || startIndex >= oldKeptCells.count) {
        return;
    }

    if(oldKeptCells[startIndex].subCells.count > 0) {
        SDLMenuRunScore *tempScore = [SDLMenuUpdateAlgorithm compareOldMenuCells:oldKeptCells[startIndex].subCells updatedMenuCells:newKeptCells[startIndex].subCells];
        NSArray<NSNumber *> *deleteMenuStatus = tempScore.oldStatus;
        NSArray<NSNumber *> *addMenuStatus = tempScore.updatedStatus;

        NSArray<SDLMenuCell *> *cellsToDelete = [self buildDeleteMenuItems:deleteMenuStatus compareTo:oldKeptCells[startIndex].subCells];
        NSArray<SDLMenuCell *> *cellsToAdd = [self buildAddMenuItems:addMenuStatus compareTo:newKeptCells[startIndex].subCells];

        NSArray<SDLMenuCell *> *oldKeeps = [self buildOldKeepMenuItems: deleteMenuStatus compareTo:oldKeptCells[startIndex].subCells];
        NSArray<SDLMenuCell *> *newKeeps = [self buildKeepNewMenuItems: addMenuStatus compareTo:newKeptCells[startIndex].subCells];

        //Update IDs on subcellls to be under their parent ID
        [self sdl_updateIdsOnMenuCells:cellsToAdd parentId:newKeptCells[startIndex].cellId];
        [self transferCellIDFromOldCells:oldKeeps toKeptCells:newKeeps];

        __weak typeof(self) weakself = self;
        [self sdl_sendDeleteCurrentMenu:cellsToDelete withCompletionHandler:^(NSError * _Nullable error) {
            [weakself sdl_sendUpdatedMenu:cellsToAdd usingMenu:weakself.menuCells[startIndex].subCells withCompletionHandler:^(NSError * _Nullable error) {
                [weakself sendSubMenuUpdates:oldKeptCells newKeepCell:newKeptCells atIndex:(startIndex + 1)];
            }];
        }];
    } else {
        [self sendSubMenuUpdates:oldKeptCells newKeepCell:newKeptCells atIndex:(startIndex + 1)];
    }
}

// Main Menu
- (NSArray<SDLMenuCell *> *)buildDeleteMenuItems:(NSArray<NSNumber *> *)oldStatusList compareTo:(NSArray<SDLMenuCell *> *)oldList {
    NSMutableArray<SDLMenuCell *> *deleteCells = [[NSMutableArray alloc] init];
    // The index of the status should corrleate 1-1 with the number of items in the menu
    // [2,0,2,0] => [A,B,C,D] = [B,D]
    [oldStatusList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull status, NSUInteger index, BOOL * _Nonnull stop) {
        if(status.integerValue == 0) { // 0 means the cell was marked for Deletion
            [deleteCells addObject:oldList[index]];
        }
    }];
    return [deleteCells copy];
}

- (NSArray<SDLMenuCell *> *)buildAddMenuItems:(NSArray<NSNumber *> *)newStatusList compareTo:(NSArray<SDLMenuCell *> *)menuList {
    NSMutableArray<SDLMenuCell *> *addCells = [[NSMutableArray alloc] init];
    // The index of the status should corrleate 1-1 with the number of items in the menu
    // [2,1,2,1] => [A,B,C,D] = [B,D]
    [newStatusList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull status, NSUInteger index, BOOL * _Nonnull stop) {
        if(status.integerValue == 1) { // 1 means the cell was marked for add
            [addCells addObject:menuList[index]];
        }
    }];
    return [addCells copy];
}

- (NSArray<SDLMenuCell *> *)buildOldKeepMenuItems:(NSArray<NSNumber *> *)oldStatusList compareTo:(NSArray<SDLMenuCell *> *)oldList  {
    NSMutableArray<SDLMenuCell *> *keepMenuCells = [[NSMutableArray alloc] init];

    [oldStatusList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull status, NSUInteger index, BOOL * _Nonnull stop) {
        if(status.integerValue == 2) { // 2 means the cell was marked for Keep
            [keepMenuCells addObject:oldList[index]];
        }
    }];

    return [keepMenuCells copy];
}

- (NSArray<SDLMenuCell *> *)buildKeepNewMenuItems:(NSArray<NSNumber *> *)newStatusList compareTo:(NSArray<SDLMenuCell *> *)newList  {
    NSMutableArray<SDLMenuCell *> *keepMenuCells = [[NSMutableArray alloc] init];

    [newStatusList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull status, NSUInteger index, BOOL * _Nonnull stop) {
        if(status.integerValue == 2) { // 2 means the cell was marked for Keep
            [keepMenuCells addObject:newList[index]];
        }
    }];

    return [keepMenuCells copy];
}

- (void)transferCellIDFromOldCells:(NSArray<SDLMenuCell *> *)oldCells toKeptCells:(NSArray<SDLMenuCell *> *)newCells {
    if (oldCells.count == 0) { return; }
    for(NSUInteger i = 0; i < newCells.count; i++) {
        newCells[i].cellId = oldCells[i].cellId;
    }
}

#pragma mark - Updating System

- (void)sdl_updateCellsToDelete:(NSArray<SDLMenuCell *> *)deleteCells cellsToAdd:(NSArray<SDLMenuCell *> *)addCells withCompletionHandler:(nullable SDLMenuUpdateCompletionHandler)completionHandler {
    //create funtion to do this for subcells so we can use proper call backs.
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
        [weakself sdl_sendUpdatedMenu:addCells usingMenu: weakself.menuCells withCompletionHandler:^(NSError * _Nullable error) {
            weakself.inProgressUpdate = nil;

            if (completionHandler != nil) {
                completionHandler(error);
            }

            if (weakself.hasQueuedUpdate) {
                [weakself sdl_updateCellsToDelete:deleteCells cellsToAdd:addCells withCompletionHandler:nil];
                weakself.hasQueuedUpdate = NO;
            }
        }];
    }];
}

#pragma mark Delete Old Menu Items

- (void)sdl_sendDeleteCurrentMenu:(nullable NSArray<SDLMenuCell *> *)deleteMenuCells withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.oldMenuCells.count == 0 || deleteMenuCells == nil) {
        completionHandler(nil);
        return;
    }

    NSArray<SDLRPCRequest *> *deleteMenuCommands = [self sdl_deleteCommandsForCells: deleteMenuCells];
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

- (void)sdl_sendUpdatedMenu:(NSArray<SDLMenuCell *> *)updatedMenu usingMenu:(NSArray<SDLMenuCell *> *)menu withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.menuCells.count == 0) {
        SDLLogD(@"No main menu to send");
        completionHandler(nil);
        return;
    }

    NSArray<SDLRPCRequest *> *mainMenuCommands = nil;
    NSArray<SDLRPCRequest *> *subMenuCommands = nil;

    if ([self sdl_findAllArtworksToBeUploadedFromCells:self.menuCells].count > 0 || ![self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameCommandIcon]) {
        // Send artwork-less menu
        mainMenuCommands = [self sdl_mainMenuCommandsForCells:updatedMenu withArtwork:NO usingIndexOf:menu];
        subMenuCommands =  [self sdl_subMenuCommandsForCells:updatedMenu withArtwork:NO];
    } else {
        // Send full artwork menu
        mainMenuCommands = [self sdl_mainMenuCommandsForCells:updatedMenu withArtwork:YES usingIndexOf:menu];
        subMenuCommands = [self sdl_subMenuCommandsForCells:updatedMenu withArtwork:YES];
    }

    self.inProgressUpdate = [mainMenuCommands arrayByAddingObjectsFromArray:subMenuCommands];

    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:mainMenuCommands progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send main menu commands: %@", errors);
            completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
            return;
        }

        weakSelf.oldMenuCells = weakSelf.menuCells; // ASK about this what does oldMenuCells become now? Dont do this yet we need to delete // add subcells first
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

#pragma mark Artworks

- (NSArray<SDLArtwork *> *)sdl_findAllArtworksToBeUploadedFromCells:(NSArray<SDLMenuCell *> *)cells {
    if (![self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameCommandIcon]) {
        return @[];
    }

    NSMutableSet<SDLArtwork *> *mutableArtworks = [NSMutableSet set];
    for (SDLMenuCell *cell in cells) {
        if ([self sdl_artworkNeedsUpload:cell.icon]) {
            [mutableArtworks addObject:cell.icon];
        }

        if (cell.subCells.count > 0) {
            [mutableArtworks addObjectsFromArray:[self sdl_findAllArtworksToBeUploadedFromCells:cell.subCells]];
        }
    }

    return [mutableArtworks allObjects];
}

- (BOOL)sdl_artworkNeedsUpload:(SDLArtwork *)artwork {
    return (artwork != nil && ![self.fileManager hasUploadedFile:artwork] && !artwork.isStaticIcon);
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

#pragma mark Deletes

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

- (NSArray<SDLRPCRequest *> *)sdl_mainMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork usingIndexOf:(NSArray<SDLMenuCell *> *)menu {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];
    [menu enumerateObjectsUsingBlock:^(SDLMenuCell * _Nonnull menuCell, NSUInteger mainIndex, BOOL * _Nonnull stop) {
        [cells enumerateObjectsUsingBlock:^(SDLMenuCell * _Nonnull updatedCell, NSUInteger updatedIndex, BOOL * _Nonnull stop) {
            if([menuCell isEqual:updatedCell]) {
                if (updatedCell.subCells.count > 0) {
                    [mutableCommands addObject:[self sdl_subMenuCommandForMenuCell:updatedCell withArtwork:shouldHaveArtwork position:(UInt16)mainIndex]];
                } else {
                    [mutableCommands addObject:[self sdl_commandForMenuCell:updatedCell withArtwork:shouldHaveArtwork position:(UInt16)mainIndex]];
                }
            }
        }];
    }];

    return [mutableCommands copy];
}

- (NSArray<SDLRPCRequest *> *)sdl_subMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];
    for (SDLMenuCell *cell in cells) {
        if (cell.subCells.count > 0) {
            [mutableCommands addObjectsFromArray:[self sdl_allCommandsForCells:cell.subCells withArtwork:shouldHaveArtwork]];
        }
    }

    return [mutableCommands copy];
}

- (NSArray<SDLRPCRequest *> *)sdl_allCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];
    [cells enumerateObjectsUsingBlock:^(SDLMenuCell * _Nonnull cell, NSUInteger index, BOOL * _Nonnull stop) {
        if (cell.subCells.count > 0) {
            [mutableCommands addObject:[self sdl_subMenuCommandForMenuCell:cell withArtwork:shouldHaveArtwork position:(UInt16)index]];
            [mutableCommands addObjectsFromArray:[self sdl_allCommandsForCells:cell.subCells withArtwork:shouldHaveArtwork]];
        } else {
            [mutableCommands addObject:[self sdl_commandForMenuCell:cell withArtwork:shouldHaveArtwork position:(UInt16)index]];
        }
    }];

    return [mutableCommands copy];
}

//Loop thought keep compare to oldMenu and transfer cell Ids to new cells
- (SDLAddCommand *)sdl_commandForMenuCell:(SDLMenuCell *)cell withArtwork:(BOOL)shouldHaveArtwork position:(UInt16)position {
    SDLAddCommand *command = [[SDLAddCommand alloc] init];

    SDLMenuParams *params = [[SDLMenuParams alloc] init];
    params.menuName = cell.title;
    params.parentID = cell.parentCellId != UINT32_MAX ? @(cell.parentCellId) : nil;
    params.position = @(position);

    command.menuParams = params;
    command.vrCommands = cell.voiceCommands;
    command.cmdIcon = (cell.icon && shouldHaveArtwork) ? cell.icon.imageRPC : nil;
    command.cmdID = @(cell.cellId);

    return command;
}

- (SDLAddSubMenu *)sdl_subMenuCommandForMenuCell:(SDLMenuCell *)cell withArtwork:(BOOL)shouldHaveArtwork position:(UInt16)position {
    SDLImage *icon = (shouldHaveArtwork && (cell.icon.name != nil)) ? cell.icon.imageRPC : nil;
    return [[SDLAddSubMenu alloc] initWithId:cell.cellId menuName:cell.title menuIcon:icon position:(UInt8)position];
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

- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;

    if (!response.success.boolValue) { return; }
    if (response.displayCapabilities == nil) {
        SDLLogE(@"RegisterAppInterface succeeded but didn't send a display capabilities. A lot of things will probably break.");
        return;
    }

    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;

    if (!response.success.boolValue) { return; }
    if (response.displayCapabilities == nil) {
        SDLLogE(@"SetDisplayLayout succeeded but didn't send a display capabilities. A lot of things will probably break.");
        return;
    }

    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
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
