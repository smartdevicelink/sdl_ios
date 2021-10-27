#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLChoiceCell.h"
#import "SDLNextFunctionInfo.h"

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

QuickSpecBegin(SDLChoiceCellSpec)

describe(@"an SDLChoiceCell", ^{
    __block SDLChoiceCell *testCell = nil;

    __block NSString *testText = @"testText";
    __block NSString *testSecondaryText = @"testsecondary";
    __block NSString *testTertiaryText = @"testtertiary";
    __block NSString *testArtworkName = @"testArtworkName";
    __block NSString *testSecondaryArtworkName = @"testsecondaryartworkname";
    __block SDLArtwork *testArtwork = nil;
    __block SDLArtwork *testSecondaryArtwork = nil;
    __block NSArray<NSString *> *testVRCommands = nil;
    __block SDLNextFunctionInfo *nextFunctionInfo = nil;

    beforeEach(^{
        testArtwork = [[SDLArtwork alloc] initWithData:[@"testart" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];
        testSecondaryArtwork = [[SDLArtwork alloc] initWithData:[@"testsecondary art" dataUsingEncoding:NSUTF8StringEncoding] name:testSecondaryArtworkName fileExtension:@"jpg" persistent:NO];
        testVRCommands = @[@"testvr"];

        testCell = nil;
        nextFunctionInfo = [[SDLNextFunctionInfo alloc] initWithNextFunction:SDLNextFunctionDialNumber loadingText:@"hello world"];
    });

    describe(@"initializing", ^{
        it(@"should initialize properly with initWithText:", ^{
            testCell = [[SDLChoiceCell alloc] initWithText:testText];

            expect(testCell.text).to(equal(testText));
            expect(testCell.secondaryText).to(beNil());
            expect(testCell.tertiaryText).to(beNil());
            expect(testCell.voiceCommands).to(beNil());
            expect(testCell.artwork).to(beNil());
            expect(testCell.secondaryArtwork).to(beNil());
            expect(@(testCell.choiceId)).to(equal(@(UINT16_MAX)));
            expect(testCell.uniqueText).to(equal(testText));
            expect(testCell.nextFunctionInfo).to(beNil());
        });

        it(@"should initialize properly with initWithText:artwork:voiceCommands:", ^{
            testCell = [[SDLChoiceCell alloc] initWithText:testText artwork:testArtwork voiceCommands:testVRCommands];

            expect(testCell.text).to(equal(testText));
            expect(testCell.secondaryText).to(beNil());
            expect(testCell.tertiaryText).to(beNil());
            expect(testCell.voiceCommands).to(equal(testVRCommands));
            expect(testCell.artwork).to(equal(testArtwork));
            expect(testCell.secondaryArtwork).to(beNil());
            expect(@(testCell.choiceId)).to(equal(@(UINT16_MAX)));
            expect(testCell.uniqueText).to(equal(testText));
            expect(testCell.nextFunctionInfo).to(beNil());
        });

        it(@"should initialize properly with initWithText:secondaryText:tertiaryText:voiceCommands:artwork:secondaryArtwork:", ^{
            testCell = [[SDLChoiceCell alloc] initWithText:testText secondaryText:testSecondaryText tertiaryText:testTertiaryText voiceCommands:testVRCommands artwork:testArtwork secondaryArtwork:testSecondaryArtwork];

            expect(testCell.text).to(equal(testText));
            expect(testCell.secondaryText).to(equal(testSecondaryText));
            expect(testCell.tertiaryText).to(equal(testTertiaryText));
            expect(testCell.voiceCommands).to(equal(testVRCommands));
            expect(testCell.artwork).to(equal(testArtwork));
            expect(testCell.secondaryArtwork).to(equal(testSecondaryArtwork));
            expect(@(testCell.choiceId)).to(equal(@(UINT16_MAX)));
            expect(testCell.uniqueText).to(equal(testText));
            expect(testCell.nextFunctionInfo).to(beNil());
        });

        it(@"should initialize properly with initWithText:secondaryText:tertiaryText:voiceCommands:artwork:secondaryArtwork:", ^{
            testCell = [[SDLChoiceCell alloc] initWithText:testText secondaryText:testSecondaryText tertiaryText:testTertiaryText voiceCommands:testVRCommands artwork:testArtwork secondaryArtwork:testSecondaryArtwork nextFunctionInfo:nextFunctionInfo];

            expect(testCell.text).to(equal(testText));
            expect(testCell.secondaryText).to(equal(testSecondaryText));
            expect(testCell.tertiaryText).to(equal(testTertiaryText));
            expect(testCell.voiceCommands).to(equal(testVRCommands));
            expect(testCell.artwork).to(equal(testArtwork));
            expect(testCell.secondaryArtwork).to(equal(testSecondaryArtwork));
            expect(@(testCell.choiceId)).to(equal(@(UINT16_MAX)));
            expect(testCell.uniqueText).to(equal(testText));
            expect(testCell.nextFunctionInfo).to(equal(nextFunctionInfo));
        });
    });

    describe(@"equality tests", ^{
        __block SDLChoiceCell *secondTestCell = nil;
        __block SDLChoiceCell *matchingFirstCell = nil;
        beforeEach(^{
            testCell = [[SDLChoiceCell alloc] initWithText:testText secondaryText:testSecondaryText tertiaryText:testTertiaryText voiceCommands:testVRCommands artwork:testArtwork secondaryArtwork:testSecondaryArtwork];
            secondTestCell = [[SDLChoiceCell alloc] initWithText:testSecondaryText secondaryText:testText tertiaryText:testTertiaryText voiceCommands:testVRCommands artwork:testArtwork secondaryArtwork:testSecondaryArtwork];
            matchingFirstCell = [[SDLChoiceCell alloc] initWithText:testText secondaryText:testSecondaryText tertiaryText:testTertiaryText voiceCommands:testVRCommands artwork:testArtwork secondaryArtwork:testSecondaryArtwork];
        });

        it(@"should match cells with the same data", ^{
            expect([testCell isEqual:matchingFirstCell]).to(beTrue());
        });

        it(@"should not match cells with data in different places", ^{
            expect([testCell isEqual:secondTestCell]).to(beFalse());
        });
    });
});

QuickSpecEnd
