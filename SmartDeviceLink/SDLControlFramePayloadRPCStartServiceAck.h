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

@property (assign, nonatomic, readonly) int32_t hashId;
@property (assign, nonatomic, readonly) int64_t mtu;
@property (copy, nonatomic, readonly) NSString *protocolVersion;

@end

NS_ASSUME_NONNULL_END
