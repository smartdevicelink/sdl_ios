#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLSoftButtonState.h"

QuickSpecBegin(SDLSoftButtonState)

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
        expect(testState.ephemeralArtwork).to(beFalsy());

        expect(testState.artwork.persistent).to(beTruthy());
        expect(testState.artwork.fileType).to(equal(SDLFileTypePNG));
        // The rest should be tested in SDLArtwork
    });
});

QuickSpecEnd
