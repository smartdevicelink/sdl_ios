//
//  SDLVideoStreamingRangeSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/21/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import <SmartDeviceLink/SmartDeviceLink.h>

QuickSpecBegin(SDLVideoStreamingRangeSpec)

describe(@"video streaming range", ^{
    __block SDLVideoStreamingRange *testRange = nil;
    SDLImageResolution *disabledResolution = [[SDLImageResolution alloc] initWithWidth:0 height:0];
    SDLImageResolution *minResolution = [[SDLImageResolution alloc] initWithWidth:10 height:50];
    SDLImageResolution *maxResolution = [[SDLImageResolution alloc] initWithWidth:100 height:500];
    const float minimumAspectRatio = 2.5;
    const float maximumAspectRatio = 7.1;
    const float minimumDiagonal = 3.3;

    float defaultMinimumAspectRatio = 1.0;
    float defaultMaximumAspectRatio = 9999.0;
    float defaultMinimumDiagonal = 0.0;

    describe(@"initialization", ^{
        context(@"init", ^{
            beforeEach(^{
                testRange = [SDLVideoStreamingRange disabled];
            });

            it(@"expect object to be created with empty fields", ^{
                expect(testRange).toNot(beNil());
                expect(testRange.minimumResolution).to(equal(disabledResolution));
                expect(testRange.maximumResolution).to(equal(disabledResolution));
                expect(testRange.minimumAspectRatio).to(equal(defaultMinimumAspectRatio));
                expect(testRange.maximumAspectRatio).to(equal(defaultMaximumAspectRatio));
                expect(testRange.minimumDiagonal).to(equal(defaultMinimumDiagonal));
            });

            it(@"expect object to be created and properties are set properly", ^{
                testRange.minimumResolution = minResolution;
                testRange.maximumResolution = maxResolution;
                testRange.minimumDiagonal = minimumDiagonal;
                testRange.minimumAspectRatio = minimumAspectRatio;
                testRange.maximumAspectRatio = maximumAspectRatio;

                expect(testRange).toNot(beNil());
                expect(testRange.minimumResolution).to(equal(minResolution));
                expect(testRange.maximumResolution).to(equal(maxResolution));
                expect(testRange.minimumAspectRatio).to(equal(minimumAspectRatio));
                expect(testRange.maximumAspectRatio).to(equal(maximumAspectRatio));
                expect(testRange.minimumDiagonal).to(equal(minimumDiagonal));
            });
        });

        context(@"initWithMinimumResolution:maximumResolution:", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:minResolution maximumResolution:maxResolution];
            });

            it(@"expect min and max resolution to be set and others are defaults", ^{
                expect(testRange).toNot(beNil());
                expect(testRange.minimumResolution).to(equal(minResolution));
                expect(testRange.maximumResolution).to(equal(maxResolution));
                expect(testRange.minimumAspectRatio).to(equal(defaultMinimumAspectRatio));
                expect(testRange.maximumAspectRatio).to(equal(defaultMaximumAspectRatio));
                expect(testRange.minimumDiagonal).to(equal(defaultMinimumDiagonal));
            });
        });

        context(@"initWithMinimumResolution:maximumResolution:minimumAspectRatio:maximumAspectRatio:minimumDiagonal:", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:minResolution maximumResolution:maxResolution minimumAspectRatio:minimumAspectRatio maximumAspectRatio:maximumAspectRatio minimumDiagonal:minimumDiagonal];
            });

            it(@"expect min and max resolution to be set and others are defaults", ^{
                expect(testRange).toNot(beNil());
                expect(testRange.minimumResolution).to(equal(minResolution));
                expect(testRange.maximumResolution).to(equal(maxResolution));
                expect(testRange.minimumAspectRatio).to(equal(minimumAspectRatio));
                expect(testRange.maximumAspectRatio).to(equal(maximumAspectRatio));
                expect(testRange.minimumDiagonal).to(equal(minimumDiagonal));
            });
        });
    });

    describe(@"setting float parameters", ^{
        beforeEach(^{
            testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:minResolution maximumResolution:maxResolution];;
        });

        describe(@"minimum aspect ratio", ^{
            context(@"below the minimum", ^{
                it(@"should be set to the minimum", ^{
                    testRange.minimumAspectRatio = -2.0;
                    expect(testRange.minimumAspectRatio).to(equal(defaultMinimumAspectRatio));
                });
            });

            context(@"above the minimum", ^{
                it(@"should set the value", ^{
                    testRange.minimumAspectRatio = minimumAspectRatio;
                    expect(testRange.minimumAspectRatio).to(equal(minimumAspectRatio));
                });
            });
        });

        describe(@"maximum aspect ratio", ^{
            context(@"below the minimum", ^{
                it(@"should be set to the minimum", ^{
                    testRange.maximumAspectRatio = -2.0;
                    expect(testRange.maximumAspectRatio).to(equal(defaultMinimumAspectRatio));
                });
            });

            context(@"above the minimum", ^{
                it(@"should set the value", ^{
                    testRange.maximumAspectRatio = maximumAspectRatio;
                    expect(testRange.maximumAspectRatio).to(equal(maximumAspectRatio));
                });
            });
        });

        describe(@"minimum diagonal", ^{
            context(@"below the minimum", ^{
                it(@"should be set to the minimum", ^{
                    testRange.minimumDiagonal = -2.0;
                    expect(testRange.minimumDiagonal).to(equal(defaultMinimumDiagonal));
                });
            });

            context(@"above the minimum", ^{
                it(@"should set the value", ^{
                    testRange.minimumDiagonal = minimumDiagonal;
                    expect(testRange.minimumDiagonal).to(equal(minimumDiagonal));
                });
            });
        });
    });

    describe(@"checking if the resolution is in a given range", ^{
        beforeEach(^{
            testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:minResolution maximumResolution:maxResolution];
        });

        context(@"when there is no minimum or maximum resolution", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:nil];
            });

            it(@"should return NO", ^{
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:2 height:2]]).to(beFalse());
            });
        });

        context(@"when there is no maximum resolution", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:minResolution maximumResolution:nil];
            });

            it(@"should return YES when above the minimum resolution", ^{
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:12 height:52]]).to(beTrue());
            });
        });

        context(@"when there is no minimum resolution", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:maxResolution];
            });

            it(@"should return YES", ^{
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:2 height:2]]).to(beTrue());
            });
        });

        context(@"when the resolution is below the range", ^{
            it(@"should return NO", ^{
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:0 height:0]]).to(beFalse());
            });
        });

        context(@"when the resolution is above the range", ^{
            it(@"should return NO", ^{
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:34463 height:34463]]).to(beFalse());
            });
        });

        context(@"when the resolution is in the range", ^{
            it(@"should return YES", ^{
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:12 height:52]]).to(beTrue());
            });
        });
    });

    describe(@"checking if the aspect ratio is in a given range", ^{
        beforeEach(^{
            testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:nil minimumAspectRatio:minimumAspectRatio maximumAspectRatio:maximumAspectRatio minimumDiagonal:1.0];
        });

        context(@"when there is no maximum aspect ratio", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:nil minimumAspectRatio:minimumAspectRatio maximumAspectRatio:0.0 minimumDiagonal:1.0];
            });

            it(@"should return NO", ^{
                expect([testRange isAspectRatioInRange:10.0]).to(beFalse());
            });
        });

        context(@"when there is no minimum aspect ratio", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:nil minimumAspectRatio:0.0 maximumAspectRatio:maximumAspectRatio minimumDiagonal:1.0];
            });

            it(@"should set the minimum to 1.0", ^{
                expect(testRange.minimumAspectRatio).to(equal(1.0));
            });
        });

        context(@"when the aspect ratio is below the range", ^{
            it(@"should return NO", ^{
                expect([testRange isAspectRatioInRange:2.0]).to(beFalse());
            });
        });

        context(@"when the aspect ratio is above the range", ^{
            it(@"should return NO", ^{
                expect([testRange isAspectRatioInRange:99.0]).to(beFalse());
            });
        });

        context(@"when the aspect ratio is in the range", ^{
            it(@"should return NO", ^{
                expect([testRange isAspectRatioInRange:6.0]).to(beTrue());
            });
        });
    });
});

QuickSpecEnd
