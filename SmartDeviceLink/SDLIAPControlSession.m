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
        if (self.delegate == nil) { return; }
        [self.delegate controlSessionShouldRetry];
    } else {
        SDLLogD(@"Starting a control session with accessory (%@)", self.accessory.name);

        if (![self sdl_startStreams]) {
            SDLLogW(@"Control session failed to setup with accessory: %@. Attempting to create a new control session", self.accessory);
            [self destroySession];
            if (self.delegate == nil) { return; }
            [self.delegate controlSessionShouldRetry];
        } else {
            SDLLogD(@"Waiting for the protocol string from Core, setting timer for %d seconds", ProtocolIndexTimeoutSeconds);
            self.protocolIndexTimer = [self sdl_createControlSessionProtocolIndexStringDataTimeoutTimer];
        }
    }
}

- (BOOL)sdl_startStreams {
    if (![super createSession]) { return NO; }

    // No need for its own thread as only a small amount of data will be transmitted before control session is destroyed
    SDLLogD(@"Created the control session successfully");
    [super startStream:self.eaSession.outputStream];
    [super startStream:self.eaSession.inputStream];

    return YES;
}

#pragma mark Stop

- (void)destroySession {
    SDLLogD(@"Destroying the control session");
    [self sdl_destroySession];
}

/**
 *  Makes sure the session is closed and destroyed on the main thread.
 */
- (void)sdl_destroySession {
    if ([NSThread isMainThread]) {
        [self sdl_stopAndDestroySession];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self sdl_stopAndDestroySession];
        });
    }
}

/**
 *  Closes the session streams and then destroys the session.
 */
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
    [self destroySession];

    if (self.delegate == nil) { return; }
    [self.delegate controlSessionShouldRetry];
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
    [self destroySession];

    if (self.accessory.isConnected) {
        if (self.delegate != nil) {
            [self.delegate controlSession:self didReceiveProtocolString:indexedProtocolString];
        }
        [self.protocolIndexTimer cancel];
    }
}

/**
 *  Called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 */
- (void)sdl_streamDidError:(NSStream *)stream {
    SDLLogE(@"Control stream error");

    [self.protocolIndexTimer cancel];
    [self destroySession];

    if (self.delegate == nil) { return; }
    [self.delegate controlSessionShouldRetry];
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
        [strongSelf sdl_destroySession];

        if (strongSelf.delegate == nil) { return; }
        [strongSelf.delegate controlSessionShouldRetry];
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

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPControlSession dealloc");
    [self destroySession];
    _protocolIndexTimer = nil;
}

@end

NS_ASSUME_NONNULL_END
