//
//  SDLTCPTransport.m
//  SmartDeviceLink
//
//  Created by Sho Amano on 2018/04/23.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLTCPTransport.h"
#import "SDLMutableDataQueue.h"
#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLTimer.h"
#import <errno.h>

NS_ASSUME_NONNULL_BEGIN

NSString *const TCPIOThreadName = @"com.smartdevicelink.tcpiothread";
NSTimeInterval const IOThreadCanceledSemaphoreWaitSecs = 1.0;
NSUInteger const DefaultReceiveBufferSize = 16 * 1024;
NSTimeInterval ConnectionTimeoutSecs = 30.0;

@interface SDLTCPTransport ()

@property (nullable, nonatomic, strong) NSThread *ioThread;
@property (nonatomic, assign) NSUInteger receiveBufferSize;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@property (nullable, nonatomic, strong) NSInputStream *inputStream;
@property (nullable, nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, assign) BOOL outputStreamHasSpace;
@property (nullable, nonatomic, strong) SDLTimer *connectionTimer;
@property (nonatomic, assign) BOOL transportConnected;
@property (nonatomic, assign) BOOL transportErrorNotified;
/// A semaphore used to block the current thread until we know that the I/O streams have been shutdown on the ioThread
@property (nonatomic, strong) dispatch_semaphore_t ioThreadCancelledSemaphore;

@end

@implementation SDLTCPTransport

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _receiveBufferSize = DefaultReceiveBufferSize;
    _sendDataQueue = [[SDLMutableDataQueue alloc] init];
    _ioThreadCancelledSemaphore = dispatch_semaphore_create(0);

    return self;
}

- (instancetype)initWithHostName:(NSString *)hostName portNumber:(NSString *)portNumber {
    self = [self init];
    if (!self) { return nil; }

    _hostName = hostName;
    _portNumber = portNumber;

    return self;
}

#pragma mark - Stream Lifecycle

// Note: When a connection is refused (e.g. TCP port number is not correct) or timed out (e.g. invalid IP address), then onError will be notified.
- (void)connect {
    if (self.ioThread != nil) {
        SDLLogW(@"TCP transport is already connected");
        return;
    }

    SDLLogD(@"Attempting to connect");

    unsigned int port;
    int num = [self.portNumber intValue];
    if (0 <= num && num <= 65535) {
        port = (unsigned int)num;
    } else {
        // specify an invalid port, so that once connection is initiated we will receive an error through delegate
        port = 65536;
    }

    self.ioThread = [[NSThread alloc] initWithTarget:self selector:@selector(sdl_tcpTransportEventLoop) object:nil];
    self.ioThread.name = TCPIOThreadName;

    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    CFStringRef hostName = (__bridge CFStringRef)self.hostName;

    CFStreamCreatePairWithSocketToHost(NULL, hostName, port, &readStream, &writeStream);

    // this transport is mainly for video streaming
    CFReadStreamSetProperty(readStream, kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVideo);
    CFWriteStreamSetProperty(writeStream, kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVideo);

    self.inputStream = (__bridge_transfer NSInputStream *)readStream;
    self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;

    [self.ioThread start];
}

- (void)disconnectWithCompletionHandler:(void (^)(void))disconnectCompletionHandler {
    SDLLogD(@"Disconnecting");

    [self.sendDataQueue removeAllObjects];
    self.transportErrorNotified = NO;
    self.transportConnected = NO;

    if (self.ioThread == nil) {
        SDLLogV(@"TCP transport not yet started or has been shutdown");
        return disconnectCompletionHandler();
    }

    // Tell the ioThread to shutdown the I/O streams. The I/O streams must be opened and closed on the same thread; if they are not, random crashes can occur. Dispatch this task to the main queue to ensure that this task is performed on the Main Thread. We are using the Main Thread for ease since we don't want to create a separate thread just to wait on closing the I/O streams. Using the Main Thread ensures that semaphore wait is not called from ioThread, which would block the ioThread and prevent shutdown.
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;

        // Attempt to cancel the ioThread. Once the thread realizes it has been cancelled, it will cleanup the I/O streams. Make sure to wake up the run loop in case there is no current I/O event running on the ioThread.
        [strongSelf.ioThread cancel];
        [strongSelf performSelector:@selector(sdl_doNothing) onThread:self.ioThread withObject:nil waitUntilDone:NO];

        // Block the thread until the semaphore has been released by the ioThread (or a timeout has occured).
        BOOL cancelledSuccessfully = [strongSelf sdl_isIOThreadCancelled];
        if (!cancelledSuccessfully) {
            SDLLogE(@"The I/O streams were not shut down successfully. We might not be able to create a new session with an accessory during the same app session. If this happens, only force quitting and restarting the app will allow new sessions.");
        }

        disconnectCompletionHandler();
    });
}

/// Wait for the ioThread to destroy the I/O streams. To ensure that we are not blocking the ioThread, this method should only be called from the main thread.
/// @return Whether or not the session's I/O streams were closed successfully.
- (BOOL)sdl_isIOThreadCancelled {
    NSAssert(![NSThread.currentThread.name isEqualToString:TCPIOThreadName], @"%@ must not be called from the ioThread!", NSStringFromSelector(_cmd));

    long lWait = dispatch_semaphore_wait(self.ioThreadCancelledSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(IOThreadCanceledSemaphoreWaitSecs * NSEC_PER_SEC)));
    if (lWait == 0) {
        SDLLogD(@"ioThread cancelled successfully");
        return YES;
    }

    SDLLogE(@"Failed to cancel ioThread within %f seconds", IOThreadCanceledSemaphoreWaitSecs);
    return NO;
}

/// Helper method for waking up the ioThread.
- (void)sdl_doNothing {}

#pragma mark - Data Transmission

- (void)sendData:(NSData *)msgBytes {
    [self.sendDataQueue enqueueBuffer:msgBytes.mutableCopy];

    [self performSelector:@selector(sdl_writeToStream) onThread:self.ioThread withObject:nil waitUntilDone:NO];
}

#pragma mark - Run loop

- (void)sdl_tcpTransportEventLoop {
    @autoreleasepool {
        [self sdl_setupStream:self.inputStream];
        [self sdl_setupStream:self.outputStream];

        // JFYI: NSStream itself has a connection timeout (about 1 minute). If you specify a large timeout value, you may get the NSStream's timeout event first.
        __weak typeof(self) weakSelf = self;
        self.connectionTimer = [[SDLTimer alloc] initWithDuration:ConnectionTimeoutSecs];
        self.connectionTimer.elapsedBlock = ^{
            [weakSelf sdl_onConnectionTimedOut];
        };
        [self.connectionTimer startOnRunLoop:[NSRunLoop currentRunLoop]];

        // these will initiate a connection to remote server
        SDLLogD(@"Connecting to %@:%@ ...", self.hostName, self.portNumber);
        [self.inputStream open];
        [self.outputStream open];

        while (self.ioThread != nil && !self.ioThread.cancelled) {
            BOOL ret = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            if (!ret) {
                SDLLogW(@"Failed to start TCP transport run loop");
                break;
            }
        }

        // Close the I/O streams
        SDLLogD(@"TCP transport run loop terminated");
        [self sdl_teardownStream:self.inputStream];
        [self sdl_teardownStream:self.outputStream];
        self.inputStream = nil;
        self.outputStream = nil;
        [self.connectionTimer cancel];

        // If a thread is blocked waiting on the I/O streams to shutdown, let the thread know that shutdown has completed.
        dispatch_semaphore_signal(self.ioThreadCancelledSemaphore);
    }
}

/// Configures a stream
/// @param stream An input or output stream
- (void)sdl_setupStream:(NSStream *)stream {
    stream.delegate = self;
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

/// Tears down a stream
/// @param stream An input or output stream
- (void)sdl_teardownStream:(NSStream *)stream {
    NSStreamStatus streamStatus = stream.streamStatus;
    if (streamStatus != NSStreamStatusNotOpen && streamStatus != NSStreamStatusClosed) {
        [stream close];
    }
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream setDelegate:nil];
}

#pragma mark - NSStreamDelegate
// this method runs only on the I/O thread (i.e. invoked from the run loop)

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventNone: {
            // nothing to do
        } break;
        case NSStreamEventOpenCompleted: {
            // We will get two NSStreamEventOpenCompleted events (for both input and output streams) and we don't need both. Let's use the one of output stream since we need to make sure that output stream is ready before Proxy sending Start Service frame.
            if (aStream == self.outputStream) {
                SDLLogD(@"TCP transport connected");
                [self.connectionTimer cancel];
                self.transportConnected = YES;
                [self.delegate onTransportConnected];
            }
        } break;
        case NSStreamEventHasBytesAvailable: {
            [self sdl_readFromStream];
        } break;
        case NSStreamEventHasSpaceAvailable: {
            self.outputStreamHasSpace = YES;
            [self sdl_writeToStream];
        } break;
        case NSStreamEventErrorOccurred: {
            SDLLogW(@"TCP transport error occurred with %@ stream: %@", aStream == self.inputStream ? @"input" : @"output", aStream.streamError);
            [self sdl_onStreamError:aStream];
        } break;
        case NSStreamEventEndEncountered: {
            SDLLogD(@"TCP transport %@ stream end encountered", aStream == self.inputStream ? @"input" : @"output");
            [self sdl_onStreamEnd:aStream];
        } break;
    }
}

#pragma mark - Stream event handlers
// these methods run only on the I/O thread (i.e. invoked from the run loop)

- (void)sdl_readFromStream {
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_readFromStream is called on a wrong thread!");

    BytePtr buffer = malloc(self.receiveBufferSize);
    NSInteger readBytes = [self.inputStream read:buffer maxLength:self.receiveBufferSize];
    if (readBytes < 0) {
        SDLLogW(@"TCP transport read error: %@", self.inputStream.streamError);
        [self sdl_onStreamError:self.inputStream];
        free(buffer);
        return;
    } else if (readBytes == 0) {
        SDLLogD(@"TCP transport input stream closed");
        [self sdl_onStreamEnd:self.inputStream];
        free(buffer);
        return;
    }

    NSData *data = [NSData dataWithBytesNoCopy:buffer length:(NSUInteger)readBytes freeWhenDone:YES];
    [self.delegate onDataReceived:data];
}

- (void)sdl_writeToStream {
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_writeToStream is called on a wrong thread!");

    if (!self.outputStreamHasSpace || [self.sendDataQueue count] == 0) {
        return;
    }

    NSMutableData *buffer = [self.sendDataQueue frontBuffer];
    NSUInteger bufferLen = buffer.length;

    NSInteger bytesWritten = [self.outputStream write:buffer.bytes maxLength:bufferLen];
    if (bytesWritten < 0) {
        SDLLogW(@"TCP transport write error: %@", self.outputStream.streamError);
        [self sdl_onStreamError:self.outputStream];
        return;
    } else if (bytesWritten == 0) {
        SDLLogD(@"TCP transport output stream closed");
        [self sdl_onStreamEnd:self.outputStream];
        return;
    }

    if (bytesWritten == bufferLen) {
        // we have consumed all of data in this buffer
        [self.sendDataQueue popBuffer];
    } else {
        [buffer replaceBytesInRange:NSMakeRange(0, (NSUInteger)bytesWritten) withBytes:NULL length:0];
    }

    // the output stream may still have some spaces, but let's wait for another NSStreamEventHasSpaceAvailable event before writing
    self.outputStreamHasSpace = NO;
}

- (void)sdl_onConnectionTimedOut {
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_onConnectionTimedOut is called on a wrong thread!");

    SDLLogW(@"TCP connection timed out");
    if (!self.transportErrorNotified) {
        NSAssert(!self.transportConnected, @"transport should not be connected in this case");
        [self.delegate onError:[NSError sdl_transport_connectionTimedOutError]];
        self.transportErrorNotified = YES;
    }
}

- (void)sdl_onStreamError:(NSStream *)stream {
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_onStreamError is called on a wrong thread!");

    // avoid notifying multiple error events
    if (self.transportErrorNotified) {
        return;
    }

    if (self.transportConnected) {
        // transport is disconnected while running
        [self.delegate onTransportDisconnected];
        self.transportErrorNotified = YES;
    } else if ([stream.streamError.domain isEqualToString:NSPOSIXErrorDomain]) {
        // connection error

        // According to Apple's document "Error Objects, Domains, and Codes", the 'code' values of NSPOSIXErrorDomain are actually errno values.
        NSError *error;
        switch (stream.streamError.code) {
            case ECONNREFUSED: {
                SDLLogE(@"TCP connection error: ECONNREFUSED (connection refused)");
                error = [NSError sdl_transport_connectionRefusedError];
            } break;
            case ETIMEDOUT: {
                SDLLogE(@"TCP connection error: ETIMEDOUT (connection timed out)");
                error = [NSError sdl_transport_connectionTimedOutError];
            } break;
            case ENETDOWN: {
                SDLLogE(@"TCP connection error: ENETDOWN (network down)");
                error = [NSError sdl_transport_networkDownError];
            } break;
            case ENETUNREACH: {
                SDLLogE(@"TCP connection error: ENETUNREACH (network unreachable)");
                error = [NSError sdl_transport_networkDownError];
            } break;
            default: {
                SDLLogE(@"TCP connection error: unknown error %ld", (long)stream.streamError.code);
                error = [NSError sdl_transport_unknownError];
            } break;
        }
        [self.delegate onError:error];
        self.transportErrorNotified = YES;
    } else {
        SDLLogE(@"Unhandled stream error! %@", stream.streamError);
    }
}

- (void)sdl_onStreamEnd:(NSStream *)stream {
    SDLLogD(@"Stream ended");
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_onStreamEnd is called on a wrong thread!");

    if (!self.transportErrorNotified) {
        [self.delegate onTransportDisconnected];
        self.transportErrorNotified = YES;
    }
}

@end

NS_ASSUME_NONNULL_END
