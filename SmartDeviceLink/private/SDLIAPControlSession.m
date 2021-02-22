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
#import "SDLIAPConstants.h"
#import "SDLIAPControlSessionDelegate.h"
#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLTimer.h"


NS_ASSUME_NONNULL_BEGIN

int const ProtocolIndexTimeoutSeconds = 10;

@interface SDLIAPControlSession ()
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (nullable, weak, nonatomic) id<SDLIAPControlSessionDelegate> delegate;
@property (nullable, nonatomic, strong) SDLIAPSession *iapSession;
@end

@implementation SDLIAPControlSession

#pragma mark - Session lifecycle

- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPControlSessionDelegate>)delegate forProtocol:(NSString *)protocol {
    SDLLogD(@"SDLIAPControlSession init with protocol %@ and accessory %@", protocol, accessory);
    self = [super init];
    _iapSession = [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:protocol iAPSessionDelegate:self];
    _protocolIndexTimer = nil;
    _delegate = delegate;
    SDLLogD(@"SDLIAPControlSession Wait for the protocol string from Core, setting timeout timer for %d seconds", ProtocolIndexTimeoutSeconds);
    self.protocolIndexTimer = [self sdl_createControlSessionProtocolIndexStringDataTimeoutTimer];

    return self;
}

- (void)closeSession {
    [self.iapSession closeSession];
}

- (nullable EAAccessory *) accessory {
    return self.iapSession.accessory;
}
- (NSUInteger)connectionID {
    return self.iapSession.connectionID;
}

- (BOOL)isSessionInProgress {
    return [self.iapSession isSessionInProgress];
}

#pragma mark - NSStreamDelegate


- (void)streamsDidOpen {
    SDLLogD(@"SDLIAPControlSession streams opened for control session instance %@", self);
    if (self.delegate != nil) {
        [self sdl_startControlSessionProtocolIndexStringDataTimeoutTimer];
    }
}

- (void)streamsDidEnd {
    SDLLogD(@"SDLIAPControlSession EASession stream ended");
    if (self.delegate != nil) {
        [self.delegate controlSessionDidEnd];
    }
}

- (void)streamHasSpaceToWrite {}

/**
 *  Called when the session gets a `NSStreamEventHasBytesAvailable` event code. A protocol string is created from the received data. Since a new session needs to be established with the protocol string, the current session is closed and a new session is created.
 */
- (void)streamHasBytesAvailable:(NSInputStream *)inputStream {
    SDLLogV(@"SDLIAPControlSession EASession stream received data");
    
    // Read in the stream a single byte at a time
    uint8_t buf[1];
    NSInteger len = [inputStream read:buf maxLength:1];
    if (len <= 0) {
        SDLLogV(@"No data in the control stream");
        return;
    }
    
    // If we have data from the control stream, use the data to create the protocol string needed to establish a data session.
    NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@", IndexedProtocolStringPrefix, @(buf[0])];
    SDLLogD(@"SDLIAPControlSession EASession Stream will switch to protocol %@", indexedProtocolString);
    
    [self.protocolIndexTimer cancel];
    if (self.delegate != nil) {
        [self.delegate controlSession:self didReceiveProtocolString:indexedProtocolString];
    }
}

/**
 *  Called when the session gets a `NSStreamEventErrorOccurred` event code. The current session is closed and a new session is attempted.
 */
- (void)streamDidError {
    SDLLogE(@"SDLIAPControlSession stream error");
    [self.protocolIndexTimer cancel];
    if (self.delegate != nil) {
        [self.delegate controlSessionDidEnd];
    }
}

#pragma mark - Timer

/**
 *  Creates a timer for the session. Core has ~10 seconds to send the protocol string, otherwise when the timer's elapsed block is called, the current session is closed and a new session is attempted.
 *
 *  @return A timer
 */
- (SDLTimer *)sdl_createControlSessionProtocolIndexStringDataTimeoutTimer {
    SDLTimer *protocolIndexTimer = [[SDLTimer alloc] initWithDuration:ProtocolIndexTimeoutSeconds repeat:NO];
    __weak typeof(self) weakSelf = self;
    void (^elapsedBlock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogW(@"SDLIAPControlSession failed to get the protocol string from Core after %d seconds, retrying.", ProtocolIndexTimeoutSeconds);
        if (self.delegate != nil) {
            [strongSelf.delegate controlSessionDidEnd];
        }
    };
    protocolIndexTimer.elapsedBlock = elapsedBlock;
    return protocolIndexTimer;
}

/**
 *  Starts a timer for the session. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and the delegate will be notified that it should attempt to establish a new control session.
 */
- (void)sdl_startControlSessionProtocolIndexStringDataTimeoutTimer {
    if (self.protocolIndexTimer == nil) { return; }
    [self.protocolIndexTimer start];
}

@end

NS_ASSUME_NONNULL_END


