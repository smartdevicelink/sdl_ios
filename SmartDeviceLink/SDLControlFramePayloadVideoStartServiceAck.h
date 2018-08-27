//
//  SDLControlFramePayloadVideoStartServiceAck.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/26/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadVideoStartServiceAck : NSObject <SDLControlFramePayloadType>

/// Max transport unit to be used for this service
@property (assign, nonatomic, readonly) int64_t mtu;

/// Accepted height in pixels from the client requesting the video service to start
@property (assign, nonatomic, readonly) int32_t height;

/// Accepted width in pixels from the client requesting the video service to start
@property (assign, nonatomic, readonly) int32_t width;

/// Accepted video protocol to be used. See VideoStreamingProtocol RPC
@property (copy, nonatomic, readonly, nullable) SDLVideoStreamingProtocol videoProtocol;

/// Accepted video codec to be used. See VideoStreamingCodec RPC
@property (copy, nonatomic, readonly, nullable) SDLVideoStreamingCodec videoCodec;

- (instancetype)initWithMTU:(int64_t)mtu height:(int32_t)height width:(int32_t)width protocol:(nullable SDLVideoStreamingProtocol)protocol codec:(nullable SDLVideoStreamingCodec)codec;

@end

NS_ASSUME_NONNULL_END
