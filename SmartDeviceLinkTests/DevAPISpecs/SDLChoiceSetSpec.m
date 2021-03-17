#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLChoiceSet.h"

#import "SDLChoiceCell.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"
#import "SDLArtwork.h"

@interface SDLChoiceSet()

@property (nullable, copy, nonatomic) SDLChoiceSetCanceledHandler canceledHandler;

@end

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

        it(@"should get and set correctly", ^{
            NSArray<SDLTTSChunk *> *testTTSInitialPrompt = [SDLTTSChunk textChunksFromString:testInitialPrompt];
            NSArray<SDLTTSChunk *> *testTTSTimeoutPrompt = [SDLTTSChunk textChunksFromString:testTimeoutPrompt];
            NSArray<SDLTTSChunk *> *testTTSHelpPrompt = [SDLTTSChunk textChunksFromString:testHelpPrompt];

            testChoiceSet = [[SDLChoiceSet alloc] init];
            testChoiceSet.title = testTitle;
            testChoiceSet.initialPrompt = testTTSInitialPrompt;
            testChoiceSet.layout = testLayout;
            testChoiceSet.timeout = testTimeout;
            testChoiceSet.timeoutPrompt = testTTSTimeoutPrompt;
            testChoiceSet.helpPrompt = testTTSHelpPrompt;
            testChoiceSet.helpList = @[testHelpItem];
            testChoiceSet.delegate = testDelegate;
            testChoiceSet.choices = @[testCell];

            expect(testChoiceSet.title).to(equal(testTitle));
            expect(testChoiceSet.initialPrompt).to(equal(testTTSInitialPrompt));
            expect(@(testChoiceSet.layout)).to(equal(testLayout));
            expect(testChoiceSet.timeout).to(equal(testTimeout));
            expect(testChoiceSet.timeoutPrompt).to(equal(testTTSTimeoutPrompt));
            expect(testChoiceSet.helpPrompt).to(equal(testTTSHelpPrompt));
            expect(testChoiceSet.helpList).to(equal(@[testHelpItem]));
            expect(testChoiceSet.delegate).to(equal(testDelegate));
            expect(testChoiceSet.choices).to(equal(@[testCell]));
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

            it(@"should cap the timeout when too long or too short", ^{
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate layout:testLayout timeout:4.9 initialPromptString:nil timeoutPromptString:nil helpPromptString:nil vrHelpList:nil choices:@[testCell]];
                expect(testChoiceSet).toNot(beNil());
                expect(testChoiceSet.timeout).to(beCloseTo(5.0));

                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate layout:testLayout timeout:100.1 initialPromptString:nil timeoutPromptString:nil helpPromptString:nil vrHelpList:nil choices:@[testCell]];
                expect(testChoiceSet).toNot(beNil());
                expect(testChoiceSet.timeout).to(beCloseTo(100.0));
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

            it(@"should return nil when 2 or more cells are identical", ^{
                // Cells cannot be identical
                SDLArtwork *testArtwork = [[SDLArtwork alloc] initWithStaticIcon:SDLStaticIconNameKey];
                SDLChoiceCell *equalCell = [[SDLChoiceCell alloc] initWithText:@"Text" secondaryText:@"Text 2" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:testArtwork];
                SDLChoiceCell *equalCell2 = [[SDLChoiceCell alloc] initWithText:@"Text" secondaryText:@"Text 2" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:testArtwork];
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:@[equalCell, equalCell2]];
                expect(testChoiceSet).to(beNil());
            });

            it(@"should return nil when 2 or more cells voice commands are identical", ^{
                // Cell `text` cannot be equal
                SDLChoiceCell *equalCell = [[SDLChoiceCell alloc] initWithText:@"Text" artwork:nil voiceCommands:@[@"Kit", @"Kat"]];
                SDLChoiceCell *equalCell2 = [[SDLChoiceCell alloc] initWithText:@"Text 2" artwork:nil voiceCommands:@[@"Kat"]];
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:testDelegate choices:@[equalCell, equalCell2]];
                expect(testChoiceSet).to(beNil());
            });

            context(@"With bad VR data", ^{
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

    describe(@"setting the default timeout", ^{
        __block SDLChoiceSet *testChoiceSet = nil;

        beforeEach(^{
            testChoiceSet = [[SDLChoiceSet alloc] init];
        });

        it(@"should return the default timeout if the timeout value was not set", ^{
            int testDefaultTimeout = 6.0;
            SDLChoiceSet.defaultTimeout = testDefaultTimeout;

            expect(SDLChoiceSet.defaultTimeout).to(equal(testDefaultTimeout));
            expect(testChoiceSet.timeout).to(equal(testDefaultTimeout));
        });

        it(@"should return the timeout value even if the default timeout was set", ^{
            int testTimeout = 7.0;
            int testDefaultTimeout = 9.0;
            SDLChoiceSet.defaultTimeout = testDefaultTimeout;
            testChoiceSet.timeout = testTimeout;

            expect(SDLChoiceSet.defaultTimeout).to(equal(testDefaultTimeout));
            expect(testChoiceSet.timeout).to(equal(testTimeout));
        });

        it(@"should return 100 if a value greater than 100 has been set", ^{
            SDLChoiceSet.defaultTimeout = 155.0;

            expect(SDLChoiceSet.defaultTimeout).to(equal(100.0));
            expect(testChoiceSet.timeout).to(equal(100.0));
        });

        it(@"should return 5 if a value less than 5 has been set", ^{
            SDLChoiceSet.defaultTimeout = -3.0;

            expect(SDLChoiceSet.defaultTimeout).to(equal(5.0));
            expect(testChoiceSet.timeout).to(equal(5.0));
        });
    });

    describe(@"setting the timeout", ^{
        __block SDLChoiceSet *testChoiceSet = nil;
        __block NSTimeInterval testDefaultTimeout = 7.0;

        beforeEach(^{
            testChoiceSet = [[SDLChoiceSet alloc] init];
            SDLChoiceSet.defaultTimeout = testDefaultTimeout;
        });

        it(@"should return the default timeout if the timeout was not set", ^{
            expect(testChoiceSet.timeout).to(equal(testDefaultTimeout));
        });

        it(@"should return the default timeout if the timeout was set to 0", ^{
            testChoiceSet.timeout = 0.0;
            expect(testChoiceSet.timeout).to(equal(testDefaultTimeout));
        });

        it(@"should return the timeout value if it was set", ^{
            int testTimeout = 9.0;
            testChoiceSet.timeout = testTimeout;
            expect(testChoiceSet.timeout).to(equal(testTimeout));
        });

        it(@"should return 100 if a value greater than 100 has been set", ^{
            testChoiceSet.timeout = 214.0;
            expect(testChoiceSet.timeout).to(equal(100.0));
        });

        it(@"should return 5 if a value less than 5 has been set", ^{
            testChoiceSet.timeout = 2.25;
            expect(testChoiceSet.timeout).to(equal(5.0));
        });
    });

    describe(@"canceling the choice set", ^{
        __block BOOL canceledHandlerCalled = NO;

        beforeEach(^{
            testChoiceSet = [[SDLChoiceSet alloc] init];
            testChoiceSet.canceledHandler = ^{
                canceledHandlerCalled = YES;
            };
            expect(canceledHandlerCalled).to(beFalse());
        });

        it(@"should call the cancelled handler", ^{
            [testChoiceSet cancel];
            expect(canceledHandlerCalled).to(beTrue());
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
