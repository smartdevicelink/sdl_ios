//
//  SDLAlertView.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAlertView.h"

#import "SDLAlertAudioData.h"
#import "SDLError.h"
#import "SDLSoftButtonObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlertView()

@property (nullable, copy, nonatomic) SDLAlertCanceledHandler canceledHandler;

@end

@implementation SDLAlertView

static const float TimoutDefault = 0.0;
static const float TimoutMinCap = 3.0;
static const float TimoutMaxCap = 10.0;
static const float DefaultAlertTimeout = 5.0;

static NSTimeInterval _defaultAlertTimeout = DefaultAlertTimeout;

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _timeout = TimoutDefault;

    return self;
}

- (instancetype)initWithText:(NSString *)text buttons:(NSArray<SDLSoftButtonObject *> *)softButtons {
    self = [self init];
    if (!self) { return nil; }

    _text = text;
    _softButtons = softButtons;

    return self;
}

- (instancetype)initWithText:(nullable NSString *)text secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText timeout:(NSTimeInterval)timeout showWaitIndicator:(BOOL)showWaitIndicator audioIndication:(nullable SDLAlertAudioData *)audio buttons:(nullable NSArray<SDLSoftButtonObject *> *)softButtons icon:(nullable SDLArtwork *)icon {
    self = [self init];
    if (!self) { return nil; }

    _text = text;
    _secondaryText = secondaryText;
    _tertiaryText = tertiaryText;
    _timeout = timeout;
    _showWaitIndicator = showWaitIndicator;
    _audio = audio;
    _softButtons = softButtons;
    _icon = icon;

    return self;
}

#pragma mark - Cancel

- (void)cancel {
    if (self.canceledHandler == nil) { return; }
    self.canceledHandler();
}

#pragma mark - Getters / Setters

- (void)setSoftButtons:(nullable NSArray<SDLSoftButtonObject *> *)softButtons {
    for (SDLSoftButtonObject *softButton in softButtons) {
        if (softButton.states.count == 1) { continue; }
        @throw [NSException sdl_invalidAlertSoftButtonStatesException];
    }

    _softButtons = softButtons;
}

+ (void)setDefaultTimeout:(NSTimeInterval)defaultTimeout {
    _defaultAlertTimeout = defaultTimeout;
}

+ (NSTimeInterval)defaultTimeout {
   if (_defaultAlertTimeout < TimoutMinCap) {
        return TimoutMinCap;
    } else if (_defaultAlertTimeout > TimoutMaxCap) {
        return TimoutMaxCap;
    }

    return _defaultAlertTimeout;
}

- (NSTimeInterval)timeout {
    if (_timeout == TimoutDefault) {
        return SDLAlertView.defaultTimeout;
    } else if (_timeout < TimoutMinCap) {
        return TimoutMinCap;
    } else if (_timeout > TimoutMaxCap) {
        return TimoutMaxCap;
    }

    return _timeout;
}

#pragma mark - Etc.

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLAlertView: \"%@\", text: \"%@\", secondaryText: \"%@\", tertiaryText: \"%@\"", [self sdl_alertType], _text, _secondaryText, _tertiaryText];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"SDLAlertView: \"%@\", text: \"%@\", secondaryText: \"%@\", tertiaryText: \"%@\", timeout: %f, showWaitIndicator: %d, audio: \"%@\", softButtons: \"%@\", icon: \"%@\"", [self sdl_alertType], _text, _secondaryText, _tertiaryText, _timeout, _showWaitIndicator, _audio, _softButtons, _icon];
}

- (NSString *)sdl_alertType {
    BOOL alertHasText = (_text || _secondaryText || _tertiaryText);
    BOOL alertHasSound = (_audio.prompts.count > 0 || _audio.audioFiles.count > 0);

    NSString *alertType;
    if (alertHasText && alertHasSound) {
        alertType = @"Text-and-sound alert";
    } else if (alertHasText) {
        alertType = @"Text-only alert";
    } else if (alertHasSound) {
        alertType = @"Sound-only alert";
    } else {
        alertType = @"Invalid alert (no text or sound)";
    }

    return alertType;
}

@end

NS_ASSUME_NONNULL_END
