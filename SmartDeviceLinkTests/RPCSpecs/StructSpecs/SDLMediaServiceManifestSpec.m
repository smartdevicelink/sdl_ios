//
//  SDLMediaServiceManifestSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/11/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLMediaServiceManifest *testStruct = [[SDLMediaServiceManifest alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        // no parameters to test
        expect(testStruct).toNot(beNil());
    });
});

QuickSpecEnd
