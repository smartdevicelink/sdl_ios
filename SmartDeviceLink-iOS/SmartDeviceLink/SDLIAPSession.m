//
//  SDLIAPSession.m
//

#import "SDLIAPSession.h"
#import "SDLDebugTool.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"


@interface SDLIAPSession ()

@property (assign) BOOL isInputStreamOpen;
@property (assign) BOOL isOutputStreamOpen;

@end


@implementation SDLIAPSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {
    NSString *logMessage = [NSString stringWithFormat:@"SDLIAPSession initWithAccessory:%@ forProtocol:%@", accessory, protocol];
    [SDLDebugTool logInfo:logMessage];

    self = [super init];
    if (self) {
        _delegate = nil;
        _accessory = accessory;
        _protocol = protocol;
        _streamDelegate = nil;
        _easession = nil;
        _isInputStreamOpen = NO;
        _isOutputStreamOpen = NO;
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

        [strongSelf startStream:weakSelf.easession.outputStream];
        [strongSelf startStream:weakSelf.easession.inputStream];

        return YES;

    } else {
        [SDLDebugTool logInfo:@"Error: Could Not Create Session Object"];
        return NO;
    }
}

- (void)stop {
    [self stopStream:self.easession.outputStream];
    [self stopStream:self.easession.inputStream];
    self.easession = nil;
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

    [stream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
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


#pragma mark - Lifecycle Destruction

- (void)dealloc {
    self.delegate = nil;
    self.accessory = nil;
    self.protocol = nil;
    self.streamDelegate = nil;
    self.easession = nil;
    [SDLDebugTool logInfo:@"SDLIAPSession Dealloc"];
}

@end
