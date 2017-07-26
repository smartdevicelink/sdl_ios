//
//  SDLControlFramePayloadVideoStartService.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

@interface SDLControlFramePayloadVideoStartService : NSObject <SDLControlFramePayloadType>

/// Desired height in pixels from the client requesting the video service to start
@property (assign, nonatomic, readonly) int32_t height;

/// Desired width in pixels from the client requesting the video service to start
@property (assign, nonatomic, readonly) int32_t width;

/// Desired video protocol to be used. See VideoStreamingProtocol RPC
@property (copy, nonatomic, readonly) NSString *videoProtocol;

/// Desired video codec to be used. See VideoStreamingCodec RPC
@property (copy, nonatomic, readonly) NSString *videoCodec;

@end
