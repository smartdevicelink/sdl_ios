//
//  SDLIAPSession.m
//

#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLMutableDataQueue.h"
#import "SDLTimer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPSession ()

@property (nonatomic, weak) id<SDLIAPSessionDelegate> iAPSessionDelegate;
@property (nullable, strong, nonatomic, readwrite) EAAccessory *accessory;
@property (nullable, strong, nonatomic, readwrite) EASession *eaSession;
@property (copy, nonatomic) dispatch_queue_t iapSessionQueue;
@property (nullable, strong, nonatomic, readwrite) NSString *protocolString;

@property (nonatomic) BOOL inputStreamOpen;
@property (nonatomic) BOOL outputStreamOpen;
@property (nonatomic) BOOL runTheLoop;
@property (nonatomic, weak) NSThread *sessionThread;

@end

@implementation SDLIAPSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory
                      forProtocol:(NSString *)protocol
               iAPSessionDelegate:(id<SDLIAPSessionDelegate>)iAPSessionDelegate {
    SDLLogD(@"SDLIAPSession init with accessory:%@ for protocol:%@", accessory.name, protocol);
    self = [super init];
    if (!self) { return nil; }
    _accessory = accessory;
    _iAPSessionDelegate = iAPSessionDelegate;
    _inputStreamOpen = NO;
    _outputStreamOpen = NO;
    _protocolString = protocol;
    _runTheLoop = NO;
    _iapSessionQueue = dispatch_queue_create("com.sdl.iapsession", DISPATCH_QUEUE_SERIAL);
    [self startSession];
    return self;
}

- (void) dealloc {
    if (self.eaSession != nil && self.sessionThread != nil) {
        [self performSelector:@selector(peformCloseSession) onThread:self.sessionThread withObject:nil waitUntilDone:YES];
    }
}

- (void)write:(NSMutableData *) data length: (NSUInteger) length  withCompletionHandler:(void (^)(NSInteger bytesWritten))completionHandler {
    NSInteger bytesWritten = [self write:data.bytes maxLength: length];
    completionHandler(bytesWritten);
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len {
    return [self.eaSession.outputStream write:buffer maxLength:len];
}

#pragma mark - Private Stream Helpers

- (void) startSession {
    dispatch_async(self.iapSessionQueue, ^{
        self.eaSession = [[EASession alloc] initWithAccessory:self.accessory forProtocol:self.protocolString];
        self.sessionThread = NSThread.currentThread;
        SDLLogD(@"Created EASession with %@ Protocol and EASession is %@", self.protocolString, self.eaSession);
        if (self.eaSession != nil) {
            [self openStreams];
            [self startStreamRunLoop];
        } else {
            SDLLogD(@"Failed to create EASession with Protocol : %@", self.protocolString);
        }
    });
}

- (void) openStreams {
    if (self.eaSession != nil) {
        [[self.eaSession inputStream] setDelegate: self];
        [[self.eaSession inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[self.eaSession inputStream] open];
        [[self.eaSession outputStream] setDelegate: self];
        [[self.eaSession outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[self.eaSession outputStream] open];
    } else {
        SDLLogD(@"EASession is nil when calling openStreams()");
    }
}

- (void)close:(NSStream *)stream {
    if (stream.streamStatus == NSStreamStatusClosed) {
        if ([self isInputStream:stream]) {
            SDLLogD(@"EASession inputstream already closed for EASession %@", self.eaSession);
        }
        if ([self isOutputStream:stream]) {
            SDLLogD(@"EASession outputstream already closed for EASession %@", self.eaSession);
        }
        return;
    }
    
    [stream close];
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream setDelegate:nil];
    
    if ([self isInputStream:stream]) {
        self.inputStreamOpen = NO;
        SDLLogD(@"EASession closed input stream for EASession %@", self.eaSession);
    }
    if ([self isOutputStream:stream]) {
        self.outputStreamOpen = NO;
        SDLLogD(@"EASession closed output stream for EASession %@", self.eaSession);
    }
}

- (void) closeSession {
    bool waitUntilDone = NO;
    if (NSThread.currentThread == self.sessionThread) {
        waitUntilDone = YES;
    }
    [self performSelector:@selector(peformCloseSession) onThread:self.sessionThread withObject:nil waitUntilDone:waitUntilDone];
}

- (void) peformCloseSession {
    SDLLogD(@"Closing EASession streams");
    if (self.eaSession != nil) {
        [self stopStreamRunLoop];
        [self close: self.eaSession.inputStream];
        [self close: self.eaSession.outputStream];
        self.eaSession = nil;
    } else {
        SDLLogD(@"Failed to close streams because EASession is already nil");
    }
}

- (void) startStreamRunLoop {
    self.runTheLoop = YES;
    @autoreleasepool {
        while(self.runTheLoop) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.25f]];
        }
    }
}

- (void) stopStreamRunLoop {
    self.runTheLoop = NO;
}

#pragma mark - Delegate Stuff

/**
 *  Handles events on the input/output streams of the open session.
 *
 *  @param stream       The stream (either input or output) that the event occured on
 *  @param eventCode    The stream event code
 */
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
        case NSStreamEventHasSpaceAvailable: {
            [self streamHasSpaceToWrite];
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
- (void)streamDidOpen:(NSStream *)stream {
    if ([self isInputStream:stream]) {
        self.inputStreamOpen = YES;
    }
    if ([self isOutputStream: stream]) {
        self.outputStreamOpen = YES;
    }
    if (self.bothStreamsOpen) {
        SDLLogD(@"EASession input and output streams did open for protocol: %@ SDLIAPSession: %@", self.protocolString, self);
        if (self.iAPSessionDelegate != nil) {
            [self.iAPSessionDelegate streamsDidOpen];
        }
    }
}

/**
 *  Called when the session gets a `NSStreamEventHasBytesAvailable` event code. The data is passed to the listener.
 */
- (void)streamHasBytesAvailable:(NSInputStream *)inputStream {
    if (self.iAPSessionDelegate != nil) {
        [self.iAPSessionDelegate streamHasBytesAvailable:inputStream];
    }
}

/**
 *  Called when the session gets a `NSStreamEventHasSpaceAvailable` event code. Send any queued data to Core.
 */
- (void)streamHasSpaceToWrite {
    if (self.iAPSessionDelegate != nil) {
        [self.iAPSessionDelegate streamHasSpaceToWrite];
    }
}

/**
 *  Called when the session gets a `NSStreamEventEndEncountered` event code. The current session is closed and a new session is attempted.
 */
- (void)streamDidEnd:(NSStream *)stream { 
    [self closeSession];
    if (self.iAPSessionDelegate != nil) {
        [self.iAPSessionDelegate streamsDidEnd];
    }
}

/**
 *  Called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 */
- (void)streamDidError:(NSStream *)stream {
    if ([self isInputStream:stream]) {
        SDLLogE(@"EASession input stream errored");
    }
    if ([self isOutputStream:stream]) {
        SDLLogE(@"EASession output stream errored");
    }
    [self closeSession];
    if (self.iAPSessionDelegate != nil) {
        [self.iAPSessionDelegate streamDidError];
    }
}

#pragma mark - Getters

- (BOOL)bothStreamsOpen {
    if (self.inputStreamOpen && self.outputStreamOpen) {
        return YES;
    }
    return NO;
}

- (BOOL)bothStreamsClosed {
    if (self.inputStreamOpen || self.outputStreamOpen) {
        return NO;
    }
    return YES;
}

- (NSUInteger)connectionID {
    return self.eaSession.accessory.connectionID;
}

- (BOOL)hasSpaceAvailable {
    return self.eaSession.outputStream.hasSpaceAvailable;
}

- (BOOL)isConnected {
    return self.accessory.isConnected;
}

- (BOOL)isInputStream:(NSStream *)stream {
    if (stream == self.eaSession.inputStream) {
        return YES;
    }
    return NO;;
}

- (BOOL)isOutputStream:(NSStream *)stream {
    if (stream == self.eaSession.outputStream) {
        return YES;
    }
    return NO;;
}

- (BOOL)isSessionInProgress {
    if (!self.inputStreamOpen && !self.outputStreamOpen) {
        return NO;
        SDLLogD(@"EASession not in progress");
    }
    return YES;
}

@end

NS_ASSUME_NONNULL_END
