//
//  ButtonManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 5/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "ButtonManager.h"
#import "AlertManager.h"
#import "AppConstants.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface ButtonManager ()

@property (copy, nonatomic, nullable) RefreshUIHandler refreshUIHandler;
@property (strong, nonatomic) SDLManager *sdlManager;

@property (assign, nonatomic, getter=isTextEnabled, readwrite) BOOL textEnabled;
@property (assign, nonatomic, getter=areImagesEnabled, readwrite) BOOL imagesEnabled;

@end

@implementation ButtonManager

- (instancetype)initWithManager:(SDLManager *)manager refreshUIHandler:(RefreshUIHandler)refreshUIHandler {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sdlManager = manager;
    _refreshUIHandler = refreshUIHandler;

    _textEnabled = YES;
    _imagesEnabled = YES;

    return self;
}

#pragma mark - Setters

- (void)setTextEnabled:(BOOL)textEnabled {
    _textEnabled = textEnabled;
    if (self.refreshUIHandler == nil) { return; }
    self.refreshUIHandler();
}

- (void)setImagesEnabled:(BOOL)imagesEnabled {
    _imagesEnabled = imagesEnabled;
    if (self.refreshUIHandler == nil) { return; }
    self.refreshUIHandler();
}

#pragma mark - Custom Soft Buttons

- (NSArray<SDLSoftButtonObject *> *)allScreenSoftButtons {
    return @[[self sdlex_softButtonAlert], [self sdlex_softButtonSubtleAlert], [self sdlex_softButtonTextVisible], [self sdlex_softButtonImagesVisible]];
}

- (SDLSoftButtonObject *)sdlex_softButtonAlert {
    SDLSoftButtonState *alertImageAndTextState = [[SDLSoftButtonState alloc] initWithStateName:AlertSoftButtonImageState text:AlertSoftButtonText artwork:[SDLArtwork artworkWithImage:[[UIImage imageNamed:CarBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] name:CarBWIconImageName asImageFormat:SDLArtworkImageFormatPNG]];
    SDLSoftButtonState *alertTextState = [[SDLSoftButtonState alloc] initWithStateName:AlertSoftButtonTextState text:AlertSoftButtonText image:nil];

    __weak typeof(self) weakSelf = self;
    SDLSoftButtonObject *alertSoftButton = [[SDLSoftButtonObject alloc] initWithName:AlertSoftButton states:@[alertImageAndTextState, alertTextState] initialStateName:alertImageAndTextState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        [weakSelf sdlex_sendAlertWithImageName:CarBWIconImageName textField1:AlertMessageText textField2:nil];
    }];

    return alertSoftButton;
}

- (SDLSoftButtonObject *)sdlex_softButtonSubtleAlert {
    __weak typeof(self) weakSelf = self;
    return [[SDLSoftButtonObject alloc] initWithName:SubtleAlertSoftButton text:nil artwork: [SDLArtwork artworkWithImage:[[UIImage imageNamed:BatteryFullBWIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        [weakSelf sdlex_sendSubtleAlertWithImageName:BatteryEmptyBWIconName textField1:SubtleAlertHeaderText textField2:SubtleAlertSubheaderText errorMessage:SubtleAlertNotSupportedText];
    }];
}

- (SDLSoftButtonObject *)sdlex_softButtonTextVisible {
    SDLSoftButtonState *textOnState = [[SDLSoftButtonState alloc] initWithStateName:TextVisibleSoftButtonTextOnState text:TextVisibleSoftButtonTextOnText image:nil];
    SDLSoftButtonState *textOffState = [[SDLSoftButtonState alloc] initWithStateName:TextVisibleSoftButtonTextOffState text:TextVisibleSoftButtonTextOffText image:nil];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *textButton = [[SDLSoftButtonObject alloc] initWithName:TextVisibleSoftButton states:@[textOnState, textOffState] initialStateName:textOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        weakself.textEnabled = !weakself.textEnabled;

        SDLSoftButtonObject *textVisibleSoftButton = [weakself.sdlManager.screenManager softButtonObjectNamed:TextVisibleSoftButton];
        [textVisibleSoftButton transitionToNextState];
    }];

    return textButton;
}

- (SDLSoftButtonObject *)sdlex_softButtonImagesVisible {
    SDLSoftButtonState *imagesOnState = [[SDLSoftButtonState alloc] initWithStateName:ImagesVisibleSoftButtonImageOnState text:ImagesVisibleSoftButtonImageOnText image:nil];
    SDLSoftButtonState *imagesOffState = [[SDLSoftButtonState alloc] initWithStateName:ImagesVisibleSoftButtonImageOffState text:ImagesVisibleSoftButtonImageOffText image:nil];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *imagesButton = [[SDLSoftButtonObject alloc] initWithName:ImagesVisibleSoftButton states:@[imagesOnState, imagesOffState] initialStateName:imagesOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        weakself.imagesEnabled = !weakself.imagesEnabled;

        SDLSoftButtonObject *imagesVisibleSoftButton = [weakself.sdlManager.screenManager softButtonObjectNamed:ImagesVisibleSoftButton];
        [imagesVisibleSoftButton transitionToNextState];

        SDLSoftButtonObject *alertSoftButton = [weakself.sdlManager.screenManager softButtonObjectNamed:AlertSoftButton];
        [alertSoftButton transitionToNextState];
    }];

    return imagesButton;
}

#pragma mark - Helpers

- (void)sdlex_sendImageWithName:(NSString *)imageName completionHandler:(void (^)(BOOL success, NSString *_Nullable artworkName))completionHandler {
    SDLArtwork *artwork = [SDLArtwork artworkWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG];

    [self.sdlManager.fileManager uploadArtwork:artwork completionHandler:^(BOOL success, NSString * _Nonnull artworkName, NSUInteger bytesAvailable, NSError * _Nullable error) {
        return completionHandler(success, artworkName);
    }];
}

- (void)sdlex_sendAlertWithImageName:(NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2 {
    __weak typeof(self) weakSelf = self;
    [self sdlex_sendImageWithName:imageName completionHandler:^(BOOL success, NSString * _Nullable artworkName) {
        SDLAlert *alert = [AlertManager alertWithMessageAndCloseButton:textField1 textField2:textField2 iconName:(success ? artworkName : nil)];
        [weakSelf sdlex_sendAlertRequest:alert errorMessage:SubtleAlertNotSupportedText];
    }];
}

- (void)sdlex_sendSubtleAlertWithImageName:(NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2 errorMessage:(NSString *)errorMessage {
    __weak typeof(self) weakSelf = self;
    [self sdlex_sendImageWithName:imageName completionHandler:^(BOOL success, NSString * _Nullable artworkName) {
        SDLSubtleAlert *subtleAlert = [AlertManager subtleAlertWithMessageAndCloseButton:textField1 textField2:textField2 iconName:(success ? artworkName : nil)];
        [weakSelf sdlex_sendAlertRequest:subtleAlert errorMessage:errorMessage];
    }];
}

- (void)sdlex_sendAlertRequest:(SDLRPCRequest *)request errorMessage:(nullable NSString *)errorMessage {
    __weak typeof(self) weakSelf = self;
    [self.sdlManager sendRequest:request withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (response.success.boolValue == NO && errorMessage != nil) {
            SDLAlert *warningAlert = [AlertManager alertWithMessageAndCloseButton:errorMessage textField2:nil iconName:nil];
            [weakSelf.sdlManager sendRequest:warningAlert];
        }
    }];
}


@end

NS_ASSUME_NONNULL_END
