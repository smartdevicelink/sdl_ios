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

@end

@implementation SDLIAPControlSession

- (instancetype)initWithSession:(nullable SDLIAPSession *)session retrySessionCompletionHandler:(SDLIAPControlSessionRetryCompletionHandler)retrySessionHandler createDataSessionCompletionHandler:(SDLIAPControlSessionCreateDataSessionCompletionHandler)createDataSessionHandler {
    SDLLogV(@"SDLIAPControlSession init");

    self = [super init];
    if (!self) {
        return nil;
    }

    _session = session;
    _protocolIndexTimer = nil;

    if (self.session) {
        SDLLogD(@"Starting control session with accessory (%@)", self.session.accessory.name);
        EAAccessory *accessory = session.accessory;
        SDLStreamDelegate *controlStreamDelegate = [[SDLStreamDelegate alloc] init];
        controlStreamDelegate.streamHasBytesHandler = [self sdl_controlStreamHasBytesHandlerForAccessory:accessory createDataSessionCompletionHandler:createDataSessionHandler];
        controlStreamDelegate.streamEndHandler = [self sdl_controlStreamEndedHandlerWithRetrySessionHandler:retrySessionHandler];
        controlStreamDelegate.streamErrorHandler = [self sdl_controlStreamEndedHandlerWithRetrySessionHandler:retrySessionHandler];
        self.session.streamDelegate = controlStreamDelegate;

        if (![self.session start]) {
            SDLLogW(@"Control session failed to setup with accessory: %@. Retrying...", accessory);
            [self stopSession];
            if (retrySessionHandler != nil) {
                retrySessionHandler();
            }
        } else {
            SDLLogW(@"Control session started");
            if (self.protocolIndexTimer != nil) {
                SDLLogV(@"Cancelling control session timer");
                [self.protocolIndexTimer cancel];
            }

            SDLLogD(@"Waiting for the protocol string from Core, setting timer for %d seconds", ProtocolIndexTimeoutSeconds);
            self.protocolIndexTimer = [self sdl_createProtocolIndexTimerWithRetrySessionHandler:retrySessionHandler];
        }
    } else {
        SDLLogW(@"Failed to setup control session");
        if (retrySessionHandler != nil) {
            retrySessionHandler();
        }
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

/**
 *  Handler called when the session gets a `NSStreamEventEndEncountered` event code. The current session is closed and a new session is attempted.
 *
 *  @return A SDLStreamEndHandler handler
 */
- (SDLStreamEndHandler)sdl_controlStreamEndedHandlerWithRetrySessionHandler:(SDLIAPControlSessionRetryCompletionHandler)retrySessionHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"Control stream ended");

        // End events come in pairs, only perform this once per set.
        if (strongSelf.session != nil) {
            [strongSelf.protocolIndexTimer cancel];
            [strongSelf stopSession];

            if (retrySessionHandler == nil) { return; }
            retrySessionHandler();
        }
    };
}

/**
 *  Handler called when the session gets a `NSStreamEventHasBytesAvailable` event code. A protocol string is created from the received data. Since a new session needs to be established with the protocol string, the current session is closed and a new session is created.
 *
 *  @param accessory    The connected accessory
 *  @return             A SDLStreamHasBytesHandler handler
 */
- (SDLStreamHasBytesHandler)sdl_controlStreamHasBytesHandlerForAccessory:(EAAccessory *)accessory createDataSessionCompletionHandler:(SDLIAPControlSessionCreateDataSessionCompletionHandler)createDataSessionHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSInputStream *istream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogV(@"Control stream received data");

        // Read in the stream a single byte at a time
        uint8_t buf[1];
        NSInteger len = [istream read:buf maxLength:1];
        if (len <= 0) {
            SDLLogV(@"No data in the control stream");
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
                if (createDataSessionHandler != nil) {
                    createDataSessionHandler(accessory, indexedProtocolString);
                }
                [strongSelf.protocolIndexTimer cancel];
            });
        }
    };
}

/**
 *  Handler called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 *
 *  @return A SDLStreamErrorHandler handler
 */
- (SDLStreamErrorHandler)sdl_controlStreamErroredHandlerWithRetrySessionHandler:(SDLIAPControlSessionRetryCompletionHandler)retrySessionHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogE(@"Control stream error");

        [strongSelf.protocolIndexTimer cancel];
        [strongSelf stopSession];

        if (retrySessionHandler == nil) { return; }
        retrySessionHandler();
    };
}

#pragma mark - Timer

/**
 *  Creates a timer for the session. Core has ~10 seconds to send the protocol string, otherwise when the timer's elapsed block is called, the current session is closed and a new session is attempted.
 *
 *  @return A timer
 */
- (SDLTimer *)sdl_createProtocolIndexTimerWithRetrySessionHandler:(SDLIAPControlSessionRetryCompletionHandler)retrySessionHandler {
    SDLTimer *protocolIndexTimer = [[SDLTimer alloc] initWithDuration:ProtocolIndexTimeoutSeconds repeat:NO];

    __weak typeof(self) weakSelf = self;
    void (^elapsedBlock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogW(@"Control session failed to get the protocol string from Core after %d seconds, retrying.", ProtocolIndexTimeoutSeconds);
        [strongSelf stopSession];

        if (retrySessionHandler == nil) { return; }
        retrySessionHandler();
    };
    protocolIndexTimer.elapsedBlock = elapsedBlock;

    return protocolIndexTimer;
}

#pragma mark - Getters

- (NSUInteger)connectionID {
    return self.session.accessory.connectionID;
}

- (BOOL)isSessionInProgress {
    return (self.session != nil && !self.session.isStopped);
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPControlSession dealloc");
    _session = nil;
    _protocolIndexTimer = nil;
}

@end

NS_ASSUME_NONNULL_END
