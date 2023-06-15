//
//  SDLOnSystemCapabilityUpdatedSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLPhoneCapability.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSystemCapability.h"

QuickSpecBegin(SDLOnSystemCapabilityUpdatedSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLSystemCapability *testSystemCapability = nil;

    beforeEach(^{
        SDLPhoneCapability *testPhoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:true];
        testSystemCapability = [[SDLSystemCapability alloc] initWithPhoneCapability:testPhoneCapability];
    });

    it(@"Should set and get correctly", ^{
        SDLOnSystemCapabilityUpdated *testNotification = [[SDLOnSystemCapabilityUpdated alloc] init];
        testNotification.systemCapability = testSystemCapability;

        expect(testNotification.systemCapability).to(equal(testSystemCapability));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameNotification:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameSystemCapability:testSystemCapability
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnSystemCapabilityUpdated}};
        SDLOnSystemCapabilityUpdated *testNotification = [[SDLOnSystemCapabilityUpdated alloc] initWithDictionary:dict];

        expect(testNotification.systemCapability).to(equal(testSystemCapability));
    });

    it(@"Should get correctly when initialized with initWithSystemCapability:", ^{
        SDLOnSystemCapabilityUpdated *testNotification = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:testSystemCapability];

        expect(testNotification.systemCapability).to(equal(testSystemCapability));
    });

    it(@"Should return nil if not set", ^{
        SDLOnSystemCapabilityUpdated *testNotification = [[SDLOnSystemCapabilityUpdated alloc] init];

        expect(testNotification.systemCapability).to(beNil());
    });
});

QuickSpecEnd
