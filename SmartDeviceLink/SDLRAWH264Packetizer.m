//
//  SDLRAWH264Packetizer
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 4/11/17.
//  Copyright © 2017 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLRAWH264Packetizer.h"
#import "SDLH264Packetizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRAWH264Packetizer ()
@property (nonatomic) NSData *startCode;
@end

@implementation SDLRAWH264Packetizer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    // This is the start code that we will write to the elementary stream before every NAL unit
    UInt8 startCode[] = {0x00, 0x00, 0x00, 0x01};
    _startCode = [[NSData alloc] initWithBytes:startCode length:4];

    return self;
}

- (nullable NSArray<NSData *> *)createPackets:(NSArray<NSData *> *)nalUnits
                        presentationTimestamp:(double)presentationTimestamp {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    NSMutableData *elementaryStream = [NSMutableData data];

    // Note: this packetizer consolidates all NAL units into one NSData object
    // to keep compatibility with previous implementation.
    for (NSData *nalUnit in nalUnits) {
        [elementaryStream appendData:self.startCode];
        [elementaryStream appendData:nalUnit];
    }

    [array addObject:elementaryStream];
    return [array copy];
}

@end

NS_ASSUME_NONNULL_END
