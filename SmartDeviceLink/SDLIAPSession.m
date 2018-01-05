//
//  SDLIAPSession.m
//

#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLMutableDataQueue.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const IOStreamThreadName = @"com.smartdevicelink.iostream";
NSTimeInterval const StreamThreadWaitSecs = 1.0;

@interface SDLIAPSession ()

@property (nonatomic, assign) BOOL isInputStreamOpen;
@property (nonatomic, assign) BOOL isOutputStreamOpen;
@property (nonatomic, assign) BOOL isDataSession;
@property (nullable, nonatomic, strong) NSThread *ioStreamThread;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@property (nonatomic, strong) dispatch_semaphore_t canceledSemaphore;

@end


@implementation SDLIAPSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {
    SDLLogD(@"SDLIAPSession initWithAccessory:%@ forProtocol:%@", accessory, protocol);

    self = [super init];
    if (self) {
        _isDataSession = [protocol isEqualToString:@"com.smartdevicelink.prot0"] ? NO : YES;
        _accessory = accessory;
        _protocol = protocol;
        _canceledSemaphore = dispatch_semaphore_create(0);
        _sendDataQueue = [[SDLMutableDataQueue alloc] init];
        _isInputStreamOpen = NO;
        _isOutputStreamOpen = NO;
    }
    return self;
}


#pragma mark - Public Stream Lifecycle

- (BOOL)start {
    __weak typeof(self) weakSelf = self;
    SDLLogD(@"Opening EASession withAccessory:%@ forProtocol:%@", _accessory.name, _protocol);

    // TODO: This assignment should be broken out of the if and the if / else should be flipped.
    if ((self.easession = [[EASession alloc] initWithAccessory:self.accessory forProtocol:self.protocol])) {
        __strong typeof(self) strongSelf = weakSelf;

        SDLLogD(@"Created Session Object");

        strongSelf.streamDelegate.streamErrorHandler = [self streamErroredHandler];
        strongSelf.streamDelegate.streamOpenHandler = [self streamOpenedHandler];
        if (self.isDataSession) {
            self.streamDelegate.streamHasSpaceHandler = [self sdl_streamHasSpaceHandler];
            // Start I/O event loop processing events in iAP channel
            self.ioStreamThread = [[NSThread alloc] initWithTarget:self selector:@selector(sdl_accessoryEventLoop) object:nil];
            [self.ioStreamThread setName:IOStreamThreadName];
            [self.ioStreamThread start];
        } else {
            // Set up control session -- no need for its own thread
            [self startStream:self.easession.outputStream];
            [self startStream:self.easession.inputStream];
        }
        return YES;

    } else {
        SDLLogE(@"Error: Could Not Create Session Object");
        return NO;
    }
}

- (void)stop {
    // This method must be called on the main thread
    if ([NSThread isMainThread]) {
        [self sdl_stop];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self sdl_stop];
        });
    }
}

- (void)sdl_stop {
    if (self.isDataSession) {
        [self.ioStreamThread cancel];

        long lWait = dispatch_semaphore_wait(self.canceledSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(StreamThreadWaitSecs * NSEC_PER_SEC)));
        if (lWait == 0) {
            SDLLogW(@"Stream thread cancelled");
        } else {
            SDLLogE(@"Failed to cancel stream thread");
        }
        self.ioStreamThread = nil;
        self.isDataSession = NO;
    } else {
        // Stop control session
        [self stopStream:self.easession.outputStream];
        [self stopStream:self.easession.inputStream];
    }
    self.easession = nil;
}

- (BOOL)isStopped {
    return !self.isOutputStreamOpen && !self.isInputStreamOpen;
}

#pragma mark - data send methods

- (void)sendData:(NSData *)data {
    // Enqueue the data for transmission on the IO thread
    [self.sendDataQueue enqueueBuffer:data.mutableCopy];

    [self performSelector:@selector(sdl_dequeueAndWriteToOutputStream) onThread:self.ioStreamThread withObject:nil waitUntilDone:NO];
}

- (void)sdl_dequeueAndWriteToOutputStream {
    NSOutputStream *ostream = self.easession.outputStream;
    NSMutableData *remainder = [self.sendDataQueue frontBuffer];

    if (remainder != nil && ostream.streamStatus == NSStreamStatusOpen) {
        NSUInteger bytesRemaining = remainder.length;
        NSInteger bytesWritten = [ostream write:remainder.bytes maxLength:bytesRemaining];
        if (bytesWritten < 0) {
            if (ostream.streamError != nil) {
                [self sdl_handleOutputStreamWriteError:ostream.streamError];
            }
        } else if (bytesWritten == bytesRemaining) {
            // Remove the data from the queue
            [self.sendDataQueue popBuffer];
        } else {
            // Cleave the sent bytes from the data, the remainder will sit at the head of the queue
            [remainder replaceBytesInRange:NSMakeRange(0, (NSUInteger)bytesWritten) withBytes:NULL length:0];
        }
    }
}

- (void)sdl_handleOutputStreamWriteError:(NSError *)error {
    SDLLogE(@"Output stream error: %@", error);
    // TODO: We should look at the domain and the code as a tuple and decide how to handle the error based on both values. For now, if the stream is closed, we will flush the send queue and leave it as-is otherwise so that temporary error conditions can be dealt with by retrying
    if (self.easession == nil ||
        self.easession.outputStream == nil ||
        self.easession.outputStream.streamStatus != NSStreamStatusOpen) {
        [self.sendDataQueue removeAllObjects];
    }
}

#pragma mark - background I/O for data session

// Data session I/O thread
- (void)sdl_accessoryEventLoop {
    @autoreleasepool {
        NSAssert(self.easession, @"_session must be assigned before calling");

        if (!self.easession) {
            return;
        }

        [self startStream:self.easession.inputStream];
        [self startStream:self.easession.outputStream];

        SDLLogD(@"Starting the accessory event loop");
        do {
            if (self.sendDataQueue.count > 0 && !self.sendDataQueue.frontDequeued) {
                [self sdl_dequeueAndWriteToOutputStream];
            }
            // The principle here is to give the event loop enough time to process stream events while also allowing it to handle new enqueued data buffers in a timely manner. We're capping the run loop CPU time at 0.25s maximum before it will return control to the rest of the loop.
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25f]];
        } while (![NSThread currentThread].cancelled);

        SDLLogD(@"Closing the accessory session for id: %tu, name: %@", self.easession.accessory.connectionID, self.easession.accessory.name);

        // Close I/O streams of the iAP session
        [self sdl_closeSession];
        dispatch_semaphore_signal(self.canceledSemaphore);
    }
}

// Must be called on accessoryEventLoop.
- (void)sdl_closeSession {
    if (!self.easession) {
        return;
    }

    SDLLogD(@"Close EASession for accessory id: %tu, name: %@", self.easession.accessory.connectionID, self.easession.accessory.name);

    [self stopStream:[self.easession inputStream]];
    [self stopStream:[self.easession outputStream]];
}


#pragma mark - Private Stream Lifecycle Helpers

- (void)startStream:(NSStream *)stream {
    stream.delegate = self.streamDelegate;
    NSAssert((self.isDataSession && [[NSThread currentThread] isEqual:self.ioStreamThread]) || [NSThread isMainThread], @"startStream is being called on the wrong thread!!!");
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
}

- (void)stopStream:(NSStream *)stream {
    // Verify stream is in a state that can be closed.
    // (N.B. Closing a stream that has not been opened has very, very bad effects.)

    // When you disconect the cable you get a stream end event and come here but stream is already in closed state.
    // Still need to remove from run loop.

    NSAssert((self.isDataSession && [[NSThread currentThread] isEqual:self.ioStreamThread]) || [NSThread isMainThread], @"stopStream is being called on the wrong thread!!!");

    NSUInteger status1 = stream.streamStatus;
    if (status1 != NSStreamStatusNotOpen &&
        status1 != NSStreamStatusClosed) {
        [stream close];
    }

    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream setDelegate:nil];

    NSUInteger status2 = stream.streamStatus;
    if (status2 == NSStreamStatusClosed) {
        if (stream == [self.easession inputStream]) {
            SDLLogD(@"Input Stream Closed");
			self.isInputStreamOpen = NO;
        } else if (stream == [self.easession outputStream]) {
            SDLLogD(@"Output Stream Closed");
			self.isOutputStreamOpen = NO;
        }
    }
}


#pragma mark - Stream Handlers

- (SDLStreamOpenHandler)streamOpenedHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (stream == [strongSelf.easession outputStream]) {
            SDLLogD(@"Output Stream Opened");
            strongSelf.isOutputStreamOpen = YES;
        } else if (stream == [strongSelf.easession inputStream]) {
            SDLLogD(@"Input Stream Opened");
            strongSelf.isInputStreamOpen = YES;
        }

        // When both streams are open, session initialization is complete. Let the delegate know.
        if (strongSelf.isInputStreamOpen && strongSelf.isOutputStreamOpen) {
            [strongSelf.delegate onSessionInitializationCompleteForSession:weakSelf];
        }
    };
}

- (SDLStreamErrorHandler)streamErroredHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        SDLLogW(@"Stream Error: %@", stream);
        [strongSelf.delegate onSessionStreamsEnded:strongSelf];
    };
}

- (SDLStreamHasSpaceHandler)sdl_streamHasSpaceHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (!strongSelf.isDataSession) {
            return;
        }

        [strongSelf sdl_dequeueAndWriteToOutputStream];
    };
}

@end

NS_ASSUME_NONNULL_END
