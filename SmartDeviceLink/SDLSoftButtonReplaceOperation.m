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
#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonReplaceOperation ()

@property (strong, nonatomic) SDLSoftButtonCapabilities *softButtonCapabilities;
@property (strong, nonatomic) NSArray<SDLSoftButtonObject *> *softButtonObjects;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLSoftButtonReplaceOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager capabilities:(SDLSoftButtonCapabilities *)capabilities softButtonObjects:(NSArray<SDLSoftButtonObject *> *)softButtonObjects mainField1:(NSString *)mainField1 {
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

    // Check the state of our images
    if (![self sdl_supportsSoftButtonImages]) {
        // We don't support images at all
        SDLLogW(@"Soft button images are not supported. Attempting to send text-only soft buttons. If any button does not contain text, no buttons will be sent.");

        // Send text buttons if all the soft buttons have text
        __weak typeof(self) weakself = self;
        [self sdl_sendCurrentStateTextOnlySoftButtonsWithCompletionHandler:^(BOOL success) {
            if (!success) {
                SDLLogE(@"Head unit does not support images and some of the soft buttons do not have text, so none of the buttons will be sent.");
                [weakself finishOperation];
            }
        }];
    } else if ([self sdl_currentStateHasImages] && ![self sdl_allCurrentStateImagesAreUploaded]) {
        // If there are images that aren't uploaded
        // Send text buttons if all the soft buttons have text
        [self sdl_sendCurrentStateTextOnlySoftButtonsWithCompletionHandler:^(BOOL success) {}];

        // Upload initial images
        __weak typeof(self) weakself = self;
        [self sdl_uploadInitialStateImagesWithCompletionHandler:^{
            // Send initial soft buttons w/ images
            [weakself sdl_sendCurrentStateSoftButtonsWithCompletionHandler:^{
                // Upload other images
                [weakself sdl_uploadOtherStateImagesWithCompletionHandler:^{
                    __strong typeof(weakself) strongself = weakself;
                    SDLLogV(@"Finished sending other images for soft buttons");
                    [strongself finishOperation];
                }];
            }];
        }];
    } else {
        // All the images are already uploaded. Send initial soft buttons w/ images.
        __weak typeof(self) weakself = self;
        [self sdl_sendCurrentStateSoftButtonsWithCompletionHandler:^{
            __strong typeof(weakself) strongself = weakself;
            SDLLogV(@"Finished sending soft buttons with images");
            [strongself finishOperation];
        }];
    }
}


#pragma mark - Uploading Images

- (void)sdl_uploadInitialStateImagesWithCompletionHandler:(void (^)(void))handler {
    // Upload all soft button images, the initial state images first, then the other states. We need to send updates when the initial state is ready.
    NSMutableArray<SDLArtwork *> *initialStatesToBeUploaded = [NSMutableArray array];
    for (SDLSoftButtonObject *object in self.softButtonObjects) {
        if ([self sdl_artworkNeedsUpload:object.currentState.artwork]) {
            [initialStatesToBeUploaded addObject:object.currentState.artwork];
        }
    }

    if (initialStatesToBeUploaded.count == 0) {
        SDLLogV(@"No initial state artworks to upload");
        handler();
        return;
    }

    SDLLogD(@"Uploading soft button initial artworks");
    NSMutableArray<NSString *> *failedArtworkNames = [NSMutableArray array];
    __weak typeof(self) weakself = self;
    [self.fileManager uploadArtworks:[initialStatesToBeUploaded copy] progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
        SDLLogV(@"Uploaded initial state artwork: %@, error: %@, percent complete: %f.2%%", artworkName, error, uploadPercentage * 100);
        if (error != nil) {
            [failedArtworkNames addObject:artworkName];
        }

        if (weakself.isCancelled) {
            [weakself finishOperation];
            return NO;
        }

        return YES;
    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error uploading soft button artworks: %@", error);
        } else {
            SDLLogD(@"Soft button initial state artworks uploaded");
        }

        handler();
    }];
}

- (void)sdl_uploadOtherStateImagesWithCompletionHandler:(void (^)(void))handler {
    NSMutableArray<SDLArtwork *> *otherStatesToBeUploaded = [NSMutableArray array];
    // Upload all soft button images, the initial state images first, then the other states. We need to send updates when the initial state is ready.
    for (SDLSoftButtonObject *object in self.softButtonObjects) {
        for (SDLSoftButtonState *state in object.states) {
            if ([state.name isEqualToString:object.currentState.name]) { continue; }
            if ([self sdl_artworkNeedsUpload:state.artwork]) {
                [otherStatesToBeUploaded addObject:state.artwork];
            }
        }
    }

    if (otherStatesToBeUploaded.count == 0) {
        SDLLogV(@"No other state artworks to upload");
        handler();
        return;
    }

    SDLLogD(@"Uploading soft button other state artworks");
    NSMutableArray<NSString *> *failedArtworkNames = [NSMutableArray array];
    __weak typeof(self) weakself = self;
    [self.fileManager uploadArtworks:[otherStatesToBeUploaded copy] progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
        SDLLogV(@"Uploaded other state artwork: %@, error: %@, percent complete: %f.2%%", artworkName, error, uploadPercentage * 100);
        if (error != nil) {
            [failedArtworkNames addObject:artworkName];
        }

        if (weakself.isCancelled) {
            [weakself finishOperation];
            return NO;
        }

        return YES;
    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error uploading soft button artworks: %@", error);
        } else {
            SDLLogD(@"Soft button other state artworks uploaded");
        }

        handler();
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
    return (artwork != nil && ![self.fileManager hasUploadedFile:artwork] && !artwork.isStaticIcon);
}

- (BOOL)sdl_currentStateHasImages {
    for (SDLSoftButtonObject *object in self.softButtonObjects) {
        if (object.currentState.artwork != nil) {
            return YES;
        }
    }

    return NO;
}

- (BOOL)sdl_allCurrentStateImagesAreUploaded {
    for (SDLSoftButtonObject *button in self.softButtonObjects) {
        SDLArtwork *artwork = button.currentState.artwork;
        if ([self sdl_artworkNeedsUpload:artwork]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)sdl_supportsSoftButtonImages {
    return self.softButtonCapabilities ? self.softButtonCapabilities.imageSupported.boolValue : NO;
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
