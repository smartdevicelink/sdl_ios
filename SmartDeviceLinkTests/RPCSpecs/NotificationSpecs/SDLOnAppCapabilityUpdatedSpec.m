//
//  SDLOnAppCapabilityUpdatedSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLAppCapability.h"
#import "SDLOnAppCapabilityUpdated.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SDLVideoStreamingCapability.h"

QuickSpecBegin(SDLOnAppCapabilityUpdatedSpec)

describe(@"getter/setter tests", ^{
    SDLVideoStreamingCapability *videoStreamingCapability = [[SDLVideoStreamingCapability alloc] init];
    SDLAppCapability *appCapability = [[SDLAppCapability alloc] initWithVideoStreamingCapability:videoStreamingCapability];

    context(@"init", ^{
        SDLOnAppCapabilityUpdated *testStruct = [[SDLOnAppCapabilityUpdated alloc] init];
        it(@"expect all properties to be nil", ^{
            expect(testStruct.appCapability).to(beNil());
        });
    });

    context(@"init & assign", ^{
        SDLOnAppCapabilityUpdated *testStruct = [[SDLOnAppCapabilityUpdated alloc] init];
        testStruct.appCapability = appCapability;
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapability).to(equal(appCapability));
        });
    });

    context(@"initWithVideoStreamingCapability:", ^{
        SDLOnAppCapabilityUpdated *testStruct = [[SDLOnAppCapabilityUpdated alloc] initWithAppCapability:appCapability];
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapability).to(equal(appCapability));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary *params = @{
            SDLRPCParameterNameAppCapability: appCapability,
        };
        NSDictionary* dict = @{SDLRPCParameterNameNotification: @{
                                    SDLRPCParameterNameParameters: params,
                                    SDLRPCParameterNameOperationName: SDLRPCFunctionNameOnAppCapabilityUpdated}
        };
        SDLOnAppCapabilityUpdated *testStruct = [[SDLOnAppCapabilityUpdated alloc] initWithDictionary:dict];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.appCapability).to(equal(appCapability));
        });
    });
});

QuickSpecEnd
