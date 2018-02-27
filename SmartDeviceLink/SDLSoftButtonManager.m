//
//  SDLSoftButtonManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonManager.h"

#import "SDLConnectionManagerType.h"
#import "SDLFileManager.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonManager()

@property (strong, nonatomic) NSArray<SDLSoftButton *> *currentSoftButtons;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic) SDLShow *inProgressUpdate;
@property (strong, nonatomic, nullable) SDLShow *queuedImageUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLSoftButtonUpdateCompletionHandler queuedUpdateHandler;

@end

@implementation SDLSoftButtonManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;

    return self;
}

- (BOOL)updateButtonNamed:(NSString *)buttonName replacingCurrentStateWithState:(SDLSoftButtonState *)state {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", buttonName];
    NSArray<SDLSoftButtonObject *> *buttons = [self.softButtons filteredArrayUsingPredicate:predicate];
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

    // Check to make sure no two soft buttons have the same name, there aren't many soft buttons, so n^2 isn't going to be bad
    for (NSUInteger i = 0; i < softButtons.count; i++) {
        NSString *buttonName = softButtons[i].name;
        for (NSUInteger j = i; j < softButtons.count; i++) {
            if ([softButtons[j].name isEqualToString:buttonName]) {
                return NO;
            }
        }
    }

    _softButtonObjects = softButtons;

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
        // The images don't yet exist on the head unit, so we must upload them before showing the buttons
    }

    [self.connectionManager sendConnectionRequest:self.inProgressUpdate withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (handler != NULL) {
            handler(error);
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

- (void)sdl_uploadArtworks:(NSArray<SDLArtwork *> *)artworks withCompletionHandler:(void (^)(NSError *error))handler {
    // TODO: Need uploadArtworks
}

#pragma mark - Creating Soft Buttons

/**
 Returns text soft buttons representing the initial states of the button objects, or nil if _any_ of the buttons' current states are image only buttons.

 @param buttons The buttons to extract from
 @return The text soft buttons
 */
- (nullable NSArray<SDLSoftButton *> *)sdl_extractInitialTextFromSoftButtons:(NSArray<SDLSoftButtonObject *> *)buttons {
    NSMutableArray<SDLSoftButton *> *textButtons = [NSMutableArray arrayWithCapacity:buttons.count];
    for (SDLSoftButtonObject *buttonObject in buttons) {
        SDLSoftButtonState *currentState = buttonObject.currentState;
        if (currentState.artwork != nil && currentState.text == nil) {
            return nil;
        }
    }

    return [textButtons copy];
}

- (NSArray<SDLSoftButton *> *)sdl_createSoftButtonsFromCurrentState {
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray arrayWithCapacity:self.softButtonObjects.count];
    for (SDLSoftButtonObject *button in self.softButtonObjects) {
        [softButtons addObject:button.currentState.softButton];
    }

    return [softButtons copy];
}

@end

NS_ASSUME_NONNULL_END
