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
 * @note This must be between 0 and 127. Default value is 96.
 */
@property (assign, nonatomic) UInt8 payloadType;

/**
 * SSRC of RTP header field.
 *
 * @note A random value is generated and used as default.
 */
@property (assign, nonatomic) UInt32 ssrc;

/**
 * Initializer.
 */
- (instancetype)init;

/**
 * Creates RTP packets from given H.264 NAL units and presentation timestamp.
 *
 * @param nalUnits List of NAL units to create packets.
 * @param pts Presentation timestamp associated to the NAL units, in seconds.
 *
 * @return List of NSData. Each NSData holds a RTP packet.
 *
 * @note This method cannot be called more than once with same pts value.
 *       All NAL units that belongs to a frame should be included in
 *       nalUnits array.
 */
- (nullable NSArray *)createPackets:(NSArray *)nalUnits pts:(double)pts;

@end

NS_ASSUME_NONNULL_END
