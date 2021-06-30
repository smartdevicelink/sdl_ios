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
    SDLImageResolution *lowResolution = [[SDLImageResolution alloc] initWithWidth:1 height:1];
    SDLImageResolution *highResolution = [[SDLImageResolution alloc] initWithWidth:999 height:999];

    float defaultMinimumAspectRatio = 1.0;
    float defaultMaximumAspectRatio = 9999.0;
    float defaultMinimumDiagonal = 0.0;

    float testMinimumAspectRatio = 4.0;
    float testMaximumAspectRatio = 12.0;
    float testMinimumDiagonal = 6.0;

    beforeEach(^{
        testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:lowResolution maximumResolution:highResolution];;
    });

    context(@"initialized with initWithMinimumResolution:maximumResolution", ^{
        it(@"should set all parameters correctly", ^{
            expect(testRange.minimumResolution).to(equal(lowResolution));
            expect(testRange.maximumResolution).to(equal(highResolution));
            expect(testRange.minimumAspectRatio).to(equal(1.0));
            expect(testRange.maximumAspectRatio).to(equal(9999.0));
            expect(testRange.minimumDiagonal).to(equal(0.0));
        });
    });

    context(@"initialized with initWithMinimumResolution:maximumResolution:minimumAspectRatio:maximumAspectRatio:minimumDiagonal:", ^{
        beforeEach(^{
            testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:lowResolution maximumResolution:highResolution minimumAspectRatio:testMinimumAspectRatio maximumAspectRatio:testMaximumAspectRatio minimumDiagonal:testMinimumDiagonal];
        });

        it(@"should set all parameters correctly", ^{
            expect(testRange.minimumResolution).to(equal(lowResolution));
            expect(testRange.maximumResolution).to(equal(highResolution));
            expect(testRange.minimumAspectRatio).to(equal(testMinimumAspectRatio));
            expect(testRange.maximumAspectRatio).to(equal(testMaximumAspectRatio));
            expect(testRange.minimumDiagonal).to(equal(testMinimumDiagonal));
        });
    });

    context(@"initialized with disabled", ^{
        beforeEach(^{
            testRange = [SDLVideoStreamingRange disabled];
        });

        it(@"should set all parameters correctly", ^{
            expect(testRange.minimumResolution).to(equal(disabledResolution));
            expect(testRange.maximumResolution).to(equal(disabledResolution));
            expect(testRange.minimumAspectRatio).to(equal(defaultMinimumAspectRatio));
            expect(testRange.maximumAspectRatio).to(equal(defaultMaximumAspectRatio));
            expect(testRange.minimumDiagonal).to(equal(defaultMinimumDiagonal));
        });
    });

    describe(@"setting float parameters", ^{
        describe(@"minimum aspect ratio", ^{
            context(@"below the minimum", ^{
                it(@"should be set to the minimum", ^{
                    testRange.minimumAspectRatio = -2.0;
                    expect(testRange.minimumAspectRatio).to(equal(defaultMinimumAspectRatio));
                });
            });

            context(@"above the minimum", ^{
                it(@"should set the value", ^{
                    testRange.minimumAspectRatio = testMinimumAspectRatio;
                    expect(testRange.minimumAspectRatio).to(equal(testMinimumAspectRatio));
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
                    testRange.maximumAspectRatio = testMaximumAspectRatio;
                    expect(testRange.maximumAspectRatio).to(equal(testMaximumAspectRatio));
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
                    testRange.minimumDiagonal = testMinimumDiagonal;
                    expect(testRange.minimumDiagonal).to(equal(testMinimumDiagonal));
                });
            });
        });
    });

    describe(@"checking if the resolution is in a given range", ^{
        beforeEach(^{
            testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:lowResolution maximumResolution:highResolution];
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
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:lowResolution maximumResolution:nil];
            });

            it(@"should return YES", ^{
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:2 height:2]]).to(beTrue());
            });
        });

        context(@"when there is no minimum resolution", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:highResolution];
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
                expect([testRange isImageResolutionInRange:[[SDLImageResolution alloc] initWithWidth:2 height:2]]).to(beTrue());
            });
        });
    });

    describe(@"checking if the aspect ratio is in a given range", ^{
        beforeEach(^{
            testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:nil minimumAspectRatio:testMinimumAspectRatio maximumAspectRatio:testMaximumAspectRatio minimumDiagonal:1.0];
        });

        context(@"when there is no maximum aspect ratio", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:nil minimumAspectRatio:testMinimumAspectRatio maximumAspectRatio:0.0 minimumDiagonal:1.0];
            });

            it(@"should return NO", ^{
                expect([testRange isAspectRatioInRange:10.0]).to(beTrue());
            });
        });

        context(@"when there is no minimum aspect ratio", ^{
            beforeEach(^{
                testRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:nil maximumResolution:nil minimumAspectRatio:0.0 maximumAspectRatio:testMaximumAspectRatio minimumDiagonal:1.0];
            });

            it(@"should return NO", ^{
                expect([testRange isAspectRatioInRange:10.0]).to(beTrue());
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
                expect([testRange isAspectRatioInRange:10.0]).to(beTrue());
            });
        });
    });
});

QuickSpecEnd
