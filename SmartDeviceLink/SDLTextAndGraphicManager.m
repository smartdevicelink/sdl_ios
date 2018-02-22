//
//  SDLTextAndGraphicManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLTextAndGraphicManager.h"

#import "SDLConnectionManagerType.h"
#import "SDLDisplayCapabilities.h"
#import "SDLMetadataTags.h"
#import "SDLNotificationConstants.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLTextAndGraphicConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTextAndGraphicManager()

@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@end

@implementation SDLTextAndGraphicManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLTextAndGraphicConfiguration *)configuration {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _configuration = configuration;

    // TODO: Is this too early?
    self.displayCapabilities = self.connectionManager.registerResponse.displayCapabilities;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];

    return self;
}

- (void)updateWithCompletionHandler:(SDLTextAndGraphicUpdateCompletionHandler)handler {
    NSUInteger numberOfShowLines = self.displayCapabilities.textFields.count; // TODO: Will this work?
    SDLShow *show = [[SDLShow alloc] init];
    show = [self sdl_assembleShowMetadataTags:show];
    show = [self sdl_assembleShowText:show forNumberOfLines:numberOfShowLines];
    show.alignment = self.configuration.alignment;
}

- (SDLShow *)sdl_assembleShowImages:(SDLShow *)show {
    // TODO: Need to upload and send

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

- (NSArray *)sdl_findNonNilFields {
    NSMutableArray *array = [NSMutableArray array];
    self.textField1.length > 0 ? [array addObject:self.textField1] : nil;
    self.textField2.length > 0 ? [array addObject:self.textField2] : nil;
    self.textField3.length > 0 ? [array addObject:self.textField3] : nil;
    self.textField4.length > 0 ? [array addObject:self.textField4] : nil;

    return array.copy;
}

- (SDLShow *)sdl_assembleShowMetadataTags:(SDLShow *)show {
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

#pragma mark - RPC Responses

- (void)sdl_displayLayoutResponse:(SDLRPCNotificationNotification *)notification {
    self.displayCapabilities = (SDLDisplayCapabilities *)notification.notification;

    // TODO: Send an updated Show
}

@end

NS_ASSUME_NONNULL_END
