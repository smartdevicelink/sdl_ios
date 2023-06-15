//
//  SDLControlFramePayloadRegisterSecondaryTransportNakSpec.m
//  SmartDeviceLinkTests
//
//  Created by Sho Amano on 2018/03/25.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLControlFramePayloadRegisterSecondaryTransportNak.h"

QuickSpecBegin(SDLControlFramePayloadRegisterSecondaryTransportNakSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadRegisterSecondaryTransportNak *testPayload = nil;
    __block NSString *testReason = nil;

    context(@"with paramaters", ^{
        beforeEach(^{
            testReason = @"a sample reason of NAK";
            testPayload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithReason:testReason];
        });

        it(@"should create the correct data", ^{
            NSString *base64Encoded = [testPayload.data base64EncodedStringWithOptions:0];
            expect(base64Encoded).to(equal(@"KAAAAAJyZWFzb24AFwAAAGEgc2FtcGxlIHJlYXNvbiBvZiBOQUsAAA=="));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testReason = nil;
            testPayload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithReason:testReason];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadRegisterSecondaryTransportNak *testPayload = nil;
    __block NSData *testData = nil;
    __block NSString *testReason = nil;

    beforeEach(^{
        testReason = @"Here is another reason";

        SDLControlFramePayloadRegisterSecondaryTransportNak *payload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithReason:testReason];
        testData = payload.data;

        testPayload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.reason).to(equal(testReason));
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadRegisterSecondaryTransportNak *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.reason).to(beNil());
    });
});

QuickSpecEnd
