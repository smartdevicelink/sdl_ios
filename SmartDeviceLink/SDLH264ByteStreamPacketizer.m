//
//  SDLH264ByteStreamPacketizer.m
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 4/11/17.
//  Copyright © 2017 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLH264ByteStreamPacketizer.h"

@interface SDLH264ByteStreamPacketizer () <SDLH264Packetizer>
@property (nonatomic) NSData *startCode;
@end

@implementation SDLH264ByteStreamPacketizer

- (instancetype)init {
    if (self = [super init]) {
        // This is the start code that we will write to the elementary stream before every NAL unit
        UInt8 startCode[] = {0x00, 0x00, 0x00, 0x01};
        _startCode = [[NSData alloc] initWithBytes:startCode length:4];
    }

    return self;
}

- (NSArray *)createPackets:(NSArray *)nalUnits pts:(double)pts {

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    NSMutableData *elementaryStream = [NSMutableData data];

    for (NSData *nalUnit in nalUnits) {
        [elementaryStream appendData:self.startCode];
        [elementaryStream appendData:nalUnit];
    }

    [array addObject:elementaryStream];
    return array;
}

@end
