//
//  SDLPreloadChoicesOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"

@class SDLChoiceCell;
@class SDLFileManager;
@class SDLWindowCapability;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLPreloadChoicesCompletionHandler)(NSSet<SDLChoiceCell *> *updatedLoadedCells, NSError *_Nullable error);

typedef NS_ENUM(NSUInteger, SDLPreloadChoicesOperationState) {
    SDLPreloadChoicesOperationStateWaitingToStart,
    SDLPreloadChoicesOperationStateUploadingArtworks,
    SDLPreloadChoicesOperationStatePreloadingChoices,
    SDLPreloadChoicesOperationStateFinished
};

@interface SDLPreloadChoicesOperation : SDLAsynchronousOperation

@property (assign, nonatomic) SDLPreloadChoicesOperationState currentState;

/// The cells that are loaded on the head unit
@property (strong, nonatomic) NSSet<SDLChoiceCell *> *loadedCells;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)defaultMainWindowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSOrderedSet<SDLChoiceCell *> *)cellsToPreload loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells completionHandler:(SDLPreloadChoicesCompletionHandler)completionHandler;

- (BOOL)removeChoicesFromUpload:(NSSet<SDLChoiceCell *> *)choices;

@end

NS_ASSUME_NONNULL_END
