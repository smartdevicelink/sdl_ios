//
//  SDLSupportedStreamingRangeSpec.m
//  SmartDeviceLinkTests
//
//  Created by Leonid Lokhmatov on 25.12.2020.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVideoStreamingRange.h"
#import "SDLImageResolution.h"

QuickSpecBegin(SDLSupportedStreamingRangeSpec)

SDLImageResolution *minResolution = [[SDLImageResolution alloc] initWithWidth:10 height:50];
SDLImageResolution *maxResolution = [[SDLImageResolution alloc] initWithWidth:100 height:500];
const float minimumAspectRatio = 2.5;
const float maximumAspectRatio = 7.1;
const float minimumDiagonal = 3.3;

describe(@"initialization", ^{
    context(@"init", ^{
        SDLVideoStreamingRange *streamingRange = [[SDLVideoStreamingRange alloc] init];

        it(@"expect object to be created with empty fields", ^{
            expect(streamingRange).toNot(beNil());
            expect(streamingRange.minimumResolution).to(beNil());
            expect(streamingRange.maximumResolution).to(beNil());
            expect(streamingRange.minimumAspectRatio).to(equal(0));
            expect(streamingRange.maximumAspectRatio).to(equal(0));
            expect(streamingRange.minimumDiagonal).to(equal(0));
        });
    });

    context(@"init and assign", ^{
        SDLVideoStreamingRange *streamingRange = [[SDLVideoStreamingRange alloc] init];
        streamingRange.minimumResolution = minResolution;
        streamingRange.maximumResolution = maxResolution;
        streamingRange.minimumDiagonal = minimumDiagonal;
        streamingRange.minimumAspectRatio = minimumAspectRatio;
        streamingRange.maximumAspectRatio = maximumAspectRatio;

        it(@"expect object to be created and properties are set properly", ^{
            expect(streamingRange).toNot(beNil());
            expect(streamingRange.minimumResolution).to(equal(minResolution));
            expect(streamingRange.maximumResolution).to(equal(maxResolution));
            expect(streamingRange.minimumAspectRatio).to(equal(minimumAspectRatio));
            expect(streamingRange.maximumAspectRatio).to(equal(maximumAspectRatio));
            expect(streamingRange.minimumDiagonal).to(equal(minimumDiagonal));
        });
    });

    context(@"initWithMinimumResolution:maximumResolution:", ^{
        SDLVideoStreamingRange *streamingRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:minResolution maximumResolution:maxResolution];
        it(@"expect min and max resolution to be set and others are not", ^{
            expect(streamingRange).toNot(beNil());
            expect(streamingRange.minimumResolution).to(equal(minResolution));
            expect(streamingRange.maximumResolution).to(equal(maxResolution));
            expect(streamingRange.minimumAspectRatio).to(equal(0));
            expect(streamingRange.maximumAspectRatio).to(equal(0));
            expect(streamingRange.minimumDiagonal).to(equal(0));
        });
    });
});

describe(@"methods", ^{
    context(@"isAspectRatioInRange:", ^{
        SDLVideoStreamingRange *streamingRange = [[SDLVideoStreamingRange alloc] init];

        beforeEach(^{
            streamingRange.minimumAspectRatio = minimumAspectRatio;
            streamingRange.maximumAspectRatio = maximumAspectRatio;
        });

        it(@"expect to be within range", ^{
            expect(streamingRange).toNot(beNil());
            const float midAR = (minimumAspectRatio + maximumAspectRatio) / 2.0;
            expect([streamingRange isAspectRatioInRange:minimumAspectRatio]).to(beTrue());
            expect([streamingRange isAspectRatioInRange:maximumAspectRatio]).to(beTrue());
            expect([streamingRange isAspectRatioInRange:midAR]).to(beTrue());
        });

        it(@"expect to be out of range", ^{
            expect(streamingRange).toNot(beNil());
            expect([streamingRange isAspectRatioInRange:minimumAspectRatio - 1]).to(beFalse());
            expect([streamingRange isAspectRatioInRange:maximumAspectRatio + 1]).to(beFalse());
        });
    });

    context(@"isImageResolutionInRange:", ^{
        SDLVideoStreamingRange *streamingRange = [[SDLVideoStreamingRange alloc] initWithMinimumResolution:minResolution maximumResolution:maxResolution];
        const int width = (minResolution.resolutionWidth.intValue + maxResolution.resolutionWidth.intValue) >> 1;
        const int height = (minResolution.resolutionHeight.intValue + maxResolution.resolutionHeight.intValue) >> 1;
        SDLImageResolution *midResolution = [[SDLImageResolution alloc] initWithWidth:(uint16_t)width height:(uint16_t)height];
        SDLImageResolution *belowResolution = [minResolution copy];
        belowResolution.resolutionWidth = @(belowResolution.resolutionWidth.intValue - 1);
        SDLImageResolution *aboveResolution = [maxResolution copy];
        aboveResolution.resolutionWidth = @(aboveResolution.resolutionWidth.intValue + 1);

        it(@"expect to be within range", ^{
            expect(streamingRange).toNot(beNil());

            expect([streamingRange isImageResolutionInRange:midResolution]).to(beTrue());
            expect([streamingRange isImageResolutionInRange:minResolution]).to(beTrue());
            expect([streamingRange isImageResolutionInRange:maxResolution]).to(beTrue());
        });

        it(@"expect to be out of range", ^{
            expect(streamingRange).toNot(beNil());
            expect([streamingRange isImageResolutionInRange:belowResolution]).to(beFalse());
            expect([streamingRange isImageResolutionInRange:aboveResolution]).to(beFalse());
        });
    });
});


QuickSpecEnd
