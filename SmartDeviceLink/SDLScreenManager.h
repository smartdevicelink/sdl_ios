//
//  SDLScreenManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 3/5/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLMetadataType.h"
#import "SDLTextAlignment.h"

@class SDLArtwork;
@class SDLFileManager;
@class SDLMenuCell;
@class SDLVoiceCommand;
@class SDLSoftButtonObject;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLScreenManagerUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLScreenManager : NSObject

/**
 The top text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField1;

/**
 The second text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField2;

/**
 The third text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField3;

/**
 The fourth text field within a template layout
 */
@property (copy, nonatomic, nullable) NSString *textField4;

/**
 The media text field available within the media layout. Often less emphasized than textField(1-4)
 */
@property (copy, nonatomic, nullable) NSString *mediaTrackTextField;

/**
 The primary graphic within a template layout
 */
@property (strong, nonatomic, nullable) SDLArtwork *primaryGraphic;

/**
 A secondary graphic used in some template layouts
 */
@property (strong, nonatomic, nullable) SDLArtwork *secondaryGraphic;

/**
 What alignment textField(1-4) should use
 */
@property (copy, nonatomic) SDLTextAlignment textAlignment;

/**
 The type of data textField1 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField1Type;

/**
 The type of data textField2 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField2Type;

/**
 The type of data textField3 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField3Type;

/**
 The type of data textField4 describes
 */
@property (copy, nonatomic, nullable) SDLMetadataType textField4Type;

/**
 The current list of soft buttons within a template layout. Set this array to change the displayed soft buttons.
 */
@property (copy, nonatomic) NSArray<SDLSoftButtonObject *> *softButtonObjects;

/**
 The current list of menu cells displayed in the app's menu.
 */
@property (copy, nonatomic) NSArray<SDLMenuCell *> *menu;

/**
 The current list of voice commands available for the user to speak and be recognized by the IVI's voice recognition engine.
 */
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *voiceCommands;

/**
 Initialize a screen manager

 @warning For internal use

 @param connectionManager The connection manager used to send RPCs
 @param fileManager The file manager used to upload files
 @return The screen manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

/**
 Stops the manager.

 @warning For internal use
 */
- (void)stop;

/**
 Delays all screen updates until endUpdatesWithCompletionHandler: is called.
 */
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
- (void)endUpdatesWithCompletionHandler:(nullable SDLScreenManagerUpdateCompletionHandler)handler;

/**
 Find a current soft button object with a specific name

 @param name The name of the soft button object to find
 @return The soft button object or nil if there isn't one with that name
 */
- (nullable SDLSoftButtonObject *)softButtonObjectNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
