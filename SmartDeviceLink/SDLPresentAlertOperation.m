//
//  SDLPresentAlertOperation.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/12/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLPresentAlertOperation.h"

#import "SDLAlert.h"
#import "SDLAlertAudioData.h"
#import "SDLAlertView.h"
#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLFile.h"
#import "SDLSoftButtonObject.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLPresentAlertOperation()

@property (strong, nonatomic) NSUUID *operationId;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic, readwrite) SDLAlertView *alertView;
@property (assign, nonatomic) UInt16 cancelId;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLPresentAlertOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager alertView:(SDLAlertView *)alertView cancelID:(UInt16)cancelID {

    self = [super init];
    if (!self) { return self; }

    _connectionManager = connectionManager;
    _alertView = alertView;
    _cancelId = cancelID;
    _operationId = [NSUUID UUID];

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }
}

- (void)sdl_presentAlert {
    [self.connectionManager sendConnectionRequest:self.alert withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (self.isCancelled) {
            [self finishOperation];
            return;
        }

        if (error != nil) {
            self.internalError = error;
        }

        [self finishOperation];
    }];
}

#pragma mark - Private Getters / Setters

- (SDLAlert *)alert {
    SDLAlert *alert = [[SDLAlert alloc] init];
    alert.alertText1 = self.alertView.text;
    alert.alertText2 = self.alertView.secondaryText;
    alert.alertText3 = self.alertView.tertiaryText;
    alert.duration = @((NSUInteger)(self.alertView.timeout * 1000));
    alert.alertIcon = self.alertView.icon.imageRPC;
    alert.progressIndicator = @(self.alertView.showWaitIndicator);
    alert.cancelID = @(self.cancelId);

    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray arrayWithCapacity:alert.softButtons.count];
    for (SDLSoftButtonObject *button in self.alertView.softButtons) {
        [softButtons addObject:button.currentStateSoftButton];
    }
    alert.softButtons = softButtons;

    NSMutableArray<SDLTTSChunk *> *ttsChunks = [NSMutableArray array];
    BOOL playTone = NO;
    for (SDLAlertAudioData *audioData in self.alertView.audio) {
        if (audioData.playTone == YES) {
            playTone = YES;
        }
        if (audioData.audioFile != nil) {
            [ttsChunks addObjectsFromArray:[SDLTTSChunk fileChunksWithName:audioData.audioFile.name]];
        }
        if (audioData.prompt != nil) {
            [ttsChunks addObjectsFromArray:audioData.prompt];
        }
    }
    alert.playTone = @(playTone);
    alert.ttsChunks = ttsChunks;

    return alert;
}

@end

NS_ASSUME_NONNULL_END
