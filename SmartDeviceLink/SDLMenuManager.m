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
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLMenuCell.h"
#import "SDLMenuParams.h"
#import "SDLOnCommand.h"
#import "SDLOnHMIStatus.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLVoiceCommand.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 cellId;

@end

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

@interface SDLMenuManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (strong, nonatomic, nullable) NSArray<SDLRPCRequest *> *inProgressUpdate;
@property (copy, nonatomic, nullable) SDLMenuUpdateCompletionHandler inProgressHandler;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLMenuUpdateCompletionHandler queuedUpdateHandler;
@property (assign, nonatomic) BOOL waitingOnHMILevelUpdate;

@end

@implementation SDLMenuManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

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

    _menuCells = @[];
    _voiceCommands = @[];

    return self;
}

- (void)sdl_updateWithCompletionHandler:(nullable SDLMenuUpdateCompletionHandler)completionHandler {
    // Upload images that need it

    // Delete old commands, keep voice commands

    // Add new commands once images are uploaded
}

#pragma mark - Setters

- (void)setMenuCells:(NSArray<SDLMenuCell *> *)menuCells {
    if (self.currentLevel == nil || [self.currentLevel isEqualToString:SDLHMILevelNone]) {
        _waitingOnHMILevelUpdate = YES;
        _menuCells = menuCells;
        return;
    }

    // Set the ids

    _menuCells = menuCells;

    [self sdl_updateWithCompletionHandler:nil];
}

- (void)setVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    if (self.currentLevel == nil || [self.currentLevel isEqualToString:SDLHMILevelNone]) {
        _waitingOnHMILevelUpdate = YES;
        _voiceCommands = voiceCommands;
        return;
    }

    // Set the ids
    
    _voiceCommands = voiceCommands;

    [self sdl_updateWithCompletionHandler:nil];
}

#pragma mark - Helpers

- (NSArray<SDLRPCRequest *> *)deleteCommandsForCurrentCells {
    NSMutableArray<SDLRPCRequest *> *mutableDeletes = [NSMutableArray array];
    for (SDLMenuCell *cell in self.menuCells) {
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

- (NSArray<SDLDeleteCommand *> *)deleteCommandsForCurrentVoiceCommands {
    NSMutableArray<SDLDeleteCommand *> *mutableDeletes = [NSMutableArray array];
    for (SDLVoiceCommand *command in self.voiceCommands) {
        SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:command.commandId];
        [mutableDeletes addObject:delete];
    }

    return [mutableDeletes copy];
}

- (SDLAddCommand *)sdl_commandForMenuCell:(SDLMenuCell *)cell withParentCellId:(nullable NSNumber<SDLInt> *)parentId {
    SDLAddCommand *command = [[SDLAddCommand alloc] init];

    SDLMenuParams *params = [[SDLMenuParams alloc] init];
    params.menuName = cell.title;
    params.parentID = parentId;

    command.menuParams = params;
    command.vrCommands = cell.voiceCommands;
    command.cmdIcon = cell.icon ? [[SDLImage alloc] initWithName:cell.icon.name] : nil;

    return command;
}

- (SDLAddSubMenu *)sdl_subMenuCommandForMenuCell:(SDLMenuCell *)cell {
    return [[SDLAddSubMenu alloc] initWithId:0 menuName:cell.title];
}

- (SDLAddCommand *)sdl_commandForVoiceCommand:(SDLVoiceCommand *)voiceCommand {
    SDLAddCommand *command = [[SDLAddCommand alloc] init];
    command.vrCommands = voiceCommand.voiceCommands;

    return command;
}

#pragma mark - Observers

- (void)sdl_commandNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnCommand *onCommand = (SDLOnCommand *)notification.notification;

    NSArray<id> *allCommands = [self.menuCells arrayByAddingObjectsFromArray:self.voiceCommands];
    for (id object in allCommands) {
        if ([object isKindOfClass:[SDLMenuCell class]]) {
            SDLMenuCell *cell = (SDLMenuCell *)object;
            if (onCommand.cmdID.unsignedIntegerValue != cell.cellId) { continue; }

            cell.handler();
            break;
        } else if ([object isKindOfClass:[SDLVoiceCommand class]]) {
            SDLVoiceCommand *voiceCommand = (SDLVoiceCommand *)object;
            if (onCommand.cmdID.unsignedIntegerValue != voiceCommand.commandId) { continue; }

            voiceCommand.handler();
            break;
        }
    }

}

- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;

    // Auto-send an updated show
    [self sdl_updateWithCompletionHandler:nil];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;

    SDLHMILevel oldHMILevel = self.currentLevel;
    self.currentLevel = hmiStatus.hmiLevel;

    // Auto-send an updated show if we were in NONE and now we are not
    if ([oldHMILevel isEqualToString:SDLHMILevelNone] && ![self.currentLevel isEqualToString:SDLHMILevelNone]) {
        if (self.waitingOnHMILevelUpdate) {
            [self setMenuCells:_menuCells];
            [self setVoiceCommands:_voiceCommands];
        } else {
            [self sdl_updateWithCompletionHandler:nil];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
