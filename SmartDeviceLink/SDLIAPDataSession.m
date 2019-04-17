//
//  SDLIAPDataSession.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLIAPDataSession.h"

#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLStreamDelegate.h"
#import "SDLGlobals.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const LegacyProtocolString = @"com.ford.sync.prot0";

@interface SDLIAPDataSession ()

@property (nullable, strong, nonatomic, readwrite) SDLIAPSession *session;
@property (nullable, strong, nonatomic) SDLIAPDataSessionRetryCompletionHandler retrySessionHandler;
@property (nullable, strong, nonatomic) SDLIAPDataSessionCreateDataReceivedHandler dataReceivedHandler;

@end

@implementation SDLIAPDataSession

- (instancetype)init {
    SDLLogV(@"SDLIAPDataSession Init");
    self = [super init];
    if (!self) {
        return nil;
    }

    _session = nil;

    return self;
}

- (instancetype)initWithSession:(nullable SDLIAPSession *)session retrySessionCompletionHandler:(SDLIAPDataSessionRetryCompletionHandler)retrySessionHandler dataReceivedCompletionHandler:(SDLIAPDataSessionCreateDataReceivedHandler)dataReceivedHandler {

    self = [super init];
    if (!self) {
        return nil;
    }

    _session = session;
    _retrySessionHandler = retrySessionHandler;
    _dataReceivedHandler = dataReceivedHandler;

    if (self.session) {
        SDLLogD(@"Starting data session with accessory: %@, using protocol: %@", self.session.accessory.name, session.protocol);
        SDLStreamDelegate *ioStreamDelegate = [[SDLStreamDelegate alloc] init];
        self.session.streamDelegate = ioStreamDelegate;
        ioStreamDelegate.streamHasBytesHandler = [self sdl_dataStreamHasBytesHandler];
        ioStreamDelegate.streamEndHandler = [self sdl_dataStreamEndedHandler];
        ioStreamDelegate.streamErrorHandler = [self sdl_dataStreamErroredHandler];

        if (![self.session start]) {
            SDLLogW(@"Data session failed to setup with accessory: %@. Retrying...", session.accessory);
            self.session.streamDelegate = nil;
            self.session = nil;
            [self sdl_shouldRetryEstablishSession:YES];
        }
    } else {
        SDLLogW(@"Failed to setup data session");
        [self sdl_shouldRetryEstablishSession:YES];
    }

    return self;
}

- (void)destroySession {
    if (self.session != nil) {
        SDLLogD(@"Destroying data session");
        [self.session stop];
        self.session.streamDelegate = nil;
        self.session = nil;
    }
}

#pragma mark Data Stream Handlers

- (SDLStreamEndHandler)sdl_dataStreamEndedHandler {
    __weak typeof(self) weakSelf = self;
    return ^(NSStream *stream) {
        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
        __strong typeof(weakSelf) strongSelf = weakSelf;

        SDLLogD(@"Data stream ended");
        if (strongSelf.session == nil) {
            SDLLogD(@"Data session is nil");
            return;
        }
        // The handler will be called on the IO thread, but the session stop method must be called on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.session stop];
            strongSelf.session.streamDelegate = nil;
            strongSelf.session = nil;

            [strongSelf sdl_shouldRetryEstablishSession:YES];
        });

        // To prevent deadlocks the handler must return to the runloop and not block the thread
    };
}

- (SDLStreamHasBytesHandler)sdl_dataStreamHasBytesHandler {
    __weak typeof(self) weakSelf = self;
    return ^(NSInputStream *istream) {
        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
        __strong typeof(weakSelf) strongSelf = weakSelf;
        uint8_t buf[[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
        while (istream.streamStatus == NSStreamStatusOpen && istream.hasBytesAvailable) {
            // It is necessary to check the stream status and whether there are bytes available because the dataStreamHasBytesHandler is executed on the IO thread and the accessory disconnect notification arrives on the main thread, causing data to be passed to the delegate while the main thread is tearing down the transport.

            NSInteger bytesRead = [istream read:buf maxLength:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
            if (bytesRead < 0) {
                SDLLogE(@"Failed to read from data stream");
                break;
            }

            NSData *dataIn = [NSData dataWithBytes:buf length:(NSUInteger)bytesRead];
            SDLLogBytes(dataIn, SDLLogBytesDirectionReceive);

            if (bytesRead > 0) {
                [strongSelf sdl_sendData:dataIn];
            } else {
                break;
            }
        }
    };
}

- (SDLStreamErrorHandler)sdl_dataStreamErroredHandler {
    __weak typeof(self) weakSelf = self;
    return ^(NSStream *stream) {
        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogE(@"Data stream error");
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.session stop];
            strongSelf.session.streamDelegate = nil;
            strongSelf.session = nil;
            if (![LegacyProtocolString isEqualToString:strongSelf.session.protocol]) {
                [strongSelf sdl_shouldRetryEstablishSession:YES];
            }
        });

        // To prevent deadlocks the handler must return to the runloop and not block the thread
    };
}

#pragma mark - Helpers
- (void)sdl_shouldRetryEstablishSession:(BOOL)retryEstablishSession {
    if (self.retrySessionHandler == nil) {
        return;
    }

    self.retrySessionHandler(retryEstablishSession);
}

- (void)sdl_sendData:(NSData *)data {
    if (self.dataReceivedHandler == nil) {
        return;
    }

    self.dataReceivedHandler(data);
}

- (NSUInteger)accessoryID {
    return self.session.accessory.connectionID;
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPDataSession Dealloc");
    _session = nil;
}

@end

NS_ASSUME_NONNULL_END
