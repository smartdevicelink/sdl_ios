//
//  SDLSoftButtonManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonManager.h"

#import "SDLConnectionManagerType.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonObject()

@property (assign, nonatomic) NSUInteger buttonId;

@end

@interface SDLSoftButtonManager()

@property (strong, nonatomic) NSArray<SDLSoftButton *> *currentSoftButtons;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic) SDLShow *inProgressUpdate;
@property (strong, nonatomic, nullable) SDLShow *queuedImageUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLSoftButtonUpdateCompletionHandler queuedUpdateHandler;

@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@end

@implementation SDLSoftButtonManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];

    return self;
}

- (BOOL)updateButtonNamed:(NSString *)buttonName replacingCurrentStateWithState:(SDLSoftButtonState *)state {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", buttonName];
    NSArray<SDLSoftButtonObject *> *buttons = [self.softButtonObjects filteredArrayUsingPredicate:predicate];
    if (buttons.count == 0) {
        return NO;
    }

    NSAssert(buttons.count == 1, @"Multiple SDLSoftButtonObjects are named the same thing, this should have been checked for");
    SDLSoftButtonObject *button = buttons.firstObject;
    [button transitionToState:state.name];

    if (_isBatchingUpdates) {
        return YES;
    }

    // TODO: Else send the update
    [self sdl_updateSoftButtonsWithCompletionHandler:nil];

    return YES;
}

- (void)beginUpdates {
    _isBatchingUpdates = YES;
}

- (void)endUpdatesWithCompletionHandler:(SDLSoftButtonUpdateCompletionHandler)handler {
    _isBatchingUpdates = NO;
    [self sdl_updateSoftButtonsWithCompletionHandler:handler];
}

- (BOOL)setSoftButtons:(NSArray<SDLSoftButtonObject *> *)softButtons {
    _isBatchingUpdates = NO;

    // TODO: Check number of soft buttons vs. allowed number of buttons

    // Set the soft button ids. Check to make sure no two soft buttons have the same name, there aren't many soft buttons, so n^2 isn't going to be bad
    for (NSUInteger i = 0; i < softButtons.count; i++) {
        NSString *buttonName = softButtons[i].name;
        softButtons[i].buttonId = i * 100;
        for (NSUInteger j = (i + 1); j < softButtons.count; j++) {
            if ([softButtons[j].name isEqualToString:buttonName]) {
                return NO;
            }
        }
    }

    _softButtonObjects = softButtons;

    // TODO: Upload all soft button images, the initial state images first, then the other states. We need to send updates when the initial state is ready.
    // TODO: We'll also need to handle changes that occur during that process

    [self sdl_updateSoftButtonsWithCompletionHandler:nil];

    return YES;
}

- (void)sdl_updateSoftButtonsWithCompletionHandler:(nullable SDLSoftButtonUpdateCompletionHandler)handler {
    if (self.inProgressUpdate != nil) {
        if (handler != nil) {
            self.queuedUpdateHandler = handler;
        } else {
            self.hasQueuedUpdate = YES;
        }

        return;
    }

    // TODO: Upload initial images, then other state images
    // TODO: Needs upload artworks

    // TODO: Create soft buttons
    self.inProgressUpdate = [[SDLShow alloc] init];
    self.inProgressUpdate.softButtons = [self sdl_createSoftButtonsFromCurrentState];
    if ([self sdl_currentStateHasImages] && ![self sdl_allCurrentStateImagesAreUploaded]) {
        // The images don't yet exist on the head unit, send a text update if possible
        NSArray<SDLSoftButton *> *textOnlyButtons = [self sdl_textButtonsForCurrentState];
        if (textOnlyButtons != nil) {
            self.inProgressUpdate.softButtons = textOnlyButtons;
        } else {
            return;
        }
    }

    [self.connectionManager sendConnectionRequest:self.inProgressUpdate withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (handler != NULL) {
            handler(error);
        }
    }];
}

#pragma mark - Images

- (void)sdl_uploadArtworks:(NSArray<SDLArtwork *> *)artworks withCompletionHandler:(void (^)(NSError *error))handler {
    // TODO: Need uploadArtworks
    [self.fileManager uploadArtworks:artworks completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        handler(error);
    }];
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
        if (artwork != nil && ![self.fileManager hasUploadedFile:artwork]) {
            return NO;
        }
    }

    return YES;
}

#pragma mark - Creating Soft Buttons

/**
 Returns text soft buttons representing the initial states of the button objects, or nil if _any_ of the buttons' current states are image only buttons.

 @return The text soft buttons
 */
- (nullable NSArray<SDLSoftButton *> *)sdl_textButtonsForCurrentState {
    NSMutableArray<SDLSoftButton *> *textButtons = [NSMutableArray arrayWithCapacity:self.softButtonObjects.count];
    for (SDLSoftButtonObject *buttonObject in self.softButtonObjects) {
        SDLSoftButton *button = buttonObject.currentStateSoftButton;
        if (button.text == nil) {
            return nil;
        }

        button.image = nil;
        button.type = SDLSoftButtonTypeText;
        [textButtons addObject:button];
    }

    return [textButtons copy];
}

- (NSArray<SDLSoftButton *> *)sdl_createSoftButtonsFromCurrentState {
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray arrayWithCapacity:self.softButtonObjects.count];
    for (SDLSoftButtonObject *button in self.softButtonObjects) {
        [softButtons addObject:button.currentStateSoftButton];
    }

    return [softButtons copy];
}

#pragma mark - RPC Responses

- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;

    // Auto-send an updated Show
    [self sdl_updateSoftButtonsWithCompletionHandler:nil];
}

@end

NS_ASSUME_NONNULL_END
