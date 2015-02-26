//
//  SDLIAPSession.m
//
//  Copyright (c) 2014 FMC. All rights reserved.
//
#import "SDLDebugTool.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"
#import "SDLIAPConfig.h"


@interface SDLIAPSession ()

@property (assign) BOOL isInputStreamOpen;
@property (assign) BOOL isOutputStreamOpen;

- (void)startStream:(NSStream *)stream ;
- (void)stopStream:(NSStream *)stream;

@end


@implementation SDLIAPSession

- (instancetype)initWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol{
    NSString *logMessage = [NSString stringWithFormat:@"SDLIAPSession initWithAccessory:%@ forProtocol:%@" , accessory, protocol];
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


- (BOOL)start {

    __weak typeof(self) weakSelf = self;

    NSString *logMessage = [NSString stringWithFormat:@"Opening EASession withAccessory:%@ forProtocol:%@" , _accessory.name, _protocol];
    [SDLDebugTool logInfo:logMessage];

    if ((self.easession = [[EASession alloc] initWithAccessory:_accessory forProtocol:_protocol])) {
        [SDLDebugTool logInfo:@"Created Session Object"];

        // Stream Error Handler
        weakSelf.streamDelegate.streamErrorHandler = ^(NSStream *stream) {
            [SDLDebugTool logInfo:@"Stream Error"];
            [weakSelf.delegate onSessionStreamsEnded:weakSelf];
        };

        // Stream Open Handler
        weakSelf.streamDelegate.streamOpenHandler = ^(NSStream *stream){

            if (stream == [weakSelf.easession outputStream]) {
                [SDLDebugTool logInfo:@"Output Stream Opened"];
                weakSelf.isOutputStreamOpen = YES;
            } else if (stream == [weakSelf.easession inputStream]) {
                [SDLDebugTool logInfo:@"Input Stream Opened"];
                weakSelf.isInputStreamOpen = YES;
            }

            // When both streams are open, session initialization is complete. Let the delegate know.
            if (weakSelf.isInputStreamOpen && weakSelf.isOutputStreamOpen) {
                [weakSelf.delegate onSessionInitializationCompleteForSession:weakSelf];
            }
        };


        // Start the streams.
        [weakSelf startStream:weakSelf.easession.outputStream];
        [weakSelf startStream:weakSelf.easession.inputStream];

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

- (void)dealloc {
    self.delegate = nil;
    self.accessory = nil;
    self.protocol = nil;
    self.streamDelegate = nil;
    self.easession = nil;
    [SDLDebugTool logInfo:@"SDLIAPSession Dealloc"];
}

@end
