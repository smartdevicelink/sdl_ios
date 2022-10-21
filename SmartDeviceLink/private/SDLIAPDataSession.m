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
#import "SDLIAPDataSessionDelegate.h"
#import "SDLIAPSession.h"
#import "SDLLogMacros.h"
#import "SDLMutableDataQueue.h"
#import "SDLLifecycleManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPDataSession ()

@property (nullable, nonatomic, strong) SDLIAPSession *iapSession;
@property (weak, nonatomic) id<SDLIAPDataSessionDelegate> delegate;
@property (nullable, nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@end

@implementation SDLIAPDataSession

#pragma mark - Lifecycle

- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPDataSessionDelegate>)delegate forProtocol:(NSString *)protocol; {
    SDLLogD(@"SDLIAPDataSession iAP data session init for accessory: %@", accessory);
    self = [super init];
    _delegate = delegate;
    _iapSession = [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:protocol iAPSessionDelegate:self];
    _sendDataQueue = [[SDLMutableDataQueue alloc] init];
    return self;
}

- (void)closeSession {
    [self.iapSession closeSession];
}

- (void)sendData:(NSData *)data {
    [self.sendDataQueue enqueueBuffer:data.mutableCopy];
    if (!self.iapSession.hasSpaceAvailable) {
        SDLLogD(@"SDLIAPDataSession needs to send data but no space available on IAPSession %@.", self.iapSession);
        return;
    }
    [self writeDataToSessionStream];
}

- (void)writeDataToSessionStream {
    NSMutableData *remainder = [self.sendDataQueue frontBuffer];
    if (remainder != nil) {
        NSUInteger bytesRemaining = remainder.length;
        [self.iapSession write:remainder length:bytesRemaining withCompletionHandler:^(NSInteger bytesWritten) {
            if (bytesWritten >= 0) {
                if (bytesWritten == bytesRemaining) {
                    [self.sendDataQueue popBuffer];
                } else if (bytesRemaining > bytesWritten) {
                    // Cleave the sent bytes from the data, the remainder will sit at the head of the queue
                    SDLLogV(@"SDLIAPDataSession writeDataToSessionStream bytes written %ld", (long)bytesWritten);
                    [remainder replaceBytesInRange:NSMakeRange(0, (NSUInteger)bytesWritten) withBytes:NULL length:0];
                } else {
                    // Error processing current data. Remove corrupted buffer
                    SDLLogE(@"Unable to remove sent bytes. Bytes remaining is less than bytes written %lu < %lu. Clearing buffer", bytesRemaining, bytesWritten);
                    [self.sendDataQueue popBuffer];
                }
            } else {
                // The write operation failed but there is no further information about the error. This can occur when disconnecting from an external accessory.
                SDLLogE(@"Output stream write operation failed");
            }
        }];
    } else {
        SDLLogV(@"No more data to write to data session's output stream for IAPSession %@", self.iapSession);
        return;
    }
}

#pragma mark - Sending data

#pragma mark - NSStreamDelegate

- (void)streamsDidOpen {
    SDLLogD(@"SDLIAPDataSession streams opened for data session instance %@", self);
    if (self.delegate != nil) {
        [self.delegate dataSessionDidConnect];
    }
}

- (void)streamHasSpaceToWrite {
    [self writeDataToSessionStream];
}

- (void)streamHasBytesAvailable:(NSInputStream *)inputStream {
    uint8_t buf[[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
    // It is necessary to check the stream status and whether there are bytes available
    // because the dataStreamHasBytesHandler is executed on the IO thread and
    // the accessory disconnect notification arrives on the main thread, causing data to be passed to the delegate
    // if the main thread is tearing down the transport.
    while (inputStream.streamStatus == NSStreamStatusOpen && inputStream.hasBytesAvailable) {
        NSInteger bytesRead = [inputStream read:buf maxLength:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC]];
        if (bytesRead < 0) {
            SDLLogE(@"Failed to read from EASession data stream %@", inputStream);
            break;
        }
        NSData *dataIn = [NSData dataWithBytes:buf length:(NSUInteger)bytesRead];
        SDLLogBytes(dataIn, SDLLogBytesDirectionReceive);

        if (bytesRead > 0) {
            if (self.delegate != nil) {
                [self.delegate dataSessionDidReceiveData:dataIn];
            }
        } else {
            break;
        }
    }
}

- (void)streamsDidEnd {
    SDLLogD(@"SDLIAPDataSession EASession streamsDidEnd");
    if (self.delegate != nil) {
        [self.delegate  dataSessionDidEnd];
    }
}

- (void)streamDidError {
    SDLLogD(@"SDLIAPDataSession EASession streamDidError");
    if (![self.iapSession.protocolString isEqualToString:LegacyProtocolString]) {
        [self.sendDataQueue removeAllObjects];
        if (self.delegate != nil) {
            [self.delegate  dataSessionDidEnd];
        }
    }
}

#pragma mark Getters

- (nullable EAAccessory *) accessory {
    return self.iapSession.accessory;
}

- (NSUInteger)connectionID {
    return self.iapSession.connectionID;
}

- (BOOL)isSessionInProgress {
    return [self.iapSession isSessionInProgress];
}

@end

NS_ASSUME_NONNULL_END


