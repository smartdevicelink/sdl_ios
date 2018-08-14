//
//  SDLFileManagerConfigurationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 8/1/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileManagerConfiguration.h"

QuickSpecBegin(SDLFileManagerConfigurationSpec)

describe(@"A file manager configuration", ^{
    __block SDLFileManagerConfiguration *testConfig = nil;

    it(@"should get and set correctly", ^{
        testConfig = [[SDLFileManagerConfiguration alloc] init];
        testConfig.artworkRetryCount = 5;
        testConfig.fileRetryCount = 1;

        expect(testConfig.artworkRetryCount).to(equal(5));
        expect(testConfig.fileRetryCount).to(equal(1));
    });

    it(@"should be set to default configuration if parameters are not set", ^{
        testConfig = [[SDLFileManagerConfiguration alloc] init];

        expect(testConfig.artworkRetryCount).to(equal(1));
        expect(testConfig.fileRetryCount).to(equal(1));
    });

    it(@"should instantiate correctly with the default configuration", ^{
        testConfig = [SDLFileManagerConfiguration defaultConfiguration];

        expect(testConfig.artworkRetryCount).to(equal(1));
        expect(testConfig.fileRetryCount).to(equal(1));
    });

    it(@"should instantiate correctly with initWithArtworkRetryCount:fileRetryCount:", ^{
        testConfig = [[SDLFileManagerConfiguration alloc] initWithArtworkRetryCount:2 fileRetryCount:3];

        expect(testConfig.artworkRetryCount).to(equal(2));
        expect(testConfig.fileRetryCount).to(equal(3));
    });
});

QuickSpecEnd
