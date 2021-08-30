//
//  SDLPreloadPresentChoiceSetOperationUtilities.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/27/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLChoiceCell;
@class SDLChoiceSet;
@class SDLWindowCapability;

NS_ASSUME_NONNULL_BEGIN

@interface SDLPreloadPresentChoicesOperationUtilities : NSObject

@property (class, assign, nonatomic) UInt16 choiceId;
@property (class, assign, nonatomic) BOOL reachedMaxId;

/// Assigns a unique id to each choice item.
/// @param cells An array of choices
/// @param loadedCells The already loaded cells with ids to avoid
+ (void)assignIdsToCells:(NSOrderedSet<SDLChoiceCell *> *)cells loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells;

+ (void)makeCellsToUploadUnique:(NSMutableOrderedSet<SDLChoiceCell *> *)cellsToUpload choiceSet:(nullable SDLChoiceSet *)choiceSet basedOnLoadedCells:(NSMutableSet<SDLChoiceCell *> *)loadedCells windowCapability:(SDLWindowCapability *)windowCapability;
+ (void)updateChoiceSet:(SDLChoiceSet *)choiceSet withLoadedCells:(NSSet<SDLChoiceCell *> *)loadedCells cellsToUpload:(NSSet<SDLChoiceCell *> *)cellsToUpload;

@end

NS_ASSUME_NONNULL_END
