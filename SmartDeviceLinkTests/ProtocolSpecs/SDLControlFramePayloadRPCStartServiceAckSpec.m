
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

    context(@"with paramaters", ^{
        beforeEach(^{
            testHashId = 1457689;
            testMTU = 5984649;
            testProtocolVersion = @"1.32.32";

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:testProtocolVersion];
        });

        it(@"should create the correct data", ^{
            expect(testPayload.data.description).to(equal(@"<3b000000 10686173 68496400 193e1600 126d7475 0089515b 00000000 00027072 6f746f63 6f6c5665 7273696f 6e000800 0000312e 33322e33 320000>"));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testHashId = SDLControlFrameInt32NotFound;
            testMTU = SDLControlFrameInt64NotFound;

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:nil];
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

    beforeEach(^{
        testHashId = 1545784;
        testMTU = 989786483;
        testProtocolVersion = @"3.89.5";

        SDLControlFramePayloadRPCStartServiceAck *firstPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU protocolVersion:testProtocolVersion];
        testData = firstPayload.data;

        testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.hashId).to(equal(testHashId));
        expect(testPayload.mtu).to(equal(testMTU));
        expect(testPayload.protocolVersion).to(equal(testProtocolVersion));
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
