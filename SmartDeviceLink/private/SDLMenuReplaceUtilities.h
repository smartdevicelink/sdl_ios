//
//  SDLMenuReplaceUtilities.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/22/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLMenuLayout.h"

@class SDLArtwork;
@class SDLFileManager;
@class SDLMenuCell;
@class SDLRPCRequest;
@class SDLWindowCapability;

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuReplaceUtilities : NSObject

+ (NSArray<SDLRPCRequest *> *)deleteCommandsForCells:(NSArray<SDLMenuCell *> *)cells;

+ (NSArray<SDLRPCRequest *> *)mainMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager usingIndexesFrom:(NSArray<SDLMenuCell *> *)menu windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout;
+ (NSArray<SDLRPCRequest *> *)subMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout;

+ (NSArray<SDLArtwork *> *)findAllArtworksToBeUploadedFromCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability;

@end

NS_ASSUME_NONNULL_END
