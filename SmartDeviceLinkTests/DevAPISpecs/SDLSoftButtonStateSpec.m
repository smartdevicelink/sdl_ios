#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLImage.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonState.h"

QuickSpecBegin(SDLSoftButtonStateSpec)

describe(@"soft button state", ^{
    __block SDLSoftButtonState *testState = nil;

    __block NSString *testStateName = @"Test State Name";
    __block NSString *testStateText = @"Test State Text";

    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    __block UIImage *testStateImage = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];

    it(@"should properly create with an image with defaults", ^{
        testState = [[SDLSoftButtonState alloc] initWithStateName:testStateName text:testStateText image:testStateImage];

        expect(testState.name).to(equal(testStateName));
        expect(testState.text).to(equal(testStateText));
        expect(testState.highlighted).to(beFalsy());
        expect(testState.systemAction).to(equal(SDLSystemActionDefaultAction));
        expect(testState.artwork.persistent).to(beTruthy());
        expect(testState.artwork.fileType).to(equal(SDLFileTypePNG));
        // The rest should be tested in SDLArtwork
    });

    context(@"when created with an artwork", ^{
        __block SDLArtwork *testArtwork = nil;
        __block NSString *testArtworkName = @"Test Artwork Name";
        beforeEach(^{
            testArtwork = [[SDLArtwork alloc] initWithImage:testStateImage name:testArtworkName persistent:YES asImageFormat:SDLArtworkImageFormatPNG];

            testState = [[SDLSoftButtonState alloc] initWithStateName:testStateName text:testStateText artwork:testArtwork];
        });

        it(@"should properly create", ^{
            expect(testState.name).to(equal(testStateName));
            expect(testState.text).to(equal(testStateText));
            expect(testState.highlighted).to(beFalsy());
            expect(testState.systemAction).to(equal(SDLSystemActionDefaultAction));
            expect(testState.artwork.persistent).to(beTruthy());
            expect(testState.artwork.fileType).to(equal(SDLFileTypePNG));
        });

        it(@"should properly create a soft button", ^{
            SDLSoftButton *testSoftButton = testState.softButton;

            expect(testSoftButton.type).to(equal(SDLSoftButtonTypeBoth));
            expect((id)testSoftButton.handler).to(beNil());
            expect(testSoftButton.softButtonID).to(equal(0));
            expect(testSoftButton.isHighlighted).to(beFalsy());
            expect(testSoftButton.systemAction).to(equal(SDLSystemActionDefaultAction));
            expect(testSoftButton.text).to(equal(testStateText));
            expect(testSoftButton.image.imageType).to(equal(SDLImageTypeDynamic));
            expect(testSoftButton.image.value).to(equal(testArtworkName));
        });
    });

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    context(@"when created invalid", ^{
        it(@"should assert", ^{
            expectAction(^{
                [[SDLSoftButtonState alloc] initWithStateName:testStateName text:nil image:nil];
            }).to(raiseException());
        });
    });
#pragma clang diagnostic pop
});

QuickSpecEnd
