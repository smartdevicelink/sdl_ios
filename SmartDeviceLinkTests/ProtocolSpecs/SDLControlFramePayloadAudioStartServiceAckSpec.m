
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadAudioStartServiceAck.h"

QuickSpecBegin(SDLControlFramePayloadAudioStartServiceAckSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadAudioStartServiceAck *testPayload = nil;
    __block int32_t testHashId = 0;
    __block int64_t testMTU = 0;

    context(@"with paramaters", ^{
        beforeEach(^{
            testHashId = 1457689;
            testMTU = 598464979;

            testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU];
        });

        it(@"should create the correct data", ^{
            expect(testPayload.data.description).to(equal(@"<1e000000 10686173 68496400 193e1600 126d7475 00d3d9ab 23000000 0000>"));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testHashId = SDLControlFrameInt32NotFound;
            testMTU = SDLControlFrameInt64NotFound;

            testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadAudioStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;
    __block int32_t testHashId = 0;
    __block int64_t testMTU = 0;

    beforeEach(^{
        testHashId = 1545784;
        testMTU = 989786483;

        SDLControlFramePayloadAudioStartServiceAck *firstPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU];
        testData = firstPayload.data;

        testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.hashId).to(equal(testHashId));
        expect(testPayload.mtu).to(equal(testMTU));
    });
});

QuickSpecEnd
