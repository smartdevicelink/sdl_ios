//
//  SDLControlFramePayloadAudioStartServiceAck.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadAudioStartServiceAck : NSObject <SDLControlFramePayloadType>

/// Max transport unit to be used for this service. If not included the client should use the one set via the RPC service or protocol version default.
@property (assign, nonatomic, readonly) int64_t mtu;

- (instancetype)initWithMTU:(int64_t)mtu;

@end

NS_ASSUME_NONNULL_END
