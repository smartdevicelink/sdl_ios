//
//  SDLOnAppCapabilityUpdatedSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLAppCapability.h"
#import "SDLRPCParameterNames.h"
#import "SDLVideoStreamingCapability.h"

QuickSpecBegin(SDLAppCapabilitySpec)

describe(@"getter/setter tests", ^{
    SDLVideoStreamingCapability *videoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
    SDLSystemCapabilityType appCapabilityType = SDLSystemCapabilityTypeVideoStreaming;

    context(@"init", ^{
        SDLAppCapability *testStruct = [[SDLAppCapability alloc] init];
        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be nil", ^{
            expect(testStruct.appCapabilityType).to(beNil());
            expect(testStruct.videoStreamingCapability).to(beNil());
        });
    });

    context(@"init & assign", ^{
        SDLAppCapability *testStruct = [[SDLAppCapability alloc] init];
        testStruct.appCapabilityType = appCapabilityType;
        testStruct.videoStreamingCapability = videoStreamingCapability;
        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapabilityType).to(equal(appCapabilityType));
            expect(testStruct.videoStreamingCapability).to(equal(videoStreamingCapability));
        });
    });

    context(@"initWithVideoStreamingCapability:", ^{
        SDLAppCapability *testStruct = [[SDLAppCapability alloc] initWithVideoStreamingCapability:videoStreamingCapability];
        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapabilityType).to(equal(appCapabilityType));
            expect(testStruct.videoStreamingCapability).to(equal(videoStreamingCapability));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary *dict = @{
            SDLRPCParameterNameVideoStreamingCapability: videoStreamingCapability,
            SDLRPCParameterNameAppCapabilityType: appCapabilityType,
        };
        SDLAppCapability *testStruct = [[SDLAppCapability alloc] initWithDictionary:dict];

        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapabilityType).to(equal(appCapabilityType));
            expect(testStruct.videoStreamingCapability).to(equal(videoStreamingCapability));
        });
    });
});

QuickSpecEnd
