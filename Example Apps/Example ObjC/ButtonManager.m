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
@property (assign, nonatomic, getter=isHexagonEnabled, readwrite) BOOL toggleEnabled;
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
    _toggleEnabled = YES;

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

    SDLSoftButtonObject *object = [self.sdlManager.screenManager softButtonObjectNamed:AlertSoftButton];
    [object transitionToNextState];

    if (self.refreshUIHandler == nil) { return; }
    self.refreshUIHandler();
}

- (void)setToggleEnabled:(BOOL)toggleEnabled {
    _toggleEnabled = toggleEnabled;
    SDLSoftButtonObject *object = [self.sdlManager.screenManager softButtonObjectNamed:ToggleSoftButton];
    [object transitionToStateNamed:(toggleEnabled ? ToggleSoftButtonImageOnState : ToggleSoftButtonImageOffState)];
}

#pragma mark - Custom Soft Buttons

- (NSArray<SDLSoftButtonObject *> *)allScreenSoftButtons {
    return @[[self sdlex_softButtonAlertWithManager:self.sdlManager], [self sdlex_softButtonToggleWithManager:self.sdlManager], [self sdlex_softButtonTextVisibleWithManager:self.sdlManager], [self sdlex_softButtonImagesVisibleWithManager:self.sdlManager]];
}

- (SDLSoftButtonObject *)sdlex_softButtonAlertWithManager:(SDLManager *)manager {
    SDLSoftButtonState *alertImageAndTextState = [[SDLSoftButtonState alloc] initWithStateName:AlertSoftButtonImageState text:AlertSoftButtonText artwork:[SDLArtwork artworkWithImage:[[UIImage imageNamed:CarBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG]];
    SDLSoftButtonState *alertTextState = [[SDLSoftButtonState alloc] initWithStateName:AlertSoftButtonTextState text:AlertSoftButtonText image:nil];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *alertSoftButton = [[SDLSoftButtonObject alloc] initWithName:AlertSoftButton states:@[alertImageAndTextState, alertTextState] initialStateName:alertImageAndTextState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        [weakself.sdlManager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"You pushed the soft button!" textField2:nil]];

        SDLLogD(@"Star icon soft button press fired");
    }];

    return alertSoftButton;
}

- (SDLSoftButtonObject *)sdlex_softButtonToggleWithManager:(SDLManager *)manager {
    SDLSoftButtonState *toggleImageOnState = [[SDLSoftButtonState alloc] initWithStateName:ToggleSoftButtonImageOnState text:nil image:[[UIImage imageNamed:ToggleOnBWIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    SDLSoftButtonState *toggleImageOffState = [[SDLSoftButtonState alloc] initWithStateName:ToggleSoftButtonImageOffState text:nil image:[[UIImage imageNamed:ToggleOffBWIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *toggleButton = [[SDLSoftButtonObject alloc] initWithName:ToggleSoftButton states:@[toggleImageOnState, toggleImageOffState] initialStateName:toggleImageOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }
        weakself.toggleEnabled = !weakself.toggleEnabled;
        SDLLogD(@"Toggle icon button press fired %d", self.toggleEnabled);
    }];

    return toggleButton;
}

- (SDLSoftButtonObject *)sdlex_softButtonTextVisibleWithManager:(SDLManager *)manager {
    SDLSoftButtonState *textOnState = [[SDLSoftButtonState alloc] initWithStateName:TextVisibleSoftButtonTextOnState text:TextVisibleSoftButtonTextOnText image:nil];
    SDLSoftButtonState *textOffState = [[SDLSoftButtonState alloc] initWithStateName:TextVisibleSoftButtonTextOffState text:TextVisibleSoftButtonTextOffText image:nil];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *textButton = [[SDLSoftButtonObject alloc] initWithName:TextVisibleSoftButton states:@[textOnState, textOffState] initialStateName:textOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) { return; }

        weakself.textEnabled = !weakself.textEnabled;
        SDLSoftButtonObject *object = [weakself.sdlManager.screenManager softButtonObjectNamed:TextVisibleSoftButton];
        [object transitionToNextState];

        SDLLogD(@"Text visibility soft button press fired %d", weakself.textEnabled);
    }];

    return textButton;
}

- (SDLSoftButtonObject *)sdlex_softButtonImagesVisibleWithManager:(SDLManager *)manager {
    SDLSoftButtonState *imagesOnState = [[SDLSoftButtonState alloc] initWithStateName:ImagesVisibleSoftButtonImageOnState text:ImagesVisibleSoftButtonImageOnText image:nil];
    SDLSoftButtonState *imagesOffState = [[SDLSoftButtonState alloc] initWithStateName:ImagesVisibleSoftButtonImageOffState text:ImagesVisibleSoftButtonImageOffText image:nil];

    __weak typeof(self) weakself = self;
    SDLSoftButtonObject *imagesButton = [[SDLSoftButtonObject alloc] initWithName:ImagesVisibleSoftButton states:@[imagesOnState, imagesOffState] initialStateName:imagesOnState.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (buttonPress == nil) {
            return;
        }

        weakself.imagesEnabled = !weakself.imagesEnabled;

        SDLSoftButtonObject *object = [weakself.sdlManager.screenManager softButtonObjectNamed:ImagesVisibleSoftButton];
        [object transitionToNextState];

        SDLLogD(@"Image visibility soft button press fired %d", weakself.imagesEnabled);
    }];

    return imagesButton;
}

@end

NS_ASSUME_NONNULL_END
