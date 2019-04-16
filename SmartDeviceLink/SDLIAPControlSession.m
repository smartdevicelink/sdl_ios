//
//  SDLIAPControlSession.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLIAPControlSession.h"

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"
#import <CommonCrypto/CommonDigest.h>


NS_ASSUME_NONNULL_BEGIN

NSString *const ControlProtocolString = @"com.smartdevicelink.prot0";
NSString *const IndexedProtocolStringPrefix = @"com.smartdevicelink.prot";

int const ProtocolIndexTimeoutSeconds = 10;

@interface SDLIAPControlSession ()

@property (nullable, strong, nonatomic, readwrite) SDLIAPSession *session;
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (nullable, strong, nonatomic) SDLIAPControlSessionRetryCompletionHandler retryCompletionHandler;
@property (nullable, strong, nonatomic) SDLIAPControlSessionCreateDataSessionCompletionHandler createDataSessionCompletionHandler;

@end

@implementation SDLIAPControlSession

- (instancetype)init {
    SDLLogV(@"SDLIAPControlSession Init");
    self = [super init];
    if (!self) {
        return nil;
    }

    _session = nil;
    _protocolIndexTimer = nil;

    return self;
}

+ (nullable SDLIAPSession *)createSessionWithAccessory:(EAAccessory *)accessory {
    return [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:ControlProtocolString];
}

- (void)setSession:(nullable SDLIAPSession *)session delegate:(id<SDLIAPSessionDelegate>)delegate retryCompletionHandler:(SDLIAPControlSessionRetryCompletionHandler)retryCompletionHandler createDataSessionCompletionHandler:(SDLIAPControlSessionCreateDataSessionCompletionHandler)createDataSessionCompletionHandler {
    SDLLogD(@"Starting control session with accessory (%@)", self.session.accessory.name);

    self.session = session;
    self.retryCompletionHandler = retryCompletionHandler;
    self.createDataSessionCompletionHandler = createDataSessionCompletionHandler;

    if (self.session) {
        self.session.delegate = delegate;

        EAAccessory *accessory = session.accessory;
        SDLStreamDelegate *controlStreamDelegate = [[SDLStreamDelegate alloc] init];
        controlStreamDelegate.streamHasBytesHandler = [self sdl_controlStreamHasBytesHandlerForAccessory:accessory];
        controlStreamDelegate.streamEndHandler = [self sdl_controlStreamEndedHandler];
        controlStreamDelegate.streamErrorHandler = [self sdl_controlStreamErroredHandler];
        self.session.streamDelegate = controlStreamDelegate;

        if (![self.session start]) {
            SDLLogW(@"Control session failed to setup (%@), trying to creating a new control session", accessory);
            self.session.streamDelegate = nil;
            self.session = nil;
            [self sdl_shouldRetryEstablishSession:YES];
        } else {
            SDLLogW(@"Control session started");
            if (self.protocolIndexTimer != nil) {
                SDLLogV(@"Cancelling currently running protocol index timer");
                [self.protocolIndexTimer cancel];
            }

            SDLLogD(@"Setting timer for %d seconds to get the protocol string from Core", ProtocolIndexTimeoutSeconds);
            self.protocolIndexTimer = [self sdl_startTimerToGetProtocolString];
        }
    } else {
        SDLLogW(@"Failed to setup control session");
        [self sdl_shouldRetryEstablishSession:YES];
    }
}

- (SDLTimer *)sdl_startTimerToGetProtocolString {
    SDLTimer *protocolIndexTimer = [[SDLTimer alloc] initWithDuration:ProtocolIndexTimeoutSeconds repeat:NO];

    __weak typeof(self) weakSelf = self;
    void (^elapsedBlock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogW(@"Control session failed to get the protocol string from Core after %d seconds, retrying.", ProtocolIndexTimeoutSeconds);
        [strongSelf.session stop];
        strongSelf.session.streamDelegate = nil;
        strongSelf.session = nil;
        [strongSelf sdl_shouldRetryEstablishSession:YES];
    };
    protocolIndexTimer.elapsedBlock = elapsedBlock;

    return protocolIndexTimer;
}

- (void)destroySession {
    if (self.session != nil) {
        SDLLogD(@"Destroying control session");
        [self.session stop];
        self.session.streamDelegate = nil;
        self.session = nil;
    } else {
        SDLLogW(@"Attempted to destroy the control session but control session does not exists");
    }
}

#pragma mark - Control Stream Handlers

- (SDLStreamEndHandler)sdl_controlStreamEndedHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"Control stream ended");

        // End events come in pairs, only perform this once per set.
        if (strongSelf.session != nil) {
            [strongSelf.protocolIndexTimer cancel];
            [strongSelf.session stop];
            strongSelf.session.streamDelegate = nil;
            strongSelf.session = nil;
            [strongSelf sdl_shouldRetryEstablishSession:YES];
        }
    };
}

- (SDLStreamHasBytesHandler)sdl_controlStreamHasBytesHandlerForAccessory:(EAAccessory *)accessory {
    __weak typeof(self) weakSelf = self;

    return ^(NSInputStream *istream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogV(@"Control stream received data");

        // Read in the stream a single byte at a time
        uint8_t buf[1];
        NSInteger len = [istream read:buf maxLength:1];
        if (len <= 0) {
            SDLLogV(@"No data received from the control stream");
            return;
        }

        // If we have data from the control stream, use the data to create the protocol string needed to establish the data session. Destroy the control session as it is no longer needed and then create the data session,.
        NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@", IndexedProtocolStringPrefix, @(buf[0])];
        SDLLogD(@"Control Stream will switch to protocol %@", indexedProtocolString);

        // Destroy the control session
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongSelf.session stop];
            strongSelf.session.streamDelegate = nil;
            strongSelf.session = nil;
        });

        if (accessory.isConnected) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf sdl_createDataSessionWithIndexProtocolString:indexedProtocolString connectedAccessory:accessory];
                [strongSelf.protocolIndexTimer cancel];
            });
        } else {
            SDLLogE(@"Accessory is not connected");
        }
    };
}

- (SDLStreamErrorHandler)sdl_controlStreamErroredHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogE(@"Control stream error");

        [strongSelf.protocolIndexTimer cancel];
        [strongSelf.session stop];
        strongSelf.session.streamDelegate = nil;
        strongSelf.session = nil;
        [strongSelf sdl_shouldRetryEstablishSession:YES];
    };
}

#pragma mark - Helper

- (void)sdl_shouldRetryEstablishSession:(BOOL)retryEstablishSession {
    if (self.retryCompletionHandler == nil) {
        return;
    }

    self.retryCompletionHandler(retryEstablishSession);
}

- (void)sdl_createDataSessionWithIndexProtocolString:(NSString *)indexProtocolString connectedAccessory:(EAAccessory *)accessory {
    if (self.createDataSessionCompletionHandler == nil) {
        return;
    }

    self.createDataSessionCompletionHandler(accessory, indexProtocolString);
}

- (NSUInteger)accessoryID {
    return self.session.accessory.connectionID;
}

@end

NS_ASSUME_NONNULL_END
