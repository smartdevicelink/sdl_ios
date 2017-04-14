//
//  SDLH264ByteStreamPacketizer.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 4/11/17.
//  Copyright © 2017 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLH264Packetizer.h"

@interface SDLH264ByteStreamPacketizer : NSObject <SDLH264Packetizer>

/**
 * Initializer.
 */
- (instancetype)init;

/**
 * Creates H.264 byte-stream by appending start codes in front of every NAL units.
 *
 * @param nalUnits List of NAL units to create the stream
 * @param pts Ignored; presentation timestamp in seconds.
 *
 * @return List of NSData, containing H.264 byte-stream
 *
 * @note This packetizer consolidates all NAL units into one NSData object
 *       to keep compatibility with previous implementation.
 */
- (NSArray *)createPackets:(NSArray *)nalUnits pts:(double)pts;

@end
