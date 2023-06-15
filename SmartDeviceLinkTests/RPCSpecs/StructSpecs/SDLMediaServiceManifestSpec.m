//
//  SDLMediaServiceManifestSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/11/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLMediaServiceManifest.h"

QuickSpecBegin(SDLMediaServiceManifestSpec)

describe(@"Getter/Setter Tests", ^{
    it(@"Should set and get correctly", ^{
        SDLMediaServiceManifest *testStruct = [[SDLMediaServiceManifest alloc] init];

        // no parameters to test
        expect(testStruct).toNot(beNil());
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{};
        SDLMediaServiceManifest *testStruct = [[SDLMediaServiceManifest alloc] initWithDictionary:dict];

        // no parameters to test
        expect(testStruct).toNot(beNil());
    });
});

QuickSpecEnd
