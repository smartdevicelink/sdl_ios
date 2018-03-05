//
//  SDLTextAndGraphicManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLTextAndGraphicManager.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLMetadataTags.h"
#import "SDLNotificationConstants.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLTextAndGraphicConfiguration.h"
#import "SDLTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTextAndGraphicManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

/**
 A show describing the current text and images on the screen (not soft buttons, etc.)
 */
@property (strong, nonatomic) SDLShow *currentScreenData;

/**
 This is the "full" update, including both text and image names, whether or not that will succeed at the moment (e.g. if images are in the process of uploading)
 */
@property (strong, nonatomic, nullable) SDLShow *inProgressUpdate;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler inProgressHandler;

@property (strong, nonatomic, nullable) SDLShow *queuedImageUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler queuedUpdateHandler;

@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@end

@implementation SDLTextAndGraphicManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(nonnull SDLFileManager *)fileManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;

    _currentScreenData = [[SDLShow alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];

    return self;
}

- (void)updateWithCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler {
    if (self.inProgressUpdate != nil) {
        // If we already have a pending update, we're going to tell the old handler that it was superseded by a new update and then return
        if (self.queuedUpdateHandler != nil) {
            self.queuedUpdateHandler([NSError sdl_textAndGraphicManager_pendingUpdateSuperseded]);
            self.queuedUpdateHandler = nil;
        }

        if (handler != nil) {
            self.queuedUpdateHandler = handler;
        } else {
            self.hasQueuedUpdate = YES;
        }

        return;
    }

    SDLShow *fullShow = [[SDLShow alloc] init];
    fullShow = [self sdl_assembleShowMetadataTags:fullShow];
    fullShow.alignment = self.configuration.alignment ?: SDLTextAlignmentCenter;
    fullShow = [self sdl_assembleShowText:fullShow forDisplayCapabilities:self.displayCapabilities];
    fullShow = [self sdl_assembleShowImages:fullShow];

    self.inProgressHandler = handler;
    __weak typeof(self)weakSelf = self;
    if (!([self sdl_shouldUpdatePrimaryImage] || [self sdl_shouldUpdateSecondaryImage])) {
        // If there are no images to update, just send the text update
        self.inProgressUpdate = [self sdl_extractTextFromShow:fullShow];
    } else if ([self sdl_uploadedArtworkOrDoesntExist:self.primaryGraphic] && [self sdl_uploadedArtworkOrDoesntExist:self.secondaryGraphic]) {
        // The files to be updated are already uploaded, send the full show immediately
        self.inProgressUpdate = fullShow;
    } else {
        // We need to upload or queue the upload of the images
        // Send the text immediately
        self.inProgressUpdate = [self sdl_extractTextFromShow:fullShow];
        // Start uploading the images
        __block SDLShow *thisUpdate = fullShow;
        [self sdl_uploadImagesWithCompletionHandler:^(NSError * _Nonnull error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // Check if queued image update still matches our images (there could have been a new Show in the meantime) and send a new update if it does. Since the images will already be on the head unit, the whole show will be sent
            // TODO: Send delete if it doesn't?
            if ([strongSelf sdl_showImages:thisUpdate isEqualToShowImages:strongSelf.queuedImageUpdate]) {
                [strongSelf updateWithCompletionHandler:strongSelf.inProgressHandler];
            }
        }];
        // TODO: If a new update comes in while this upload is happening, what do we do?
        // When the images are done uploading, send another show with the images
        self.queuedImageUpdate = fullShow;
    }

    [self.connectionManager sendConnectionRequest:self.inProgressUpdate withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"TextAndGraphic update request: %@, response: %@, error: %@", request, response, error);

        if (response.success) {
            [strongSelf sdl_updateCurrentScreenDataFromShow:(SDLShow *)request];
        }

        strongSelf.inProgressUpdate = nil;
        if (strongSelf.inProgressHandler != nil) {
            strongSelf.inProgressHandler(error);
            strongSelf.inProgressHandler = nil;
        }

        if (strongSelf.hasQueuedUpdate) {
            [strongSelf updateWithCompletionHandler:[strongSelf.queuedUpdateHandler copy]];
            strongSelf.queuedUpdateHandler = nil;
            strongSelf.hasQueuedUpdate = NO;
        }
    }];
}

#pragma mark - Upload / Send

- (void)sdl_uploadImagesWithCompletionHandler:(void (^)(NSError *error))handler {
    NSMutableArray<SDLArtwork *> *artworksToUpload = [NSMutableArray array];
    if ([self sdl_shouldUpdatePrimaryImage]) {
        [artworksToUpload addObject:self.primaryGraphic];
    }
    if ([self sdl_shouldUpdateSecondaryImage]) {
        [artworksToUpload addObject:self.secondaryGraphic];
    }

    [self.fileManager uploadArtworks:artworksToUpload completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        handler(error);
    }];
}

#pragma mark - Assembly of Shows

- (SDLShow *)sdl_assembleShowImages:(SDLShow *)show {
    if (![self sdl_shouldUpdatePrimaryImage] && ![self sdl_shouldUpdateSecondaryImage]) {
        return show;
    }

    if ([self sdl_shouldUpdatePrimaryImage]) {
        show.graphic = [[SDLImage alloc] initWithName:self.primaryGraphic.name ofType:SDLImageTypeDynamic];
    }
    if ([self sdl_shouldUpdateSecondaryImage]) {
        show.graphic = [[SDLImage alloc] initWithName:self.primaryGraphic.name ofType:SDLImageTypeDynamic];
    }

    return show;
}

- (SDLShow *)sdl_assembleShowText:(SDLShow *)show forDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    NSArray *nonNilFields = [self sdl_findNonNilFields];
    if (nonNilFields.count == 0) {
        show.mainField1 = @"";
        show.mainField2 = @"";
        show.mainField3 = @"";
        show.mainField4 = @"";
        return show;
    }

    NSUInteger numberOfLines = [displayCapabilities maxNumberOfMainFieldLines];
    if (numberOfLines == 1) {
        show = [self sdl_assembleOneLineShowText:show withShowFields:nonNilFields];
    } else if (numberOfLines == 2) {
        show = [self sdl_assembleTwoLineShowText:show withShowFields:nonNilFields];
    } else if (numberOfLines == 3) {
        show = [self sdl_assembleThreeLineShowText:show withShowFields:nonNilFields];
    } else if (numberOfLines == 4) {
        show = [self sdl_assembleFourLineShowText:show withShowFields:nonNilFields];
    }

    return show;
}

- (SDLShow *)sdl_assembleOneLineShowText:(SDLShow *)show withShowFields:(NSArray<NSString *> *)fields {
    NSMutableString *showString1 = [NSMutableString stringWithString:fields[0]];
    for (NSUInteger i = 1; i < fields.count; i++) {
        [showString1 appendFormat:@" - %@", fields[i]];
    }
    show.mainField1 = showString1.copy;

    return show;
}

- (SDLShow *)sdl_assembleTwoLineShowText:(SDLShow *)show withShowFields:(NSArray<NSString *> *)fields {
    if (fields.count == 1) {
        show.mainField1 = fields[0];
    } else if (fields.count == 2) {
        show.mainField1 = fields[0];
        show.mainField2 = fields[1];
    } else if (fields.count == 3) {
        show.mainField1 = fields[0];
        show.mainField2 = [NSString stringWithFormat:@"%@ - %@", fields[1], fields[2]];
    } else if (fields.count == 4) {
        show.mainField1 = [NSString stringWithFormat:@"%@ - %@", fields[0], fields[1]];
        show.mainField2 = [NSString stringWithFormat:@"%@ - %@", fields[2], fields[3]];
    }

    return show;
}

- (SDLShow *)sdl_assembleThreeLineShowText:(SDLShow *)show withShowFields:(NSArray<NSString *> *)fields {
    if (fields.count == 1) {
        show.mainField1 = fields[0];
    } else if (fields.count == 2) {
        show.mainField1 = fields[0];
        show.mainField2 = fields[1];
    } else if (fields.count == 3) {
        show.mainField1 = fields[0];
        show.mainField2 = fields[1];
        show.mainField3 = fields[2];
    } else if (fields.count == 4) {
        show.mainField1 = fields[0];
        show.mainField2 = fields[1];
        show.mainField3 = [NSString stringWithFormat:@"%@ - %@", fields[2], fields[3]];
    }

    return show;
}

- (SDLShow *)sdl_assembleFourLineShowText:(SDLShow *)show withShowFields:(NSArray<NSString *> *)fields {
    if (fields.count == 4) {
        show.mainField4 = fields[3];
    }
    if (fields.count >= 3) {
        show.mainField3 = fields[2];
    }
    if (fields.count >= 2) {
        show.mainField2 = fields[1];
    }
    if (fields.count >= 1) {
        show.mainField1 = fields[0];
    }

    return show;
}

- (SDLShow *)sdl_assembleShowMetadataTags:(SDLShow *)show {
    if (self.configuration == nil) {
        show.metadataTags = nil;
        return show;
    }

    NSUInteger numberOfShowLines = self.displayCapabilities.maxNumberOfMainFieldLines;
    SDLMetadataTags *tags = [[SDLMetadataTags alloc] init];
    NSMutableArray<SDLMetadataType> *metadataArray = [NSMutableArray array];

    if (numberOfShowLines == 1) {
        self.configuration.textField1Type ? [metadataArray addObject:self.configuration.textField1Type] : nil;
        self.configuration.textField2Type ? [metadataArray addObject:self.configuration.textField2Type] : nil;
        self.configuration.textField3Type ? [metadataArray addObject:self.configuration.textField3Type] : nil;
        self.configuration.textField4Type ? [metadataArray addObject:self.configuration.textField4Type] : nil;
        tags.mainField1 = metadataArray.copy;
    } else if (numberOfShowLines == 2) {
        self.configuration.textField1Type ? [metadataArray addObject:self.configuration.textField1Type] : nil;
        self.configuration.textField2Type ? [metadataArray addObject:self.configuration.textField2Type] : nil;
        tags.mainField1 = metadataArray.copy;

        [metadataArray removeAllObjects];
        self.configuration.textField3Type ? [metadataArray addObject:self.configuration.textField3Type] : nil;
        self.configuration.textField4Type ? [metadataArray addObject:self.configuration.textField4Type] : nil;
        tags.mainField2 = metadataArray.copy;
    } else if (numberOfShowLines == 3) {
        tags.mainField1 = self.configuration.textField1Type ? @[self.configuration.textField1Type] : nil;
        tags.mainField2 = self.configuration.textField2Type ? @[self.configuration.textField2Type] : nil;

        self.configuration.textField3Type ? [metadataArray addObject:self.configuration.textField3Type] : nil;
        self.configuration.textField4Type ? [metadataArray addObject:self.configuration.textField4Type] : nil;
        tags.mainField3 = metadataArray.copy;
    } else if (numberOfShowLines >= 4) {
        tags.mainField1 = self.configuration.textField1Type ? @[self.configuration.textField1Type] : nil;
        tags.mainField2 = self.configuration.textField2Type ? @[self.configuration.textField2Type] : nil;
        tags.mainField3 = self.configuration.textField3Type ? @[self.configuration.textField3Type] : nil;
        tags.mainField4 = self.configuration.textField4Type ? @[self.configuration.textField4Type] : nil;
    }

    show.metadataTags = tags;
    return show;
}

#pragma mark - Extraction

- (SDLShow *)sdl_extractTextFromShow:(SDLShow *)show {
    SDLShow *newShow = [[SDLShow alloc] init];
    newShow.mainField1 = show.mainField1;
    newShow.mainField2 = show.mainField2;
    newShow.mainField3 = show.mainField3;
    newShow.mainField4 = show.mainField4;
    newShow.metadataTags = show.metadataTags;

    return newShow;
}

- (SDLShow *)sdl_extractImageFromShow:(SDLShow *)show {
    SDLShow *newShow = [[SDLShow alloc] init];
    newShow.graphic = show.graphic;
    newShow.secondaryGraphic = show.secondaryGraphic;

    return newShow;
}

- (void)sdl_updateCurrentScreenDataFromShow:(SDLShow *)show {
    // If the items are nil, they were not updated, so we can't just set it directly
    self.currentScreenData.mainField1 = show.mainField1 ?: self.currentScreenData.mainField1;
    self.currentScreenData.mainField2 = show.mainField2 ?: self.currentScreenData.mainField2;
    self.currentScreenData.mainField3 = show.mainField3 ?: self.currentScreenData.mainField3;
    self.currentScreenData.mainField4 = show.mainField4 ?: self.currentScreenData.mainField4;
    self.currentScreenData.metadataTags = show.metadataTags ?: self.currentScreenData.metadataTags;
    self.currentScreenData.alignment = show.alignment ?: self.currentScreenData.alignment;
    self.currentScreenData.graphic = show.graphic ?: self.currentScreenData.graphic;
    self.currentScreenData.secondaryGraphic = show.secondaryGraphic ?: self.currentScreenData.secondaryGraphic;
}

#pragma mark - Helpers

- (BOOL)sdl_uploadedArtworkOrDoesntExist:(SDLArtwork *)artwork {
    return (!artwork || [self.fileManager hasUploadedFile:artwork]);
}

- (BOOL)sdl_shouldUpdatePrimaryImage {
    return ([self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameGraphic]
            && ![self.currentScreenData.graphic.value isEqualToString:self.primaryGraphic.name]
            && self.primaryGraphic != nil);
}

- (BOOL)sdl_shouldUpdateSecondaryImage {
    // Cannot detect if there is a secondary image, so we'll just try to detect if there's a primary image and allow it if there is.
    return ([self.displayCapabilities hasImageFieldOfName:SDLImageFieldNameGraphic]
            && ![self.currentScreenData.secondaryGraphic.value isEqualToString:self.secondaryGraphic.name]
            && self.secondaryGraphic != nil);
}

- (NSArray *)sdl_findNonNilFields {
    NSMutableArray *array = [NSMutableArray array];
    self.textField1.length > 0 ? [array addObject:self.textField1] : nil;
    self.textField2.length > 0 ? [array addObject:self.textField2] : nil;
    self.textField3.length > 0 ? [array addObject:self.textField3] : nil;
    self.textField4.length > 0 ? [array addObject:self.textField4] : nil;

    return [array copy];
}

#pragma mark - Equality

- (BOOL)sdl_showImages:(SDLShow *)show isEqualToShowImages:(SDLShow *)show2 {
    BOOL same = NO;
    same = ((show.graphic.value == nil && show.graphic.value == nil)
            || [show.graphic.value isEqualToString:show2.graphic.value]);
    if (!same) { return NO; }

    same = ((show.secondaryGraphic.value == nil && show.secondaryGraphic.value == nil)
            || [show.secondaryGraphic.value isEqualToString:show2.secondaryGraphic.value]);

    return same;
}

#pragma mark - Getters / Setters

- (BOOL)hasQueuedUpdate {
    return (_hasQueuedUpdate || _queuedUpdateHandler != nil);
}

- (SDLArtwork *)blankArtwork {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), NO, 0.0);
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [SDLArtwork artworkWithImage:blankImage name:@"sdl_BlankArt" asImageFormat:SDLArtworkImageFormatPNG];
}

#pragma mark - RPC Responses

- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;

    if (response.displayCapabilities != nil) {
        // TODO: We should probably allow the set to nil and just allow everything if we have a nil displayCapabilities
        self.displayCapabilities = response.displayCapabilities;

        // Auto-send an updated show
        [self updateWithCompletionHandler:nil];
    }
}

@end

NS_ASSUME_NONNULL_END
