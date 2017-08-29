
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadAudioStartServiceAck.h"

QuickSpecBegin(SDLControlFramePayloadAudioStartServiceAckSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadAudioStartServiceAck *testPayload = nil;
    __block int64_t testMTU = 0;

    context(@"with paramaters", ^{
        beforeEach(^{
            testMTU = 598464979;

            testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithMTU:testMTU];
        });

        it(@"should create the correct data", ^{
            expect(testPayload.data.description).to(equal(@"<12000000 126d7475 00d3d9ab 23000000 0000>"));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testMTU = SDLControlFrameInt64NotFound;

            testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithMTU:testMTU];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadAudioStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;
    __block int64_t testMTU = 0;

    beforeEach(^{
        testMTU = 989786483;

        SDLControlFramePayloadAudioStartServiceAck *firstPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithMTU:testMTU];
        testData = firstPayload.data;

        testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.mtu).to(equal(testMTU));
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadAudioStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.mtu).to(equal(-1));
        expect(testPayload.data.length).to(equal(0));
    });
});

QuickSpecEnd
