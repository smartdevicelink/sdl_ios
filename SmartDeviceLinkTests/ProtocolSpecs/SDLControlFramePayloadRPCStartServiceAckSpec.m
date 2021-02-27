
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"

QuickSpecBegin(SDLControlFramePayloadRPCStartServiceAckSpec)

describe(@"The payload", ^{
    __block SDLControlFramePayloadRPCStartServiceAck *testPayload = nil;
    __block NSData *testData = nil;
    int32_t testHashId = 1457689;
    int64_t testMTU = 5984649;
    NSString *testProtocolVersion = @"1.32.32";
    NSString *testAuthToken = @"Test Auth Token";
    NSArray<NSString *> *testSecondaryTransports = @[@"TCP_WIFI", @"IAP_USB"];
    NSArray<NSNumber *> *testAudioServiceTransports = @[@(2)];
    NSArray<NSNumber *> *testVideoServiceTransports = @[@2, @1];
    NSString *testMake = @"Livio";
    NSString *testModel = @"Is";
    NSString *testTrim = @"Awesome";
    NSString *testModelYear = @"2021";
    NSString *testSystemSoftwareVersion = @"1.1.1.1";
    NSString *testSystemHardwareVersion = @"2.2.2.2";

    describe(@"Test encoding data", ^{
        context(@"with parameters", ^{
            beforeEach(^{
                testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU authToken:testAuthToken protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports make:testMake model:testModel trim:testTrim modelYear:testModelYear systemSoftwareVersion:testSystemSoftwareVersion systemHardwareVersion:testSystemHardwareVersion];
            });

            it(@"should create the correct data", ^{
                NSString *base64Encoded = [testPayload.data base64EncodedStringWithOptions:0];
                expect(base64Encoded).to(equal(@"bAEAAAR2aWRlb1NlcnZpY2VUcmFuc3BvcnRzABMAAAAQMAACAAAAEDEAAQAAAAAQaGFzaElkABk+FgACbW9kZWwAAwAAAElzABJtdHUAiVFbAAAAAAACbW9kZWxZZWFyAAUAAAAyMDIxAAJzeXN0ZW1IYXJkd2FyZVZlcnNpb24ACAAAADIuMi4yLjIAAm1ha2UABgAAAExpdmlvAAJhdXRoVG9rZW4AEAAAAFRlc3QgQXV0aCBUb2tlbgAEc2Vjb25kYXJ5VHJhbnNwb3J0cwAkAAAAAjAACQAAAFRDUF9XSUZJAAIxAAgAAABJQVBfVVNCAAACc3lzdGVtU29mdHdhcmVWZXJzaW9uAAgAAAAxLjEuMS4xAAJ0cmltAAgAAABBd2Vzb21lAARhdWRpb1NlcnZpY2VUcmFuc3BvcnRzAAwAAAAQMAACAAAAAAJwcm90b2NvbFZlcnNpb24ACAAAADEuMzIuMzIAAA=="));
            });
        });

        context(@"without parameters", ^{
            beforeEach(^{
                testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:SDLControlFrameInt32NotFound mtu:SDLControlFrameInt64NotFound authToken:nil protocolVersion:nil secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil make:nil model:nil trim:nil modelYear:nil systemSoftwareVersion:nil systemHardwareVersion:nil];
            });

            it(@"should create no data", ^{
                expect(testPayload.data.length).to(equal(0));
            });
        });
    });

    describe(@"Test decoding data", ^{
        context(@"with parameters", ^{
            beforeEach(^{
                SDLControlFramePayloadRPCStartServiceAck *firstPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU authToken:testAuthToken protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports make:testMake model:testModel trim:testTrim modelYear:testModelYear systemSoftwareVersion:testSystemSoftwareVersion systemHardwareVersion:testSystemHardwareVersion];
                testData = firstPayload.data;

                testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:testData];
            });

            it(@"should output the correct params", ^{
                expect(testPayload.hashId).to(equal(testHashId));
                expect(testPayload.mtu).to(equal(testMTU));
                expect(testPayload.authToken).to(equal(testAuthToken));
                expect(testPayload.protocolVersion).to(equal(testProtocolVersion));
                expect(testPayload.secondaryTransports).to(equal(testSecondaryTransports));
                expect(testPayload.audioServiceTransports).to(equal(testAudioServiceTransports));
                expect(testPayload.videoServiceTransports).to(equal(testVideoServiceTransports));
                expect(testPayload.make).to(equal(testMake));
                expect(testPayload.model).to(equal(testModel));
                expect(testPayload.trim).to(equal(testTrim));
                expect(testPayload.modelYear).to(equal(testModelYear));
                expect(testPayload.systemSoftwareVersion).to(equal(testSystemSoftwareVersion));
                expect(testPayload.systemHardwareVersion).to(equal(testSystemHardwareVersion));
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
});

QuickSpecEnd
