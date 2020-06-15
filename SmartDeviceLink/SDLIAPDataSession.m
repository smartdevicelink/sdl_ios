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
#import "SDLLogMacros.h"
#import "SDLMutableDataQueue.h"

NSString *const IOStreamThreadName = @"com.smartdevicelink.iostream";
NSTimeInterval const IOStreamThreadCanceledSemaphoreWaitSecs = 1.0;

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPDataSession ()

@property (nullable, nonatomic, strong) NSThread *ioStreamThread;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@property (weak, nonatomic) id<SDLIAPDataSessionDelegate> delegate;
/// A semaphore used to block the current thread until we know that the I/O streams have been shutdown on the ioStreamThread
@property (nonatomic, strong) dispatch_semaphore_t ioStreamThreadCancelledSemaphore;

@end

@implementation SDLIAPDataSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPDataSessionDelegate>)delegate forProtocol:(NSString *)protocol; {
    SDLLogV(@"iAP data session init for accessory: %@", accessory);

    self = [super initWithAccessory:accessory forProtocol:protocol];
    if (!self) { return nil; }

    _delegate = delegate;
    _sendDataQueue = [[SDLMutableDataQueue alloc] init];
    _ioStreamThreadCancelledSemaphore = dispatch_semaphore_create(0);

    return self;
}


#pragma mark Start

- (void)startSession {
    if (self.accessory == nil) {
        SDLLogW(@"Failed to setup data session");
        if (self.delegate == nil) { return; }
        [self.delegate dataSessionShouldRetry];
    } else {
        SDLLogD(@"Starting data session with accessory: %@, using protocol: %@", self.accessory.name, self.protocolString);

        if (![super createSession]) {
            SDLLogW(@"Data session failed to setup with accessory: %@. Retrying...", self.accessory);
            __weak typeof(self) weakSelf = self;
            [self destroySessionWithCompletionHandler:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf.delegate == nil) { return; }
                [strongSelf.delegate dataSessionShouldRetry];
            }];
        }

        if (self.eaSession != nil) {
            self.ioStreamThread = [[NSThread alloc] initWithTarget:self selector:@selector(sdl_accessoryEventLoop) object:nil];
            [self.ioStreamThread setName:IOStreamThreadName];
            [self.ioStreamThread start];
        }
    }
}

#pragma mark Stop

/// Waits for the ioStreamThread to close and destroy the I/O streams.
/// @param disconnectCompletionHandler Handler called when the session has disconnected
- (void)destroySessionWithCompletionHandler:(void (^)(void))disconnectCompletionHandler {
    SDLLogD(@"Destroying the data session");

    if (self.ioStreamThread == nil) {
        SDLLogV(@"No data session established");
        [super cleanupClosedSession];
        return disconnectCompletionHandler();
    }

    // Tell the ioStreamThread to shutdown the I/O streams. The I/O streams must be opened and closed on the same thread; if they are not, random crashes can occur. Dispatch this task to the main queue to ensure that this task is performed on the Main Thread. We are using the Main Thread for ease since we don't want to create a separate thread just to wait on closing the I/O streams. Using the Main Thread ensures that semaphore wait is not called from ioStreamThread, which would block the ioStreamThread and prevent shutdown.
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;

        // Attempt to cancel the ioStreamThread. Once the thread realizes it has been cancelled, it will cleanup the I/O streams. Make sure to wake up the run loop in case there is no current I/O event running on the ioThread.
        [strongSelf.ioStreamThread cancel];
        [strongSelf performSelector:@selector(sdl_doNothing) onThread:self.ioStreamThread withObject:nil waitUntilDone:NO];

        // Block the thread until the semaphore has been released by the ioStreamThread (or a timeout has occured).
        BOOL cancelledSuccessfully = [strongSelf sdl_isIOThreadCancelled];
        if (!cancelledSuccessfully) {
            SDLLogE(@"The I/O streams were not shut down successfully. We might not be able to create a new session with an accessory during the same app session. If this happens, only force quitting and restarting the app will allow new sessions.");
        }

        [strongSelf.sendDataQueue removeAllObjects];

        disconnectCompletionHandler();
    });
}

/// Wait for the ioStreamThread to destroy the I/O streams. Make sure this method is not called on the ioStreamThread, as it will block the thread until the timeout occurs.
/// @return Whether or not the session's I/O streams were closed successfully.
- (BOOL)sdl_isIOThreadCancelled {
    NSAssert(![NSThread.currentThread.name isEqualToString:IOStreamThreadName], @"%@ must not be called from the ioStreamThread!", NSStringFromSelector(_cmd));

    long lWait = dispatch_semaphore_wait(self.ioStreamThreadCancelledSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(IOStreamThreadCanceledSemaphoreWaitSecs * NSEC_PER_SEC)));
    if (lWait == 0) {
        SDLLogD(@"ioStreamThread cancelled successfully");
        return YES;
    }

    SDLLogE(@"Failed to cancel ioStreamThread within %.1f seconds", IOStreamThreadCanceledSemaphoreWaitSecs);
    return NO;
}

/// Helper method for waking up the ioStreamThread.
- (void)sdl_doNothing {}

#pragma mark - Sending data

- (void)sendData:(NSData *)data {
    // Enqueue the data for transmission on the IO thread
    [self.sendDataQueue enqueueBuffer:data.mutableCopy];

    [self performSelector:@selector(sdl_dequeueAndWriteToOutputStream) onThread:self.ioStreamThread withObject:nil waitUntilDone:NO];
}

/**
 *  Sends any queued data to Core on the output stream for the session.
 */
- (void)sdl_dequeueAndWriteToOutputStream {
    if ([self.ioStreamThread isCancelled]) {
        SDLLogW(@"Attempted to send data on I/O thread but the thread is cancelled.");
        return;
    }

    NSOutputStream *ostream = self.eaSession.outputStream;
    if (!ostream.hasSpaceAvailable) {
        SDLLogV(@"Attempted to send data with output stream but there is no space available.");
        return;
    }

    NSMutableData *remainder = [self.sendDataQueue frontBuffer];
    if (remainder == nil) {
        SDLLogV(@"No more data to write to data session's output stream. Returning");
        return;
    }

    NSUInteger bytesRemaining = remainder.length;
    NSInteger bytesWritten = [ostream write:remainder.bytes maxLength:bytesRemaining];

    if (bytesWritten < 0) {
        if (ostream.streamError != nil) {
            // Once a stream has reported an error, it cannot be re-used for read or write operations. Shut down the stream and attempt to create a new session.
            [self sdl_streamDidError:ostream];
        } else {
            // The write operation failed but there is no further information about the error. This can occur when disconnecting from an external accessory.
            SDLLogE(@"Output stream write operation failed");
        }
    } else if (bytesWritten == bytesRemaining) {
        // Remove the data from the queue
        [self.sendDataQueue popBuffer];
    } else {
        // Cleave the sent bytes from the data, the remainder will sit at the head of the queue
        [remainder replaceBytesInRange:NSMakeRange(0, (NSUInteger)bytesWritten) withBytes:NULL length:0];
    }
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
        case NSStreamEventHasSpaceAvailable: {
            [self sdl_streamHasSpaceToWrite];
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
        default: {
            break;
        }
    }
}

/**
 *  Called when the session gets a `NSStreamEventOpenCompleted`. When both the input and output streams open, notify the lifecycle manager that a connection has been established with the accessory.
 *
 *  @param stream The stream that got the event code.
 */
- (void)sdl_streamDidOpen:(NSStream *)stream {
    if (stream == [self.eaSession outputStream]) {
        SDLLogD(@"Data session output stream opened");
        self.isOutputStreamOpen = YES;
    } else if (stream == [self.eaSession inputStream]) {
        SDLLogD(@"Data session input stream opened");
        self.isInputStreamOpen = YES;
    }

    // When both streams are open, session initialization is complete. Let the delegate know.
    if (self.isInputStreamOpen && self.isOutputStreamOpen) {
        SDLLogV(@"Data session I/O streams opened for protocol: %@", self.protocolString);
        if (self.delegate == nil) { return; }
        [self.delegate dataSessionDidConnect];
    }
}

/**
 *  Called when the session gets a `NSStreamEventEndEncountered` event code. The current session is closed and a new session is attempted.
 */
- (void)sdl_streamDidEnd:(NSStream *)stream {
    NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));

    SDLLogD(@"Data stream ended");
    if (self.accessory == nil) {
        SDLLogD(@"Data session is nil");
        return;
    }

    // The handler will be called on the I/O thread, but the session stop method must be called on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        [self destroySessionWithCompletionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate == nil) { return; }
            [strongSelf.delegate dataSessionShouldRetry];
        }];
    });

    // To prevent deadlocks the handler must return to the runloop and not block the thread
}

/**
 *  Called when the session gets a `NSStreamEventHasBytesAvailable` event code. The data is passed to the listener.
 */
- (void)sdl_streamHasBytesAvailable:(NSInputStream *)inputStream {
    NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
    uint8_t buf[[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
    while (inputStream.streamStatus == NSStreamStatusOpen && inputStream.hasBytesAvailable) {
        // It is necessary to check the stream status and whether there are bytes available because the dataStreamHasBytesHandler is executed on the IO thread and the accessory disconnect notification arrives on the main thread, causing data to be passed to the delegate while the main thread is tearing down the transport.
        NSInteger bytesRead = [inputStream read:buf maxLength:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
        if (bytesRead < 0) {
            SDLLogE(@"Failed to read from data stream");
            break;
        }

        NSData *dataIn = [NSData dataWithBytes:buf length:(NSUInteger)bytesRead];
        SDLLogBytes(dataIn, SDLLogBytesDirectionReceive);

        if (bytesRead > 0) {
            if (self.delegate == nil) { return; }
            [self.delegate dataSessionDidReceiveData:dataIn];
        } else {
            break;
        }
    }
}

/**
 *  Called when the session gets a `NSStreamEventHasSpaceAvailable` event code. Send any queued data to Core.
 */
- (void)sdl_streamHasSpaceToWrite {
    [self sdl_dequeueAndWriteToOutputStream];
}

/**
 *  Called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 */
- (void)sdl_streamDidError:(NSStream *)stream {
    NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));

    SDLLogE(@"Data session %s stream errored", stream == self.eaSession.inputStream ? "input" : "output");

    // To prevent deadlocks the handler must return to the runloop and not block the thread
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        [self destroySessionWithCompletionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (![strongSelf.protocolString isEqualToString:LegacyProtocolString]) {
                if (strongSelf.delegate == nil) { return; }
                [strongSelf.delegate dataSessionShouldRetry];
            }
        }];
    });
}

#pragma mark - Stream lifecycle

// Data session I/O thread
- (void)sdl_accessoryEventLoop {
    @autoreleasepool {
        NSAssert(self.eaSession != nil, @"Session must be assigned before calling");
        if (!self.eaSession) {
            return;
        }

        [self startStream:self.eaSession.inputStream];
        [self startStream:self.eaSession.outputStream];

        SDLLogD(@"Starting the accessory event loop on thread: %@", NSThread.currentThread.name);

        while (self.ioStreamThread != nil && !self.ioStreamThread.cancelled) {
            // Enqueued data will be written to and read from the streams in the runloop
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25f]];
        }

        SDLLogD(@"Closing the accessory event loop on thread: %@", NSThread.currentThread.name);

        // Close I/O streams
        [self sdl_closeSession];
        [super cleanupClosedSession];

        // If a thread is blocked waiting on the I/O streams to shutdown, let the thread know that shutdown has completed.
        dispatch_semaphore_signal(self.ioStreamThreadCancelledSemaphore);
    }
}

// Must be called on accessoryEventLoop.
- (void)sdl_closeSession {
    if (self.eaSession == nil) {
        return;
    }

    SDLLogD(@"Closing EASession for accessory connection id: %tu, name: %@", self.connectionID, self.eaSession.accessory.name);

    [self stopStream:[self.eaSession inputStream]];
    [self stopStream:[self.eaSession outputStream]];
}

- (void)startStream:(NSStream *)stream {
    NSAssert([[NSThread currentThread] isEqual:self.ioStreamThread] || [NSThread isMainThread], @"startStream is being called on the wrong thread!!!");
    [super startStream:stream];
}

- (void)stopStream:(NSStream *)stream {
    NSAssert([[NSThread currentThread] isEqual:self.ioStreamThread] || [NSThread isMainThread], @"stopStream is being called on the wrong thread!!!");
    [super stopStream:stream];
}


@end

NS_ASSUME_NONNULL_END
