#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemCapability.h"

#import "SDLAppServicesCapabilities.h"
#import "SDLDriverDistractionCapability.h"
#import "SDLImageResolution.h"
#import "SDLNavigationCapability.h"
#import "SDLPhoneCapability.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "SDLSeatLocationCapability.h"
#import "SDLSystemCapabilityType.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"

#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLSystemCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLAppServicesCapabilities *testAppServicesCapabilities = nil;
    __block SDLNavigationCapability *testNavigationCapability = nil;
    __block SDLPhoneCapability *testPhoneCapability = nil;
    __block SDLRemoteControlCapabilities *testRemoteControlCapabilities = nil;
    __block SDLVideoStreamingCapability *testVideoStreamingCapability = nil;
    __block SDLSeatLocationCapability *testSeatLocationCapability = nil;
    __block SDLDriverDistractionCapability *testDriverDistractionCapability = nil;

    beforeEach(^{
        testAppServicesCapabilities = [[SDLAppServicesCapabilities alloc] initWithAppServices:nil];
        testNavigationCapability = [[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:NO];
        testPhoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];
        testRemoteControlCapabilities = [[SDLRemoteControlCapabilities alloc] initWithClimateControlCapabilities:nil radioControlCapabilities:nil buttonCapabilities:nil seatControlCapabilities:nil audioControlCapabilities:nil hmiSettingsControlCapabilities:nil lightControlCapabilities:nil];
        testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:[[SDLImageResolution alloc] initWithWidth:50 height:50] maxBitrate:5 supportedFormats:@[] hapticDataSupported:false diagonalScreenSize:23 pixelPerInch:119 scale:1.4];
        testSeatLocationCapability = [[SDLSeatLocationCapability alloc] init];
        testDriverDistractionCapability = [[SDLDriverDistractionCapability alloc] initWithMenuLength:@2 subMenuDepth:@4];
    });

    it(@"Should set and get correctly", ^ {
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] init];
        testStruct.systemCapabilityType = SDLSystemCapabilityTypeNavigation;
        testStruct.appServicesCapabilities = testAppServicesCapabilities;
        testStruct.navigationCapability = testNavigationCapability;
        testStruct.phoneCapability = testPhoneCapability;
        testStruct.videoStreamingCapability = testVideoStreamingCapability;
        testStruct.remoteControlCapability = testRemoteControlCapabilities;
        testStruct.seatLocationCapability = testSeatLocationCapability;
        testStruct.driverDistractionCapability = testDriverDistractionCapability;

        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeNavigation));
        expect(testStruct.appServicesCapabilities).to(equal(testAppServicesCapabilities));
        expect(testStruct.navigationCapability).to(equal(testNavigationCapability));
        expect(testStruct.phoneCapability).to(equal(testPhoneCapability));
        expect(testStruct.videoStreamingCapability).to(equal(testVideoStreamingCapability));
        expect(testStruct.remoteControlCapability).to(equal(testRemoteControlCapabilities));
        expect(testStruct.seatLocationCapability).to(equal(testSeatLocationCapability));
        expect(testStruct.driverDistractionCapability).to(equal(testDriverDistractionCapability));
    });

    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{
                               SDLRPCParameterNameSystemCapabilityType: SDLSystemCapabilityTypeNavigation,
                               SDLRPCParameterNameAppServicesCapabilities: testAppServicesCapabilities,
                               SDLRPCParameterNameNavigationCapability: testNavigationCapability,
                               SDLRPCParameterNamePhoneCapability: testPhoneCapability,
                               SDLRPCParameterNameRemoteControlCapability: testRemoteControlCapabilities,
                               SDLRPCParameterNameVideoStreamingCapability: testVideoStreamingCapability,
                               SDLRPCParameterNameSeatLocationCapability: testSeatLocationCapability,
                               SDLRPCParameterNameDriverDistractionCapability: testDriverDistractionCapability
                               };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeNavigation));
        expect(testStruct.appServicesCapabilities).to(equal(testAppServicesCapabilities));
        expect(testStruct.navigationCapability).to(equal(testNavigationCapability));
        expect(testStruct.phoneCapability).to(equal(testPhoneCapability));
        expect(testStruct.remoteControlCapability).to(equal(testRemoteControlCapabilities));
        expect(testStruct.videoStreamingCapability).to(equal(testVideoStreamingCapability));
        expect(testStruct.seatLocationCapability).to(equal(testSeatLocationCapability));
        expect(testStruct.driverDistractionCapability).to(equal(testDriverDistractionCapability));
    });

    it(@"Should return nil if not set", ^ {
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] init];

        expect(testStruct.systemCapabilityType).to(beNil());
        expect(testStruct.appServicesCapabilities).to(beNil());
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(beNil());
        expect(testStruct.videoStreamingCapability).to(beNil());
        expect(testStruct.remoteControlCapability).to(beNil());
        expect(testStruct.seatLocationCapability).to(beNil());
        expect(testStruct.driverDistractionCapability).to(beNil());
    });

    it(@"should initialize correctly with initWithAppServicesCapabilities:", ^{
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithAppServicesCapabilities:testAppServicesCapabilities];

        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeAppServices));
        expect(testStruct.appServicesCapabilities).to(equal(testAppServicesCapabilities));
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(beNil());
        expect(testStruct.remoteControlCapability).to(beNil());
        expect(testStruct.videoStreamingCapability).to(beNil());
        expect(testStruct.seatLocationCapability).to(beNil());
        expect(testStruct.driverDistractionCapability).to(beNil());
    });

    it(@"should initialize correctly with initWithPhoneCapability:", ^{
        SDLPhoneCapability *testPhoneStruct = [[SDLPhoneCapability alloc] initWithDialNumber:YES];
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithPhoneCapability:testPhoneStruct];

        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypePhoneCall));
        expect(testStruct.appServicesCapabilities).to(beNil());
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(equal(testPhoneStruct));
        expect(testStruct.remoteControlCapability).to(beNil());
        expect(testStruct.videoStreamingCapability).to(beNil());
        expect(testStruct.seatLocationCapability).to(beNil());
        expect(testStruct.driverDistractionCapability).to(beNil());
    });

    it(@"should initialize correctly with initWithNavigationCapability:", ^{
        SDLNavigationCapability *testNavStruct = [[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:YES];
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithNavigationCapability:testNavStruct];

        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeNavigation));
        expect(testStruct.appServicesCapabilities).to(beNil());
        expect(testStruct.navigationCapability).to(equal(testNavStruct));
        expect(testStruct.phoneCapability).to(beNil());
        expect(testStruct.remoteControlCapability).to(beNil());
        expect(testStruct.videoStreamingCapability).to(beNil());
        expect(testStruct.seatLocationCapability).to(beNil());
        expect(testStruct.driverDistractionCapability).to(beNil());
    });

    it(@"should initialize correctly with initWithVideoStreamingCapability:", ^{
        SDLImageResolution* resolution = [[SDLImageResolution alloc] init];
        resolution.resolutionWidth = @600;
        resolution.resolutionHeight = @500;

        int32_t maxBitrate = 100;
        BOOL hapticDataSupported = YES;

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = SDLVideoStreamingCodecH264;
        format1.protocol = SDLVideoStreamingProtocolRAW;

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = SDLVideoStreamingCodecH265;
        format2.protocol = SDLVideoStreamingProtocolRTP;

        NSArray<SDLVideoStreamingFormat *> *formatArray = @[format1, format2];

        SDLVideoStreamingCapability *testVidStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:maxBitrate supportedFormats:formatArray hapticDataSupported:hapticDataSupported diagonalScreenSize:45 pixelPerInch:112 scale:2.1];
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithVideoStreamingCapability:testVidStruct];

        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeVideoStreaming));
        expect(testStruct.appServicesCapabilities).to(beNil());
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(beNil());
        expect(testStruct.remoteControlCapability).to(beNil());
        expect(testStruct.videoStreamingCapability).to(equal(testVidStruct));
        expect(testStruct.seatLocationCapability).to(beNil());
        expect(testStruct.driverDistractionCapability).to(beNil());
    });
    
    it(@"should initialize correctly with initWithRemoteControlCapability:", ^{
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithRemoteControlCapability:testRemoteControlCapabilities];
        
        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeRemoteControl));
        expect(testStruct.appServicesCapabilities).to(beNil());
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(beNil());
        expect(testStruct.remoteControlCapability).to(equal(testRemoteControlCapabilities));
        expect(testStruct.videoStreamingCapability).to(beNil());
        expect(testStruct.seatLocationCapability).to(beNil());
        expect(testStruct.driverDistractionCapability).to(beNil());
    });
    
    it(@"should initialize correctly with initWithSeatLocationCapability:", ^{
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithSeatLocationCapability:testSeatLocationCapability];
        
        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeSeatLocation));
        expect(testStruct.appServicesCapabilities).to(beNil());
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(beNil());
        expect(testStruct.remoteControlCapability).to(beNil());
        expect(testStruct.videoStreamingCapability).to(beNil());
        expect(testStruct.seatLocationCapability).to(equal(testSeatLocationCapability));
        expect(testStruct.driverDistractionCapability).to(beNil());
    });

    it(@"should initialize correctly with initWithDriverDistractionCapability:", ^{
        SDLSystemCapability *testStruct = [[SDLSystemCapability alloc] initWithDriverDistractionCapability:testDriverDistractionCapability];

        expect(testStruct.systemCapabilityType).to(equal(SDLSystemCapabilityTypeDriverDistraction));
        expect(testStruct.appServicesCapabilities).to(beNil());
        expect(testStruct.navigationCapability).to(beNil());
        expect(testStruct.phoneCapability).to(beNil());
        expect(testStruct.remoteControlCapability).to(beNil());
        expect(testStruct.videoStreamingCapability).to(beNil());
        expect(testStruct.seatLocationCapability).to(beNil());
        expect(testStruct.driverDistractionCapability).to(equal(testDriverDistractionCapability));
    });
});


QuickSpecEnd
