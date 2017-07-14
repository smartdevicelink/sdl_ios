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

        testRequest.systemCapabilityType = [SDLSystemCapabilityType NAVIGATION];

        expect(testRequest.systemCapabilityType).to(equal([SDLSystemCapabilityType NAVIGATION]));
    });
});

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary *dict = @{NAMES_request: @{
                                       NAMES_parameters: @{
                                               NAMES_systemCapabilityType: @"PHONE_CALL"
                                               }
                                       }
                               };
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] initWithDictionary:[dict mutableCopy]];

        expect(testRequest.systemCapabilityType).to(equal([SDLSystemCapabilityType PHONE_CALL]));
    });

    it(@"Should return nil if not set", ^ {
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] init];

        expect(testRequest.systemCapabilityType).to(beNil());
    });

    it(@"should initialize correctly with initWithType:", ^{
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] initWithType:[SDLSystemCapabilityType PHONE_CALL]];

        expect(testRequest.systemCapabilityType).to(equal([SDLSystemCapabilityType PHONE_CALL]));
    });
});


QuickSpecEnd
