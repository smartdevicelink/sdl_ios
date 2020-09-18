//
//  SDLTextAndGraphicUpdateOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/13/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

@class SDLArtwork;
@class SDLFileManager;
@class SDLImageField;
@class SDLTextField;
@class SDLShow;
@class SDLTemplateConfiguration;
@class SDLTextAndGraphicState;
@class SDLWindowCapability;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLTextAndGraphicUpdateCompletionHandler)(NSError *__nullable error);
typedef void(^CurrentDataUpdatedHandler)(SDLTextAndGraphicState *__nullable newScreenData, NSError *__nullable error);

@interface SDLTextAndGraphicUpdateOperation : SDLAsynchronousOperation

/// The current state of the screen in TextAndGraphicState form. This is passed as a dependency in the init but it may need to be updated if a previous operation updated the state of the screen. This will be updated with new screen data when this operation sends successful shows.
@property (strong, nonatomic) SDLTextAndGraphicState *currentScreenData;

/// Initialize the operation with its dependencies
/// @param connectionManager The connection manager to send RPCs
/// @param fileManager The file manager to upload artwork
/// @param currentCapabilities The current window capability describing whether or not image fields and text fields are supported
/// @param currentData The current show data to determine which text and image fields need to be sent
/// @param newState The new text and graphic manager state to be compared with currentData and sent in a Show update if needed.
/// @param updateCompletionHandler The handler potentially passed by the developer to be called when the update finishes
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager currentCapabilities:(SDLWindowCapability *)currentCapabilities currentScreenData:(SDLTextAndGraphicState *)currentData newState:(SDLTextAndGraphicState *)newState currentScreenDataUpdatedHandler:(CurrentDataUpdatedHandler)currentDataUpdatedHandler updateCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)updateCompletionHandler;

@end

NS_ASSUME_NONNULL_END
