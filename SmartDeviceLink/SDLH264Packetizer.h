//
//  SDLH264Packetizer.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 4/11/17.
//  Copyright © 2017 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLH264Packetizer

/**
 * Creates packets from given H.264 NAL units and presentation timestamp.
 *
 * @param nalUnits List of NAL units to create packets.
 * @param presentationTimestamp Presentation timestamp associated to
 *                              the NAL units, in seconds.
 *
 * @return List of NSData. Each NSData holds a packet.
 *
 * @warning This method cannot be called more than once with same pts value.
 *          All NAL units that belongs to a frame should be included in
 *          nalUnits array.
 */
- (nullable NSArray<NSData *> *)createPackets:(NSArray<NSData *> *)nalUnits
                        presentationTimestamp:(double)presentationTimestamp;

@end

NS_ASSUME_NONNULL_END
