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
#import "SDLLogMacros.h"
#import "SDLTimer.h"


NS_ASSUME_NONNULL_BEGIN

int const ProtocolIndexTimeoutSeconds = 10;

@interface SDLIAPControlSession ()

@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (weak, nonatomic) id<SDLIAPControlSessionDelegate> delegate;

@end

@implementation SDLIAPControlSession

#pragma mark - Session lifecycle

- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPControlSessionDelegate>)delegate {
    SDLLogV(@"SDLIAPControlSession init");

    self = [super initWithAccessory:accessory forProtocol:ControlProtocolString];
    if (!self) { return nil; }

    _protocolIndexTimer = nil;
    _delegate = delegate;

    return self;
}

#pragma mark Start

- (void)startSession {
    if (self.accessory == nil) {
        SDLLogW(@"There is no control session in progress, attempting to create a new control session.");
        [self.delegate controlSessionShouldRetry];
    } else {
        SDLLogD(@"Starting a control session with accessory (%@)", self.accessory.name);
        __weak typeof(self) weakSelf = self;
        [self sdl_startStreamsWithCompletionHandler:^(BOOL success) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!success) {
                SDLLogW(@"Control session failed to setup with accessory: %@. Attempting to create a new control session", strongSelf.accessory);
                [strongSelf destroySessionWithCompletionHandler:^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf.delegate controlSessionShouldRetry];
                }];
            } else {
                SDLLogD(@"Waiting for the protocol string from Core, setting timeout timer for %d seconds", ProtocolIndexTimeoutSeconds);
                strongSelf.protocolIndexTimer = [strongSelf sdl_createControlSessionProtocolIndexStringDataTimeoutTimer];
            }
        }];
    }
}

/// Opens the input and output streams for the session on the main thread.
/// @discussion We must close the input/output streams from the same thread that owns the streams' run loop, otherwise if the streams are closed from another thread a random crash may occur. Since only a small amount of data will be transmitted on this stream before it is closed, we will open and close the streams on the main thread instead of creating a separate thread.
- (void)sdl_startStreamsWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    if (![super createSession]) {
        return completionHandler(NO);
    }

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;

        SDLLogD(@"Created the control session successfully");
        [super startStream:strongSelf.eaSession.outputStream];
        [super startStream:strongSelf.eaSession.inputStream];

        return completionHandler(YES);
    });
}

#pragma mark Stop

/// Makes sure the session is closed and destroyed on the main thread.
/// @param disconnectCompletionHandler Handler called when the session has disconnected
- (void)destroySessionWithCompletionHandler:(void (^)(void))disconnectCompletionHandler {
    SDLLogD(@"Destroying the control session");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sdl_stopAndDestroySession];
        return disconnectCompletionHandler();
    });
}

/// Closes the session streams and then destroys the session.
- (void)sdl_stopAndDestroySession {
    NSAssert(NSThread.isMainThread, @"%@ must only be called on the main thread", NSStringFromSelector(_cmd));

    [super stopStream:self.eaSession.outputStream];
    [super stopStream:self.eaSession.inputStream];
    [super cleanupClosedSession];
}


#pragma mark - NSStreamDelegate

/**
 *  Handles events on the input/output streams of the open session.
 *
 *  @param stream       The stream (either input or output) that the event occured on
 *  @param eventCode    The stream event code
 */
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self sdl_streamDidOpen:stream];
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            [self sdl_streamHasBytesAvailable:(NSInputStream *)stream];
            break;
        }
        case NSStreamEventErrorOccurred: {
            [self sdl_streamDidError:stream];
            break;
        }
        case NSStreamEventEndEncountered: {
            [self sdl_streamDidEnd:stream];
            break;
        }
        case NSStreamEventNone:
        case NSStreamEventHasSpaceAvailable:
        default: {
            break;
        }
    }
}

/**
 *  Called when the session gets a `NSStreamEventOpenCompleted`. When both the input and output streams open, start a timer to get data from Core within a certain timeframe.
 *
 *  @param stream The stream that got the event code.
 */
- (void)sdl_streamDidOpen:(NSStream *)stream {
    if (stream == [self.eaSession outputStream]) {
        SDLLogD(@"Control session output stream opened");
        self.isOutputStreamOpen = YES;
    } else if (stream == [self.eaSession inputStream]) {
        SDLLogD(@"Control session input stream opened");
        self.isInputStreamOpen = YES;
    }

    // When both streams are open, session initialization is complete. Let the delegate know.
    if (self.isInputStreamOpen && self.isOutputStreamOpen) {
        SDLLogV(@"Control session I/O streams opened for protocol: %@", self.protocolString);
        [self sdl_startControlSessionProtocolIndexStringDataTimeoutTimer];
    }
}

/**
 *  Called when the session gets a `NSStreamEventEndEncountered` event code. The current session is closed and a new session is attempted.
 */
- (void)sdl_streamDidEnd:(NSStream *)stream {
    SDLLogD(@"Control stream ended");

    // End events come in pairs, only perform this once per set.
    [self.protocolIndexTimer cancel];

    __weak typeof(self) weakSelf = self;
    [self destroySessionWithCompletionHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.delegate controlSessionShouldRetry];
    }];
}

/**
 *  Called when the session gets a `NSStreamEventHasBytesAvailable` event code. A protocol string is created from the received data. Since a new session needs to be established with the protocol string, the current session is closed and a new session is created.
 */
- (void)sdl_streamHasBytesAvailable:(NSInputStream *)inputStream {
    SDLLogV(@"Control stream received data");

    // Read in the stream a single byte at a time
    uint8_t buf[1];
    NSInteger len = [inputStream read:buf maxLength:1];
    if (len <= 0) {
        SDLLogV(@"No data in the control stream");
        return;
    }

    // If we have data from the control stream, use the data to create the protocol string needed to establish the data session.
    NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@", IndexedProtocolStringPrefix, @(buf[0])];
    SDLLogD(@"Control Stream will switch to protocol %@", indexedProtocolString);

    // Destroy the control session as it is no longer needed, and then create the data session.
    __weak typeof(self) weakSelf = self;
    [self destroySessionWithCompletionHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.accessory.isConnected) {
            [strongSelf.protocolIndexTimer cancel];
            [strongSelf.delegate controlSession:strongSelf didReceiveProtocolString:indexedProtocolString];
        }
    }];
}

/**
 *  Called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 */
- (void)sdl_streamDidError:(NSStream *)stream {
    SDLLogE(@"Control stream error");

    [self.protocolIndexTimer cancel];
    __weak typeof(self) weakSelf = self;
    [self destroySessionWithCompletionHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.delegate controlSessionShouldRetry];
    }];
}

#pragma mark - Timer

/**
 *  Creates a timer for the session. Core has ~10 seconds to send the protocol string, otherwise when the timer's elapsed block is called, the current session is closed and a new session is attempted.
 *
 *  @return A timer
 */
- (SDLTimer *)sdl_createControlSessionProtocolIndexStringDataTimeoutTimer {
    SDLTimer *protocolIndexTimer = [[SDLTimer alloc] initWithDuration:ProtocolIndexTimeoutSeconds repeat:NO];

    __weak typeof(self) weakSelf = self;
    void (^elapsedBlock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogW(@"Control session failed to get the protocol string from Core after %d seconds, retrying.", ProtocolIndexTimeoutSeconds);
        [strongSelf destroySessionWithCompletionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.delegate controlSessionShouldRetry];
        }];
    };

    protocolIndexTimer.elapsedBlock = elapsedBlock;
    return protocolIndexTimer;
}

/**
 *  Starts a timer for the session. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and the delegate will be notified that it should attempt to establish a new control session.
 */
- (void)sdl_startControlSessionProtocolIndexStringDataTimeoutTimer {
    if (self.protocolIndexTimer == nil) { return; }
    [self.protocolIndexTimer start];
}

@end

NS_ASSUME_NONNULL_END
