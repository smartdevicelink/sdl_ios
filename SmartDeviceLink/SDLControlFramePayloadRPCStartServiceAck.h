//
//  SDLControlFramePayloadStartServiceAck.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/20/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadRPCStartServiceAck : NSObject <SDLControlFramePayloadType>

/// Hash ID to identify this service and used when sending an EndService control frame
@property (assign, nonatomic, readonly) int32_t hashId;

/// Max transport unit to be used for this service
@property (assign, nonatomic, readonly) int64_t mtu;

/// The negotiated version of the protocol. Must be in the format "Major.Minor.Patch"
@property (copy, nonatomic, readonly, nullable) NSString *protocolVersion;

- (instancetype)initWithHashId:(int32_t)hashId mtu:(int64_t)mtu protocolVersion:(nullable NSString *)protocolVersion;

@end

NS_ASSUME_NONNULL_END
