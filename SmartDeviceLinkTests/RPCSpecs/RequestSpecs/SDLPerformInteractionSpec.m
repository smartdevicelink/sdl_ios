//
//  SDLPerformInteractionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLInteractionMode.h"
#import "SDLLayoutMode.h"
#import "SDLPerformInteraction.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLPerformInteractionSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLPerformInteraction *testRequest = nil;
    __block NSString *testInitialText = @"initialText";
    __block NSArray<SDLTTSChunk *> *testInitialPrompt = nil;
    __block NSString *testInitialPromptString = nil;
    __block SDLInteractionMode testInteractionMode = SDLInteractionModeVoiceRecognitionOnly;
    __block NSArray<NSNumber<SDLUInt> *> *testInteractionChoiceSetIDList = nil;
    __block UInt16 testInteractionChoiceSetID = 48212;
    __block NSString *testHelpPromptString = nil;
    __block NSArray<SDLTTSChunk *> *testHelpPrompt = nil;
    __block NSString *testTimeoutPromptString = nil;
    __block NSArray<SDLTTSChunk *> *testTimeoutPrompt = nil;
    __block int testTimeout = 6000;
    __block NSArray<SDLVRHelpItem *> *testVRHelp = nil;
    __block SDLLayoutMode testinteractionLayout = SDLLayoutModeKeyboard;
    __block int testCancelID = 9987;

    beforeEach(^{
        testInteractionChoiceSetIDList = @[@34, @55, @23];
        testInitialPromptString = @"test initial prompt";
        testInitialPrompt = [SDLTTSChunk textChunksFromString:testInitialPromptString];
        testHelpPromptString = @"test help prompt";
        testHelpPrompt = [SDLTTSChunk textChunksFromString:testHelpPromptString];
        testTimeoutPromptString = @"test timeout prompt";
        testTimeoutPrompt = [SDLTTSChunk textChunksFromString:testTimeoutPromptString];
        testVRHelp = @[[[SDLVRHelpItem alloc] initWithText:@"test vr help" image:nil]];
    });

    context(@"Getter/Setter Tests", ^{
        it(@"Should set and get correctly", ^ {
            testRequest = [[SDLPerformInteraction alloc] init];

            testRequest.initialText = testInitialText;
            testRequest.initialPrompt = testInitialPrompt;
            testRequest.interactionMode = testInteractionMode;
            testRequest.interactionChoiceSetIDList = testInteractionChoiceSetIDList;
            testRequest.helpPrompt = testHelpPrompt;
            testRequest.timeoutPrompt = testTimeoutPrompt;
            testRequest.timeout = @(testTimeout);
            testRequest.vrHelp = testVRHelp;
            testRequest.interactionLayout = testinteractionLayout;
            testRequest.cancelID = @(testCancelID);

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal(testInitialPrompt));
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(equal(testHelpPrompt));
            expect(testRequest.timeoutPrompt).to(equal(testTimeoutPrompt));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.vrHelp).to(equal(testVRHelp));
            expect(testRequest.interactionLayout).to(equal(testinteractionLayout));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(10));
        });

        it(@"Should return nil if not set", ^ {
            testRequest = [[SDLPerformInteraction alloc] init];

            expect(testRequest.initialText).to(beNil());
            expect(testRequest.initialPrompt).to(beNil());
            expect(testRequest.interactionMode).to(beNil());
            expect(testRequest.interactionChoiceSetIDList).to(beNil());
            expect(testRequest.helpPrompt).to(beNil());
            expect(testRequest.timeoutPrompt).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.vrHelp).to(beNil());
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());

            expect(testRequest.parameters.count).to(equal(0));
        });
    });

    describe(@"initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^ {
            NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                               @{SDLRPCParameterNameParameters:
                                                     @{SDLRPCParameterNameInitialText:testInitialText,
                                                       SDLRPCParameterNameInitialPrompt:testInitialPrompt,
                                                       SDLRPCParameterNameInteractionMode:testInteractionMode,
                                                       SDLRPCParameterNameInteractionChoiceSetIdList:testInteractionChoiceSetIDList,
                                                       SDLRPCParameterNameHelpPrompt:testHelpPrompt,
                                                       SDLRPCParameterNameTimeoutPrompt:testTimeoutPrompt,
                                                       SDLRPCParameterNameTimeout:@(testTimeout),
                                                       SDLRPCParameterNameVRHelp:testVRHelp,
                                                       SDLRPCParameterNameInteractionLayout:testinteractionLayout,
                                                       SDLRPCParameterNameCancelID:@(testCancelID)},
                                                 SDLRPCParameterNameOperationName:SDLRPCFunctionNamePerformInteraction}};
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithDictionary:dict];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal(testInitialPrompt));
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(equal(testHelpPrompt));
            expect(testRequest.timeoutPrompt).to(equal(testTimeoutPrompt));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.vrHelp).to(equal(testVRHelp));
            expect(testRequest.interactionLayout).to(equal(testinteractionLayout));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(10));
        });

        it(@"Should initialize correctly with initWithInitialText:interactionMode:interactionChoiceSetIDList:cancelID:", ^{
            testRequest = [[SDLPerformInteraction alloc] initWithInitialText:testInitialText interactionMode:testInteractionMode interactionChoiceSetIDList:testInteractionChoiceSetIDList cancelID:testCancelID];

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(beNil());
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(beNil());
            expect(testRequest.timeoutPrompt).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.vrHelp).to(beNil());
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithInitialText:initialPrompt:interactionMode:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:timeout:vrHelp:interactionLayout:cancelID:", ^{
            testRequest = [[SDLPerformInteraction alloc] initWithInitialText:testInitialText initialPrompt:testInitialPrompt interactionMode:testInteractionMode interactionChoiceSetIDList:testInteractionChoiceSetIDList helpPrompt:testHelpPrompt timeoutPrompt:testTimeoutPrompt timeout:testTimeout vrHelp:testVRHelp interactionLayout:testinteractionLayout cancelID:testCancelID];

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal(testInitialPrompt));
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(equal(testHelpPrompt));
            expect(testRequest.timeoutPrompt).to(equal(testTimeoutPrompt));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.vrHelp).to(equal(testVRHelp));
            expect(testRequest.interactionLayout).to(equal(testinteractionLayout));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithInteractionChoiceSetId:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInteractionChoiceSetId:testInteractionChoiceSetID];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(beNil());
            expect(testRequest.initialPrompt).to(beNil());
            expect(testRequest.interactionMode).to(beNil());
            expect(testRequest.interactionChoiceSetIDList).to(equal(@[@(testInteractionChoiceSetID)]));
            expect(testRequest.helpPrompt).to(beNil());
            expect(testRequest.timeoutPrompt).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.vrHelp).to(beNil());
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithInteractionChoiceSetIdList:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInteractionChoiceSetIdList:testInteractionChoiceSetIDList];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(beNil());
            expect(testRequest.initialPrompt).to(beNil());
            expect(testRequest.interactionMode).to(beNil());
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(beNil());
            expect(testRequest.timeoutPrompt).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.vrHelp).to(beNil());
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithInitialPrompt:initialText:interactionChoiceSetID:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInitialPrompt:testInitialPromptString initialText:testInitialText interactionChoiceSetID:testInteractionChoiceSetID];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal([SDLTTSChunk textChunksFromString:testInitialPromptString]));
            expect(testRequest.interactionMode).to(beNil());
            expect(testRequest.interactionChoiceSetIDList).to(equal(@[@(testInteractionChoiceSetID)]));
            expect(testRequest.helpPrompt).to(beNil());
            expect(testRequest.timeoutPrompt).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.vrHelp).to(beNil());
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithInitialPrompt:initialText:interactionChoiceSetID:vrHelp:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInitialPrompt:testInitialPromptString initialText:testInitialText interactionChoiceSetID:testInteractionChoiceSetID vrHelp:testVRHelp];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal([SDLTTSChunk textChunksFromString:testInitialPromptString]));
            expect(testRequest.interactionMode).to(beNil());
            expect(testRequest.interactionChoiceSetIDList).to(equal(@[@(testInteractionChoiceSetID)]));
            expect(testRequest.helpPrompt).to(beNil());
            expect(testRequest.timeoutPrompt).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.vrHelp).to(equal(testVRHelp));
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithInitialPrompt:initialText:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:interactionMode:timeout:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInitialPrompt:testInitialPromptString initialText:testInitialText interactionChoiceSetIDList:testInteractionChoiceSetIDList helpPrompt:testHelpPromptString timeoutPrompt:testTimeoutPromptString interactionMode:testInteractionMode timeout:testTimeout];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal([SDLTTSChunk textChunksFromString:testInitialPromptString]));
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(equal([SDLTTSChunk textChunksFromString:testHelpPromptString]));
            expect(testRequest.timeoutPrompt).to(equal([SDLTTSChunk textChunksFromString:testTimeoutPromptString]));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.vrHelp).to(beNil());
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithInitialPrompt:initialText:interactionChoiceSetIDList:helpPrompt:timeoutPrompt:interactionMode:timeout:vrHelp:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInitialPrompt:testInitialPromptString initialText:testInitialText interactionChoiceSetIDList:testInteractionChoiceSetIDList helpPrompt:testHelpPromptString timeoutPrompt:testTimeoutPromptString interactionMode:testInteractionMode timeout:testTimeout vrHelp:testVRHelp];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal([SDLTTSChunk textChunksFromString:testInitialPromptString]));
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(equal([SDLTTSChunk textChunksFromString:testHelpPromptString]));
            expect(testRequest.timeoutPrompt).to(equal([SDLTTSChunk textChunksFromString:testTimeoutPromptString]));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.vrHelp).to(equal(testVRHelp));
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithInitialChunks:initialText:interactionChoiceSetIDList:helpChunks:timeoutChunks:interactionMode:timeout:vrHelp:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInitialChunks:testInitialPrompt initialText:testInitialText interactionChoiceSetIDList:testInteractionChoiceSetIDList helpChunks:testHelpPrompt timeoutChunks:testTimeoutPrompt interactionMode:testInteractionMode timeout:testTimeout vrHelp:testVRHelp];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal(testInitialPrompt));
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(equal(testHelpPrompt));
            expect(testRequest.timeoutPrompt).to(equal(testTimeoutPrompt));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.vrHelp).to(equal(testVRHelp));
            expect(testRequest.interactionLayout).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithInitialChunks:initialText:interactionChoiceSetIDList:helpChunks:timeoutChunks:interactionMode:timeout:vrHelp:interactionLayout:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLPerformInteraction alloc] initWithInitialChunks:testInitialPrompt initialText:testInitialText interactionChoiceSetIDList:testInteractionChoiceSetIDList helpChunks:testHelpPrompt timeoutChunks:testTimeoutPrompt interactionMode:testInteractionMode timeout:testTimeout vrHelp:testVRHelp interactionLayout:testinteractionLayout];
            #pragma clang diagnostic pop

            expect(testRequest.initialText).to(equal(testInitialText));
            expect(testRequest.initialPrompt).to(equal(testInitialPrompt));
            expect(testRequest.interactionMode).to(equal(testInteractionMode));
            expect(testRequest.interactionChoiceSetIDList).to(equal(testInteractionChoiceSetIDList));
            expect(testRequest.helpPrompt).to(equal(testHelpPrompt));
            expect(testRequest.timeoutPrompt).to(equal(testTimeoutPrompt));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.vrHelp).to(equal(testVRHelp));
            expect(testRequest.interactionLayout).to(equal(testinteractionLayout));
            expect(testRequest.cancelID).to(beNil());
        });
    });

    afterEach(^{
        expect(testRequest.name).to(equal(SDLRPCFunctionNamePerformInteraction));
    });
});

QuickSpecEnd
