//
//  SDLMenuReplaceStaticOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/20/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuReplaceStaticOperation.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLMenuCell.h"
#import "SDLMenuConfiguration.h"
#import "SDLMenuReplaceUtilities.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLMenuUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLMenuReplaceStaticOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) NSArray<SDLMenuCell *> *currentMenu;
@property (strong, nonatomic) NSArray<SDLMenuCell *> *updatedMenu;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLMenuReplaceStaticOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability menuConfiguration:(SDLMenuConfiguration *)menuConfiguration currentMenu:(NSArray<SDLMenuCell *> *)currentMenu updatedMenu:(NSArray<SDLMenuCell *> *)updatedMenu {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _windowCapability = windowCapability;
    _menuConfiguration = menuConfiguration;
    _currentMenu = currentMenu;
    _updatedMenu = updatedMenu;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) {
        [self finishOperation];
        return;
    }

    // TODO: We don't check cancellation or finish

    NSArray<SDLArtwork *> *artworksToBeUploaded = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:self.updatedMenu fileManager:self.fileManager windowCapability:self.windowCapability];
    if (artworksToBeUploaded.count > 0) {
        [self.fileManager uploadArtworks:artworksToBeUploaded completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
            if (error != nil) {
                SDLLogE(@"Error uploading menu artworks: %@", error);
            }

            SDLLogD(@"Menu artworks uploaded");
            [self sdl_updateMenuWithCellsToDelete:self.currentMenu cellsToAdd:self.updatedMenu completionHandler:nil];
        }];
    } else {
        // Cells have no artwork to load
        [self sdl_updateMenuWithCellsToDelete:self.currentMenu cellsToAdd:self.updatedMenu completionHandler:nil];
    }
}

#pragma mark - Private Helpers

#pragma mark Sending Items

- (void)sdl_updateMenuWithCellsToDelete:(NSArray<SDLMenuCell *> *)deleteCells cellsToAdd:(NSArray<SDLMenuCell *> *)addCells completionHandler:(nullable SDLMenuUpdateCompletionHandler)completionHandler {
    __weak typeof(self) weakself = self;
    [self sdl_sendDeleteCurrentMenu:deleteCells withCompletionHandler:^(NSError * _Nullable error) {
        [weakself sdl_sendNewMenuCells:addCells withCompletionHandler:^(NSError * _Nullable error) { }];
    }];
}

/**
 Creates add commands

 @param newMenuCells The cells you will be adding
 @param completionHandler handler
 */
- (void)sdl_sendNewMenuCells:(NSArray<SDLMenuCell *> *)newMenuCells withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.updatedMenu.count == 0 || newMenuCells.count == 0) {
        SDLLogD(@"There are no cells to update.");
        completionHandler(nil);
        return;
    }

    NSArray<SDLRPCRequest *> *mainMenuCommands = nil;
    NSArray<SDLRPCRequest *> *subMenuCommands = nil;

    if (![SDLMenuReplaceUtilities shouldRPCsIncludeImages:self.updatedMenu fileManager:self.fileManager] || ![self.windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon]) {
        // Send artwork-less menu
        mainMenuCommands = [SDLMenuReplaceUtilities mainMenuCommandsForCells:newMenuCells withArtwork:NO usingIndexesFrom:self.updatedMenu availableMenuLayouts:self.windowCapability.menuLayoutsAvailable defaultSubmenuLayout:self.menuConfiguration.defaultSubmenuLayout];
        subMenuCommands =  [SDLMenuReplaceUtilities subMenuCommandsForCells:newMenuCells withArtwork:NO availableMenuLayouts:self.windowCapability.menuLayoutsAvailable defaultSubmenuLayout:self.menuConfiguration.defaultSubmenuLayout];
    } else {
        // Send full artwork menu
        mainMenuCommands = [SDLMenuReplaceUtilities mainMenuCommandsForCells:newMenuCells withArtwork:YES usingIndexesFrom:self.updatedMenu availableMenuLayouts:self.windowCapability.menuLayoutsAvailable defaultSubmenuLayout:self.menuConfiguration.defaultSubmenuLayout];
        subMenuCommands = [SDLMenuReplaceUtilities subMenuCommandsForCells:newMenuCells withArtwork:YES availableMenuLayouts:self.windowCapability.menuLayoutsAvailable defaultSubmenuLayout:self.menuConfiguration.defaultSubmenuLayout];
    }

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

#pragma mark Delete Old Menu Items

- (void)sdl_sendDeleteCurrentMenu:(nullable NSArray<SDLMenuCell *> *)deleteMenuCells withCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (deleteMenuCells.count == 0) {
        completionHandler(nil);
        return;
    }

    NSArray<SDLRPCRequest *> *deleteMenuCommands = [SDLMenuReplaceUtilities deleteCommandsForCells:deleteMenuCells];
    [self.connectionManager sendRequests:deleteMenuCommands progressHandler:nil completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogW(@"Unable to delete all old menu commands");
        } else {
            SDLLogD(@"Finished deleting old menu");
        }

        completionHandler(nil);
    }];
}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing menu manager configuration update operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_menuManager_openMenuOperationCancelled];
    }

    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.menuManager.replaceMenu.static";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
