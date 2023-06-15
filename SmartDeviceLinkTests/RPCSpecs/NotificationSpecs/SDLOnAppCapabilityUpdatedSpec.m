//
//  SDLOnAppCapabilityUpdatedSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
@import Quick;
@import Nimble;

#import "SDLAppCapability.h"
#import "SDLOnAppCapabilityUpdated.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SDLVideoStreamingCapability.h"

QuickSpecBegin(SDLOnAppCapabilityUpdatedSpec)

describe(@"getter/setter tests", ^{
    SDLVideoStreamingCapability *videoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
    SDLAppCapability *appCapability = [[SDLAppCapability alloc] initWithAppCapabilityType:SDLAppCapabilityTypeVideoStreaming videoStreamingCapability:videoStreamingCapability];
    __block SDLOnAppCapabilityUpdated *testStruct = nil;

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLOnAppCapabilityUpdated alloc] init];
        });
        it(@"expect object to be created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be nil", ^{
            expect(testStruct.appCapability).to(beNil());
        });
    });

    context(@"init & assign", ^{
        beforeEach(^{
            testStruct = [[SDLOnAppCapabilityUpdated alloc] init];
            testStruct.appCapability = appCapability;
        });
        it(@"expect object to be created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapability).to(equal(appCapability));
        });
    });

    context(@"initWithVideoStreamingCapability:", ^{
        beforeEach(^{
            testStruct = [[SDLOnAppCapabilityUpdated alloc] initWithAppCapability:appCapability];
        });
        it(@"expect object to be created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapability).to(equal(appCapability));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary *params = @{
                SDLRPCParameterNameAppCapability: appCapability,
            };
            NSDictionary* dict = @{SDLRPCParameterNameNotification: @{
                                           SDLRPCParameterNameParameters: params,
                                           SDLRPCParameterNameOperationName: SDLRPCFunctionNameOnAppCapabilityUpdated}
            };
            testStruct = [[SDLOnAppCapabilityUpdated alloc] initWithDictionary:dict];
        });

        it(@"expect object to be created", ^{
            expect(testStruct).notTo(beNil());
        });
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapability).to(equal(appCapability));
        });
    });
});

QuickSpecEnd
