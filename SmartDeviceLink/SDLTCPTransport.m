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
#import "SDLLogMacros.h"
#import <errno.h>

NS_ASSUME_NONNULL_BEGIN

NSString *const TCPIOThreadName = @"com.smartdevicelink.tcpiothread";
NSTimeInterval const IOThreadWaitSecs = 1.0;
NSUInteger const DefaultReceiveBufferSize = 16 * 1024;
NSTimeInterval ConnectionTimeoutSecs = 30.0;

@interface SDLTCPTransport ()

@property (nullable, nonatomic, strong) NSThread *ioThread;
@property (nonatomic, strong) dispatch_semaphore_t ioThreadStoppedSemaphore;
@property (nonatomic, assign) NSUInteger receiveBufferSize;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@property (nullable, nonatomic, strong) NSInputStream *inputStream;
@property (nullable, nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, assign) BOOL outputStreamHasSpace;
@property (nullable, nonatomic, strong) NSTimer *connectionTimer;
@property (nonatomic, assign) BOOL transportConnected;
@property (nonatomic, assign) BOOL transportErrorNotified;
@end

@implementation SDLTCPTransport

- (instancetype)init {
    if (self = [super init]) {
        _receiveBufferSize = DefaultReceiveBufferSize;
        _sendDataQueue = [[SDLMutableDataQueue alloc] init];
    }
    return self;
}

- (instancetype)initWithHostName:(NSString *)hostName portNumber:(NSString *)portNumber {
    self = [self init];
    if (!self) { return nil; }

    _hostName = hostName;
    _portNumber = portNumber;

    return self;
}

- (void)dealloc {
    SDLLogD(@"SDLTCPTransport dealloc");
    [self disconnect];
}

#pragma mark - Stream Lifecycle

// Note: When a connection is refused (e.g. TCP port number is not correct) or timed out (e.g. invalid IP address), then onError will be notified.
- (void)connect {
    if (self.ioThread != nil) {
        SDLLogW(@"TCP transport is already connected");
        return;
    }

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
    self.ioThreadStoppedSemaphore = dispatch_semaphore_create(0);

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

- (void)disconnect {
    if (self.ioThread == nil) {
        // already disconnected
        return;
    }

    SDLLogD(@"Disconnecting TCP transport");

    [self sdl_cancelIOThread];

    long ret = dispatch_semaphore_wait(self.ioThreadStoppedSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(IOThreadWaitSecs * NSEC_PER_SEC)));
    if (ret == 0) {
        SDLLogD(@"TCP transport thread stopped");
    } else {
        SDLLogE(@"Failed to stop TCP transport thread");
    }
    self.ioThread = nil;

    self.inputStream = nil;
    self.outputStream = nil;

    [self.sendDataQueue removeAllObjects];
    self.transportErrorNotified = NO;
    self.transportConnected = NO;
}

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
        self.connectionTimer = [NSTimer scheduledTimerWithTimeInterval:ConnectionTimeoutSecs target:self selector:@selector(sdl_onConnectionTimedOut:) userInfo:nil repeats:NO];

        // these will initiate a connection to remote server
        SDLLogD(@"Connecting to %@:%@ ...", self.hostName, self.portNumber);
        [self.inputStream open];
        [self.outputStream open];

        while (![self.ioThread isCancelled]) {
            BOOL ret = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            if (!ret) {
                SDLLogW(@"Failed to start TCP transport run loop");
                break;
            }
        }
        SDLLogD(@"TCP transport run loop terminated");

        [self sdl_teardownStream:self.inputStream];
        [self sdl_teardownStream:self.outputStream];

        [self.connectionTimer invalidate];

        dispatch_semaphore_signal(self.ioThreadStoppedSemaphore);
    }
}

- (void)sdl_setupStream:(NSStream *)stream {
    stream.delegate = self;
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)sdl_teardownStream:(NSStream *)stream {
    NSStreamStatus streamStatus = stream.streamStatus;
    if (streamStatus != NSStreamStatusNotOpen && streamStatus != NSStreamStatusClosed) {
        [stream close];
    }
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream setDelegate:nil];
}

- (void)sdl_cancelIOThread {
    [self.ioThread cancel];
    // wake up the run loop in case we don't have any I/O event
    [self performSelector:@selector(sdl_doNothing) onThread:self.ioThread withObject:nil waitUntilDone:NO];
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
                [self.connectionTimer invalidate];
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

- (void)sdl_onConnectionTimedOut:(NSTimer *)timer {
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_onConnectionTimedOut is called on a wrong thread!");

    SDLLogW(@"TCP connection timed out");
    [self sdl_cancelIOThread];

    if (!self.transportErrorNotified) {
        NSAssert(!self.transportConnected, @"transport should not be connected in this case");
        [self.delegate onError:[NSError sdl_transport_connectionTimedOutError]];
        self.transportErrorNotified = YES;
    }
}

- (void)sdl_onStreamError:(NSStream *)stream {
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_onStreamError is called on a wrong thread!");

    // stop I/O thread
    [self sdl_cancelIOThread];

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
                SDLLogD(@"TCP connection error: ECONNREFUSED");
                error = [NSError sdl_transport_connectionRefusedError];
            } break;
            case ETIMEDOUT: {
                SDLLogD(@"TCP connection error: ETIMEDOUT");
                error = [NSError sdl_transport_connectionTimedOutError];
            } break;
            case ENETDOWN: {
                SDLLogD(@"TCP connection error: ENETDOWN");
                error = [NSError sdl_transport_networkDownError];
            } break;
            case ENETUNREACH: {
                // This is just for safe. I did not observe ENETUNREACH error on iPhone.
                SDLLogD(@"TCP connection error: ENETUNREACH");
                error = [NSError sdl_transport_networkDownError];
            } break;
            default: {
                SDLLogD(@"TCP connection error: unknown error %ld", (long)stream.streamError.code);
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
    NSAssert([[NSThread currentThread] isEqual:self.ioThread], @"sdl_onStreamEnd is called on a wrong thread!");

    [self sdl_cancelIOThread];

    if (!self.transportErrorNotified) {
        [self.delegate onTransportDisconnected];
        self.transportErrorNotified = YES;
    }
}

- (void)sdl_doNothing {}

@end

NS_ASSUME_NONNULL_END
