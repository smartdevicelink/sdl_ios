//
//  SDLTextAndGraphicManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLMetadataType.h"
#import "SDLTextAlignment.h"

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
 A text field that corresponds to SDLShow mainField1. Setting to nil is equivalent to setting an empty string.
 */
@property (copy, nonatomic, nullable) NSString *textField1;
@property (copy, nonatomic, nullable) NSString *textField2;
@property (copy, nonatomic, nullable) NSString *textField3;
@property (copy, nonatomic, nullable) NSString *textField4;
@property (copy, nonatomic, nullable) NSString *mediaTrackTextField;
@property (strong, nonatomic, nullable) SDLArtwork *primaryGraphic;
@property (strong, nonatomic, nullable) SDLArtwork *secondaryGraphic;

@property (copy, nonatomic, nullable) SDLTextAlignment alignment;
@property (copy, nonatomic, nullable) SDLMetadataType textField1Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField2Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField3Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField4Type;

/**
 If you want to make a graphic blank, set it to this artwork
 */
@property (strong, nonatomic, readonly) SDLArtwork *blankArtwork;

@property (assign, nonatomic, getter=isBatchingUpdates) BOOL batchUpdates;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a Text and Image Manager with a custom SDLTextAndImageConfiguration.

 @return A new SDLTextAndImageManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

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
- (void)updateWithCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
