
#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadVideoStartService.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingProtocol.h"

QuickSpecBegin(SDLControlFramePayloadVideoStartServiceSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadVideoStartService *testPayload = nil;
    __block int32_t testHeight = SDLControlFrameInt32NotFound;
    __block int32_t testWidth = SDLControlFrameInt32NotFound;
    __block SDLVideoStreamingCodec testCodec = nil;
    __block SDLVideoStreamingProtocol testProtocol = nil;

    context(@"with paramaters", ^{
        beforeEach(^{
            testHeight = 59794;
            testWidth = 363;
            testCodec = SDLVideoStreamingCodecH265;
            testProtocol = SDLVideoStreamingProtocolRTMP;

            testPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithVideoHeight:testHeight width:testWidth protocol:testProtocol codec:testCodec];
        });

        it(@"should create the correct data", ^{
            NSString *base64Encoded = [testPayload.data base64EncodedStringWithOptions:0];
            expect(base64Encoded).to(equal(@"SQAAAAJ2aWRlb1Byb3RvY29sAAUAAABSVE1QABB3aWR0aABrAQAAAnZpZGVvQ29kZWMABQAAAEgyNjUAEGhlaWdodACS6QAAAA=="));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testHeight = SDLControlFrameInt32NotFound;
            testWidth = SDLControlFrameInt32NotFound;
            testCodec = nil;
            testProtocol = nil;

            testPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithVideoHeight:testHeight width:testWidth protocol:testProtocol codec:testCodec];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadVideoStartService *testPayload = nil;
    __block NSData *testData = nil;
    __block int32_t testHeight = SDLControlFrameInt32NotFound;
    __block int32_t testWidth = SDLControlFrameInt32NotFound;
    __block SDLVideoStreamingCodec testCodec = nil;
    __block SDLVideoStreamingProtocol testProtocol = nil;

    beforeEach(^{
        testHeight = 787;
        testWidth = 36365;
        testCodec = SDLVideoStreamingCodecTheora;
        testProtocol = SDLVideoStreamingProtocolRTSP;

        SDLControlFramePayloadVideoStartService *firstPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithVideoHeight:testHeight width:testWidth protocol:testProtocol codec:testCodec];
        testData = firstPayload.data;

        testPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.height).to(equal(testHeight));
        expect(testPayload.width).to(equal(testWidth));
        expect(testPayload.videoCodec).to(equal(testCodec));
        expect(testPayload.videoProtocol).to(equal(testProtocol));
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadVideoStartService *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.data.length).to(equal(0));
    });
});

QuickSpecEnd
