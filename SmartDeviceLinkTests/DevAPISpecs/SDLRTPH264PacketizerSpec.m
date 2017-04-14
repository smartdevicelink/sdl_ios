//
//  SDLRTPH264PacketizerSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 4/13/17.
//  Copyright © 2017 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLRTPH264Packetizer.h"

// read 2-byte in network byte order and convert it to a UInt16
static inline UInt16 readShortInNBO(const UInt8 *p) {
    return (p[0] << 8) | p[1];
}

// read 4-byte in network byte order and convert it to a UInt32
static inline UInt32 readLongInNBO(const UInt8 *p) {
    return (p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3];
}

QuickSpecBegin(SDLRTPH264PacketizerSpec)

describe(@"a RTP H264 packetizer", ^{
    // sample NAL units (SPS, PPS, I-frame, P-frame)
    const UInt8 spsData[] = {0x67, 0x42, 0xC0, 0x0A, 0xA6, 0x11, 0x11, 0xE8, 0x40, 0x00, 0x00, 0xFA, 0x40, 0x00, 0x3A, 0x98, 0x23, 0xC4, 0x89, 0x84, 0x60};
    const UInt8 ppsData[] = {0x68, 0xC8, 0x42, 0x0F, 0x13, 0x20};
    const UInt8 iframeData[] = {0x65, 0x88, 0x82, 0x07, 0x67, 0x39, 0x31, 0x40, 0x00, 0x5E, 0x0A, 0xFB, 0xEF, 0xAE, 0xBA, 0xEB, 0xAE, 0xBA, 0xEB, 0xC0};
    const UInt8 pframeData[] = {0x41, 0x9A, 0x1C, 0x0E, 0xCE, 0x71, 0xB0};

    NSData *sps = [NSData dataWithBytes:spsData length:sizeof(spsData)];
    NSData *pps = [NSData dataWithBytes:ppsData length:sizeof(ppsData)];
    NSData *iframe = [NSData dataWithBytes:iframeData length:sizeof(iframeData)];
    NSData *pframe = [NSData dataWithBytes:pframeData length:sizeof(pframeData)];

    const NSUInteger FRAME_LENGTH_LEN = 2;
    const NSUInteger MAX_RTP_PACKET_SIZE = 65535;
    const NSUInteger RTP_HEADER_LEN = 12;
    const UInt8 DEFAULT_PAYLOAD_TYPE = 96;
    const UInt8 TYPE_FU_A = 0x1C;
    const NSUInteger CLOCK_RATE = 90000;

    __block SDLRTPH264Packetizer *packetizer = nil;

    beforeEach(^{
        packetizer = [[SDLRTPH264Packetizer alloc] init];
    });

    describe(@"its output array", ^{
        it(@"has same number or more elements compared to the input NAL units", ^{
            NSArray *nalUnits = @[sps, pps, iframe];
            NSArray *results = [packetizer createPackets:nalUnits pts:0.0];
            expect(@([results count])).to(beGreaterThanOrEqualTo(@([nalUnits count])));
        });
    });

    describe(@"First two bytes of its output", ^{
        it(@"indicates the length of a RTP packet", ^{
            NSArray *nalUnits = @[iframe];
            NSArray *results = [packetizer createPackets:nalUnits pts:0.0];
            const UInt8 *header = [results[0] bytes];
            UInt16 length = readShortInNBO(header);
            expect(@((length))).to(equal(@([results[0] length] - FRAME_LENGTH_LEN)));
        });
    });

    describe(@"header of the RTP packet", ^{
        __block const UInt8 *header;

        beforeEach(^{
            NSArray *nalUnits = @[iframe];
            NSArray *results = [packetizer createPackets:nalUnits pts:0.0];
            header = [results[0] bytes];
        });

        it(@"indicates version 2", ^{
            expect(@((header[FRAME_LENGTH_LEN] >> 6) & 3)).to(equal(@2));
        });
        it(@"indicates no padding", ^{
            expect(@((header[FRAME_LENGTH_LEN] >> 5) & 1)).to(equal(@0));
        });
        it(@"indicates no extension", ^{
            expect(@((header[FRAME_LENGTH_LEN] >> 4) & 1)).to(equal(@0));
        });
        it(@"indicates no CSRC", ^{
            expect(@(header[FRAME_LENGTH_LEN] & 0xF)).to(equal(@0));
        });
    });

    describe(@"the marker bit in the header of the RTP packet", ^{
        context(@"when there is only one NAL unit input", ^{
            it(@"is always set", ^{
                NSArray *nalUnits1 = @[iframe];
                NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];
                const UInt8 *header = [results[0] bytes];
                expect(@((header[FRAME_LENGTH_LEN+1] >> 7) & 1)).to(equal(@1));

                NSArray *nalUnits2 = @[pframe];
                results = [packetizer createPackets:nalUnits2 pts:1.0/30];
                header = [results[0] bytes];
                expect(@((header[FRAME_LENGTH_LEN+1] >> 7) & 1)).to(equal(@1));
            });
        });

        context(@"when multiple NAL units are input for an access unit", ^{
            it(@"is set only for the last packet", ^{
                // 3 NAL units for a frame
                NSArray *nalUnits1 = @[sps, pps, iframe];
                NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];

                [results enumerateObjectsUsingBlock:^(NSData *packet, NSUInteger index, BOOL *stop) {
                    const UInt8 *header = [packet bytes];
                    if (index == [results count] - 1) {
                        expect(@((header[FRAME_LENGTH_LEN+1] >> 7) & 1)).to(equal(@1));
                    } else {
                        expect(@((header[FRAME_LENGTH_LEN+1] >> 7) & 1)).to(equal(@0));
                    }
                }];

                // Only 1 NAL unit for the next frame
                NSArray *nalUnits2 = @[pframe];
                results = [packetizer createPackets:nalUnits2 pts:1.0/30];
                const UInt8 *header = [results[0] bytes];
                expect(@((header[FRAME_LENGTH_LEN+1] >> 7) & 1)).to(equal(@1));
            });
        });
    });

    describe(@"the payload type in the header of the RTP packet", ^{
        context(@"when it is not configured", ^{
            it(@"equals to 96", ^{
                NSArray *nalUnits1 = @[iframe];
                NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];
                const UInt8 *header = [results[0] bytes];
                expect(@(header[FRAME_LENGTH_LEN+1] & 0x7F)).to(equal(@(DEFAULT_PAYLOAD_TYPE)));
            });
        });

        context(@"when it is explicitly configured", ^{
            it(@"is same as the given number if the number is between 0 and 127", ^{
                UInt8 payloadType = 100;
                packetizer.payloadType = payloadType;

                NSArray *nalUnits1 = @[iframe];
                NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];
                const UInt8 *header = [results[0] bytes];
                expect(@(header[FRAME_LENGTH_LEN+1] & 0x7F)).to(equal(@(payloadType)));
            });

            it(@"equals to 96 if the given number is out of range", ^{
                packetizer.payloadType = 200;

                NSArray *nalUnits1 = @[iframe];
                NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];
                const UInt8 *header = [results[0] bytes];
                expect(@(header[FRAME_LENGTH_LEN+1] & 0x7F)).to(equal(@(DEFAULT_PAYLOAD_TYPE)));
            });
        });
    });

    describe(@"the sequence number in the header of the RTP packet", ^{
        it(@"has an initial value of random number", ^{
            // no way to test a random number
        });

        it(@"increments by one for the next packet", ^{
            NSArray *nalUnits1 = @[iframe];
            NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];
            const UInt8 *header = [results[0] bytes];
            UInt16 seqNum = readShortInNBO(&header[FRAME_LENGTH_LEN+2]);

            NSArray *nalUnits2 = @[pframe];
            results = [packetizer createPackets:nalUnits2 pts:1.0/30];
            header = [results[0] bytes];

            seqNum++;
            expect(@(seqNum)).to(equal(@(readShortInNBO(&header[FRAME_LENGTH_LEN+2]))));
        });

        it(@"wraps around after reaching 65535", ^{
            NSArray *nalUnits = @[iframe];
            UInt16 prevSeqNum = 0;

            for (NSUInteger i = 0; i <= 65536; i++) {
                NSArray *results = [packetizer createPackets:nalUnits pts:i/30.0];
                const UInt8 *header = [results[0] bytes];
                UInt16 seqNum = readShortInNBO(&header[FRAME_LENGTH_LEN+2]);

                if (prevSeqNum == 65535) {
                    expect(@(seqNum)).to(equal(@(0)));
                    break;  // end testing
                } else {
                    prevSeqNum = seqNum;
                }
            }
        });
    });

    describe(@"the timestamp field in the header of the RTP packet", ^{
        it(@"has an initial value of random number", ^{
            // no way to test a random number
        });

        it(@"then increases in 90 kHz clock value", ^{
            NSArray *nalUnits = @[iframe];
            UInt32 initialPTS = 0;

            for (NSUInteger i = 0; i <= 100; i++) {
                // the timestamp increases by 1/30 seconds
                NSArray *results = [packetizer createPackets:nalUnits pts:i/30.0];
                const UInt8 *header = [results[0] bytes];
                UInt32 pts = readLongInNBO(&header[FRAME_LENGTH_LEN+4]);

                if (i == 0) {
                    initialPTS = pts;
                } else {
                    UInt32 expectedPTS = initialPTS + i / 30.0 * CLOCK_RATE;
                    // accept calculation error (+-1)
                    expect(@(pts)).to(beGreaterThanOrEqualTo(@(expectedPTS - 1)));
                    expect(@(pts)).to(beLessThanOrEqualTo(@(expectedPTS + 1)));
                }
            }
        });
    });

    describe(@"the SSRC field in the header of the RTP packet", ^{
        context(@"when it is not configured", ^{
            it(@"is a random number", ^{
                // No way to test a random number. We only check that it is shared among packets.
                NSArray *nalUnits1 = @[iframe];
                NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];
                const UInt8 *header = [results[0] bytes];
                UInt32 ssrc = readLongInNBO(&header[FRAME_LENGTH_LEN+8]);

                NSArray *nalUnits2 = @[pframe];
                results = [packetizer createPackets:nalUnits2 pts:1.0/30];
                header = [results[0] bytes];
                UInt32 ssrc2 = readLongInNBO(&header[FRAME_LENGTH_LEN+8]);

                expect(@(ssrc)).to(equal(@(ssrc2)));
            });
        });

        context(@"when it is explicitly configured", ^{
            it(@"is same as the given number", ^{
                UInt32 expectedSSRC = 0xFEDCBA98;
                packetizer.ssrc = expectedSSRC;

                NSArray *nalUnits1 = @[iframe];
                NSArray *results = [packetizer createPackets:nalUnits1 pts:0.0];
                const UInt8 *header = [results[0] bytes];
                UInt32 ssrc = readLongInNBO(&header[FRAME_LENGTH_LEN+8]);
                expect(@(ssrc)).to(equal(@(expectedSSRC)));

                NSArray *nalUnits2 = @[pframe];
                results = [packetizer createPackets:nalUnits2 pts:1.0/30];
                header = [results[0] bytes];
                ssrc = readLongInNBO(&header[FRAME_LENGTH_LEN+8]);
                expect(@(ssrc)).to(equal(@(expectedSSRC)));
            });
        });
    });

    describe(@"the payload of its output packet", ^{
        NSData *(^createFakeNALUnit)(UInt8, NSUInteger) = ^NSData *(UInt8 firstByte, NSUInteger length) {
            UInt8 *data = malloc(length);
            data[0] = firstByte;
            for (NSUInteger i = 1; i < length; i++) {
                data[i] = i % 256;
            }
            return [NSData dataWithBytes:data length:length];
        };

        UInt8 firstByte;
        [iframe getBytes:&firstByte length:1];

        it(@"is not fragmented if input NAL unit size is less than 65524 bytes (65536-12)", ^{
            NSData *fakeNALUnit = createFakeNALUnit(firstByte, MAX_RTP_PACKET_SIZE - RTP_HEADER_LEN);
            NSArray *nalUnits = @[fakeNALUnit];
            NSArray *results = [packetizer createPackets:nalUnits pts:0.0];

            // we should get only one packet
            expect(@([results count])).to(equal(@(1)));
        });

        it(@"is fragmented if input NAL unit size equals to or is greater than 65524 bytes", ^{
            NSData *fakeNALUnit = createFakeNALUnit(firstByte, MAX_RTP_PACKET_SIZE - RTP_HEADER_LEN + 1);
            NSArray *nalUnits = @[fakeNALUnit];
            NSArray *results = [packetizer createPackets:nalUnits pts:0.0];

            // the NAL unit should be fragmented into two
            expect(@([results count])).to(equal(@(2)));
        });

        context(@"when payload is not fragmented", ^{
            it(@"is duplicate of input NAL unit", ^{
                NSArray *nalUnits = @[sps, pps, iframe];
                NSArray *results = [packetizer createPackets:nalUnits pts:0.0];

                NSUInteger nalUnitIndex = 0;
                for (NSData *packet in results) {
                    const UInt8 *p = [packet bytes];
                    int ret = memcmp(p + FRAME_LENGTH_LEN + RTP_HEADER_LEN,
                                     [nalUnits[nalUnitIndex] bytes],
                                     [nalUnits[nalUnitIndex] length]);
                    expect(@(ret)).to(equal(@0));
                    nalUnitIndex++;
                }
            });
        });

        context(@"when payload is fragmented", ^{
            __block NSData *fakeNALUnit;
            __block NSArray *results;

            beforeEach(^{
                fakeNALUnit = createFakeNALUnit(firstByte, MAX_RTP_PACKET_SIZE - RTP_HEADER_LEN + 1);
                NSArray *nalUnits = @[fakeNALUnit];
                results = [packetizer createPackets:nalUnits pts:0.0];
            });

            describe(@"its first byte", ^{
                it(@"has F bit and NRI field which are same as those of the input NAL unit", ^{
                    for (NSData *packet in results) {
                        const UInt8 *header = [packet bytes];
                        expect(@((header[FRAME_LENGTH_LEN+RTP_HEADER_LEN] >> 5) & 3)).to(equal(@((firstByte >> 5) & 3)));
                    }
                });

                it(@"indicates a FU-A type (0x1C)", ^{
                    for (NSData *packet in results) {
                        const UInt8 *header = [packet bytes];
                        expect(@(header[FRAME_LENGTH_LEN+RTP_HEADER_LEN] & 0x1F)).to(equal(@(TYPE_FU_A)));
                    }
                });
            });

            describe(@"its second byte", ^{
                it(@"has a start bit which is set only at the beginning of fragment group", ^{
                    BOOL shouldBeFirstFragment = YES;

                    for (NSUInteger i = 0; i < [results count]; i++) {
                        const UInt8 *header = [results[i] bytes];
                        UInt8 startBit = (header[FRAME_LENGTH_LEN+RTP_HEADER_LEN+1] >> 7) & 1;
                        expect(@(startBit)).to(equal(@(shouldBeFirstFragment ? 1 : 0)));
                        shouldBeFirstFragment = NO;
                    }
                });

                it(@"has a end bit which is set only at the end of fragment group", ^{
                    BOOL shouldBeLastFragment = NO;

                    for (NSUInteger i = 0; i < [results count]; i++) {
                        if (i == [results count] - 1) {
                            shouldBeLastFragment = YES;
                        } else {
                            shouldBeLastFragment = NO;
                        }

                        const UInt8 *header = [results[i] bytes];
                        UInt8 endBit = (header[FRAME_LENGTH_LEN+RTP_HEADER_LEN+1] >> 6) & 1;
                        expect(@(endBit)).to(equal(@(shouldBeLastFragment ? 1 : 0)));
                    }
                });

                it(@"has a reserved bit which is always zero", ^{
                    for (NSUInteger i = 0; i < [results count]; i++) {
                        const UInt8 *header = [results[i] bytes];
                        expect(@((header[FRAME_LENGTH_LEN+RTP_HEADER_LEN+1] >> 5) & 1)).to(equal(@(0)));
                    }
                });

                it(@"has a type field which is same as the input NAL unit's type", ^{
                    for (NSUInteger i = 0; i < [results count]; i++) {
                        const UInt8 *header = [results[i] bytes];
                        expect(@(header[FRAME_LENGTH_LEN+RTP_HEADER_LEN+1] & 0x1F)).to(equal(@(firstByte & 0x1F)));
                    }
                });
            });

            describe(@"its third and onward bytes", ^{
                it(@"equals to original NAL unit's second and onward bytes when concatenated", ^{
                    NSMutableData *concatData = [[NSMutableData alloc] init];

                    for (NSUInteger i = 0; i < [results count]; i++) {
                        NSData *packet = results[i];
                        const UInt8 *p = [packet bytes];
                        [concatData appendBytes:p + FRAME_LENGTH_LEN + RTP_HEADER_LEN + 2
                                         length:[packet length] - (FRAME_LENGTH_LEN + RTP_HEADER_LEN + 2)];
                    }

                    expect(@([concatData isEqualToData:[fakeNALUnit subdataWithRange:NSMakeRange(1, [fakeNALUnit length] - 1)]])).to(beTruthy());
                });
            });
        });
    });
});

QuickSpecEnd
