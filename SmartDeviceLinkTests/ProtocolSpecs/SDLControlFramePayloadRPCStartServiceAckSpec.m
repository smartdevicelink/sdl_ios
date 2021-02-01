
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLSystemInfo.h"
#import "SDLVehicleType.h"

@interface SDLControlFramePayloadRPCStartServiceAck (discover_internals)

@property (strong, nonatomic, readwrite, nullable) SDLSystemInfo *systemInfo;

- (void)sdl_parse:(NSData *)data;
SDLSystemInfo *__nullable sdl_parseSystemInfo(BsonObject *const payloadObject);

@end


QuickSpecBegin(SDLControlFramePayloadRPCStartServiceAckSpec)

SDLSystemInfo *defaultSystemInfo = [[SDLSystemInfo alloc] init];

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadRPCStartServiceAck *testPayload = nil;
    __block int32_t testHashId = 0;
    __block int64_t testMTU = 0;
    __block NSString *testProtocolVersion = nil;
    __block NSArray<NSString *> *testSecondaryTransports = nil;
    __block NSArray<NSNumber *> *testAudioServiceTransports = nil;
    __block NSArray<NSNumber *> *testVideoServiceTransports = nil;

    context(@"with parameters", ^{
        beforeEach(^{
            testHashId = 1457689;
            testMTU = 5984649;
            testProtocolVersion = @"1.32.32";

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU authToken:nil protocolVersion:testProtocolVersion secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil];
        });

        it(@"should create the correct data", ^{
            NSString *base64Encoded = [testPayload.data base64EncodedStringWithOptions:0];
            expect(base64Encoded).to(equal(@"OwAAABBoYXNoSWQAGT4WABJtdHUAiVFbAAAAAAACcHJvdG9jb2xWZXJzaW9uAAgAAAAxLjMyLjMyAAA="));
        });
    });

    context(@"with secondary transport parameters", ^{
        beforeEach(^{
            testHashId = 987654;
            testMTU = 4096;
            testProtocolVersion = @"5.10.01";
            testSecondaryTransports = @[@"TCP_WIFI", @"IAP_USB"];
            testAudioServiceTransports = @[@(2)];
            testVideoServiceTransports = @[(@2), @(1)];

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU authToken:nil protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
        });

        it(@"should create the correct data", ^{
            NSString *base64Encoded = [testPayload.data base64EncodedStringWithOptions:0];
            expect(base64Encoded).to(equal(@"wwAAAAR2aWRlb1NlcnZpY2VUcmFuc3BvcnRzABMAAAAQMAACAAAAEDEAAQAAAAAQaGFzaElkAAYSDwASbXR1AAAQAAAAAAAABHNlY29uZGFyeVRyYW5zcG9ydHMAJAAAAAIwAAkAAABUQ1BfV0lGSQACMQAIAAAASUFQX1VTQgAABGF1ZGlvU2VydmljZVRyYW5zcG9ydHMADAAAABAwAAIAAAAAAnByb3RvY29sVmVyc2lvbgAIAAAANS4xMC4wMQAA"));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testHashId = SDLControlFrameInt32NotFound;
            testMTU = SDLControlFrameInt64NotFound;

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU authToken:nil protocolVersion:nil secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil];
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
    __block NSString *testAuthToken = nil;
    __block NSString *testProtocolVersion = nil;
    __block NSArray<NSString *> *testSecondaryTransports = nil;
    __block NSArray<NSNumber *> *testAudioServiceTransports = nil;
    __block NSArray<NSNumber *> *testVideoServiceTransports = nil;

    context(@"with parameters", ^{
        beforeEach(^{
            testHashId = 1545784;
            testMTU = 989786483;
            testAuthToken = @"testAuthToken";
            testProtocolVersion = @"3.89.5";

            SDLControlFramePayloadRPCStartServiceAck *firstPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU authToken:testAuthToken protocolVersion:testProtocolVersion secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil];
            testData = firstPayload.data;

            testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:testData];
        });

        it(@"should output the correct params", ^{
            expect(testPayload.hashId).to(equal(testHashId));
            expect(testPayload.mtu).to(equal(testMTU));
            expect(testPayload.authToken).to(equal(testAuthToken));
            expect(testPayload.protocolVersion).to(equal(testProtocolVersion));
            expect(testPayload.secondaryTransports).to(beNil());
            expect(testPayload.audioServiceTransports).to(beNil());
            expect(testPayload.videoServiceTransports).to(beNil());
            expect(testPayload.systemInfo).to(beNil());
        });
    });

    context(@"with secondary transport parameters", ^{
        beforeEach(^{
            testHashId = 17999024;
            testMTU = 1798250;
            testAuthToken = @"testAuthToken";
            testProtocolVersion = @"6.01.00";
            testSecondaryTransports = @[@"TCP_WIFI"];
            testAudioServiceTransports = @[@(2), @(1)];
            testVideoServiceTransports = @[@(1)];

            SDLControlFramePayloadRPCStartServiceAck *firstPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMTU authToken:testAuthToken protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
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
            expect(testPayload.systemInfo).to(beNil());
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


describe(@"getter/setter test", ^{
    __block SDLControlFramePayloadRPCStartServiceAck *testPayload = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] init];
        testPayload.systemInfo = defaultSystemInfo;
    });

    it(@"expect systemInfo to be set properly", ^{
        expect(testPayload.systemInfo).to(equal(defaultSystemInfo));
    });
});

describe(@"sdl_parseVehicleType()", ^{
    __block BsonObject *bsonObject = NULL;

    char *const vhMake = "ZAZ";
    char *const vhModel = "Tavria";
    char *const vhModelYear = "1987";
    char *const vhTrim = "GT3";
    char *const vhHardVersion = "1.2.3";
    char *const vhSoftVersion = "9.8.7";

    beforeEach(^{
        bsonObject = malloc(sizeof(BsonObject));
        bool ok = NULL != bsonObject;
        if (ok) {
            ok = bson_object_initialize_default(bsonObject);
        }
        if (ok) {
            ok = bson_object_put_string(bsonObject, SDLControlFrameVehicleMake, vhMake);
        }
        if (ok) {
            ok = bson_object_put_string(bsonObject, SDLControlFrameVehicleModel, vhModel);
        }
        if (ok) {
            ok = bson_object_put_string(bsonObject, SDLControlFrameVehicleModelYear, vhModelYear);
        }
        if (ok) {
            ok = bson_object_put_string(bsonObject, SDLControlFrameVehicleTrim, vhTrim);
        }
        if (ok) {
            ok = bson_object_put_string(bsonObject, SDLControlFrameVehicleHardVersion, vhHardVersion);
        }
        if (ok) {
            ok = bson_object_put_string(bsonObject, SDLControlFrameVehicleSoftVersion, vhSoftVersion);
        }

        if (!ok) {
            NSLog(@"cannot create or init bson vehicle type");
        }
    });

    afterEach(^{
        if (bsonObject) {
            bson_object_deinitialize(bsonObject);
            free(bsonObject);
            bsonObject = NULL;
        }
    });

    it(@"expect systemInfo to be decoded from bson properly", ^{
        SDLSystemInfo *systemInfo = sdl_parseSystemInfo(bsonObject);
        expect(systemInfo).notTo(beNil());
        expect(systemInfo.vehicleType.make).to(equal([NSString stringWithUTF8String:vhMake]));
        expect(systemInfo.vehicleType.model).to(equal([NSString stringWithUTF8String:vhModel]));
        expect(systemInfo.vehicleType.modelYear).to(equal([NSString stringWithUTF8String:vhModelYear]));
        expect(systemInfo.vehicleType.trim).to(equal([NSString stringWithUTF8String:vhTrim]));
        expect(systemInfo.systemSoftwareVersion).to(equal([NSString stringWithUTF8String:vhSoftVersion]));
        expect(systemInfo.systemHardwareVersion).to(equal([NSString stringWithUTF8String:vhHardVersion]));
    });
});

describe(@"sdl_parseVehicleType()", ^{
    __block SDLControlFramePayloadRPCStartServiceAck *testPayload = nil;
    __block SDLSystemInfo *systemInfo = nil;

    NSString *strMake = @"ZAZ";
    NSString *strModel = @"Tavria";
    NSString *strModelYear = @"1987";
    NSString *strTrim = @"GT3";
    NSString *systemSoftwareVersion = @"1.2.3";
    NSString *systemHardwareVersion = @"9.8.7";

    beforeEach(^{
        SDLVehicleType *vehicleType = [[SDLVehicleType alloc] init];
        vehicleType.make = strMake;
        vehicleType.model = strModel;
        vehicleType.modelYear = strModelYear;
        vehicleType.trim = strTrim;

        systemInfo = [[SDLSystemInfo alloc] initWithVehicleType:vehicleType systemSoftwareVersion:systemSoftwareVersion systemHardwareVersion:systemHardwareVersion];


        // serialize the vehicleType
        SDLControlFramePayloadRPCStartServiceAck *helperStruct = [[SDLControlFramePayloadRPCStartServiceAck alloc] init];
        helperStruct.systemInfo = systemInfo;
        NSData *data = helperStruct.data;
        helperStruct = nil;

        // parse the data to restore the vehicleType object
        testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] init];
        [testPayload sdl_parse:data];
    });

    afterEach(^{
        testPayload = nil;
        systemInfo = nil;
    });
    
    it(@"expect vehicleType to be decoded from data properly", ^{
        SDLSystemInfo *systemInfoDecoded = testPayload.systemInfo;
        expect(systemInfoDecoded).notTo(beNil());
        expect(systemInfoDecoded).to(equal(systemInfo));
    });
});

QuickSpecEnd
