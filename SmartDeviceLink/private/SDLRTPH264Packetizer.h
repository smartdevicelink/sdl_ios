//
//  SDLRTPH264Packetizer.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 4/11/17.
//  Copyright © 2017 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLH264Packetizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRTPH264Packetizer : NSObject <SDLH264Packetizer>

/**
 * Payload Type (PT) of RTP header field.
 *
 * PT field identifies the format of the RTP payload ([5.1] in RFC 3550).
 * RFC 6184 doesn’t specify this value and says it "has to be performed
 * either through the profile used or in a dynamic way" in [5.1].
 *
 * In our spec, this value is chosen from range 96-127 (which are for
 * dynamic assignment) and will be ignored by HMI. Refer to the proposal:
 * https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0048-H264-over-RTP-support-for-video-streaming.md
 *
 * @note Default value is 96.
 */
@property (assign, nonatomic) UInt8 payloadType;

- (instancetype)initWithSSRC:(UInt32)ssrc;

@end

NS_ASSUME_NONNULL_END
