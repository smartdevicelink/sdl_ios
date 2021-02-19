//
//  SDLMenuManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLMenuManagerConstants.h"

@class SDLFileManager;
@class SDLMenuCell;
@class SDLMenuConfiguration;
@class SDLSystemCapabilityManager;
@class SDLVoiceCommand;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLMenuUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLMenuManager : NSObject

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager;

/// Starts the manager. This method is used internally.
- (void)start;

/// Stops the manager. This method is used internally.
- (void)stop;

@property (strong, nonatomic) SDLMenuConfiguration *menuConfiguration;

/**
 The menuCells array do not support 2 or more duplicate cells.

 In a state where 2 or more cells contains the same Title but are otherwise distinctive, unique identifiers will be appended in the style (2), (3), (4), etc. to those cells Title.

 Each list of subCells and the main menuCells are compared separately, which means you can have duplicate cells between the main menu and a subcell list without a conflict occurring.
 */
@property (copy, nonatomic) NSArray<SDLMenuCell *> *menuCells;

@property (assign, nonatomic) SDLDynamicMenuUpdatesMode dynamicMenuUpdatesMode;

- (BOOL)openMenu;

- (BOOL)openSubmenu:(SDLMenuCell *)cell;

@end

NS_ASSUME_NONNULL_END
