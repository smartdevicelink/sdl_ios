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

/// A handler run when the operation completes, containing the failed choice uploads.
///
/// @param failedChoiceUploads The ids of failed choice uploads; nil if no choices failed to upload
typedef void(^SDLPreloadChoicesCompletionHandler)(NSArray<NSNumber *> * _Nullable failedChoiceUploads);

typedef NS_ENUM(NSUInteger, SDLPreloadChoicesOperationState) {
    SDLPreloadChoicesOperationStateWaitingToStart,
    SDLPreloadChoicesOperationStateUploadingArtworks,
    SDLPreloadChoicesOperationStatePreloadingChoices,
    SDLPreloadChoicesOperationStateFinished
};

@interface SDLPreloadChoicesOperation : SDLAsynchronousOperation

@property (assign, nonatomic) SDLPreloadChoicesOperationState currentState;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)defaultMainWindowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSOrderedSet<SDLChoiceCell *> *)cells updateCompletionHandler:(SDLPreloadChoicesCompletionHandler)completionHandler;

- (BOOL)removeChoicesFromUpload:(NSSet<SDLChoiceCell *> *)choices;
- (BOOL)addChoicesToUpload:(NSSet<SDLChoiceCell *> *)choices;

@end

NS_ASSUME_NONNULL_END
