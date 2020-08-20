//
//  SDLTextAndGraphicUpdateOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/13/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLTextAndGraphicUpdateOperation.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLMetadataTags.h"
#import "SDLShow.h"
#import "SDLTextAndGraphicState.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

@interface SDLTextAndGraphicUpdateOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) SDLWindowCapability *currentCapabilities;
@property (strong, nonatomic) SDLTextAndGraphicState *updatedState;

@property (copy, nonatomic, nullable) CurrentDataUpdatedHandler currentDataUpdatedHandler;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler updateCompletionHandler;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLTextAndGraphicUpdateOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager currentCapabilities:(SDLWindowCapability *)currentCapabilities currentScreenData:(SDLShow *)currentData newState:(nonnull SDLTextAndGraphicState *)newState currentScreenDataUpdatedHandler:(nullable CurrentDataUpdatedHandler)currentDataUpdatedHandler updateCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)updateCompletionHandler {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _currentCapabilities = currentCapabilities;
    _currentScreenData = currentData;
    _updatedState = newState;
    _updateCompletionHandler = updateCompletionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.cancelled) { return; }

    // Build a show with everything from `self.newState`, we'll pull things out later if we can.
    SDLShow *fullShow = [[SDLShow alloc] init];
    fullShow.alignment = self.updatedState.alignment;
    fullShow.metadataTags = [[SDLMetadataTags alloc] init];
    fullShow = [self sdl_assembleShowText:fullShow];
    fullShow = [self sdl_assembleShowImages:fullShow];

    __weak typeof(self) weakSelf = self;
    if (!([self sdl_shouldUpdatePrimaryImage] || [self sdl_shouldUpdateSecondaryImage])) {
        SDLLogV(@"No images to send, sending text");
        // If there are no images to update, just send the text
        [self sdl_sendShow:[self sdl_extractTextFromShow:fullShow] withHandler:^(NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (error != nil) {
                strongSelf.internalError = error;
            }
            [strongSelf finishOperation];
        }];
    } else if (![self sdl_artworkNeedsUpload:self.updatedState.primaryGraphic] && ![self sdl_artworkNeedsUpload:self.updatedState.secondaryGraphic]) {
        SDLLogV(@"Images already uploaded, sending full update");
        // The files to be updated are already uploaded, send the full show immediately
        [self sdl_sendShow:fullShow withHandler:^(NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (error != nil) {
                strongSelf.internalError = error;
            }
            [strongSelf finishOperation];
        }];
    } else {
        SDLLogV(@"Images need to be uploaded, sending text and uploading images");

        // We need to upload or queue the upload of the images
        // Send the text immediately
        [self sdl_sendShow:[self sdl_extractTextFromShow:fullShow] withHandler:^(NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (self.cancelled) {
                [strongSelf finishOperation];
            }

            [strongSelf sdl_uploadImagesAndSendWhenDone:^(NSError * _Nullable error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error != nil) {
                    strongSelf.internalError = error;
                }
                [strongSelf finishOperation];
            }];
        }];
    }
}

#pragma mark - Send Show

- (void)sdl_sendShow:(SDLShow *)show withHandler:(void (^)(NSError *_Nullable error))handler {
    __weak typeof(self)weakSelf = self;
    [self.connectionManager sendConnectionRequest:show withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"Text and Graphic update completed");

        if (response.success) {
            [strongSelf sdl_updateCurrentScreenDataFromShow:(SDLShow *)request];
        }

        handler(error);
    }];
}

#pragma mark - Uploading Images

- (void)sdl_uploadImagesAndSendWhenDone:(void (^)(NSError *_Nullable error))handler {
    __weak typeof(self)weakSelf = self;
    [self sdl_uploadImagesWithCompletionHandler:^(NSError *_Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        SDLShow *showWithGraphics = [self sdl_createImageOnlyShowWithPrimaryArtwork:self.updatedState.primaryGraphic secondaryArtwork:self.updatedState.secondaryGraphic];
        if (showWithGraphics != nil) {
            SDLLogD(@"Sending update with the successfully uploaded images");
            [strongSelf sdl_sendShow:showWithGraphics withHandler:^(NSError * _Nullable error) {
                return handler(error);
            }];
        } else {
            SDLLogW(@"All images failed to upload. No graphics to show, skipping update.");
            return handler(error);
        }
    }];
}

- (void)sdl_uploadImagesWithCompletionHandler:(void (^)(NSError *_Nullable error))handler {
    NSMutableArray<SDLArtwork *> *artworksToUpload = [NSMutableArray array];
    if ([self sdl_shouldUpdatePrimaryImage] && !self.updatedState.primaryGraphic.isStaticIcon) {
        [artworksToUpload addObject:self.updatedState.primaryGraphic];
    }
    if ([self sdl_shouldUpdateSecondaryImage] && !self.updatedState.secondaryGraphic.isStaticIcon) {
        [artworksToUpload addObject:self.updatedState.secondaryGraphic];
    }

    if (artworksToUpload.count == 0) {
        SDLLogD(@"No artworks need an upload, sending them without upload instead");
        return handler(nil);
    }

    __weak typeof(self) weakSelf = self;
    [self.fileManager uploadArtworks:artworksToUpload progressHandler:^BOOL(NSString * _Nonnull artworkName, float uploadPercentage, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isCancelled) {
            [strongSelf finishOperation];
            return NO;
        }

        return YES;
    } completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogW(@"Text and graphic manager artwork failed to upload with error: %@", error.localizedDescription);
        }

        handler(error);
    }];
}


#pragma mark - Assembly of Shows

#pragma mark Images

- (SDLShow *)sdl_assembleShowImages:(SDLShow *)show {
    if (![self sdl_shouldUpdatePrimaryImage] && ![self sdl_shouldUpdateSecondaryImage]) {
        return show;
    }

    if ([self sdl_shouldUpdatePrimaryImage]) {
        show.graphic = self.updatedState.primaryGraphic.imageRPC;
    }
    if ([self sdl_shouldUpdateSecondaryImage]) {
        show.secondaryGraphic = self.updatedState.secondaryGraphic.imageRPC;
    }

    return show;
}

- (nullable SDLShow *)sdl_createImageOnlyShowWithPrimaryArtwork:(nullable SDLArtwork *)primaryArtwork secondaryArtwork:(nullable SDLArtwork *)secondaryArtwork  {
    SDLShow *newShow = [[SDLShow alloc] init];
    newShow.graphic = ![self sdl_artworkNeedsUpload:primaryArtwork] ? primaryArtwork.imageRPC : nil;
    newShow.secondaryGraphic = ![self sdl_artworkNeedsUpload:secondaryArtwork] ? secondaryArtwork.imageRPC : nil;

    if (newShow.graphic == nil && newShow.secondaryGraphic == nil) {
        SDLLogV(@"No graphics to upload");
        return nil;
    }

    return newShow;
}

#pragma mark Text

- (SDLShow *)sdl_assembleShowText:(SDLShow *)show {
    [self sdl_setBlankTextFieldsWithShow:show];

    if (self.updatedState.mediaTrackTextField != nil && [self sdl_shouldUpdateMediaTextField]) {
        show.mediaTrack = self.updatedState.mediaTrackTextField;
    } else {
        show.mediaTrack = @"";
    }

    if (self.updatedState.title != nil && [self sdl_shouldUpdateTitleField]) {
        show.templateTitle = self.updatedState.title;
    } else {
        show.templateTitle = @"";
    }

    NSArray *nonNilFields = [self sdl_findNonNilTextFields];
    if (nonNilFields.count == 0) { return show; }

    NSUInteger numberOfLines = self.currentCapabilities.maxNumberOfMainFieldLines;
    if (numberOfLines == 1) {
        show = [self sdl_assembleOneLineShowText:show withShowFields:nonNilFields];
    } else if (numberOfLines == 2) {
        show = [self sdl_assembleTwoLineShowText:show];
    } else if (numberOfLines == 3) {
        show = [self sdl_assembleThreeLineShowText:show];
    } else if (numberOfLines == 4) {
        show = [self sdl_assembleFourLineShowText:show];
    }

    return show;
}

- (SDLShow *)sdl_assembleOneLineShowText:(SDLShow *)show withShowFields:(NSArray<NSString *> *)fields {
    NSMutableString *showString1 = [NSMutableString stringWithString:fields[0]];
    for (NSUInteger i = 1; i < fields.count; i++) {
        [showString1 appendFormat:@" - %@", fields[i]];
    }
    show.mainField1 = showString1.copy;

    SDLMetadataTags *tags = [[SDLMetadataTags alloc] init];
    NSMutableArray<SDLMetadataType> *metadataArray = [NSMutableArray array];
    self.updatedState.textField1Type ? [metadataArray addObject:self.updatedState.textField1Type] : nil;
    self.updatedState.textField2Type ? [metadataArray addObject:self.updatedState.textField2Type] : nil;
    self.updatedState.textField3Type ? [metadataArray addObject:self.updatedState.textField3Type] : nil;
    self.updatedState.textField4Type ? [metadataArray addObject:self.updatedState.textField4Type] : nil;
    tags.mainField1 = [metadataArray copy];
    show.metadataTags = tags;

    return show;
}

- (SDLShow *)sdl_assembleTwoLineShowText:(SDLShow *)show {
    NSMutableString *tempString = [NSMutableString string];
    if (self.updatedState.textField1.length > 0) {
        // If text 1 exists, put it in slot 1
        [tempString appendString:self.updatedState.textField1];
        show.metadataTags.mainField1 = self.updatedState.textField1Type.length > 0 ? @[self.updatedState.textField1Type] : @[];
    }

    if (self.updatedState.textField2.length > 0) {
        if (!(self.updatedState.textField3.length > 0 || self.updatedState.textField4.length > 0)) {
            // If text 3 & 4 do not exist, put it in slot 2
            show.mainField2 = self.updatedState.textField2;
            show.metadataTags.mainField2 = self.updatedState.textField2Type.length > 0 ? @[self.updatedState.textField2Type] : @[];
        } else if (self.updatedState.textField1.length > 0) {
            // If text 1 exists, put it in slot 1 formatted
            [tempString appendFormat:@" - %@", self.updatedState.textField2];
            show.metadataTags.mainField1 = self.updatedState.textField2Type.length > 0 ? [show.metadataTags.mainField1 arrayByAddingObjectsFromArray:@[self.updatedState.textField2Type]] : show.metadataTags.mainField1;
        } else {
            // If text 1 does not exist, put it in slot 1 unformatted
            [tempString appendString:self.updatedState.textField2];
            show.metadataTags.mainField1 = self.updatedState.textField2Type.length > 0 ? @[self.updatedState.textField2Type] : @[];
        }
    }

    show.mainField1 = [tempString copy];

    tempString = [NSMutableString string];
    if (self.updatedState.textField3.length > 0) {
        // If text 3 exists, put it in slot 2
        [tempString appendString:self.updatedState.textField3];
        show.metadataTags.mainField2 = self.updatedState.textField3Type.length > 0 ? @[self.updatedState.textField3Type] : @[];
    }

    if (self.updatedState.textField4.length > 0) {
        if (self.updatedState.textField3.length > 0) {
            // If text 3 exists, put it in slot 2 formatted
            [tempString appendFormat:@" - %@", self.updatedState.textField4];
            show.metadataTags.mainField2 = self.updatedState.textField4Type.length > 0 ? [show.metadataTags.mainField2 arrayByAddingObjectsFromArray:@[self.updatedState.textField4Type]] : show.metadataTags.mainField2;
        } else {
            // If text 3 does not exist, put it in slot 3 unformatted
            [tempString appendString:self.updatedState.textField4];
            show.metadataTags.mainField2 = self.updatedState.textField4Type.length > 0 ? @[self.updatedState.textField4Type] : @[];
        }
    }

    if (tempString.length > 0) {
        show.mainField2 = [tempString copy];
    }

    return show;
}

- (SDLShow *)sdl_assembleThreeLineShowText:(SDLShow *)show {
    if (self.updatedState.textField1.length > 0) {
        show.mainField1 = self.updatedState.textField1;
        show.metadataTags.mainField1 = self.updatedState.textField1Type.length > 0 ? @[self.updatedState.textField1Type] : @[];
    }

    if (self.updatedState.textField2.length > 0) {
        show.mainField2 = self.updatedState.textField2;
        show.metadataTags.mainField2 = self.updatedState.textField2Type.length > 0 ? @[self.updatedState.textField2Type] : @[];
    }

    NSMutableString *tempString = [NSMutableString string];
    if (self.updatedState.textField3.length > 0) {
        [tempString appendString:self.updatedState.textField3];
        show.metadataTags.mainField3 = self.updatedState.textField3Type.length > 0 ? @[self.updatedState.textField3Type] : @[];
    }

    if (self.updatedState.textField4.length > 0) {
        if (self.updatedState.textField3.length > 0) {
            // If text 3 exists, put it in slot 3 formatted
            [tempString appendFormat:@" - %@", self.updatedState.textField4];
            show.metadataTags.mainField3 = self.updatedState.textField4Type.length > 0 ? [show.metadataTags.mainField3 arrayByAddingObjectsFromArray:@[self.updatedState.textField4Type]] : show.metadataTags.mainField3;
        } else {
            // If text 3 does not exist, put it in slot 3 formatted
            [tempString appendString:self.updatedState.textField4];
            show.metadataTags.mainField3 = self.updatedState.textField4Type.length > 0 ? @[self.updatedState.textField4Type] : @[];
        }
    }

    show.mainField3 = [tempString copy];

    return show;
}

- (SDLShow *)sdl_assembleFourLineShowText:(SDLShow *)show {
    if (self.updatedState.textField1.length > 0) {
        show.mainField1 = self.updatedState.textField1;
        show.metadataTags.mainField1 = self.updatedState.textField1Type.length > 0 ? @[self.updatedState.textField1Type] : @[];
    }

    if (self.updatedState.textField2.length > 0) {
        show.mainField2 = self.updatedState.textField2;
        show.metadataTags.mainField2 = self.updatedState.textField2Type.length > 0 ? @[self.updatedState.textField2Type] : @[];
    }

    if (self.updatedState.textField3.length > 0) {
        show.mainField3 = self.updatedState.textField3;
        show.metadataTags.mainField3 = self.updatedState.textField3Type.length > 0 ? @[self.updatedState.textField3Type] : @[];
    }

    if (self.updatedState.textField4.length > 0) {
        show.mainField4 = self.updatedState.textField4;
        show.metadataTags.mainField4 = self.updatedState.textField4Type.length > 0 ? @[self.updatedState.textField4Type] : @[];
    }

    return show;
}

- (SDLShow *)sdl_setBlankTextFieldsWithShow:(SDLShow *)show {
    show.mainField1 = @"";
    show.mainField2 = @"";
    show.mainField3 = @"";
    show.mainField4 = @"";
    show.mediaTrack = @"";
    show.templateTitle = @"";

    return show;
}

#pragma mark - Extraction

- (SDLShow *)sdl_extractTextFromShow:(SDLShow *)show {
    SDLShow *newShow = [[SDLShow alloc] init];
    newShow.mainField1 = show.mainField1;
    newShow.mainField2 = show.mainField2;
    newShow.mainField3 = show.mainField3;
    newShow.mainField4 = show.mainField4;
    newShow.mediaTrack = show.mediaTrack;
    newShow.templateTitle = show.templateTitle;
    newShow.metadataTags = show.metadataTags;

    return newShow;
}

- (void)sdl_updateCurrentScreenDataFromShow:(SDLShow *)show {
    // If the items are nil, they were not updated, so we can't just set it directly
    self.currentScreenData.mainField1 = show.mainField1 ?: self.currentScreenData.mainField1;
    self.currentScreenData.mainField2 = show.mainField2 ?: self.currentScreenData.mainField2;
    self.currentScreenData.mainField3 = show.mainField3 ?: self.currentScreenData.mainField3;
    self.currentScreenData.mainField4 = show.mainField4 ?: self.currentScreenData.mainField4;
    self.currentScreenData.mediaTrack = show.mediaTrack ?: self.currentScreenData.mediaTrack;
    self.currentScreenData.templateTitle = show.templateTitle ?: self.currentScreenData.templateTitle;
    self.currentScreenData.metadataTags = show.metadataTags ?: self.currentScreenData.metadataTags;
    self.currentScreenData.alignment = show.alignment ?: self.currentScreenData.alignment;
    self.currentScreenData.graphic = show.graphic ?: self.currentScreenData.graphic;
    self.currentScreenData.secondaryGraphic = show.secondaryGraphic ?: self.currentScreenData.secondaryGraphic;

    self.currentDataUpdatedHandler(self.currentScreenData);
}

#pragma mark - Should Update

- (BOOL)sdl_artworkNeedsUpload:(SDLArtwork *)artwork {
    return (artwork != nil && ![self.fileManager hasUploadedFile:artwork] && !artwork.isStaticIcon);
}

- (BOOL)sdl_shouldUpdatePrimaryImage {
    BOOL templateSupportsPrimaryArtwork = [self.currentCapabilities hasImageFieldOfName:SDLImageFieldNameGraphic];
    BOOL graphicMatchesExisting = [self.currentScreenData.graphic.value isEqualToString:self.updatedState.primaryGraphic.name];
    BOOL graphicExists = (self.updatedState.primaryGraphic != nil);

    return (templateSupportsPrimaryArtwork && !graphicMatchesExisting && graphicExists);
}

- (BOOL)sdl_shouldUpdateSecondaryImage {
    BOOL templateSupportsSecondaryArtwork = [self.currentCapabilities hasImageFieldOfName:SDLImageFieldNameSecondaryGraphic];
    BOOL graphicMatchesExisting = [self.currentScreenData.secondaryGraphic.value isEqualToString:self.updatedState.secondaryGraphic.name];
    BOOL graphicExists = (self.updatedState.secondaryGraphic != nil);

    // Cannot detect if there is a secondary image, so we'll just try to detect if there's a primary image and allow it if there is.
    return (templateSupportsSecondaryArtwork && !graphicMatchesExisting && graphicExists);
}

- (BOOL)sdl_shouldUpdateMediaTextField {
    return [self.currentCapabilities hasTextFieldOfName:SDLTextFieldNameMediaTrack];
}

- (BOOL)sdl_shouldUpdateTitleField {
    return [self.currentCapabilities hasTextFieldOfName:SDLTextFieldNameTemplateTitle];
}

- (NSArray<NSString *> *)sdl_findNonNilTextFields {
    NSMutableArray *array = [NSMutableArray array];
    (self.updatedState.textField1.length > 0) ? [array addObject:self.updatedState.textField1] : nil;
    (self.updatedState.textField2.length > 0) ? [array addObject:self.updatedState.textField2] : nil;
    (self.updatedState.textField3.length > 0) ? [array addObject:self.updatedState.textField3] : nil;
    (self.updatedState.textField4.length > 0) ? [array addObject:self.updatedState.textField4] : nil;

    return [array copy];
}

- (NSArray<SDLMetadataType> *)sdl_findNonNilMetadataFields {
    NSMutableArray *array = [NSMutableArray array];
    (self.updatedState.textField1Type.length) > 0 ? [array addObject:self.updatedState.textField1Type] : nil;
    (self.updatedState.textField2Type.length) > 0 ? [array addObject:self.updatedState.textField2Type] : nil;
    (self.updatedState.textField3Type.length) > 0 ? [array addObject:self.updatedState.textField3Type] : nil;
    (self.updatedState.textField4Type.length) > 0 ? [array addObject:self.updatedState.textField4Type] : nil;

    return [array copy];
}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing text and graphic update operation");
    if (self.updateCompletionHandler != nil) {
        self.updateCompletionHandler(self.error);
    }
    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.textandgraphic.update";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end
