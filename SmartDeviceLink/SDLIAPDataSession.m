//
//  SDLIAPDataSession.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLIAPDataSession.h"

#import "SDLGlobals.h"
#import "SDLIAPConstants.h"
#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLStreamDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPDataSession ()

@property (nullable, strong, nonatomic, readwrite) SDLIAPSession *session;

@end

@implementation SDLIAPDataSession

- (instancetype)initWithSession:(nullable SDLIAPSession *)session retrySessionCompletionHandler:(SDLIAPDataSessionRetryCompletionHandler)retrySessionHandler dataReceivedCompletionHandler:(SDLIAPDataSessionDataReceivedHandler)dataReceivedHandler {
    SDLLogV(@"SDLIAPDataSession init");

    self = [super init];
    if (!self) {
        return nil;
    }

    _session = session;

    if (self.session) {
        SDLLogD(@"Starting data session with accessory: %@, using protocol: %@", self.session.accessory.name, session.protocol);
        SDLStreamDelegate *ioStreamDelegate = [[SDLStreamDelegate alloc] init];
        self.session.streamDelegate = ioStreamDelegate;
        ioStreamDelegate.streamHasBytesHandler = [self sdl_dataStreamHasBytesHandlerWithDataReceivedHandler:dataReceivedHandler];
        ioStreamDelegate.streamEndHandler = [self sdl_dataStreamEndedHandlerWithRetrySessionHandler:retrySessionHandler];
        ioStreamDelegate.streamErrorHandler = [self sdl_dataStreamErroredHandlerWithRetrySessionHandler:retrySessionHandler];

        if (![self.session start]) {
            SDLLogW(@"Data session failed to setup with accessory: %@. Retrying...", session.accessory);
            [self stopSession];
            if (retrySessionHandler != nil) {
                retrySessionHandler();
            }
        }
    } else {
        SDLLogW(@"Failed to setup data session");
        if (retrySessionHandler != nil) {
            retrySessionHandler();
        }
    }

    return self;
}

- (void)stopSession {
    if (self.session != nil) {
        SDLLogD(@"Stopping the data session");
        [self.session stop];
        self.session.streamDelegate = nil;

        // Important - Do not destroy the session as it can a few seconds to close the input and output streams. If set to `nil`, the session will not close properly and a new session with the accessory can not be created.
    }
}

#pragma mark - Data Stream Handlers

- (SDLStreamEndHandler)sdl_dataStreamEndedHandlerWithRetrySessionHandler:(SDLIAPDataSessionRetryCompletionHandler)retrySessionHandler {
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
            [strongSelf stopSession];

            if (retrySessionHandler == nil) { return; }
            retrySessionHandler();
        });

        // To prevent deadlocks the handler must return to the runloop and not block the thread
    };
}

- (SDLStreamHasBytesHandler)sdl_dataStreamHasBytesHandlerWithDataReceivedHandler:(SDLIAPDataSessionDataReceivedHandler)dataReceivedHandler {
    return ^(NSInputStream *istream) {
        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
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
                if (dataReceivedHandler == nil) { return; }
                dataReceivedHandler(dataIn);
            } else {
                break;
            }
        }
    };
}

- (SDLStreamErrorHandler)sdl_dataStreamErroredHandlerWithRetrySessionHandler:(SDLIAPDataSessionRetryCompletionHandler)retrySessionHandler {
    __weak typeof(self) weakSelf = self;
    return ^(NSStream *stream) {
        NSAssert(!NSThread.isMainThread, @"%@ should only be called on the IO thread", NSStringFromSelector(_cmd));
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogE(@"Data stream error");
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf stopSession];
            if (![LegacyProtocolString isEqualToString:strongSelf.session.protocol]) {
                if (retrySessionHandler == nil) { return; }
                retrySessionHandler();
            }
        });

        // To prevent deadlocks the handler must return to the runloop and not block the thread
    };
}

#pragma mark - Helpers

- (NSUInteger)connectionID {
    return self.session.accessory.connectionID;
}

- (BOOL)isSessionInProgress {
    return (self.session != nil && !self.session.isStopped);
}

#pragma mark - Lifecycle Destruction

- (void)dealloc {
    SDLLogV(@"SDLIAPDataSession dealloc");
    _session = nil;
}

@end

NS_ASSUME_NONNULL_END
