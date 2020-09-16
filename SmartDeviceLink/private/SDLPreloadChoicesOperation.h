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

typedef NS_ENUM(NSUInteger, SDLPreloadChoicesOperationState) {
    SDLPreloadChoicesOperationStateWaitingToStart,
    SDLPreloadChoicesOperationStateUploadingArtworks,
    SDLPreloadChoicesOperationStatePreloadingChoices,
    SDLPreloadChoicesOperationStateFinished
};

@interface SDLPreloadChoicesOperation : SDLAsynchronousOperation

@property (assign, nonatomic) SDLPreloadChoicesOperationState currentState;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)defaultMainWindowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSSet<SDLChoiceCell *> *)cells;

- (BOOL)removeChoicesFromUpload:(NSSet<SDLChoiceCell *> *)choices;

@end

NS_ASSUME_NONNULL_END
