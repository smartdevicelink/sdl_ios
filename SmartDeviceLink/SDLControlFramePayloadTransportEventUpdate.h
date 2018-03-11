//
//  SDLControlFramePayloadTransportEventUpdate.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/03/05.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadTransportEventUpdate : NSObject <SDLControlFramePayloadType>

/// A string representing IP address of Core's TCP transport. It can be either IPv4 or IPv6 address.
@property (copy, nonatomic, readonly, nullable) NSString *tcpIpAddress;
/// TCP port number that Core is listening on
@property (assign, nonatomic, readonly) int32_t tcpPort;


- (instancetype)initWithTcpIpAddress:(nullable NSString *)tcpIpAddress tcpPort:(int32_t)tcpPort;

@end

NS_ASSUME_NONNULL_END
