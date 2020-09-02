//
//  SDLSoftButtonReplaceOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonReplaceOperation.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonReplaceOperation ()

@property (strong, nonatomic, nullable) SDLSoftButtonCapabilities *softButtonCapabilities;
@property (strong, nonatomic) NSArray<SDLSoftButtonObject *> *softButtonObjects;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLSoftButtonReplaceOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager capabilities:(nullable SDLSoftButtonCapabilities *)capabilities softButtonObjects:(NSArray<SDLSoftButtonObject *> *)softButtonObjects mainField1:(NSString *)mainField1 {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _softButtonCapabilities = capabilities;
    _softButtonObjects = softButtonObjects;
    _mainField1 = mainField1;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    // Check if soft buttons have images and, if so, if the images need to be uploaded
    if (![self sdl_supportsSoftButtonImages]) {
        // The module does not support images
        SDLLogW(@"Soft button images are not supported. Attempting to send text-only soft buttons. If any button does not contain text, no buttons will be sent.");

        // Send text-only buttons if all current states for the soft buttons have text
        __weak typeof(self) weakself = self;
        [self sdl_sendCurrentStateTextOnlySoftButtonsWithCompletionHandler:^(BOOL success) {
            __strong typeof(weakself) strongself = weakself;
            if (!success) {
                SDLLogE(@"Buttons will not be sent because the module does not support images and some of the buttons do not have text");
            }
            [strongself finishOperation];
        }];
    } else if (![self sdl_allStateImagesAreUploaded]) {
        // If there are images in the first soft button state that have not yet been uploaded, send a text-only version of the soft buttons (the text-only buttons will only be sent if all the first button states have text)
        [self sdl_sendCurrentStateTextOnlySoftButtonsWithCompletionHandler:^(BOOL success) {}];

        // Upload images used in the first soft button state
        __weak typeof(self) weakself = self;
        [self sdl_uploadInitialStateImagesWithCompletionHandler:^{
            SDLLogV(@"Finished sending images for the first soft button states");
            // Now that the images have been uploaded, send the soft buttons with images
            __strong typeof(weakself) strongself = weakself;
            [strongself sdl_sendCurrentStateSoftButtonsWithCompletionHandler:^{
                // Finally, upload the images used in the other button states
                __strong typeof(weakself) strongself = weakself;
                [strongself sdl_uploadOtherStateImagesWithCompletionHandler:^{
                    __strong typeof(weakself) strongself = weakself;
                    SDLLogV(@"Finished sending images for the other soft button states");
                    [strongself finishOperation];
                }];
            }];
        }];
    } else {
        // All the images have been uploaded. Send initial soft buttons with images.
        __weak typeof(self) weakself = self;
        [self sdl_sendCurrentStateSoftButtonsWithCompletionHandler:^{
            __strong typeof(weakself) strongself = weakself;
            SDLLogV(@"Finished sending soft buttons with images");
            [strongself finishOperation];
        }];
    }
}


#pragma mark - Uploading Images

/// Upload the initial state images.
/// @param handler Called when all images have been uploaded
- (void)sdl_uploadInitialStateImagesWithCompletionHandler:(void (^)(void))handler {
    NSMutableArray<SDLArtwork *> *initialStatesToBeUploaded = [NSMutableArray array];
    for (SDLSoftButtonObject *object in self.softButtonObjects) {
        if ([self sdl_artworkNeedsUpload:object.currentState.artwork]) {
            [initialStatesToBeUploaded addObject:object.currentState.artwork];
        }
    }

    [self sdl_uploadImages:initialStatesToBeUploaded forStateName:@"Initial" completionHandler:handler];
}

/// Upload the other state images.
/// @param handler Called when all images have been uploaded
- (void)sdl_uploadOtherStateImagesWithCompletionHandler:(void (^)(void))handler {
    NSMutableArray<SDLArtwork *> *otherStatesToBeUploaded = [NSMutableArray array];
    for (SDLSoftButtonObject *object in self.softButtonObjects) {
        for (SDLSoftButtonState *state in object.states) {
            if ([state.name isEqualToString:object.currentState.name]) { continue; }
            if ([self sdl_artworkNeedsUpload:state.artwork]) {
                [otherStatesToBeUploaded addObject:state.artwork];
            }
        }
    }

    [self sdl_uploadImages:otherStatesToBeUploaded forStateName:@"Other" completionHandler:handler];
}

/// Helper method for uploading images
/// @param images The images to upload
/// @param stateName The name of the button states for which the images are being uploaded. Used for logs.
/// @param completionHandler Called when all images have been uploaded
- (void)sdl_uploadImages:(NSArray<SDLArtwork *> *)images forStateName:(NSString *)stateName completionHandler:(void (^)(void))completionHandler {
    if (images.count == 0) {
        SDLLogV(@"No images to upload for %@ states", stateName);
        completionHandler();
        return;
    }

    SDLLogD(@"Uploading images for %@ states", stateName);
    __weak typeof(self) weakself = self;
    [self.fileManager uploadArtworks:[images copy] progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
        __strong typeof(weakself) strongself = weakself;
        SDLLogV(@"Uploaded %@ states images: %@, error: %@, percent complete: %f.2%%", stateName, artworkName, error, uploadPercentage * 100);
        if (strongself.isCancelled) {
            [strongself finishOperation];
            return NO;
        }

        return YES;
    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error uploading %@ states images: %@", stateName, error);
        } else {
            SDLLogD(@"All %@ states images uploaded", stateName);
        }

        completionHandler();
    }];
}


#pragma mark - Sending the Soft Buttons

- (void)sdl_sendCurrentStateSoftButtonsWithCompletionHandler:(void (^)(void))handler {
    if (self.isCancelled) {
        [self finishOperation];
    }

    SDLLogV(@"Preparing to send full soft buttons");
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray arrayWithCapacity:self.softButtonObjects.count];
    for (SDLSoftButtonObject *buttonObject in self.softButtonObjects) {
        [softButtons addObject:buttonObject.currentStateSoftButton];
    }

    SDLShow *show = [[SDLShow alloc] init];
    show.mainField1 = self.mainField1;
    show.softButtons = [softButtons copy];

    [self.connectionManager sendConnectionRequest:show withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogW(@"Failed to update soft buttons with text buttons: %@", error);
        }

        SDLLogD(@"Finished sending text only soft buttons");
        handler();
    }];
}

/**
 Returns text soft buttons representing the current states of the button objects, or returns if _any_ of the buttons' current states are image only buttons.
*/
- (void)sdl_sendCurrentStateTextOnlySoftButtonsWithCompletionHandler:(void (^)(BOOL success))handler {
    if (self.isCancelled) {
        [self finishOperation];
    }

    SDLLogV(@"Preparing to send text-only soft buttons");
    NSMutableArray<SDLSoftButton *> *textButtons = [NSMutableArray arrayWithCapacity:self.softButtonObjects.count];
    for (SDLSoftButtonObject *buttonObject in self.softButtonObjects) {
        SDLSoftButton *button = buttonObject.currentStateSoftButton;
        if (button.text == nil) {
            SDLLogW(@"Attempted to create text buttons, but some buttons don't support text, so no text-only soft buttons will be sent");
            handler(NO);
            return;
        }

        button.image = nil;
        button.type = SDLSoftButtonTypeText;
        [textButtons addObject:button];
    }

    SDLShow *show = [[SDLShow alloc] init];
    show.mainField1 = self.mainField1;
    show.softButtons = [textButtons copy];

    [self.connectionManager sendConnectionRequest:show withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogW(@"Failed to update soft buttons with text buttons: %@", error);
        }

        SDLLogD(@"Finished sending text only soft buttons");
        handler(YES);
    }];
}

#pragma mark - Images

- (BOOL)sdl_artworkNeedsUpload:(SDLArtwork *)artwork {
    return (artwork != nil && ![self.fileManager hasUploadedFile:artwork] && self.softButtonCapabilities.imageSupported.boolValue && !artwork.isStaticIcon);
}

/// Checks all the button states for images that need to be uploaded.
/// @return True if all images have been uploaded; false at least one image needs to be uploaded
- (BOOL)sdl_allStateImagesAreUploaded {
    for (SDLSoftButtonObject *button in self.softButtonObjects) {
        for (SDLSoftButtonState *state in button.states) {
            SDLArtwork *artwork = state.artwork;
            if (![self sdl_artworkNeedsUpload:artwork]) { continue; }
            return NO;
        }
    }

    return YES;
}

- (BOOL)sdl_supportsSoftButtonImages {
    return self.softButtonCapabilities.imageSupported.boolValue;
}

#pragma mark - Property Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing soft button replace operation");
    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.softbuttonmanager.replace";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
