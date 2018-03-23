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
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonObject()

@property (assign, nonatomic) NSUInteger buttonId;
@property (weak, nonatomic) SDLSoftButtonManager *manager;

@end

@interface SDLSoftButtonManager()

@property (strong, nonatomic) NSArray<SDLSoftButton *> *currentSoftButtons;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic, nullable) SDLShow *inProgressUpdate;
@property (copy, nonatomic, nullable) SDLSoftButtonUpdateCompletionHandler inProgressHandler;

@property (strong, nonatomic, nullable) SDLShow *queuedImageUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLSoftButtonUpdateCompletionHandler queuedUpdateHandler;

@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;
@property (strong, nonatomic, nullable) SDLSoftButtonCapabilities *softButtonCapabilities;

@property (assign, nonatomic) BOOL waitingOnHMILevelUpdateToSetButtons;

@end

@implementation SDLSoftButtonManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _softButtonObjects = @[];

    _currentLevel = SDLHMILevelNone; // Assume NONE until we get something else
    _waitingOnHMILevelUpdateToSetButtons = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)setSoftButtonObjects:(NSArray<SDLSoftButtonObject *> *)softButtonObjects {
    if (self.currentLevel == nil || [self.currentLevel isEqualToString:SDLHMILevelNone]) {
        _waitingOnHMILevelUpdateToSetButtons = YES;
        _softButtonObjects = softButtonObjects;
        return;
    }

    self.inProgressUpdate = nil;
    if (self.inProgressHandler != nil) {
        self.inProgressHandler([NSError sdl_softButtonManager_pendingUpdateSuperseded]);
        self.inProgressHandler = nil;
    }
    self.hasQueuedUpdate = NO;
    if (self.queuedUpdateHandler != nil) {
        self.queuedUpdateHandler([NSError sdl_softButtonManager_pendingUpdateSuperseded]);
        self.queuedUpdateHandler = nil;
    }

    // Set the soft button ids. Check to make sure no two soft buttons have the same name, there aren't many soft buttons, so n^2 isn't going to be bad
    for (NSUInteger i = 0; i < softButtonObjects.count; i++) {
        NSString *buttonName = softButtonObjects[i].name;
        softButtonObjects[i].buttonId = i * 100;
        for (NSUInteger j = (i + 1); j < softButtonObjects.count; j++) {
            if ([softButtonObjects[j].name isEqualToString:buttonName]) {
                _softButtonObjects = @[];
                SDLLogE(@"Attempted to set soft button objects, but two buttons had the same name: %@", softButtonObjects);
                return;
            }
        }
    }

    _softButtonObjects = softButtonObjects;

    for (SDLSoftButtonObject *button in _softButtonObjects) {
        button.manager = self;
    }

    NSMutableArray<SDLArtwork *> *initialStatesToBeUploaded = [NSMutableArray array];
    NSMutableArray<SDLArtwork *> *otherStatesToBeUploaded = [NSMutableArray array];
    if (self.displayCapabilities ? self.displayCapabilities.graphicSupported.boolValue : YES) {
        // Upload all soft button images, the initial state images first, then the other states. We need to send updates when the initial state is ready.
        for (SDLSoftButtonObject *object in self.softButtonObjects) {
            if (object.currentState.artwork != nil && ![self.fileManager hasUploadedFile:object.currentState.artwork]) {
                [initialStatesToBeUploaded addObject:object.currentState.artwork];
            }
        }
        for (SDLSoftButtonObject *object in self.softButtonObjects) {
            for (SDLSoftButtonState *state in object.states) {
                if ([state.name isEqualToString:object.currentState.name]) { continue; }
                if (state.artwork != nil && ![self.fileManager hasUploadedFile:state.artwork]) {
                    [otherStatesToBeUploaded addObject:state.artwork];
                }
            }
        }
    }

    // Upload initial images, then other state images
    if (initialStatesToBeUploaded.count > 0) {
        SDLLogD(@"Uploading soft button initial artworks");
        [self.fileManager uploadArtworks:[initialStatesToBeUploaded copy] completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
            if (error != nil) {
                SDLLogE(@"Error uploading soft button artworks: %@", error);
            }

            SDLLogD(@"Soft button initial artworks uploaded");
            [self sdl_updateWithCompletionHandler:nil];
        }];
    }
    if (otherStatesToBeUploaded.count > 0) {
        SDLLogD(@"Uploading soft button other state artworks");
        [self.fileManager uploadArtworks:[otherStatesToBeUploaded copy] completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
            if (error != nil) {
                SDLLogE(@"Error uploading soft button artworks: %@", error);
            }

            SDLLogD(@"Soft button other state artworks uploaded");
            // In case our soft button states have changed in the meantime
            [self sdl_updateWithCompletionHandler:nil];
        }];
    }

    [self sdl_updateWithCompletionHandler:nil];
}

- (nullable SDLSoftButtonObject *)softButtonObjectNamed:(NSString *)name {
    for (SDLSoftButtonObject *object in self.softButtonObjects) {
        if ([object.name isEqualToString:name]) {
            return object;
        }
    }

    return nil;
}

- (void)updateWithCompletionHandler:(nullable SDLSoftButtonUpdateCompletionHandler)handler {
    if (self.isBatchingUpdates) { return; }

    [self sdl_updateWithCompletionHandler:handler];
}

- (void)sdl_updateWithCompletionHandler:(nullable SDLSoftButtonUpdateCompletionHandler)handler {
    // Don't send if we're in HMI NONE
    if (self.currentLevel == nil || [self.currentLevel isEqualToString:SDLHMILevelNone]) {
        return;
    }

    SDLLogD(@"Updating soft buttons");
    if (self.inProgressUpdate != nil) {
        SDLLogV(@"In progress update exists, queueing update");
        // If we already have a pending update, we're going to tell the old handler that it was superseded by a new update and then return
        if (self.queuedUpdateHandler != nil) {
            SDLLogV(@"Queued update already exists, superseding previous queued update");
            self.queuedUpdateHandler([NSError sdl_softButtonManager_pendingUpdateSuperseded]);
            self.queuedUpdateHandler = nil;
        }

        if (handler != nil) {
            self.queuedUpdateHandler = handler;
        } else {
            self.hasQueuedUpdate = YES;
        }

        return;
    }

    self.inProgressHandler = [handler copy];
    self.inProgressUpdate = [[SDLShow alloc] init];
    self.inProgressUpdate.mainField1 = self.currentMainField1 ?: @"";
    if (self.softButtonObjects == nil) {
        SDLLogV(@"Soft button objects are nil, sending an empty array");
        self.inProgressUpdate.softButtons = @[];
    } else if (([self sdl_currentStateHasImages] && ![self sdl_allCurrentStateImagesAreUploaded])
               && (self.softButtonCapabilities ? !self.softButtonCapabilities.imageSupported : YES)) {
        // The images don't yet exist on the head unit, or we cannot use images, send a text update if possible, otherwise, don't send anything yet
        NSArray<SDLSoftButton *> *textOnlyButtons = [self sdl_textButtonsForCurrentState];
        if (textOnlyButtons != nil) {
            SDLLogV(@"Soft button images unavailable, sending text buttons");
            self.inProgressUpdate.softButtons = textOnlyButtons;
        } else {
            SDLLogV(@"Soft button images unavailable, text buttons unavailable");
            self.inProgressUpdate = nil;
            return;
        }
    } else {
        SDLLogV(@"Sending soft buttons with images");
        self.inProgressUpdate.softButtons = [self sdl_softButtonsForCurrentState];
    }

    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendConnectionRequest:self.inProgressUpdate withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        SDLLogD(@"Soft button update completed");

        strongSelf.inProgressUpdate = nil;
        if (strongSelf.inProgressHandler != nil) {
            strongSelf.inProgressHandler(error);
            strongSelf.inProgressHandler = nil;
        }

        if (strongSelf.hasQueuedUpdate) {
            SDLLogV(@"Queued update exists, sending another update");
            [strongSelf updateWithCompletionHandler:[strongSelf.queuedUpdateHandler copy]];
            strongSelf.queuedUpdateHandler = nil;
            strongSelf.hasQueuedUpdate = NO;
        }
    }];
}

#pragma mark - Images

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

- (NSArray<SDLSoftButton *> *)sdl_softButtonsForCurrentState {
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray arrayWithCapacity:self.softButtonObjects.count];
    for (SDLSoftButtonObject *button in self.softButtonObjects) {
        [softButtons addObject:button.currentStateSoftButton];
    }

    return [softButtons copy];
}

#pragma mark - Getters

- (BOOL)hasQueuedUpdate {
    return (_queuedUpdateHandler != nil ?: _hasQueuedUpdate);
}

#pragma mark - RPC Responses

- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;
    self.softButtonCapabilities = response.softButtonCapabilities ? response.softButtonCapabilities.firstObject : nil;
    self.displayCapabilities = response.displayCapabilities;
}

- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;

    self.softButtonCapabilities = response.softButtonCapabilities ? response.softButtonCapabilities.firstObject : nil;
    self.displayCapabilities = response.displayCapabilities;

    // Auto-send an updated Show
    [self updateWithCompletionHandler:nil];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;

    SDLHMILevel oldHMILevel = self.currentLevel;
    self.currentLevel = hmiStatus.hmiLevel;

    // Auto-send an updated show if we were in NONE and now we are not
    if ([oldHMILevel isEqualToString:SDLHMILevelNone] && ![self.currentLevel isEqualToString:SDLHMILevelNone]) {
        if (self.waitingOnHMILevelUpdateToSetButtons) {
            [self setSoftButtonObjects:_softButtonObjects];
        } else {
            [self sdl_updateWithCompletionHandler:nil];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
