//
//  SDLControlFramePayloadTransportEventUpdateSpec.m
//  SmartDeviceLinkTests
//
//  Created by Sho Amano on 2018/03/25.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadTransportEventUpdate.h"
#import "SDLControlFramePayloadConstants.h"

QuickSpecBegin(SDLControlFramePayloadTransportEventUpdateSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadTransportEventUpdate *testPayload = nil;
    __block NSString *testTcpIpAddress = nil;
    __block int32_t testTcpPort = SDLControlFrameInt32NotFound;

    context(@"with paramaters", ^{
        beforeEach(^{
            testTcpIpAddress = @"10.20.30.254";
            testTcpPort = 12345;
            testPayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
        });

        it(@"should create the correct data", ^{
            expect(testPayload.data.description).to(equal(@"<31000000 10746370 506f7274 00393000 00027463 70497041 64647265 7373000d 00000031 302e3230 2e33302e 32353400 00>"));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testTcpIpAddress = nil;
            testTcpPort = SDLControlFrameInt32NotFound;
            testPayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadTransportEventUpdate *testPayload = nil;
    __block NSData *testData = nil;
    __block NSString *testTcpIpAddress = nil;
    __block int32_t testTcpPort = SDLControlFrameInt32NotFound;

    beforeEach(^{
        testTcpIpAddress = @"192.168.132.24";
        testTcpPort = 40902;

        SDLControlFramePayloadTransportEventUpdate *payload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
        testData = payload.data;

        testPayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.tcpIpAddress).to(equal(testTcpIpAddress));
        expect(testPayload.tcpPort).to(equal(testTcpPort));
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadTransportEventUpdate *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.tcpIpAddress).to(beNil());
        expect(testPayload.tcpPort).to(equal(SDLControlFrameInt32NotFound));
    });
});

QuickSpecEnd
