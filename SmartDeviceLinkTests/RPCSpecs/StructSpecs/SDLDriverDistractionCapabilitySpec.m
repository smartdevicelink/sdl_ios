//
//  SDLDriverDistractionCapabilitySpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 7/27/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDriverDistractionCapability.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLDriverDistractionCapabilitySpec)

describe(@"the driver distraction capability struct", ^{
    __block SDLDriverDistractionCapability *testCapability = nil;
    __block NSNumber *testMenuLength = @2;
    __block NSNumber *testSubmenuDepth = @4;

    beforeEach(^{
        testCapability = [[SDLDriverDistractionCapability alloc] init];
    });

    describe(@"Getter/Setter Tests", ^ {
        it(@"Should set and get correctly", ^ {
            testCapability.menuLength = testMenuLength;
            testCapability.subMenuDepth = testSubmenuDepth;

            expect(testCapability.menuLength).to(equal(testMenuLength));
            expect(testCapability.subMenuDepth).to(equal(testSubmenuDepth));
        });

        it(@"Should get correctly when initialized", ^ {
            NSDictionary *dict = @{
                SDLRPCParameterNameMenuLength: testMenuLength,
                SDLRPCParameterNameSubMenuDepth: testSubmenuDepth
            };
            testCapability = [[SDLDriverDistractionCapability alloc] initWithDictionary:dict];

            expect(testCapability.menuLength).to(equal(testMenuLength));
            expect(testCapability.subMenuDepth).to(equal(testSubmenuDepth));
        });

        it(@"Should return nil if not set", ^ {
            expect(testCapability.menuLength).to(beNil());
            expect(testCapability.subMenuDepth).to(beNil());
        });

        it(@"should properly init with initWithMenuLength:subMenuDepth:", ^{
            testCapability = [[SDLDriverDistractionCapability alloc] initWithMenuLength:testMenuLength subMenuDepth:testSubmenuDepth];

            expect(testCapability.menuLength).to(equal(testMenuLength));
            expect(testCapability.subMenuDepth).to(equal(testSubmenuDepth));
        });
    });
});

QuickSpecEnd
