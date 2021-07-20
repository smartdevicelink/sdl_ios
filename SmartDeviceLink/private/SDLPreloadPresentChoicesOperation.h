//
//  SDLPreloadChoicesOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"
#import "SDLInteractionMode.h"
#import "SDLKeyboardDelegate.h"
#import "SDLTriggerSource.h"

@class SDLChoiceCell;
@class SDLChoiceSet;
@class SDLFileManager;
@class SDLKeyboardProperties;
@class SDLWindowCapability;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLUploadChoicesCompletionHandler)(NSSet<SDLChoiceCell *> *updatedLoadedCells, NSError *_Nullable error);

typedef void(^SDLPresentChoiceSetCompletionHandler)(SDLChoiceCell *_Nullable selectedCell, NSUInteger selectedRow, SDLTriggerSource selectedTriggerSource, NSError *_Nullable error);

@interface SDLPreloadPresentChoicesOperation : SDLAsynchronousOperation

/// The cells that are loaded on the head unit
@property (strong, nonatomic) NSSet<SDLChoiceCell *> *loadedCells;

// Preload only init
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)defaultMainWindowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSOrderedSet<SDLChoiceCell *> *)cellsToPreload loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells preloadCompletionHandler:(SDLUploadChoicesCompletionHandler)preloadCompletionHandler;

/// Preload and Present Init
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode  keyboardProperties:(nullable SDLKeyboardProperties *)originalKeyboardProperties keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate cancelID:(UInt16)cancelID displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)windowCapability isVROptional:(BOOL)isVROptional loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells preloadCompletionHandler:(SDLUploadChoicesCompletionHandler)preloadCompletionHandler presentCompletionHandler:(SDLPresentChoiceSetCompletionHandler)presentCompletionHandler;

@end

NS_ASSUME_NONNULL_END
