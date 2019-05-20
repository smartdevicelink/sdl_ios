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

- (instancetype)initWithAccessory:(EAAccessory *)accessory delegate:(id<SDLIAPControlSessionDelegate>)delegate {
    SDLLogV(@"SDLIAPControlSession init");

    self = [super initWithAccessory:accessory forProtocol:ControlProtocolString];
    if (!self) {
        return nil;
    }

    _protocolIndexTimer = nil;
    _delegate = delegate;

    return self;
}

- (void)startSession {
    if (self.accessory == nil) {
        SDLLogW(@"There is no control session in progress, attempting to create a new control session.");
        if (self.delegate == nil) { return; }
        [self.delegate retryControlSession];
    } else {
        SDLLogD(@"Starting a control session with accessory (%@)", self.accessory.name);

        if (![self sdl_start]) {
            SDLLogW(@"Control session failed to setup with accessory: %@. Attempting to create a new control session", self.accessory);
            [self destroySession];
            if (self.delegate == nil) { return; }
            [self.delegate retryControlSession];
        } else {
            SDLLogD(@"Waiting for the protocol string from Core, setting timer for %d seconds", ProtocolIndexTimeoutSeconds);
            self.protocolIndexTimer = [self sdl_createProtocolIndexTimer];
        }
    }
}

- (BOOL)sdl_start {
    if (![super start]) { return NO; }
    // No need for its own thread as only a small amount of data will be transmitted before control session is destroyed
    SDLLogD(@"Created the control session successfully");
    [self startStream:self.eaSession.outputStream];
    [self startStream:self.eaSession.inputStream];

    return YES;
}

- (void)stop {
    if ([NSThread isMainThread]) {
        [self sdl_stop];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self sdl_stop];
        });
    }
}

- (void)sdl_stop {
    NSAssert(NSThread.isMainThread, @"%@ must only be called on the main thread", NSStringFromSelector(_cmd));

    [self stopStream:self.eaSession.outputStream];
    [self stopStream:self.eaSession.inputStream];
    self.eaSession = nil;
}

- (void)destroySession {
    if (self.accessory == nil) {
        SDLLogV(@"Attempting to stop the control session but the accessory is nil");
        return;
    }

    SDLLogD(@"Destroying the control session");
    [self stop];
}

/**
 *  Starts a timer for the session. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and the delegate will be notified that it should attempt to establish a new control session.
 */
- (void)sdl_startSessionTimer {
    if (self.protocolIndexTimer == nil) { return; }
    [self.protocolIndexTimer start];
}

#pragma mark - SDLSessionDelegate

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self streamDidOpen:stream];
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            [self streamHasBytesAvailable:(NSInputStream *)stream];
            break;
        }
        case NSStreamEventErrorOccurred: {
            [self streamDidError:stream];
            break;
        }
        case NSStreamEventEndEncountered: {
            [self streamDidEnd:stream];
            break;
        }
        case NSStreamEventNone:
        case NSStreamEventHasSpaceAvailable:
        default: {
            break;
        }
    }
}

- (void)streamDidOpen:(NSStream *)stream {
    if (stream == [self.eaSession outputStream]) {
        SDLLogD(@"Output Stream Opened");
        self.isOutputStreamOpen = YES;
    } else if (stream == [self.eaSession inputStream]) {
        SDLLogD(@"Input Stream Opened");
        self.isInputStreamOpen = YES;
    }

    // When both streams are open, session initialization is complete. Let the delegate know.
    if (self.isInputStreamOpen && self.isOutputStreamOpen) {
        SDLLogV(@"Control session I/O streams opened for protocol: %@", self.protocolString);
        [self sdl_startSessionTimer];
    }
}

/**
 *  Handler called when the session gets a `NSStreamEventEndEncountered` event code. The current session is closed and a new session is attempted.
 */
- (void)streamDidEnd:(NSStream *)stream {
    SDLLogD(@"Control stream ended");

    // End events come in pairs, only perform this once per set.
    [self.protocolIndexTimer cancel];
    [self destroySession];

    if (self.delegate == nil) { return; }
    [self.delegate retryControlSession];
}

/**
 *  Handler called when the session gets a `NSStreamEventHasBytesAvailable` event code. A protocol string is created from the received data. Since a new session needs to be established with the protocol string, the current session is closed and a new session is created.
 */
- (void)streamHasBytesAvailable:(NSInputStream *)inputStream {
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
 *  Handler called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 */
- (void)streamDidError:(NSStream *)stream {
    SDLLogE(@"Control stream error");

    [self.protocolIndexTimer cancel];
    [self destroySession];

    if (self.delegate == nil) { return; }
    [self.delegate retryControlSession];
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
        [strongSelf stop];

        if (strongSelf.delegate == nil) { return; }
        [strongSelf.delegate retryControlSession];
    };

    protocolIndexTimer.elapsedBlock = elapsedBlock;
    return protocolIndexTimer;
}

#pragma mark - Getters

- (NSUInteger)connectionID {
    return self.accessory.connectionID;
}

- (BOOL)isSessionInProgress {
    return !self.isStopped;
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPControlSession dealloc");
    [self destroySession];
    _protocolIndexTimer = nil;
}

@end

NS_ASSUME_NONNULL_END
