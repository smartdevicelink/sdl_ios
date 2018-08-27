
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
            expect(testPayload.data.description).to(equal(@"<49000000 02766964 656f5072 6f746f63 6f6c0005 00000052 544d5000 10776964 7468006b 01000002 76696465 6f436f64 65630005 00000048 32363500 10686569 67687400 92e90000 00>"));
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
