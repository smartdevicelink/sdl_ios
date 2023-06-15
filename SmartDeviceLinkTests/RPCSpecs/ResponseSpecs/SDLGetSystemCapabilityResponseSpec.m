#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLGetSystemCapabilityResponse.h"

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLNavigationCapability.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityType.h"

QuickSpecBegin(SDLGetSystemCapabilityResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetSystemCapabilityResponse *testRequest = [[SDLGetSystemCapabilityResponse alloc] init];

        testRequest.systemCapability = [[SDLSystemCapability alloc] initWithNavigationCapability:[[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:NO]];

        expect(testRequest.systemCapability.systemCapabilityType).to(equal(SDLSystemCapabilityTypeNavigation));
        expect(testRequest.systemCapability.navigationCapability.sendLocationEnabled).to(equal(YES));
        expect(testRequest.systemCapability.navigationCapability.getWayPointsEnabled).to(equal(NO));
        expect(testRequest.systemCapability.phoneCapability).to(beNil());
    });
});

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{
                               SDLRPCParameterNameResponse: @{
                                       SDLRPCParameterNameParameters: @{
                                               SDLRPCParameterNameSystemCapability: @{
                                                       SDLRPCParameterNameSystemCapabilityType: @"NAVIGATION",
                                                       SDLRPCParameterNameNavigationCapability: @{
                                                               SDLRPCParameterNameGetWayPointsEnabled: @(NO),
                                                               SDLRPCParameterNameSendLocationEnabled: @(YES)}
                                                       }
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetSystemCapability
                                       }
                               };
        SDLGetSystemCapabilityResponse *testResponse = [[SDLGetSystemCapabilityResponse alloc] initWithDictionary:dict];

        expect(testResponse.systemCapability.systemCapabilityType).to(equal(SDLSystemCapabilityTypeNavigation));
        expect(testResponse.systemCapability.navigationCapability.sendLocationEnabled).to(equal(YES));
        expect(testResponse.systemCapability.navigationCapability.getWayPointsEnabled).to(equal(NO));
        expect(testResponse.systemCapability.phoneCapability).to(beNil());
        expect(testResponse.name).to(equal(SDLRPCFunctionNameGetSystemCapability));
    });

    it(@"Should return nil if not set", ^ {
        SDLGetSystemCapabilityResponse *testResponse = [[SDLGetSystemCapabilityResponse alloc] init];

        expect(testResponse.systemCapability).to(beNil());
    });
});


QuickSpecEnd
