//
//  SDLOnAppCapabilityUpdatedSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLAppCapability.h"
#import "SDLAppCapabilityType.h"
#import "SDLRPCParameterNames.h"
#import "SDLVideoStreamingCapability.h"

QuickSpecBegin(SDLAppCapabilitySpec)

describe(@"getter/setter tests", ^{
    SDLVideoStreamingCapability *videoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
    SDLAppCapabilityType appCapabilityType = SDLAppCapabilityTypeVideoStreaming;
    __block SDLAppCapability *testStruct = nil;

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLAppCapability alloc] init];
        });
        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be nil", ^{
            expect(testStruct.appCapabilityType).to(beNil());
            expect(testStruct.videoStreamingCapability).to(beNil());
        });
    });

    context(@"init & assign", ^{
        beforeEach(^{
            testStruct = [[SDLAppCapability alloc] init];
            testStruct.appCapabilityType = appCapabilityType;
            testStruct.videoStreamingCapability = videoStreamingCapability;
        });
        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapabilityType).to(equal(appCapabilityType));
            expect(testStruct.videoStreamingCapability).to(equal(videoStreamingCapability));
        });
    });

    context(@"initWithAppCapabilityType:", ^{
        beforeEach(^{
            testStruct = [[SDLAppCapability alloc] initWithAppCapabilityType:appCapabilityType];
        });
        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapabilityType).to(equal(appCapabilityType));
            expect(testStruct.videoStreamingCapability).to(beNil());
        });
    });

    context(@"initWithVideoStreamingCapability:", ^{
        beforeEach(^{
            testStruct = [[SDLAppCapability alloc] initWithAppCapabilityType:appCapabilityType videoStreamingCapability:videoStreamingCapability];
        });
        it(@"make sure object created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapabilityType).to(equal(appCapabilityType));
            expect(testStruct.videoStreamingCapability).to(equal(videoStreamingCapability));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary *dict = @{
                SDLRPCParameterNameVideoStreamingCapability: videoStreamingCapability,
                SDLRPCParameterNameAppCapabilityType: appCapabilityType,
            };
            testStruct = [[SDLAppCapability alloc] initWithDictionary:dict];
        });
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
