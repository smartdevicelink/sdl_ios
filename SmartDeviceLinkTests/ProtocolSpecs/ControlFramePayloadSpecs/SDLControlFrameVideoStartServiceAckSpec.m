
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadVideoStartServiceAck.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingProtocol.h"

QuickSpecBegin(SDLControlFramePayloadVideoStartServiceAckSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadVideoStartServiceAck *testPayload = nil;
    __block int64_t testMTU = SDLControlFrameInt64NotFound;
    __block int32_t testHeight = SDLControlFrameInt32NotFound;
    __block int32_t testWidth = SDLControlFrameInt32NotFound;
    __block SDLVideoStreamingCodec testCodec = nil;
    __block SDLVideoStreamingProtocol testProtocol = nil;

    context(@"with paramaters", ^{
        beforeEach(^{
            testMTU = 1247988;
            testHeight = 5974;
            testWidth = 36;
            testCodec = SDLVideoStreamingCodecH264;
            testProtocol = SDLVideoStreamingProtocolRAW;

            testPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:testHeight width:testWidth protocol:testProtocol codec:testCodec];
        });

        it(@"should create the correct data", ^{
            NSString *base64Encoded = [testPayload.data base64EncodedStringWithOptions:0];
            expect(base64Encoded).to(equal(@"VQAAABJtdHUA9AoTAAAAAAACdmlkZW9Qcm90b2NvbAAEAAAAUkFXABB3aWR0aAAkAAAAAnZpZGVvQ29kZWMABQAAAEgyNjQAEGhlaWdodABWFwAAAA=="));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testMTU = SDLControlFrameInt64NotFound;
            testHeight = SDLControlFrameInt32NotFound;
            testWidth = SDLControlFrameInt32NotFound;
            testCodec = nil;
            testProtocol = nil;

            testPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:testHeight width:testWidth protocol:testProtocol codec:testCodec];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadVideoStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;
    __block int64_t testMTU = SDLControlFrameInt64NotFound;
    __block int32_t testHeight = SDLControlFrameInt32NotFound;
    __block int32_t testWidth = SDLControlFrameInt32NotFound;
    __block SDLVideoStreamingCodec testCodec = nil;
    __block SDLVideoStreamingProtocol testProtocol = nil;

    beforeEach(^{
        testMTU = 4584651;
        testHeight = 787;
        testWidth = 36365;
        testCodec = SDLVideoStreamingCodecVP8;
        testProtocol = SDLVideoStreamingProtocolRTSP;

        SDLControlFramePayloadVideoStartServiceAck *firstPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:testHeight width:testWidth protocol:testProtocol codec:testCodec];
        testData = firstPayload.data;

        testPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.mtu).to(equal(testMTU));
        expect(testPayload.height).to(equal(testHeight));
        expect(testPayload.width).to(equal(testWidth));
        expect(testPayload.videoCodec).to(equal(testCodec));
        expect(testPayload.videoProtocol).to(equal(testProtocol));
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadVideoStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.data.length).to(equal(0));
    });
});

QuickSpecEnd
