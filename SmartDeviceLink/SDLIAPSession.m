//
//  SDLIAPSession.m
//

#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLMutableDataQueue.h"
#import "SDLTimer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPSession ()
/**
 * The input stream for the session is open when a `NSStreamEventOpenCompleted` event is received for the input stream. The input stream is closed when the stream status is `NSStreamStatusClosed`.
 */
@property (nonatomic, assign) BOOL isInputStreamOpen;

/**
 * The output stream for the session is open when a `NSStreamEventOpenCompleted` event is received for the output stream. The output stream has been closed when the stream status is `NSStreamStatusClosed`.
 */
@property (nonatomic, assign) BOOL isOutputStreamOpen;

@property (nullable, strong, nonatomic, readwrite) EASession *eaSession;
@property (nullable, strong, nonatomic, readwrite) EAAccessory *accessory;
@property (nullable, strong, nonatomic, readwrite) NSString *protocolString;

@end

@implementation SDLIAPSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory forProtocol:(NSString *)protocol {
    SDLLogD(@"SDLIAPSession init with accessory:%@ for protocol:%@", accessory.name, protocol);

    self = [super init];
    if (!self) { return nil; }

    _accessory = accessory;
    _protocolString = protocol;
    _isInputStreamOpen = NO;
    _isOutputStreamOpen = NO;

    return self;
}

#pragma mark - Abstract Methods

- (void)startSession {}

- (void)destroySession {}

#pragma mark - Private Stream Lifecycle Helpers

- (BOOL)start {
    SDLLogD(@"Opening EASession with accessory: %@", self.accessory.name);
    self.eaSession = [[EASession alloc] initWithAccessory:self.accessory forProtocol:self.protocolString];
    return (self.eaSession != nil);
}

- (void)startStream:(NSStream *)stream {
    stream.delegate = self;
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
}

- (void)stopStream:(NSStream *)stream {
    // Verify stream is in a state that can be closed. Closing a stream that has not been opened has very bad effects.
    NSUInteger status1 = stream.streamStatus;
    if (status1 != NSStreamStatusNotOpen &&
        status1 != NSStreamStatusClosed) {
        [stream close];
    }

    // When the USB cable is disconnected, the app will will call this method after the `NSStreamEventEndEncountered` event. The stream will already be in the closed state but it still needs to be removed from the run loop.
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream setDelegate:nil];

    NSUInteger status2 = stream.streamStatus;
    if (status2 == NSStreamStatusClosed) {
        if (stream == [self.eaSession inputStream]) {
            SDLLogD(@"Input stream closed");
			self.isInputStreamOpen = NO;
        } else if (stream == [self.eaSession outputStream]) {
            SDLLogD(@"Output stream closed");
			self.isOutputStreamOpen = NO;
        }
    }
}

- (void)closeSession {
    if (self.eaSession == nil) {
        SDLLogD(@"Attempting to close session with accessory: %@, but it is already closed", self.accessory.name);
        return;
    }

    self.eaSession = nil;
    SDLLogD(@"Session closed for: %@", self.accessory.serialNumber);
    self.accessory.delegate = nil;
}

#pragma mark - Getters

- (BOOL)isStopped {
    return !self.isOutputStreamOpen && !self.isInputStreamOpen;
}

- (NSUInteger)connectionID {
    return self.eaSession.accessory.connectionID;
}

- (BOOL)isSessionInProgress {
    return !self.isStopped;
}

@end

NS_ASSUME_NONNULL_END
