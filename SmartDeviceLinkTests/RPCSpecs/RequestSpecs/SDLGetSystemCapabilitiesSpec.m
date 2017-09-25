#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetSystemCapability.h"

#import "SDLSystemCapabilityType.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetSystemCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] init];

        testRequest.systemCapabilityType = SDLSystemCapabilityTypeNavigation;

        expect(testRequest.systemCapabilityType).to(equal(SDLSystemCapabilityTypeNavigation));
    });
});

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{SDLNameRequest: @{
                                       SDLNameParameters: @{
                                               SDLNameSystemCapabilityType: @"PHONE_CALL"
                                               }
                                       }
                               };
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] initWithDictionary:dict];

        expect(testRequest.systemCapabilityType).to(equal(SDLSystemCapabilityTypePhoneCall));
    });

    it(@"Should return nil if not set", ^ {
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] init];

        expect(testRequest.systemCapabilityType).to(beNil());
    });

    it(@"Should get correctly when initialized with systemCapabilityType", ^ {
        SDLGetSystemCapability* testRequest = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypePhoneCall];

        expect(testRequest.systemCapabilityType).to(equal(SDLSystemCapabilityTypePhoneCall));
    });


    it(@"should initialize correctly with initWithType:", ^{
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypePhoneCall];

        expect(testRequest.systemCapabilityType).to(equal(SDLSystemCapabilityTypePhoneCall));
    });
});


QuickSpecEnd
