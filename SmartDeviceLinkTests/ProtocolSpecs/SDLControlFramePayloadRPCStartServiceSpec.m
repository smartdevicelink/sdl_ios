
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadRPCStartService.h"

QuickSpecBegin(SDLControlFramePayloadRPCStartServiceSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadRPCStartService *testPayload = nil;
    __block NSString *testProtocolVersion = nil;

    context(@"with paramaters", ^{
        beforeEach(^{
            testProtocolVersion = @"74.32.2";

            testPayload = [[SDLControlFramePayloadRPCStartService alloc] initWithVersion:testProtocolVersion];
        });

        it(@"should create the correct data", ^{
            NSString *base64Encoded = [testPayload.data base64EncodedStringWithOptions:0];
            expect(base64Encoded).to(equal(@"IgAAAAJwcm90b2NvbFZlcnNpb24ACAAAADc0LjMyLjIAAA=="));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testProtocolVersion = nil;

            testPayload = [[SDLControlFramePayloadRPCStartService alloc] initWithVersion:testProtocolVersion];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadRPCStartService *testPayload = nil;
    __block NSData *testData = nil;
    __block NSString *testProtocolVersion = nil;

    beforeEach(^{
        testProtocolVersion = @"59.63.47";

        SDLControlFramePayloadRPCStartService *firstPayload = [[SDLControlFramePayloadRPCStartService alloc] initWithVersion:testProtocolVersion];
        testData = firstPayload.data;

        testPayload = [[SDLControlFramePayloadRPCStartService alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.protocolVersion).to(equal(testProtocolVersion));
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadRPCStartService *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadRPCStartService alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.protocolVersion).to(beNil());
        expect(testPayload.data.length).to(equal(0));
    });
});

QuickSpecEnd
