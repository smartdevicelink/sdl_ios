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
#import "SDLIAPControlSessionDelegate.h"
#import "SDLIAPSession.h"
#import "SDLIAPSessionDelegate.h"
#import "SDLLogMacros.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"


NS_ASSUME_NONNULL_BEGIN

int const ProtocolIndexTimeoutSeconds = 10;

@interface SDLIAPControlSession () <SDLIAPSessionDelegate>

@property (nullable, strong, nonatomic, readwrite) SDLIAPSession *session;
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (weak, nonatomic) id<SDLIAPControlSessionDelegate> delegate;

@end

@implementation SDLIAPControlSession

- (instancetype)initWithSession:(nullable SDLIAPSession *)session delegate:(id<SDLIAPControlSessionDelegate>)delegate {
    SDLLogV(@"SDLIAPControlSession init");

    self = [super init];
    if (!self) {
        return nil;
    }

    _session = session;
    _protocolIndexTimer = nil;
    _delegate = delegate;

    return self;
}

- (void)startSession {
    if (_session == nil) {
        SDLLogW(@"There is no control session in progress, attempting to create a new control session.");
        if (self.delegate == nil) { return; }
        [self.delegate retryControlSession];
    } else {
        SDLLogD(@"Starting a control session with accessory (%@)", self.session.accessory.name);
        self.session.delegate = self;
        EAAccessory *accessory = self.session.accessory;
        SDLStreamDelegate *controlStreamDelegate = [[SDLStreamDelegate alloc] init];
        controlStreamDelegate.streamHasBytesHandler = [self sdl_controlStreamHasBytesHandlerForAccessory:accessory];
        controlStreamDelegate.streamEndHandler = [self sdl_controlStreamEnded];
        controlStreamDelegate.streamErrorHandler = [self sdl_controlStreamErrored];
        self.session.streamDelegate = controlStreamDelegate;

        if (![self.session start]) {
            SDLLogW(@"Control session failed to setup with accessory: %@. Attempting to create a new control session", accessory);
            [self stopSession];
            if (self.delegate == nil) { return; }
            [self.delegate retryControlSession];
        } else {
            SDLLogD(@"Waiting for the protocol string from Core, setting timer for %d seconds", ProtocolIndexTimeoutSeconds);
            self.protocolIndexTimer = [self sdl_createProtocolIndexTimer];
        }
    }
}

- (void)stopSession {
    if (_session == nil) {
        SDLLogV(@"Attempting to stop the control session but the session is nil");
        return;
    }

    SDLLogD(@"Stopping the control session");
    [self.session stop];
    self.session.streamDelegate = nil;
    self.session = nil;
}

/**
 *  Starts a timer for the session. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and the delegate will be notified that it should attempt to establish a new control session.
 */
- (void)sdl_startSessionTimer {
    if (self.protocolIndexTimer == nil) { return; }
    [self.protocolIndexTimer start];
}

#pragma mark - Control Stream Handlers

/**
 *  Handler called when the session gets a `NSStreamEventEndEncountered` event code. The current session is closed and a new session is attempted.
 *
 *  @return                         A SDLStreamEndHandler handler
 */
- (SDLStreamEndHandler)sdl_controlStreamEnded {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"Control stream ended");

        // End events come in pairs, only perform this once per set.
        if (strongSelf.session != nil) {
            [strongSelf.protocolIndexTimer cancel];
            [strongSelf stopSession];

            if (strongSelf.delegate == nil) { return; }
            [strongSelf.delegate retryControlSession];
        }
    };
}

/**
 *  Handler called when the session gets a `NSStreamEventHasBytesAvailable` event code. A protocol string is created from the received data. Since a new session needs to be established with the protocol string, the current session is closed and a new session is created.
 *
 *  @param accessory                    The connected accessory
 *  @return                             A SDLStreamHasBytesHandler handler
 */
- (SDLStreamHasBytesHandler)sdl_controlStreamHasBytesHandlerForAccessory:(EAAccessory *)accessory {
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
                if (strongSelf.delegate != nil) {
                    [strongSelf.delegate controlSession:strongSelf.session didGetProtocolString:indexedProtocolString forConnectedAccessory:accessory];
                }
                [strongSelf.protocolIndexTimer cancel];
            });
        }
    };
}

/**
 *  Handler called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 *
 *  @return                     A SDLStreamErrorHandler handler
 */
- (SDLStreamErrorHandler)sdl_controlStreamErrored {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogE(@"Control stream error");

        [strongSelf.protocolIndexTimer cancel];
        [strongSelf stopSession];

        if (self.delegate == nil) { return; }
        [self.delegate retryControlSession];
    };
}

#pragma mark - Timer

/**
 *  Creates a timer for the session. Core has ~10 seconds to send the protocol string, otherwise when the timer's elapsed block is called, the current session is closed and a new session is attempted.
 *
 *  @return A timer
 */
- (SDLTimer *)sdl_createProtocolIndexTimer {
    SDLTimer *protocolIndexTimer = [[SDLTimer alloc] initWithDuration:ProtocolIndexTimeoutSeconds repeat:NO];

    __weak typeof(self) weakSelf = self;
    void (^elapsedBlock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogW(@"Control session failed to get the protocol string from Core after %d seconds, retrying.", ProtocolIndexTimeoutSeconds);
        [strongSelf.session stop];

        if (strongSelf.delegate == nil) { return; }
        [strongSelf.delegate retryControlSession];
    };

    protocolIndexTimer.elapsedBlock = elapsedBlock;
    return protocolIndexTimer;
}

#pragma mark - SDLIAPSessionDelegate

/**
 *  Called after both the input and output streams of the session have opened.
 *
 *  @param session The current session
 */
- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session {
    if (![session.protocol isEqualToString:ControlProtocolString]) {
        return;
    }

    SDLLogV(@"Control session I/O streams opened for protocol: %@", session.protocol);
    [self sdl_startSessionTimer];
}

/**
 *  Called when either the input and output streams of the session have errored. When the control session errors, a new control session is attempted.
 *
 *  @param session The current session
 */
- (void)onSessionStreamsEnded:(SDLIAPSession *)session {
    if (![session.protocol isEqualToString:ControlProtocolString]) {
        // Non control session
        return;
    }

    SDLLogV(@"Control session I/O streams errored for protocol: %@. Retrying", session.protocol);
    [session stop];

    if (self.delegate == nil) { return; }
    [self.delegate retryControlSession];
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
