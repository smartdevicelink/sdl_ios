//
//  SDLDynamicUpdateCapabilitiesSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 7/30/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDynamicUpdateCapabilities.h"

#import "SDLImageFieldName.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLDynamicUpdateCapabilitiesSpec)

__block SDLDynamicUpdateCapabilities *testStruct = nil;
__block NSArray<SDLImageFieldName> *testImageFields = @[SDLImageFieldNameCommandIcon, SDLImageFieldNameSubMenuIcon];
__block NSNumber<SDLBool> *testSupportsDynamicSubmenus = @YES;

describe(@"when initializing with init", ^{
    beforeEach(^{
        testStruct = [[SDLDynamicUpdateCapabilities alloc] init];
    });

    it(@"should have no data", ^{
        expect(testStruct.supportedDynamicImageFieldNames).to(beNil());
        expect(testStruct.supportsDynamicSubMenus).to(beNil());
    });

    describe(@"when getting/setting parameters", ^{
        beforeEach(^{
            testStruct.supportedDynamicImageFieldNames = @[SDLImageFieldNameCommandIcon, SDLImageFieldNameSubMenuIcon];
            testStruct.supportsDynamicSubMenus = testSupportsDynamicSubmenus;
        });

        it(@"should properly get/set the data", ^{
            expect(testStruct.supportedDynamicImageFieldNames).to(equal(testImageFields));
            expect(testStruct.supportsDynamicSubMenus).to(equal(testSupportsDynamicSubmenus));
        });
    });
});

describe(@"when initializing with a dictionary", ^{
    beforeEach(^{
        NSDictionary *testDict = @{
            SDLRPCParameterNameSupportedDynamicImageFieldNames: testImageFields,
            SDLRPCParameterNameSupportsDynamicSubMenus: testSupportsDynamicSubmenus
        };

        testStruct = [[SDLDynamicUpdateCapabilities alloc] initWithDictionary:testDict];
    });

    it(@"should properly get/set the data", ^{
        expect(testStruct.supportedDynamicImageFieldNames).to(equal(testImageFields));
        expect(testStruct.supportsDynamicSubMenus).to(equal(testSupportsDynamicSubmenus));
    });
});

describe(@"when initializing with initWithSupportedDynamicImageFieldNames:supportsDynamicSubMenus:", ^{
    beforeEach(^{
        testStruct = [[SDLDynamicUpdateCapabilities alloc] initWithSupportedDynamicImageFieldNames:testImageFields supportsDynamicSubMenus:testSupportsDynamicSubmenus];
    });

    it(@"should properly get/set the data", ^{
        expect(testStruct.supportedDynamicImageFieldNames).to(equal(testImageFields));
        expect(testStruct.supportsDynamicSubMenus).to(equal(testSupportsDynamicSubmenus));
    });
});

QuickSpecEnd
