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
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLMetadataTags.h"
#import "SDLNotificationConstants.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLTextAndGraphicConfiguration.h"

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
@property (strong, nonatomic, nullable) SDLShow *queuedImageUpdate;

@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler queuedUpdateHandler;

// Describes the display capabilities for the current display layout
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@end

@implementation SDLTextAndGraphicManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(nonnull SDLFileManager *)fileManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;

    _currentScreenData = [[SDLShow alloc] init];

    // TODO: Is this too early?
    self.displayCapabilities = self.connectionManager.registerResponse.displayCapabilities;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];

    return self;
}

- (void)updateWithCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler {
    if (self.inProgressUpdate != nil) {
        if (handler != nil) {
            self.queuedUpdateHandler = handler;
        } else {
            self.hasQueuedUpdate = YES;
        }

        return;
    }

    NSUInteger numberOfImages = self.displayCapabilities.imageFields.count; // TODO: This probably won't work without further tweaks?
    NSUInteger numberOfShowLines = self.displayCapabilities.textFields.count; // TODO: Will this work?
    SDLShow *fullShow = [[SDLShow alloc] init];
    fullShow = [self sdl_assembleShowMetadataTags:fullShow];
    fullShow.alignment = self.configuration.alignment ?: SDLTextAlignmentCenter;
    fullShow = [self sdl_assembleShowText:fullShow forNumberOfLines:numberOfShowLines];
    fullShow = [self sdl_assembleShowImages:fullShow];

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
            // Check if queued image update still matches our images (there could have been a new Show in the meantime) and send a new update if it does. Since the images will already be on the head unit, the whole show will be sent
            // TODO: Send delete if it doesn't?
            if ([self sdl_showImages:thisUpdate isEqualToShowImages:self.queuedImageUpdate]) {
                [self updateWithCompletionHandler:handler];
            }
        }];
        // TODO: If a new update comes in while this upload is happening, what do we do?
        // When the images are done uploading, send another show with the images
        self.queuedImageUpdate = [self sdl_extractImageFromShow:fullShow];
    }

    [self sdl_sendShow:self.inProgressUpdate withHandler:^(NSError * _Nullable error) {
        self.inProgressUpdate = nil;
        handler(error);
    }];
}

#pragma mark - Upload / Send

- (void)sdl_sendShow:(SDLShow *)show withHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler {
    if (show == nil) { return; }

    [self.connectionManager sendConnectionRequest:show withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (response.success && error != nil) {
            [self sdl_updateCurrentScreenDataFromShow:(SDLShow *)request];
        }

        handler(error);

        if (self.hasQueuedUpdate) {
            [self updateWithCompletionHandler:[self.queuedUpdateHandler copy]];
            self.queuedUpdateHandler = nil;
            self.hasQueuedUpdate = NO;
        }
    }];
}

- (void)sdl_uploadImagesWithCompletionHandler:(void (^)(NSError *error))handler {
    if ([self sdl_shouldUpdatePrimaryImage]) {
        // TODO: upload artwork needed
    }
    if ([self sdl_shouldUpdateSecondaryImage]) {
        // TODO: upload artwork needed
    }
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

- (SDLShow *)sdl_assembleShowText:(SDLShow *)show forNumberOfLines:(NSUInteger)numberOfLines {
    NSArray *nonNilFields = [self sdl_findNonNilFields];
    if (nonNilFields.count == 0) {
        show.mainField1 = @"";
        show.mainField2 = @"";
        show.mainField3 = @"";
        show.mainField4 = @"";
        return show;
    }

    if (numberOfLines == 1) {
        NSMutableString *showString1 = nonNilFields.firstObject;
        for (NSUInteger i = 1; i < nonNilFields.count; i++) {
            [showString1 appendFormat:@" - %@", nonNilFields[i]];
        }
        show.mainField1 = showString1.copy;
    } else if (numberOfLines == 2) {
        if (nonNilFields.count <= 2) {
            show.mainField1 = nonNilFields.firstObject;
            show.mainField2 = nonNilFields[1] ?: @"";
        } else if (nonNilFields.count == 3) {
            show.mainField1 = nonNilFields[0];
            show.mainField2 = [NSString stringWithFormat:@"%@ - %@", nonNilFields[1], nonNilFields[2]];
        } else if (nonNilFields.count == 4) {
            show.mainField1 = [NSString stringWithFormat:@"%@ - %@", nonNilFields[0], nonNilFields[1]];
            show.mainField2 = [NSString stringWithFormat:@"%@ - %@", nonNilFields[2], nonNilFields[3]];
        }
    } else if (numberOfLines == 3) {
        if (nonNilFields.count <= 3) {
            show.mainField1 = nonNilFields.firstObject;
            show.mainField2 = nonNilFields[1] ?: @"";
            show.mainField3 = nonNilFields[2] ?: @"";
        } else if (nonNilFields.count == 4) {
            show.mainField1 = nonNilFields.firstObject;
            show.mainField2 = nonNilFields[1];
            show.mainField3 = [NSString stringWithFormat:@"%@ - %@", nonNilFields[2], nonNilFields[3]];
        }
    } else if (numberOfLines == 4) {
        show.mainField1 = nonNilFields.firstObject;
        show.mainField2 = nonNilFields[1];
        show.mainField3 = nonNilFields[2];
        show.mainField4 = nonNilFields[3];
    }

    return show;
}

- (SDLShow *)sdl_assembleShowMetadataTags:(SDLShow *)show {
    if (self.configuration == nil) {
        show.metadataTags = nil;
        return show;
    }

    NSUInteger numberOfShowLines = self.displayCapabilities.textFields.count; // TODO: Will this work?
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
    return (![self.currentScreenData.graphic.value isEqualToString:self.primaryGraphic.name] && self.primaryGraphic != nil);
}

- (BOOL)sdl_shouldUpdateSecondaryImage {
    return (![self.currentScreenData.secondaryGraphic.value isEqualToString:self.secondaryGraphic.name] && self.secondaryGraphic != nil);
}

- (NSArray *)sdl_findNonNilFields {
    NSMutableArray *array = [NSMutableArray array];
    self.textField1.length > 0 ? [array addObject:self.textField1] : nil;
    self.textField2.length > 0 ? [array addObject:self.textField2] : nil;
    self.textField3.length > 0 ? [array addObject:self.textField3] : nil;
    self.textField4.length > 0 ? [array addObject:self.textField4] : nil;

    return array.copy;
}

#pragma mark - Equality

- (BOOL)sdl_showImages:(SDLShow *)show isEqualToShowImages:(SDLShow *)show2 {
    return ([show.graphic.value isEqualToString:show2.graphic.value] && [show.secondaryGraphic.value isEqualToString:show2.secondaryGraphic.value]);
}

#pragma mark - Getters

- (BOOL)hasQueuedUpdate {
    return (_hasQueuedUpdate || _queuedUpdateHandler != nil);
}

#pragma mark - RPC Responses

- (void)sdl_displayLayoutResponse:(SDLRPCNotificationNotification *)notification {
    self.displayCapabilities = (SDLDisplayCapabilities *)notification.notification;

    // TODO: Send an updated Show
    [self updateWithCompletionHandler:nil];
}

@end

NS_ASSUME_NONNULL_END
