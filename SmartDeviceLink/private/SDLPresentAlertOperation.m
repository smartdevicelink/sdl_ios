//
//  SDLPresentAlertOperation.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/12/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLPresentAlertOperation.h"

#import "SDLAlert.h"
#import "SDLAlertAudioData.h"
#import "SDLAlertResponse.h"
#import "SDLAlertView.h"
#import "SDLArtwork.h"
#import "SDLCancelInteraction.h"
#import "SDLConnectionManagerType.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLTextField.h"
#import "SDLTTSChunk.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

static const int SDLAlertSoftButtonIDMin = 10;
static const int SDLAlertSoftButtonCount = 4;

@interface SDLAlertAudioData()

@property (nullable, copy, nonatomic, readonly) NSDictionary<SDLFileName *, SDLFile *> *audioFileData;

@end

@interface SDLAlertView()

/// Handler called when the alert should be dismissed.
@property (copy, nonatomic) SDLAlertCanceledHandler canceledHandler;

@end

@interface SDLSoftButtonObject()

/// Unique id assigned to the soft button.
@property (assign, nonatomic) NSUInteger buttonId;

@end

@interface SDLPresentAlertOperation()

@property (strong, nonatomic) NSUUID *operationId;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;
@property (strong, nonatomic, readwrite) SDLAlertView *alertView;
@property (assign, nonatomic) UInt16 cancelId;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLPresentAlertOperation

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager currentWindowCapability:(nullable SDLWindowCapability *)currentWindowCapability alertView:(SDLAlertView *)alertView cancelID:(UInt16)cancelID {

    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;

    __weak typeof(self) weakSelf = self;
    alertView.canceledHandler = ^{
        [weakSelf sdl_cancelInteraction];
    };
    _alertView = [alertView copy];

    _cancelId = cancelID;
    _operationId = [NSUUID UUID];
    _currentWindowCapability = currentWindowCapability;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    if (![self sdl_isValidAlertViewData:self.alertView]) {
        if (self.alertView.audio.audioData.count > 0) {
            self.internalError = [NSError sdl_alertManager_alertAudioFileNotSupported];
        } else {
            self.internalError = [NSError sdl_alertManager_alertDataInvalid];
        }
        [self finishOperation];
    }

    dispatch_group_t uploadFilesTask = dispatch_group_create();
    dispatch_group_enter(uploadFilesTask);

    dispatch_group_enter(uploadFilesTask);
    [self sdl_uploadImagesWithCompletionHandler:^{
        dispatch_group_leave(uploadFilesTask);
    }];

    dispatch_group_enter(uploadFilesTask);
    [self sdl_uploadAudioFilesWithCompletionHandler:^{
        dispatch_group_leave(uploadFilesTask);
    }];

    dispatch_group_leave(uploadFilesTask);

    // This will always run after all `leave`s
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(uploadFilesTask, [SDLGlobals sharedGlobals].sdlProcessingQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sdl_presentAlert];
    });
}

/// Checks the `AlertView` data to make sure it conforms to the RPC Spec, which says that at least either `alertText1`, `alertText2` or `TTSChunks` need to be provided.
/// @return True if the alert data is valid; false if not
- (BOOL)sdl_isValidAlertViewData:(SDLAlertView *)alertView {
    if (alertView.text.length > 0) {
        return YES;
    }
    if (alertView.secondaryText.length > 0) {
        return YES;
    }
    if ([self sdl_getTTSChunksForAlertView:alertView].count > 0) {
        return YES;
    }

    return NO;
}

#pragma mark Uploads

/// Upload the alert audio files.
/// @param handler Called when all audio files have been uploaded
- (void)sdl_uploadAudioFilesWithCompletionHandler:(void (^)(void))handler {
    if (![self sdl_supportsAlertAudioFile]) {
        SDLLogD(@"Module does not support audio files for alerts, skipping upload of audio files");
        return handler();
    }

    NSMutableArray<SDLFile *> *filesToBeUploaded = [NSMutableArray array];
    for (SDLTTSChunk *ttsChunk in self.alertView.audio.audioData) {
        if (ttsChunk.type != SDLSpeechCapabilitiesFile) { continue; }
        SDLFile *audioFile = self.alertView.audio.audioFileData[ttsChunk.text];
        if (![self.fileManager fileNeedsUpload:audioFile]) { continue; }
        [filesToBeUploaded addObject:audioFile];
    }

    if (filesToBeUploaded.count == 0) {
        SDLLogV(@"No audio files need to be uploaded for alert");
        return handler();
    }

    SDLLogD(@"Uploading audio files for alert");
    __weak typeof(self) weakself = self;
    [self.fileManager uploadFiles:filesToBeUploaded progressHandler:^BOOL(SDLFileName * _Nonnull fileName, float uploadPercentage, NSError * _Nullable error) {
        __strong typeof(weakself) strongself = weakself;
        SDLLogD(@"Uploaded alert audio file: %@, error: %@, percent complete: %f.2%%", fileName, error, uploadPercentage * 100);
        if (strongself.isCancelled) {
            [strongself finishOperation];
            return NO;
        }

        return YES;
    } completionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error uploading alert audio files: %@", error);
        } else {
            SDLLogD(@"All alert audio files uploaded");
        }

        handler();
    }];
}

/// Upload the alert icon and soft button images.
/// @param handler Called when all images have been uploaded
- (void)sdl_uploadImagesWithCompletionHandler:(void (^)(void))handler {
    NSMutableArray<SDLArtwork *> *artworksToBeUploaded = [NSMutableArray array];
    if ([self sdl_supportsAlertIcon] && [self.fileManager fileNeedsUpload:self.alertView.icon]) {
        [artworksToBeUploaded addObject:self.alertView.icon];
    }

    for (SDLSoftButtonObject *object in self.alertView.softButtons) {
        if ([self sdl_supportsSoftButtonImages] && [self.fileManager fileNeedsUpload:object.currentState.artwork]) {
            [artworksToBeUploaded addObject:object.currentState.artwork];
        }
    }

    [self sdl_sendImages:artworksToBeUploaded completionHandler:handler];
}

/// Helper method for uploading images
/// @param images The images to upload
/// @param completionHandler Called when all images have been uploaded
- (void)sdl_sendImages:(NSArray<SDLArtwork *> *)images completionHandler:(void (^)(void))completionHandler {
    if (images.count == 0) {
        SDLLogV(@"No images to upload for alert");
        completionHandler();
        return;
    }

    SDLLogD(@"Uploading images for alert");
    __weak typeof(self) weakself = self;
    [self.fileManager uploadArtworks:[images copy] progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
        __strong typeof(weakself) strongself = weakself;
        SDLLogD(@"Uploaded alert images: %@, error: %@, percent complete: %f.2%%", artworkName, error, uploadPercentage * 100);
        if (strongself.isCancelled) {
            [strongself finishOperation];
            return NO;
        }

        return YES;
    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error uploading alert images: %@", error);
        } else {
            SDLLogD(@"All alert images uploaded");
        }

        completionHandler();
    }];
}

/// Sends the alert RPC to the module. The operation is finished once a response has been received from the module.
- (void)sdl_presentAlert {
    [self.connectionManager sendConnectionRequest:self.alertRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (self.isCancelled) {
            [self finishOperation];
            return;
        }

        if (error != nil) {
            SDLAlertResponse *alertResponse = (SDLAlertResponse *)response;
            NSMutableDictionary *alertResponseUserInfo = [NSMutableDictionary dictionary];
            alertResponseUserInfo[@"error"] = error;

            NSNumber *tryAgainTime = nil;
            if (alertResponse != nil && alertResponse.tryAgainTime != nil) {
                tryAgainTime = alertResponse.tryAgainTime;
            }
            alertResponseUserInfo[@"tryAgainTime"] = tryAgainTime;

            NSError *alertResponseError = [NSError sdl_alertManager_presentationFailed:alertResponseUserInfo];
            self.internalError = alertResponseError;
        }

        [self finishOperation];
    }];
}

#pragma mark - Cancel

/// Cancels the alert. If the alert has not yet been sent to the module, it will not be sent. If the alert is already presented on the module, the alert will be immediately dismissed. Canceling an already presented alert will only work if connected to modules supporting RPC spec versions 6.0+. On older versions alert will not be dismissed.
- (void)sdl_cancelInteraction {
    if (self.isFinished) {
        SDLLogW(@"This operation has already finished so it can not be canceled.");
        return;
    } else if (self.isCancelled) {
        SDLLogW(@"This operation has already been canceled. It will be finished at some point during the operation.");
        return;
    } else if (self.isExecuting) {
        if ([SDLGlobals.sharedGlobals.rpcVersion isLessThanVersion:[[SDLVersion alloc] initWithMajor:6 minor:0 patch:0]]) {
            SDLLogE(@"Canceling an alert is not supported on this module");
            return;
        }

        SDLLogD(@"Canceling the presented alert");
        SDLCancelInteraction *cancelInteraction = [[SDLCancelInteraction alloc] initWithAlertCancelID:self.cancelId];

        __weak typeof(self) weakSelf = self;
        [self.connectionManager sendConnectionRequest:cancelInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                weakSelf.internalError = error;
                SDLLogE(@"Error canceling the presented alert: %@, with error: %@", request, error);
                return;
            }
            SDLLogD(@"The presented alert was canceled successfully");
        }];
    } else {
        SDLLogD(@"Canceling an alert that has not yet been sent to Core");
        [self cancel];
    }
}

#pragma mark - Private Getters / Setters

/// Assembles an `Alert` RPC from the `SDLAlertView` information.
/// @return The `Alert` RPC to be sent to the module.
- (SDLAlert *)alertRPC {
    SDLAlert *alert = [[SDLAlert alloc] init];
    [self sdl_assembleAlertText:alert];
    alert.duration = @((NSUInteger)(self.alertView.timeout * 1000));
    alert.alertIcon = [self sdl_supportsAlertIcon] ? self.alertView.icon.imageRPC : nil;
    alert.progressIndicator = @(self.alertView.showWaitIndicator);
    alert.cancelID = @(self.cancelId);

    // The number of alert soft buttons sent must be capped so there are no clashes with soft button ids assigned by other managers (And thus leading to clashes saving/retreiving the button handlers in the  `SDLResponseDispatcher` class)
    NSUInteger softButtonCount = MIN(self.alertView.softButtons.count, SDLAlertSoftButtonCount);
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray arrayWithCapacity:softButtonCount];
    for (NSUInteger i = 0; i < softButtonCount; i += 1) {
        SDLSoftButtonObject *button = self.alertView.softButtons[i];
        button.buttonId = i + SDLAlertSoftButtonIDMin;
        [softButtons addObject:button.currentStateSoftButton.copy];
    }
    alert.softButtons = softButtons;

    alert.playTone = @(self.alertView.audio.playTone);
    NSArray<SDLTTSChunk *> *ttsChunks = [self sdl_getTTSChunksForAlertView:self.alertView];
    alert.ttsChunks = (ttsChunks.count > 0) ? ttsChunks : nil;

    return alert;
}

/// Creates an array of text-to-speech chunks for the `Alert` RPC from the text strings and the audio data files.
/// @return An array of TTS chunks
- (NSArray<SDLTTSChunk *> *)sdl_getTTSChunksForAlertView:(SDLAlertView *)alertView {
    SDLAlertAudioData *alertAudio = alertView.audio;

    NSMutableArray<SDLTTSChunk *> *ttsChunks = [NSMutableArray array];
    for (SDLTTSChunk *audioData in alertAudio.audioData) {
        if (audioData.type == SDLSpeechCapabilitiesFile && ![self sdl_supportsAlertAudioFile]) { continue; }
        [ttsChunks addObject:audioData];
    }

    return ttsChunks;
}

/// Checks if the connected module or current template supports soft button images.
/// @return True if soft button images are currently supported; false if not.
- (BOOL)sdl_supportsSoftButtonImages {
    SDLSoftButtonCapabilities *softButtonCapabilities = self.currentWindowCapability.softButtonCapabilities.firstObject;
    return softButtonCapabilities.imageSupported.boolValue;
}

/// Checks if the connected module supports audio files. Using an audio file in an alert will only work if connected to modules supporting RPC spec versions 5.0+. If the module does not return a speechCapabilities, assume that the module supports playing an audio file.
/// @return True if the module supports playing audio files in an alert; false if not.
- (BOOL)sdl_supportsAlertAudioFile {
    NSUInteger majorVersion = [SDLGlobals sharedGlobals].rpcVersion.major;
    BOOL supportSpeechCapabilities = self.systemCapabilityManager.speechCapabilities == nil ? YES : [self.systemCapabilityManager.speechCapabilities containsObject:SDLSpeechCapabilitiesFile];
    return (majorVersion >= 5 && supportSpeechCapabilities);
}

/// Checks if the connected module or current template supports alert icons.
/// @return True if alert icons are currently supported; false if not.
- (BOOL)sdl_supportsAlertIcon {
    return [self.currentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon];
}

#pragma mark - Text Helpers

/// Populates the alert RPC text-fields based on the number of text-fields the current template supports. If more text-fields are set in the SDLAlertView than the template supports, the text is concancated so all text fits in the currently available text-fields.
/// @param alert The alert RPC with no text-fields set
/// @return An alert RPC with the text-fields set
- (SDLAlert *)sdl_assembleAlertText:(SDLAlert *)alert {
    NSArray *nonNilFields = [self sdl_findNonNilTextFields];
    if (nonNilFields.count == 0) { return alert; }

    NSUInteger maxNumberOfLines = (self.currentWindowCapability != nil) ? self.currentWindowCapability.maxNumberOfAlertFieldLines : MaxAlertTextFieldLineCount;
    if (maxNumberOfLines == 1) {
        alert = [self sdl_assembleOneLineAlertText:alert withAlertFields:nonNilFields];
    } else if (maxNumberOfLines == 2) {
         alert = [self sdl_assembleTwoLineAlertText:alert withAlertFields:nonNilFields];
    } else if (maxNumberOfLines == 3) {
         alert = [self sdl_assembleThreeLineAlertText:alert withAlertFields:nonNilFields];
    }

    return alert;
}

/// Generates a list of all non-empty text-fields set in the SDLAlertView in order from first, second to third.
/// @return An array of all the text-fields set in the SDLAlertView
- (NSArray<NSString *> *)sdl_findNonNilTextFields {
    NSMutableArray *array = [NSMutableArray array];
    (self.alertView.text.length > 0) ? [array addObject:self.alertView.text] : nil;
    (self.alertView.secondaryText.length > 0) ? [array addObject:self.alertView.secondaryText] : nil;
    (self.alertView.tertiaryText.length > 0) ? [array addObject:self.alertView.tertiaryText] : nil;

    return [array copy];
}

/// Called if the alert template only supports one line of text. A single string is created from all the text and is used to set the first text-field in the alert RPC.
/// @param alert The alert RPC
/// @param fields A list all the text set in the SDLAlertView
/// @return An alert RPC with the text-fields set
- (SDLAlert *)sdl_assembleOneLineAlertText:(SDLAlert *)alert withAlertFields:(NSArray<NSString *> *)fields {
    NSMutableString *alertString = [NSMutableString stringWithString:[fields objectAtIndex:0]];
    for (NSUInteger i = 1; i < fields.count; i+= 1) {
        [alertString appendFormat:@" - %@", fields[i]];
    }
    alert.alertText1 = alertString.copy;

    return alert;
}

/// Called if the alert template only supports two lines of text. The first text-field in the alert RPC is set with the first available text and the second text-field is set with a single string created from all remaining text.
/// @param alert The alert RPC
/// @param fields A list all the text set in the SDLAlertView
/// @return An alert RPC with the text-fields set
- (SDLAlert *)sdl_assembleTwoLineAlertText:(SDLAlert *)alert withAlertFields:(NSArray<NSString *> *)fields {
    if (fields.count <= 2) {
        alert.alertText1 = fields.count > 0 ? fields[0] : nil;
        alert.alertText2 = fields.count > 1 ? [fields objectAtIndex:1] : nil;
    } else {
        alert.alertText1 = fields.count > 0 ? [fields objectAtIndex:0] : nil;
        alert.alertText2 = [NSString stringWithFormat:@"%@ - %@", [fields objectAtIndex:1], [fields objectAtIndex:2]];
    }

    return alert;
}

/// Called if the alert template supports all three lines of text. Each text-field in the alert RPC is set with its corresponding text.
/// @param alert The alert RPC
/// @param fields A list all the text set in the SDLAlertView
/// @return An alert RPC with the text-fields set
- (SDLAlert *)sdl_assembleThreeLineAlertText:(SDLAlert *)alert withAlertFields:(NSArray<NSString *> *)fields {
    alert.alertText1 = fields.count > 0 ? fields[0] : nil;
    alert.alertText2 = fields.count > 1 ? [fields objectAtIndex:1] : nil;
    alert.alertText3 = fields.count > 2 ? [fields objectAtIndex:2] : nil;
    return alert;
}

#pragma mark - Property Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing present alert operation");
    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.alertManager.present";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
