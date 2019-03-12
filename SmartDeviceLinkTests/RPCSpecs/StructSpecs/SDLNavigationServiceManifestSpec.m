//
//  SDLNavigationServiceManifestSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLNavigationServiceManifest.h"

QuickSpecBegin(SDLNavigationServiceManifestSpec)

describe(@"Getter/Setter Tests", ^{
    __block BOOL testAcceptsWayPoints = nil;

    beforeEach(^{
        testAcceptsWayPoints = false;
    });

    it(@"Should set and get correctly", ^{
        SDLNavigationServiceManifest *testStruct = [[SDLNavigationServiceManifest alloc] init];
        testStruct.acceptsWayPoints = @(testAcceptsWayPoints);

        expect(testStruct.acceptsWayPoints).to(equal(testAcceptsWayPoints));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameAcceptsWayPoints:@(testAcceptsWayPoints)};
        SDLNavigationServiceManifest *testStruct = [[SDLNavigationServiceManifest alloc] initWithDictionary:dict];

        expect(testStruct.acceptsWayPoints).to(equal(testAcceptsWayPoints));
    });

    it(@"Should initialize correctly with a convenience init", ^{
        SDLNavigationServiceManifest *testStruct = [[SDLNavigationServiceManifest alloc] initWithAcceptsWayPoints:testAcceptsWayPoints];

        expect(testStruct.acceptsWayPoints).to(equal(testAcceptsWayPoints));
    });

    it(@"Should return nil if not set", ^{
        SDLNavigationServiceManifest *testStruct = [[SDLNavigationServiceManifest alloc] init];

        expect(testStruct.acceptsWayPoints).to(beNil());
    });
});

QuickSpecEnd
