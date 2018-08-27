//
//  SDLH264ByteStreamPacketizerSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 4/13/17.
//  Copyright © 2017 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLRAWH264Packetizer.h"

QuickSpecBegin(SDLRAWH264PacketizerSpec)

describe(@"a H264 byte stream packetizer", ^{
    // sample NAL units (SPS, PPS, I-frame, P-frame)
    const UInt8 spsData[] = {0x67, 0x42, 0xC0, 0x0A, 0xA6, 0x11, 0x11, 0xE8, 0x40, 0x00, 0x00, 0xFA, 0x40, 0x00, 0x3A, 0x98, 0x23, 0xC4, 0x89, 0x84, 0x60};
    const UInt8 ppsData[] = {0x68, 0xC8, 0x42, 0x0F, 0x13, 0x20};
    const UInt8 iframeData[] = {0x65, 0x88, 0x82, 0x07, 0x67, 0x39, 0x31, 0x40, 0x00, 0x5E, 0x0A, 0xFB, 0xEF, 0xAE, 0xBA, 0xEB, 0xAE, 0xBA, 0xEB, 0xC0};
    const UInt8 pframeData[] = {0x41, 0x9A, 0x1C, 0x0E, 0xCE, 0x71, 0xB0};

    NSData *sps = [NSData dataWithBytes:spsData length:sizeof(spsData)];
    NSData *pps = [NSData dataWithBytes:ppsData length:sizeof(ppsData)];
    NSData *iframe = [NSData dataWithBytes:iframeData length:sizeof(iframeData)];
    NSData *pframe = [NSData dataWithBytes:pframeData length:sizeof(pframeData)];

    __block SDLRAWH264Packetizer *packetizer = nil;

    beforeEach(^{
        packetizer = [[SDLRAWH264Packetizer alloc] init];
    });

    describe(@"its output array", ^{
        it(@"always has one packet", ^{
            NSArray *nalUnits1 = @[sps, pps, iframe];
            NSArray *results = [packetizer createPackets:nalUnits1 presentationTimestamp:0.0];
            expect(@(results.count)).to(equal(@1));

            NSArray *nalUnits2 = @[pframe];
            results = [packetizer createPackets:nalUnits2 presentationTimestamp:1.0/30];
            expect(@(results.count)).to(equal(@1));
        });
    });

    describe(@"its output packet", ^{
        it(@"starts with a start code of 0x00 0x00 0x00 0x01", ^{
            const UInt8 startCode[] = {0x00, 0x00, 0x00, 0x01};

            NSArray<NSData *> *nalUnits = @[iframe];
            NSArray<NSData *> *results = [packetizer createPackets:nalUnits presentationTimestamp:0.0];
            const UInt8 *p = results[0].bytes;

            int ret = memcmp(p, startCode, sizeof(startCode));
            expect(@(ret)).to(equal(@0));
        });

        it(@"then duplicates original H.264 NAL unit", ^{
            NSData *nalUnit = iframe;

            NSArray<NSData *> *nalUnits = @[nalUnit];
            NSArray<NSData *> *results = [packetizer createPackets:nalUnits presentationTimestamp:0.0];
            const UInt8 *p = results[0].bytes;

            int ret = memcmp(p + 4, nalUnit.bytes, nalUnit.length);
            expect(@(ret)).to(equal(@0));
        });

        it(@"repeats for all given NAL units", ^{
            const UInt8 startCode[] = {0x00, 0x00, 0x00, 0x01};

            NSArray<NSData *> *nalUnits = @[sps, pps, iframe];
            NSArray<NSData *> *results = [packetizer createPackets:nalUnits presentationTimestamp:0.0];
            const UInt8 *p = results[0].bytes;

            for (NSData *nalUnit in nalUnits) {
                int ret = memcmp(p, startCode, sizeof(startCode));
                expect(@(ret)).to(equal(@0));
                p += sizeof(startCode);

                ret = memcmp(p, nalUnit.bytes, nalUnit.length);
                expect(@(ret)).to(equal(@0));
                p += nalUnit.length;
            }
        });
    });
});

QuickSpecEnd
