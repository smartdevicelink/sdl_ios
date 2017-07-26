//
//  SDLControlFramePayloadVideoStartServiceAck.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/26/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"


@interface SDLControlFramePayloadVideoStartServiceAck : NSObject <SDLControlFramePayloadType>

/// Hash ID to identify this service and used when sending an EndService control frame
@property (assign, nonatomic, readonly) int32_t hashId;

/// Max transport unit to be used for this service
@property (assign, nonatomic, readonly) int64_t mtu;

/// Accepted height in pixels from the client requesting the video service to start
@property (assign, nonatomic, readonly) int32_t height;

/// Accepted width in pixels from the client requesting the video service to start
@property (assign, nonatomic, readonly) int32_t width;

/// Accepted video protocol to be used. See VideoStreamingProtocol RPC
@property (copy, nonatomic, readonly) NSString *videoProtocol;

/// Accepted video codec to be used. See VideoStreamingCodec RPC
@property (copy, nonatomic, readonly) NSString *videoCodec;

@end
