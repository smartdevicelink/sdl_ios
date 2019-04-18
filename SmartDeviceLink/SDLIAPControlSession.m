//
//  SDLIAPControlSession.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLIAPControlSession.h"

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLIAPConstants.h"
#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"


NS_ASSUME_NONNULL_BEGIN

int const ProtocolIndexTimeoutSeconds = 10;

@interface SDLIAPControlSession ()

@property (nullable, strong, nonatomic, readwrite) SDLIAPSession *session;
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (nullable, strong, nonatomic) SDLIAPControlSessionRetryCompletionHandler retrySessionHandler;
@property (nullable, strong, nonatomic) SDLIAPControlSessionCreateDataSessionCompletionHandler createDataSessionHandler;

@end

@implementation SDLIAPControlSession

- (instancetype)init {
    SDLLogV(@"SDLIAPControlSession Init");
    self = [super init];
    if (!self) {
        return nil;
    }

    _session = nil;
    _protocolIndexTimer = nil;

    return self;
}

- (instancetype)initWithSession:(nullable SDLIAPSession *)session retrySessionCompletionHandler:(SDLIAPControlSessionRetryCompletionHandler)retrySessionHandler createDataSessionCompletionHandler:(SDLIAPControlSessionCreateDataSessionCompletionHandler)createDataSessionHandler {

    self = [super init];
    if (!self) {
        return nil;
    }

    self.session = session;
    self.retrySessionHandler = retrySessionHandler;
    self.createDataSessionHandler = createDataSessionHandler;

    if (self.session) {
        SDLLogD(@"Starting control session with accessory (%@)", self.session.accessory.name);
        EAAccessory *accessory = session.accessory;
        SDLStreamDelegate *controlStreamDelegate = [[SDLStreamDelegate alloc] init];
        controlStreamDelegate.streamHasBytesHandler = [self sdl_controlStreamHasBytesHandlerForAccessory:accessory];
        controlStreamDelegate.streamEndHandler = [self sdl_controlStreamEndedHandler];
        controlStreamDelegate.streamErrorHandler = [self sdl_controlStreamErroredHandler];
        self.session.streamDelegate = controlStreamDelegate;

        if (![self.session start]) {
            SDLLogW(@"Control session failed to setup with accessory: %@. Retrying...", accessory);
            [self stopSession];
            [self sdl_shouldRetryEstablishSession:YES];
        } else {
            SDLLogW(@"Control session started");
            if (self.protocolIndexTimer != nil) {
                SDLLogV(@"Cancelling control session timer");
                [self.protocolIndexTimer cancel];
            }

            SDLLogD(@"Waiting for the protocol string from Core, setting timer for %d seconds", ProtocolIndexTimeoutSeconds);
            self.protocolIndexTimer = [self sdl_createProtocolIndexTimer];
        }
    } else {
        SDLLogW(@"Failed to setup control session");
        [self sdl_shouldRetryEstablishSession:YES];
    }

    return self;
}

- (void)stopSession {
    if (self.session != nil) {
        SDLLogD(@"Stopping the control session");
        [self.session stop];
        self.session.streamDelegate = nil;

        // Important - Do not destroy the session as it can a few seconds to close the input and output streams. If set to `nil`, the session will not close properly and a new session with the accessory can not be created.
    }
}

- (void)startSessionTimer {
    if (!self.protocolIndexTimer) { return; }

    [self.protocolIndexTimer start];
}

#pragma mark - Control Stream Handlers

- (SDLStreamEndHandler)sdl_controlStreamEndedHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"Control stream ended");

        // End events come in pairs, only perform this once per set.
        if (strongSelf.session != nil) {
            [strongSelf.protocolIndexTimer cancel];
            [strongSelf stopSession];
            [strongSelf sdl_shouldRetryEstablishSession:YES];
        }
    };
}

- (SDLStreamHasBytesHandler)sdl_controlStreamHasBytesHandlerForAccessory:(EAAccessory *)accessory {
    __weak typeof(self) weakSelf = self;

    return ^(NSInputStream *istream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogV(@"Control stream received data");

        // Read in the stream a single byte at a time
        uint8_t buf[1];
        NSInteger len = [istream read:buf maxLength:1];
        if (len <= 0) {
            SDLLogV(@"No data received from the control stream");
            return;
        }

        // If we have data from the control stream, use the data to create the protocol string needed to establish the data session.
        NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@", IndexedProtocolStringPrefix, @(buf[0])];
        SDLLogD(@"Control Stream will switch to protocol %@", indexedProtocolString);

        // Destroy the control session as it is no longer needed, and then create the data session.
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongSelf stopSession];
        });

        if (accessory.isConnected) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf sdl_createDataSessionWithIndexProtocolString:indexedProtocolString connectedAccessory:accessory];
                [strongSelf.protocolIndexTimer cancel];
            });
        } else {
            SDLLogE(@"Accessory is not connected");
        }
    };
}

- (SDLStreamErrorHandler)sdl_controlStreamErroredHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogE(@"Control stream error");

        [strongSelf.protocolIndexTimer cancel];
        [strongSelf stopSession];
        [strongSelf sdl_shouldRetryEstablishSession:YES];
    };
}

#pragma mark - Helpers

- (SDLTimer *)sdl_createProtocolIndexTimer {
    SDLTimer *protocolIndexTimer = [[SDLTimer alloc] initWithDuration:ProtocolIndexTimeoutSeconds repeat:NO];

    __weak typeof(self) weakSelf = self;
    void (^elapsedBlock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogW(@"Control session failed to get the protocol string from Core after %d seconds, retrying.", ProtocolIndexTimeoutSeconds);
        [strongSelf stopSession];
        [strongSelf sdl_shouldRetryEstablishSession:YES];
    };
    protocolIndexTimer.elapsedBlock = elapsedBlock;

    return protocolIndexTimer;
}

- (void)sdl_shouldRetryEstablishSession:(BOOL)retryEstablishSession {
    if (self.retrySessionHandler == nil) {
        return;
    }

    self.retrySessionHandler(retryEstablishSession);
}

- (void)sdl_createDataSessionWithIndexProtocolString:(NSString *)indexProtocolString connectedAccessory:(EAAccessory *)accessory {
    if (self.createDataSessionHandler == nil) {
        return;
    }

    self.createDataSessionHandler(accessory, indexProtocolString);
}

- (NSUInteger)accessoryID {
    return self.session.accessory.connectionID;
}

- (BOOL)isSessionInProgress {
    return (self.session != nil && !self.session.isStopped);
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPControlSession Dealloc");
    _session = nil;
    _protocolIndexTimer = nil;
}

@end

NS_ASSUME_NONNULL_END
