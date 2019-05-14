//
//  SDLIAPDataSession.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLIAPDataSession.h"

#import "SDLGlobals.h"
#import "SDLIAPConstants.h"
#import "SDLIAPDataSessionDelegate.h"
#import "SDLIAPSession.h"
#import "SDLIAPSessionDelegate.h"
#import "SDLLogMacros.h"
#import "SDLStreamDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPDataSession () <SDLIAPSessionDelegate>

@property (nullable, strong, nonatomic, readwrite) SDLIAPSession *session;
@property (weak, nonatomic) id<SDLIAPDataSessionDelegate> delegate;

@end

@implementation SDLIAPDataSession

- (instancetype)initWithSession:(nullable SDLIAPSession *)session delegate:(id<SDLIAPDataSessionDelegate>)delegate {
    SDLLogV(@"SDLIAPDataSession init");

    self = [super init];
    if (!self) {
        return nil;
    }

    _session = session;
    _delegate = delegate;

    return self;
}

- (void)startSession {
    if (_session == nil) {
        SDLLogW(@"Failed to setup data session");
        if (self.delegate == nil) { return; }
        [self.delegate retryDataSession];
    } else {
        SDLLogD(@"Starting data session with accessory: %@, using protocol: %@", self.session.accessory.name, self.session.protocol);
        self.session.delegate = self;
        SDLStreamDelegate *ioStreamDelegate = [[SDLStreamDelegate alloc] init];
        self.session.streamDelegate = ioStreamDelegate;
        ioStreamDelegate.streamHasBytesHandler = [self sdl_dataStreamHasBytesHandler];
        ioStreamDelegate.streamEndHandler = [self sdl_dataStreamEndedHandler];
        ioStreamDelegate.streamErrorHandler = [self sdl_dataStreamErroredHandler];

        if (![self.session start]) {
            SDLLogW(@"Data session failed to setup with accessory: %@. Retrying...", self.session.accessory);
            [self stopSession];
            if (self.delegate == nil) { return; }
            [self.delegate retryDataSession];
        }
    }
}

- (void)stopSession {
    if (_session == nil) {
        SDLLogV(@"Attempting to stop the data session but the session is nil");
        return;
    }

    SDLLogD(@"Stopping the data session");
    [self.session stop]; // Calling stop but easession may not yet be set to `nil`
    self.session.streamDelegate = nil; //
    self.session = nil;
}

#pragma mark - Data Stream Handlers

/**
 *  Handler called when the session gets a `NSStreamEventEndEncountered` event code. The current session is closed and a new session is attempted.
 *
 *  @return A SDLStreamEndHandler handler
 */
- (SDLStreamEndHandler)sdl_dataStreamEndedHandler {
    __weak typeof(self) weakSelf = self;
    return ^(NSStream *stream) {
        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
        __strong typeof(weakSelf) strongSelf = weakSelf;

        SDLLogD(@"Data stream ended");
        if (strongSelf.session == nil) {
            SDLLogD(@"Data session is nil");
            return;
        }

        // The handler will be called on the IO thread, but the session stop method must be called on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopSession];

            if (self.delegate == nil) { return; }
            [self.delegate retryDataSession];
        });

        // To prevent deadlocks the handler must return to the runloop and not block the thread
    };
}

/**
 *  Handler called when the session gets a `NSStreamEventHasBytesAvailable` event code. The data is passed to the listener.
 *
 *  @return A SDLStreamHasBytesHandler handler
 */
- (SDLStreamHasBytesHandler)sdl_dataStreamHasBytesHandler {
    __weak typeof(self) weakSelf = self;
    return ^(NSInputStream *istream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
        uint8_t buf[[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
        while (istream.streamStatus == NSStreamStatusOpen && istream.hasBytesAvailable) {
            // It is necessary to check the stream status and whether there are bytes available because the dataStreamHasBytesHandler is executed on the IO thread and the accessory disconnect notification arrives on the main thread, causing data to be passed to the delegate while the main thread is tearing down the transport.

            NSInteger bytesRead = [istream read:buf maxLength:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
            if (bytesRead < 0) {
                SDLLogE(@"Failed to read from data stream");
                break;
            }

            NSData *dataIn = [NSData dataWithBytes:buf length:(NSUInteger)bytesRead];
            SDLLogBytes(dataIn, SDLLogBytesDirectionReceive);

            if (bytesRead > 0) {
                if (strongSelf.delegate == nil) { return; }
                [strongSelf.delegate dataReceived:dataIn];
            } else {
                break;
            }
        }
    };
}

/**
 *  Handler called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 *
 *  @return A SDLStreamErrorHandler handler
 */
- (SDLStreamErrorHandler)sdl_dataStreamErroredHandler {
    __weak typeof(self) weakSelf = self;
    return ^(NSStream *stream) {
        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
        __strong typeof(weakSelf) strongSelf = weakSelf;

        SDLLogE(@"Data stream error");
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopSession];
            if (![strongSelf.session.protocol isEqualToString:LegacyProtocolString]) {
                if (self.delegate == nil) { return; }
                [self.delegate retryDataSession];
            }
        });

        // To prevent deadlocks the handler must return to the runloop and not block the thread
    };
}

#pragma mark - SDLIAPSessionDelegate

/**
 *  Called after both the input and output streams of the session have opened.
 *
 *  @param session The current session
 */
- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session {
    if ([session.protocol isEqualToString:ControlProtocolString]) {
        // Control session
        return;
    }

    SDLLogV(@"Data session I/O streams opened for protocol: %@", session.protocol);
    if (self.delegate == nil) { return; }
    [self.delegate transportConnected];
}

/**
 *  Called when either the input and output streams of the session have errored. If the data session errored, do nothing.
 *
 *  @param session The current session
 */
- (void)onSessionStreamsEnded:(SDLIAPSession *)session {
    SDLLogV(@"Data session I/O streams errored for protocol: %@", session.protocol);
}

#pragma mark - Getters

- (NSUInteger)connectionID {
    return self.session.accessory.connectionID;
}

- (BOOL)isSessionInProgress {
    return (self.session != nil && !self.session.isStopped);
}

- (BOOL)isSessionConnected {
    return (self.session != nil && self.sessionInProgress);
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPDataSession dealloc");
    _session = nil;
}

@end

NS_ASSUME_NONNULL_END
