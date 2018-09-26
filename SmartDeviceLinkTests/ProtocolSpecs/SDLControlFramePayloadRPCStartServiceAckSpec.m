
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"

QuickSpecBegin(SDLControlFramePayloadRPCStartServiceAckSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadRPCStartServiceAck *testPayload = nil;
    __block int32_t testHashId = 0;
    __block int64_t testMTU = 0;
    __block NSString *testProtocolVersion = nil;
    __block NSArray<NSString *> *testSecondaryTransports = nil;
    __block NSArray<NSNumber *> *testAudioServiceTransports = nil;
    __block NSArray<NSNumber *> *testVideoServiceTransports = nil;

    context(@"with paramaters", ^{
        beforeEach(^{
            testHashId = 1457689;
            testMTU = 5984649;
            testProtocolVersion = @"1.32.32";

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:testProtocolVersion secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil];
        });

        it(@"should create the correct data", ^{
            expect(testPayload.data.description).to(equal(@"<3b000000 10686173 68496400 193e1600 126d7475 0089515b 00000000 00027072 6f746f63 6f6c5665 7273696f 6e000800 0000312e 33322e33 320000>"));
        });
    });

    context(@"with secondary transport paramaters", ^{
        beforeEach(^{
            testHashId = 987654;
            testMTU = 4096;
            testProtocolVersion = @"5.10.01";
            testSecondaryTransports = @[@"TCP_WIFI", @"IAP_USB"];
            testAudioServiceTransports = @[@(2)];
            testVideoServiceTransports = @[(@2), @(1)];

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
        });

        it(@"should create the correct data", ^{
            expect(testPayload.data.description).to(equal(@"<c3000000 04766964 656f5365 72766963 65547261 6e73706f 72747300 13000000 10300002 00000010 31000100 00000010 68617368 49640006 120f0012 6d747500 00100000 00000000 04736563 6f6e6461 72795472 616e7370 6f727473 00240000 00023000 09000000 5443505f 57494649 00023100 08000000 4941505f 55534200 00046175 64696f53 65727669 63655472 616e7370 6f727473 000c0000 00103000 02000000 00027072 6f746f63 6f6c5665 7273696f 6e000800 0000352e 31302e30 310000>"));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testHashId = SDLControlFrameInt32NotFound;
            testMTU = SDLControlFrameInt64NotFound;

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:nil secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadRPCStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;
    __block int32_t testHashId = 0;
    __block int64_t testMTU = 0;
    __block NSString *testProtocolVersion = nil;
    __block NSArray<NSString *> *testSecondaryTransports = nil;
    __block NSArray<NSNumber *> *testAudioServiceTransports = nil;
    __block NSArray<NSNumber *> *testVideoServiceTransports = nil;

    context(@"with paramaters", ^{
        beforeEach(^{
            testHashId = 1545784;
            testMTU = 989786483;
            testProtocolVersion = @"3.89.5";

            SDLControlFramePayloadRPCStartServiceAck *firstPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:testProtocolVersion secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil];
            testData = firstPayload.data;

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:testData];
        });

        it(@"should output the correct params", ^{
            expect(testPayload.hashId).to(equal(testHashId));
            expect(testPayload.mtu).to(equal(testMTU));
            expect(testPayload.protocolVersion).to(equal(testProtocolVersion));
        });
    });

    context(@"with secondary transportparamaters", ^{
        beforeEach(^{
            testHashId = 17999024;
            testMTU = 1798250;
            testProtocolVersion = @"6.01.00";
            testSecondaryTransports = @[@"TCP_WIFI"];
            testAudioServiceTransports = @[@(2), @(1)];
            testVideoServiceTransports = @[@(1)];

            SDLControlFramePayloadRPCStartServiceAck *firstPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
            testData = firstPayload.data;

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:testData];
        });

        it(@"should output the correct params", ^{
            expect(testPayload.hashId).to(equal(testHashId));
            expect(testPayload.mtu).to(equal(testMTU));
            expect(testPayload.protocolVersion).to(equal(testProtocolVersion));
            expect(testPayload.secondaryTransports).to(equal(testSecondaryTransports));
            expect(testPayload.audioServiceTransports).to(equal(testAudioServiceTransports));
            expect(testPayload.videoServiceTransports).to(equal(testVideoServiceTransports));
        });
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadRPCStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.data.length).to(equal(0));
    });
});

QuickSpecEnd
