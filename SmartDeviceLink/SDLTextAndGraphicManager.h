//
//  SDLTextAndGraphicManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLArtwork;
@class SDLFileManager;
@class SDLTextAndGraphicConfiguration;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLTextAndGraphicUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLTextAndGraphicManager : NSObject

/**
 The current configuration of text metadata and alignment. If this is set, it will not change the current data on the screen but will take effect on the next update.
 */
@property (copy, nonatomic) SDLTextAndGraphicConfiguration *configuration;

/**
 A text field that corresponds to SDLShow mainField1. Setting to nil is equivalent to setting an empty string.
 */
@property (copy, nonatomic, nullable) NSString *textField1;
@property (copy, nonatomic, nullable) NSString *textField2;
@property (copy, nonatomic, nullable) NSString *textField3;
@property (copy, nonatomic, nullable) NSString *textField4;
@property (strong, nonatomic, nullable) SDLArtwork *primaryGraphic;
@property (strong, nonatomic, nullable) SDLArtwork *secondaryGraphic;

/**
 If you want to make a graphic blank, set it to this artwork
 */
@property (strong, nonatomic, readonly) SDLArtwork *blankArtwork;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a Text and Image Manager with a custom SDLTextAndImageConfiguration.

 @return A new SDLTextAndImageManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

- (void)beginUpdates;

/**
 Update text fields with new text set into the text field properties. Pass an empty string `\@""` to clear the text field.

 If the system does not support a full 4 fields, this will automatically be concatenated and properly send the field available.

 If 3 lines are available: [field1, field2, field3 - field 4]

 If 2 lines are available: [field1 - field2, field3 - field4]

 If 1 line is available: [field1 - field2 - field3 - field4]

 Also updates the primary and secondary images with new image(s) if new one(s) been set. This method will take care of naming the files (based on a hash). This is assumed to be a non-persistant image.

 If it needs to be uploaded, it will be. Once the upload is complete, the on-screen graphic will be updated.

 @param handler A handler run when the fields have finished updating, with an error if the update failed. This handler may be called multiple times when the text update is sent and the image update is sent.
 */
- (void)endUpdatesWithCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
