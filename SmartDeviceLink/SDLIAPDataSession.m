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
NSTimeInterval const IOStreamThreadWaitSecs = 1.0;

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPDataSession ()

@property (nullable, nonatomic, strong) NSThread *ioStreamThread;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@property (weak, nonatomic) id<SDLIAPDataSessionDelegate> delegate;
@property (nonatomic, strong) dispatch_semaphore_t canceledSemaphore;

@end

@implementation SDLIAPDataSession

#pragma mark - Session lifecycle

- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPDataSessionDelegate>)delegate forProtocol:(NSString *)protocol; {
    SDLLogV(@"SDLIAPDataSession init");

    self = [super initWithAccessory:accessory forProtocol:protocol];
    if (!self) { return nil; }

    _delegate = delegate;
    _sendDataQueue = [[SDLMutableDataQueue alloc] init];
    _canceledSemaphore = dispatch_semaphore_create(0);

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
            [self destroySession];
            if (self.delegate == nil) { return; }
            [self.delegate dataSessionShouldRetry];
        }

        self.ioStreamThread = [[NSThread alloc] initWithTarget:self selector:@selector(sdl_accessoryEventLoop) object:nil];
        [self.ioStreamThread setName:IOStreamThreadName];
        [self.ioStreamThread start];
    }
}

#pragma mark Stop

- (void)destroySession {
    SDLLogD(@"Destroying the data session");
    [self sdl_destroySession];
    [self.sendDataQueue removeAllObjects];
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
 *  Waits for the session streams to close on the I/O Thread and then destroys the session.
 */
- (void)sdl_stopAndDestroySession {
    NSAssert(NSThread.isMainThread, @"%@ must only be called on the main thread", NSStringFromSelector(_cmd));

    if (self.ioStreamThread == nil) {
        SDLLogV(@"Stopping data session but no thread established.");
        [super cleanupClosedSession];
        return;
    }

    [self.ioStreamThread cancel];

    // Waiting for the I/O streams of the data session to close
    [self sdl_isIOThreadCanceled:self.canceledSemaphore completionHandler:^(BOOL success) {
        if (success == NO) {
            SDLLogE(@"Destroying thread (IOStreamThread) for data session when I/O streams have not yet closed.");
        }
        self.ioStreamThread = nil;
        [super cleanupClosedSession];
    }];
}

/**
 *  Wait for the data session to detroy its input and output streams. The data EASession can not be destroyed until both streams have closed.
 *
 *  @param canceledSemaphore When the canceled semaphore is released, the data session's input and output streams have been destroyed.
 *  @param completionHandler Returns whether or not the data session's I/O streams were closed successfully.
 */
- (void)sdl_isIOThreadCanceled:(dispatch_semaphore_t)canceledSemaphore completionHandler:(void (^)(BOOL success))completionHandler {
    long lWait = dispatch_semaphore_wait(canceledSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(IOStreamThreadWaitSecs * NSEC_PER_SEC)));
    if (lWait == 0) {
        SDLLogD(@"Stream thread canceled successfully");
        return completionHandler(YES);
    } else {
        SDLLogE(@"Failed to cancel stream thread");
        return completionHandler(NO);
    }
}

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
        [self destroySession];

        if (self.delegate == nil) { return; }
        [self.delegate dataSessionShouldRetry];
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
        [self destroySession];
        if (![self.protocolString isEqualToString:LegacyProtocolString]) {
            if (self.delegate == nil) { return; }
            [self.delegate dataSessionShouldRetry];
        }
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

        while (!self.ioStreamThread.cancelled) {
            // Enqueued data will be written to and read from the streams in the runloop
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25f]];
        }

        SDLLogD(@"Closing the accessory event loop on thread: %@", NSThread.currentThread.name);

        // Close I/O streams of the data session. When the streams are closed. Notify the thread that it can close
        [self sdl_closeSession];

        dispatch_semaphore_signal(self.canceledSemaphore);
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

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPDataSession dealloc");
    [self destroySession];
}

@end

NS_ASSUME_NONNULL_END
