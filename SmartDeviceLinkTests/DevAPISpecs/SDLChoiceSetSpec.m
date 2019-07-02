#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLChoiceSet.h"

#import "SDLChoiceCell.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"

QuickSpecBegin(SDLChoiceSetSpec)

describe(@"an SDLChoiceSet", ^{
    __block SDLChoiceSet *testChoiceSet = nil;
    __block NSString *testTitle = @"title";
    __block SDLChoiceCell *testCell = nil;
    __block id<SDLChoiceSetDelegate> testDelegate = nil;
    __block SDLChoiceSetLayout testLayout = SDLChoiceSetLayoutList;
    __block NSTimeInterval testTimeout = 28;
    __block NSString *testInitialPrompt = @"initial prompt";
    __block NSString *testHelpPrompt = @"help prompt";
    __block NSString *testTimeoutPrompt = @"timeout prompt";
    __block SDLVRHelpItem *testHelpItem = nil;

    beforeEach(^{
        testCell = [[SDLChoiceCell alloc] initWithText:@"cell text"];
        testDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
        testHelpItem = [[SDLVRHelpItem alloc] initWithText:@"help item" image:nil];

        testChoiceSet = nil;
    });

    describe(@"initializing", ^{
        it(@"should initialize default properties correctly", ^{
            expect(@(SDLChoiceSet.defaultLayout)).to(equal(@(SDLChoiceSetLayoutList)));
            expect(SDLChoiceSet.defaultTimeout).to(equal(10));
        });

        it(@"should set default properties correctly", ^{
            SDLChoiceSet.defaultLayout = SDLChoiceSetLayoutTiles;
            SDLChoiceSet.defaultTimeout = 6;

            expect(@(SDLChoiceSet.defaultLayout)).to(equal(@(SDLChoiceSetLayoutTiles)));
            expect(SDLChoiceSet.defaultTimeout).to(equal(6));
        });

        it(@"should initialize correctly with initWithTitle:delegate:choices:", ^{
            testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:@[testCell]];

            expect(testChoiceSet.title).to(equal(testTitle));
            expect(testChoiceSet.initialPrompt).to(beNil());
            expect(@(testChoiceSet.layout)).to(equal(@(SDLChoiceSet.defaultLayout)));
            expect(testChoiceSet.timeout).to(equal(SDLChoiceSet.defaultTimeout));
            expect(testChoiceSet.timeoutPrompt).to(beNil());
            expect(testChoiceSet.helpPrompt).to(beNil());
            expect(testChoiceSet.helpList).to(beNil());
            expect(testChoiceSet.delegate).to(equal(testDelegate));
            expect(testChoiceSet.choices).to(equal(@[testCell]));
        });

        it(@"should initialize correctly with initWithTitle:delegate:layout:timeout:initialPromptString:timeoutPromptString:helpPromptString:vrHelpList:choices:", ^{
            testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate layout:testLayout timeout:testTimeout initialPromptString:testInitialPrompt timeoutPromptString:testTimeoutPrompt helpPromptString:testHelpPrompt vrHelpList:@[testHelpItem] choices:@[testCell]];

            expect(testChoiceSet.title).to(equal(testTitle));
            expect(testChoiceSet.initialPrompt).to(equal([SDLTTSChunk textChunksFromString:testInitialPrompt]));
            expect(@(testChoiceSet.layout)).to(equal(@(testLayout)));
            expect(testChoiceSet.timeout).to(equal(testTimeout));
            expect(testChoiceSet.timeoutPrompt).to(equal([SDLTTSChunk textChunksFromString:testTimeoutPrompt]));
            expect(testChoiceSet.helpPrompt).to(equal([SDLTTSChunk textChunksFromString:testHelpPrompt]));
            expect(testChoiceSet.helpList).to(equal(@[testHelpItem]));
            expect(testChoiceSet.helpList.firstObject.position).to(equal(1));
            expect(testChoiceSet.delegate).to(equal(testDelegate));
            expect(testChoiceSet.choices).to(equal(@[testCell]));
        });

        it(@"should initialize correctly with initWithTitle:delegate:layout:timeout:initialPrompt:timeoutPrompt:helpPrompt:vrHelpList:choices:", ^{
            testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate layout:testLayout timeout:testTimeout initialPrompt:[SDLTTSChunk textChunksFromString:testInitialPrompt] timeoutPrompt:[SDLTTSChunk textChunksFromString:testTimeoutPrompt] helpPrompt:[SDLTTSChunk textChunksFromString:testHelpPrompt] vrHelpList:@[testHelpItem] choices:@[testCell]];

            expect(testChoiceSet.title).to(equal(testTitle));
            expect(testChoiceSet.initialPrompt).to(equal([SDLTTSChunk textChunksFromString:testInitialPrompt]));
            expect(@(testChoiceSet.layout)).to(equal(@(testLayout)));
            expect(testChoiceSet.timeout).to(equal(testTimeout));
            expect(testChoiceSet.timeoutPrompt).to(equal([SDLTTSChunk textChunksFromString:testTimeoutPrompt]));
            expect(testChoiceSet.helpPrompt).to(equal([SDLTTSChunk textChunksFromString:testHelpPrompt]));
            expect(testChoiceSet.helpList).to(equal(@[testHelpItem]));
            expect(testChoiceSet.delegate).to(equal(testDelegate));
            expect(testChoiceSet.choices).to(equal(@[testCell]));
        });

        context(@"with bad data", ^{
            it(@"should return nil with too few or too many choices", ^{
                // Choices must be between 1 and 100
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:@[]];
                expect(testChoiceSet).to(beNil());

                NSMutableArray<SDLChoiceCell *> *choices = [NSMutableArray array];
                for (int i = 0; i < 101; i++) {
                    [choices addObject:[[SDLChoiceCell alloc] initWithText:@"hi"]];
                }
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:choices];
                expect(testChoiceSet).to(beNil());
            });

            it(@"should return nil with too short or too long timeout", ^{
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate layout:testLayout timeout:4.9 initialPromptString:nil timeoutPromptString:nil helpPromptString:nil vrHelpList:nil choices:@[testCell]];
                expect(testChoiceSet).to(beNil());

                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate layout:testLayout timeout:100.1 initialPromptString:nil timeoutPromptString:nil helpPromptString:nil vrHelpList:nil choices:@[testCell]];
                expect(testChoiceSet).to(beNil());
            });

            it(@"should return nil with too short or too long title", ^{
                // Title strings must be between 1 and 500 length
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:@"" delegate:testDelegate choices:@[]];
                expect(testChoiceSet).to(beNil());

                NSMutableString *testString = [NSMutableString string];
                for (int i = 0; i < 51; i++) {
                    [testString appendString:@"abcdefghij"];
                }

                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:[testString copy] delegate:testDelegate choices:@[]];
                expect(testChoiceSet).to(beNil());
            });

            it(@"should return nil with equivalent cell text", ^{
                // Cell `text` cannot be equal
                SDLChoiceCell *equalCell = [[SDLChoiceCell alloc] initWithText:@"Text"];
                SDLChoiceCell *equalCell2 = [[SDLChoiceCell alloc] initWithText:@"Text"];
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:@[equalCell, equalCell2]];
                expect(testChoiceSet).to(beNil());
            });

            context(@"With bad VR data", ^{
                it(@"should return nil if not all choice set items have voice commands", ^{
                    // Cell `voiceCommands` cannot be equal
                    SDLChoiceCell *equalCellVR = [[SDLChoiceCell alloc] initWithText:@"Text" artwork:nil voiceCommands:@[@"vr"]];
                    SDLChoiceCell *equalCellVR2 = [[SDLChoiceCell alloc] initWithText:@"Text2" artwork:nil voiceCommands:nil];
                    testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:@[equalCellVR, equalCellVR2]];
                    expect(testChoiceSet).to(beNil());
                });

                it(@"should return nil if there are duplicate voice command strings in the choice set", ^{
                    // Cell `voiceCommands` cannot be equal
                    SDLChoiceCell *equalCellVR = [[SDLChoiceCell alloc] initWithText:@"Text" artwork:nil voiceCommands:@[@"Dog"]];
                    SDLChoiceCell *equalCellVR2 = [[SDLChoiceCell alloc] initWithText:@"Text2" artwork:nil voiceCommands:@[@"Parrot", @"Dog"]];
                    testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:@[equalCellVR, equalCellVR2]];
                    expect(testChoiceSet).to(beNil());
                });
            });
        });
    });

    describe(@"setting data", ^{
        beforeEach(^{
            testChoiceSet = [[SDLChoiceSet alloc] init];
        });

        it(@"should properly set help list position", ^{
            testChoiceSet.helpList = @[testHelpItem];

            expect(testHelpItem.position).to(equal(1));
        });
    });
});

QuickSpecEnd
