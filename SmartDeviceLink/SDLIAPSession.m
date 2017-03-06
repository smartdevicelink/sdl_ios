//
//  SDLIAPSession.m
//

#import "SDLIAPSession.h"
#import "SDLDebugTool.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"
#import "SDLMutableDataQueue.h"

NS_ASSUME_NONNULL_BEGIN
#define IO_STREAMTHREAD_NAME            @ "com.smartdevicelink.iostream"
#define STREAM_THREAD_WAIT_SECS         1.0

@interface SDLIAPSession ()

@property (assign, nonatomic) BOOL isInputStreamOpen;
@property (assign, nonatomic) BOOL isOutputStreamOpen;
@property (assign, nonatomic) BOOL isDataSession;
@property (nonatomic, strong) NSThread *ioStreamThread;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@property (nonatomic, strong) dispatch_semaphore_t canceledSema;

@end


@implementation SDLIAPSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {
    NSString *logMessage = [NSString stringWithFormat:@"SDLIAPSession initWithAccessory:%@ forProtocol:%@", accessory, protocol];
    [SDLDebugTool logInfo:logMessage];

    self = [super init];
    if (self) {
        if ([protocol isEqualToString:@"com.smartdevicelink.prot0"]){
            _isDataSession = NO;
        }
        else{
            _isDataSession = YES;
        }
        _accessory = accessory;
        _protocol = protocol;
        _isInputStreamOpen = NO;
        _isOutputStreamOpen = NO;
        _canceledSema = dispatch_semaphore_create(0);
        _sendDataQueue = [[SDLMutableDataQueue alloc] init];
    }
    return self;
}


#pragma mark - Public Stream Lifecycle

- (BOOL)start {
    __weak typeof(self) weakSelf = self;

    NSString *logMessage = [NSString stringWithFormat:@"Opening EASession withAccessory:%@ forProtocol:%@", _accessory.name, _protocol];
    [SDLDebugTool logInfo:logMessage];

    if ((self.easession = [[EASession alloc] initWithAccessory:_accessory forProtocol:_protocol])) {
        __strong typeof(self) strongSelf = weakSelf;

        [SDLDebugTool logInfo:@"Created Session Object"];

        strongSelf.streamDelegate.streamErrorHandler = [self streamErroredHandler];
        strongSelf.streamDelegate.streamOpenHandler = [self streamOpenedHandler];
        if (!self.isDataSession){
            [strongSelf startStream:weakSelf.easession.outputStream];
            [strongSelf startStream:weakSelf.easession.inputStream];
        }
        else{
            strongSelf.streamDelegate.streamHasSpaceHandler = [self streamHasSpaceHandler];
            // Start I/O event loop processing events in iAP channel
            self.ioStreamThread = [[NSThread alloc] initWithTarget:self selector:@selector(sdl_accessoryEventLoop) object:nil];
            [self.ioStreamThread setName:IO_STREAMTHREAD_NAME];
            [self.ioStreamThread start];
        }

        return YES;

    } else {
        [SDLDebugTool logInfo:@"Error: Could Not Create Session Object"];
        return NO;
    }
}

- (void)stop {

    if (!self.isDataSession){
        [self stopStream:self.easession.outputStream];
        [self stopStream:self.easession.inputStream];
    }
    else{
        [self.ioStreamThread cancel];
        
        long lWait = dispatch_semaphore_wait(self.canceledSema, dispatch_time(DISPATCH_TIME_NOW, STREAM_THREAD_WAIT_SECS * NSEC_PER_SEC));
        if (lWait == 0){
            [SDLDebugTool logInfo:@"Stream thread canceled"];
        }
        else{
           [SDLDebugTool logInfo:@"Error: failed to cancel stream thread"];
        }
        self.ioStreamThread = nil;
        self.isDataSession = NO;
    }
    self.easession = nil;
}

- (void)sendData:(NSData *)data{
    // Enqueue the data for transmission on the IO thread
    [self.sendDataQueue enqueue:data.mutableCopy];
}

- (BOOL)sdl_dequeueAndWriteToOutputStream:(NSError **)error{
    NSOutputStream *ostream = self.easession.outputStream;
    NSMutableData *remainder = [self.sendDataQueue front];
    BOOL allDataWritten = NO;
    
    if (remainder != nil && ostream.streamStatus == NSStreamStatusOpen){
        NSInteger bytesRemaining = remainder.length;
        NSInteger bytesWritten = [ostream write:remainder.bytes maxLength:bytesRemaining];
        if (bytesWritten < 0){
            *error = ostream.streamError;
        }
        else{
            if (bytesWritten == bytesRemaining){
                // Remove the data from the queue
                [self.sendDataQueue pop];
                allDataWritten = YES;
            }
            else{
                // Cleave the sent bytes from the data, the remainder will sit at the head of the queue
                [remainder replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
            }
        }
    }
    
    return allDataWritten;
}

- (void)sdl_handleOutputStreamWriteError:(NSError *)error{
    NSString *errString = [NSString stringWithFormat:@"Output stream error: %@", error];
    [SDLDebugTool logInfo:errString];
    // REVIEW: We should look at the domain and the code as a tuple and decide
    // how to handle the error based on both values. For now, if the stream
    // is closed, we will flush the send queue and leave it as-is otherwise
    // so that temporary error conditions can be dealt with by retrying
    if (self.easession == nil ||
        self.easession.outputStream == nil ||
        self.easession.outputStream.streamStatus != NSStreamStatusOpen){
        [self.sendDataQueue flush];
    }
}

- (void)sdl_accessoryEventLoop {
    
  @autoreleasepool {
    NSAssert(self.easession, @"_session must be assigned before calling");
    
    if (!self.easession) {
      return;
    }
    
    // Open I/O streams of the iAP session
    NSInputStream *inStream = [self.easession inputStream];
    [inStream setDelegate:self.streamDelegate];
    [inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inStream open];
    
    NSOutputStream *outStream = [self.easession outputStream];
    [outStream setDelegate:self.streamDelegate];
    [outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outStream open];
    
    [SDLDebugTool logInfo:@"starting the event loop for accessory"];
    do {
        if (self.sendDataQueue.count > 0 && !self.sendDataQueue.frontDequeued){
            NSError *sendErr = nil;
            if (![self sdl_dequeueAndWriteToOutputStream:&sendErr] && sendErr != nil){
                [self sdl_handleOutputStreamWriteError:sendErr];
            }
        }
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25f]];
    } while (self.accessory != nil &&
             self.accessory.connected &&
             ![NSThread currentThread].cancelled);
    
    NSLog(@"closing accessory session");
    
    // Close I/O streams of the iAP session
    [self sdl_closeSession];
    _accessory = nil;
      dispatch_semaphore_signal(self.canceledSema);
  }
}

// Must be called on accessoryEventLoop.
- (void)sdl_closeSession {
  if (self.easession) {
    NSLog(@"Close EASession: %tu", self.easession.accessory.connectionID);
    NSInputStream *inStream = [self.easession inputStream];
    NSOutputStream *outStream = [self.easession outputStream];
    
    [self stopStream:inStream];
    [self stopStream:outStream];
    self.easession = nil;
  }
}


#pragma mark - Private Stream Lifecycle Helpers

- (void)startStream:(NSStream *)stream {
    stream.delegate = self.streamDelegate;
    [stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
}

- (void)stopStream:(NSStream *)stream {
    // Verify stream is in a state that can be closed.
    // (N.B. Closing a stream that has not been opened has very, very bad effects.)

    // When you disconect the cable you get a stream end event and come here but stream is already in closed state.
    // Still need to remove from run loop.

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
            [SDLDebugTool logInfo:@"Input Stream Closed"];
        } else if (stream == [self.easession outputStream]) {
            [SDLDebugTool logInfo:@"Output Stream Closed"];
        }
    }
}


#pragma mark - Stream Handlers

- (SDLStreamOpenHandler)streamOpenedHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (stream == [strongSelf.easession outputStream]) {
            [SDLDebugTool logInfo:@"Output Stream Opened"];
            strongSelf.isOutputStreamOpen = YES;
        } else if (stream == [strongSelf.easession inputStream]) {
            [SDLDebugTool logInfo:@"Input Stream Opened"];
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

        [SDLDebugTool logInfo:@"Stream Error"];
        [strongSelf.delegate onSessionStreamsEnded:strongSelf];
    };
}

- (SDLStreamHasSpaceHandler)streamHasSpaceHandler {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.isDataSession){
            NSError *sendErr = nil;
            
            if (![strongSelf sdl_dequeueAndWriteToOutputStream:&sendErr] && sendErr != nil){
                [strongSelf sdl_handleOutputStreamWriteError:sendErr];
            }
        }
    };
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    [self.sendDataQueue flush];
    self.sendDataQueue = nil;
    self.delegate = nil;
    self.accessory = nil;
    self.protocol = nil;
    self.streamDelegate = nil;
    self.easession = nil;
    self.ioStreamThread =  nil;
    self.canceledSema = nil;
    [SDLDebugTool logInfo:@"SDLIAPSession Dealloc"];
}

@end

NS_ASSUME_NONNULL_END
