//
//  SDLtreamDelegate.m
//

#import "SDLStreamDelegate.h"
#import "SDLDebugTool.h"

@interface SDLStreamDelegate ()

@property(nonatomic, strong) dispatch_queue_t input_stream_queue;

@end


@implementation SDLStreamDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _streamOpenHandler = defaultStreamOpenHandler;
        _streamHasBytesHandler = defaultStreamHasBytesHandler;
        _streamHasSpaceHandler = defaultStreamHasSpaceHandler;
        _streamErrorHandler = defaultStreamErrorHandler;
        _streamEndHandler = defaultStreamErrorHandler;

        _input_stream_queue = dispatch_queue_create("com.sdl.streamdelegate.input", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            if (self.streamOpenHandler) {
                self.streamOpenHandler(stream);
            }
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            if (self.streamHasBytesHandler) {
                dispatch_async(self.input_stream_queue, ^{
                    self.streamHasBytesHandler((NSInputStream *)stream);
                });
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            if (self.streamHasSpaceHandler) {
                self.streamHasSpaceHandler((NSOutputStream *)stream);
            }
            break;
        }
        case NSStreamEventErrorOccurred: {
            if (self.streamErrorHandler) {
                self.streamErrorHandler(stream);
            }
            break;
        }
        case NSStreamEventEndEncountered: {
            if (self.streamEndHandler) {
                self.streamEndHandler(stream);
            }
            break;
        }
        case NSStreamEventNone:
        default: {
            break;
        }
    }
}

SDLStreamOpenHandler defaultStreamOpenHandler = ^(NSStream *stream) {
    [SDLDebugTool logInfo:@"Stream Event Open"];
};

SDLStreamHasBytesHandler defaultStreamHasBytesHandler = ^(NSInputStream *istream) {
    [SDLDebugTool logInfo:@"Stream Event Has Bytes"];
};

SDLStreamHasSpaceHandler defaultStreamHasSpaceHandler = ^(NSOutputStream *ostream) {

};

SDLStreamErrorHandler defaultStreamErrorHandler = ^(NSStream *stream) {
    [SDLDebugTool logInfo:@"Stream Event Error"];
};

SDLStreamEndHandler defaultStreamEndHandler = ^(NSStream *stream) {
    [SDLDebugTool logInfo:@"Stream Event End"];
};

- (void)dealloc{
    [SDLDebugTool logInfo:@"SDLStreamDelegate dealloc"];
    self.input_stream_queue = nil;
    self.streamOpenHandler = nil;
    self.streamEndHandler = nil;
    self.streamErrorHandler = nil;
    self.streamHasBytesHandler = nil;
    self.streamHasSpaceHandler = nil;
}

@end
