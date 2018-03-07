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

/// The transport types for Secondary Transport
@property (copy, nonatomic, readonly, nullable) NSArray<NSString *> *secondaryTransports;

/// List of transports that are allowed to carry audio service. The values can be either 1 (primary transport) or 2 (secondary transport) and are listed in preferred order.
@property (copy, nonatomic, readonly, nullable) NSArray<NSNumber *> *audioServiceTransports;

/// List of transports that are allowed to carry video service. The values can be either 1 (primary transport) or 2 (secondary transport) and are listed in preferred order.
@property (copy, nonatomic, readonly, nullable) NSArray<NSNumber *> *videoServiceTransports;

- (instancetype)initWithHashId:(int32_t)hashId mtu:(int64_t)mtu protocolVersion:(nullable NSString *)protocolVersion secondaryTransports:(nullable NSArray<NSString *> *)secondaryTransports audioServiceTransports:(nullable NSArray<NSNumber *> *)audioServiceTransports videoServiceTransports:(nullable NSArray<NSNumber *> *)videoServiceTransports;

@end

NS_ASSUME_NONNULL_END
