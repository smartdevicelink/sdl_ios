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
#import "SDLDeleteCommand.h"
#import "SDLImage.h"
#import "SDLMenuCell.h"
#import "SDLMenuParams.h"
#import "SDLOnCommand.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLVoiceCommand.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuManager()

@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

// The top level of AddCommands & AddSubMenus
@property (copy, nonatomic) NSArray<SDLRPCRequest *> *cellCommands;
@property (copy, nonatomic) NSArray<SDLAddCommand *> *voiceCommandCommands;

@end

@implementation SDLMenuManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_commandNotification:) name:SDLDidReceiveCommandNotification object:nil];

    return self;
}

- (void)sdl_updateWithCompletionHandler:(SDLMenuUpdateCompletionHandler)completionHandler {
    // Upload images that need it

    // Delete old commands, keep voice commands

    // Add new commands once images are uploaded
}

#pragma mark - Setters

- (void)setMenuCells:(NSArray<SDLMenuCell *> *)menuCells {
    _menuCells = menuCells;
}

- (void)setVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    _voiceCommands = voiceCommands;
}

#pragma mark - Helpers

- (NSArray<SDLDeleteCommand *> *)deleteCommandsForCurrentCells {
    NSMutableArray<SDLDeleteCommand *> *mutableDeletes = [NSMutableArray array];
    for (SDLRPCRequest *request in self.voiceCommandCommands) {
        if ([request isKindOfClass:[SDLAddCommand class]]) {
            SDLAddCommand *command = (SDLAddCommand *)request;
            SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:command.cmdID.unsignedIntValue];
            [mutableDeletes addObject:delete];
        } else if ([request isKindOfClass:[SDLAddSubMenu class]]) {
            SDLAddSubMenu *subMenu = (SDLAddSubMenu *)request;
            SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:subMenu.menuID.unsignedIntValue];
            [mutableDeletes addObject:delete];
        } else {
            NSAssert(NO, @"Menu manager only handles AddSubMenu and AddCommand, not %@", [request class]);
        }
    }

    return [mutableDeletes copy];
}

- (NSArray<SDLDeleteCommand *> *)deleteCommandsForCurrentVoiceCommands {
    NSMutableArray<SDLDeleteCommand *> *mutableDeletes = [NSMutableArray array];
    for (SDLAddCommand *command in self.voiceCommandCommands) {
        SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:command.cmdID.unsignedIntValue];
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

@end

NS_ASSUME_NONNULL_END
