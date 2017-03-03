//
//  SDLIAPSession.m
//

#import "SDLIAPSession.h"
#import "SDLDebugTool.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"

#define IO_STREAMTHREAD_NAME            @ "com.smartdevicelink.iostream"
#define STREAM_THREAD_WAIT_SECS         1.0
#define STREAM_THREAD_WAIT_WRITE_SECS   5.0

@interface SDLIAPSession ()

@property (assign, nonatomic) BOOL isInputStreamOpen;
@property (assign, nonatomic) BOOL isOutputStreamOpen;
@property (assign, nonatomic) BOOL isDataSession;
@property (nonatomic, copy) SessionSendHandler sendBlock;
@property (nonatomic, strong) NSThread *ioStreamThread;
@property (nonatomic, assign) BOOL isSendStarted;
@property (nonatomic, strong) dispatch_semaphore_t canceledSema;
@property (nonatomic, strong) dispatch_semaphore_t sendCompleteSema;
@end


@implementation SDLIAPSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {
    NSString *logMessage = [NSString stringWithFormat:@"SDLIAPSession initWithAccessory:%@ forProtocol:%@", accessory, protocol];
    [SDLDebugTool logInfo:logMessage];
    
    if ([protocol isEqualToString:@"com.smartdevicelink.prot0"]){
        _isDataSession = NO;
    }
    else{
        _isDataSession = YES;
    }

    self = [super init];
    if (self) {
        _accessory = accessory;
        _protocol = protocol;
        _isInputStreamOpen = NO;
        _isOutputStreamOpen = NO;
        _canceledSema = dispatch_semaphore_create(0);
        _sendCompleteSema = dispatch_semaphore_create(0);
        _sendBlock = nil;
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
            _ioStreamThread = [[NSThread alloc] initWithTarget:self selector:@selector(accessoryEventLoop) object:nil];
            [_ioStreamThread setName:IO_STREAMTHREAD_NAME];
            [_ioStreamThread start];
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

- (void)sendData:(SessionSendHandler)sender{
    @synchronized (self) {
        self.sendBlock = sender;
        self.isSendStarted = NO;
    }
    long lWait = dispatch_semaphore_wait(self.sendCompleteSema, dispatch_time(DISPATCH_TIME_NOW, STREAM_THREAD_WAIT_WRITE_SECS * NSEC_PER_SEC));
    if (lWait != 0){
        NSLog(@"ERROR! Failed to write data!!!");
    }
}

- (void)accessoryEventLoop {
    BOOL sendStarted;
    SessionSendHandler sendBlock;
    
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
      @autoreleasepool {
          @synchronized (self) {
              sendBlock = self.sendBlock;
              sendStarted = self.isSendStarted;
          }
          
          if (sendBlock != nil &&!sendStarted && outStream.hasSpaceAvailable){
              NSError *err = nil;
              BOOL sendComplete = sendBlock(&err);
              
              
              if (err != nil){
                  [SDLDebugTool logFormat:@"Output stream error %@", err];
              }
              else{
                  if (sendComplete){
                      @synchronized (self) {
                          self.sendBlock = nil;
                      }
                      dispatch_semaphore_signal(self.sendCompleteSema);
                  }
                  else{
                      @synchronized (self) {
                          self.isSendStarted = YES;
                      }
                  }
              }
          }
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25f]];
      }
    } while (self.accessory != nil &&
             self.accessory.connected &&
             ![NSThread currentThread].cancelled);
    
    NSLog(@"closing accessory session");
    
    // Close I/O streams of the iAP session
    [self closeSession];
    _accessory = nil;
      dispatch_semaphore_signal(self.canceledSema);
  }
}

// Must be called on accessoryEventLoop.
- (void)closeSession {
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
            SessionSendHandler sendCompletion;
            @synchronized (strongSelf) {
                sendCompletion = strongSelf.sendBlock;
            }
            
            if (sendCompletion != nil){
                NSError *err = nil;
                BOOL sendComplete = sendCompletion(&err);
                if (err != nil){
                    NSLog(@"ERROR!!! Output stream reported %@", err);
                }
                else{
                    if (sendComplete){
                        @synchronized (strongSelf) {
                            strongSelf.sendBlock = nil;
                        }
                        dispatch_semaphore_signal(strongSelf.sendCompleteSema);
                    }
                }
            }
        }
    };
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    self.delegate = nil;
    self.accessory = nil;
    self.protocol = nil;
    self.streamDelegate = nil;
    self.easession = nil;
    self.ioStreamThread =  nil;
    self.canceledSema = nil;
    self.sendBlock = nil;
    self.sendCompleteSema = nil;
    [SDLDebugTool logInfo:@"SDLIAPSession Dealloc"];
}

@end

