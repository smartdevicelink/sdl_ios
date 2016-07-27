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
#import "SDLNames.h"

QuickSpecBegin(SDLPerformInteractionSpec)

SDLTTSChunk* chunk1 = [[SDLTTSChunk alloc] init];
SDLTTSChunk* chunk2 = [[SDLTTSChunk alloc] init];
SDLTTSChunk* chunk3 = [[SDLTTSChunk alloc] init];
SDLVRHelpItem* helpItem = [[SDLVRHelpItem alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPerformInteraction* testRequest = [[SDLPerformInteraction alloc] init];
        
        testRequest.initialText = @"a";
        testRequest.initialPrompt = [@[chunk1] mutableCopy];
        testRequest.interactionMode = [SDLInteractionMode VR_ONLY];
        testRequest.interactionChoiceSetIDList = [@[@1, @2, @3] mutableCopy];
        testRequest.helpPrompt = [@[chunk2] mutableCopy];
        testRequest.timeoutPrompt = [@[chunk3] mutableCopy];
        testRequest.timeout = @42000;
        testRequest.vrHelp = [@[helpItem] mutableCopy];
        testRequest.interactionLayout = [SDLLayoutMode ICON_WITH_SEARCH];
        
        expect(testRequest.initialText).to(equal(@"a"));
        expect(testRequest.initialPrompt).to(equal([@[chunk1] mutableCopy]));
        expect(testRequest.interactionMode).to(equal([SDLInteractionMode VR_ONLY]));
        expect(testRequest.interactionChoiceSetIDList).to(equal([@[@1, @2, @3] mutableCopy]));
        expect(testRequest.helpPrompt).to(equal([@[chunk2] mutableCopy]));
        expect(testRequest.timeoutPrompt).to(equal([@[chunk3] mutableCopy]));
        expect(testRequest.timeout).to(equal(@42000));
        expect(testRequest.vrHelp).to(equal([@[helpItem] mutableCopy]));
        expect(testRequest.interactionLayout).to(equal([SDLLayoutMode ICON_WITH_SEARCH]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_initialText:@"a",
                                                   NAMES_initialPrompt:[@[chunk1] mutableCopy],
                                                   NAMES_interactionMode:[SDLInteractionMode VR_ONLY],
                                                   NAMES_interactionChoiceSetIDList:[@[@1, @2, @3] mutableCopy],
                                                   NAMES_helpPrompt:[@[chunk2] mutableCopy],
                                                   NAMES_timeoutPrompt:[@[chunk3] mutableCopy],
                                                   NAMES_timeout:@42000,
                                                   NAMES_vrHelp:[@[helpItem] mutableCopy],
                                                   NAMES_interactionLayout:[SDLLayoutMode ICON_WITH_SEARCH]},
                                             NAMES_operation_name:NAMES_PerformInteraction}} mutableCopy];
        SDLPerformInteraction* testRequest = [[SDLPerformInteraction alloc] initWithDictionary:dict];
        
        expect(testRequest.initialText).to(equal(@"a"));
        expect(testRequest.initialPrompt).to(equal([@[chunk1] mutableCopy]));
        expect(testRequest.interactionMode).to(equal([SDLInteractionMode VR_ONLY]));
        expect(testRequest.interactionChoiceSetIDList).to(equal([@[@1, @2, @3] mutableCopy]));
        expect(testRequest.helpPrompt).to(equal([@[chunk2] mutableCopy]));
        expect(testRequest.timeoutPrompt).to(equal([@[chunk3] mutableCopy]));
        expect(testRequest.timeout).to(equal(@42000));
        expect(testRequest.vrHelp).to(equal([@[helpItem] mutableCopy]));
        expect(testRequest.interactionLayout).to(equal([SDLLayoutMode ICON_WITH_SEARCH]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPerformInteraction* testRequest = [[SDLPerformInteraction alloc] init];
        
        expect(testRequest.initialText).to(beNil());
        expect(testRequest.initialPrompt).to(beNil());
        expect(testRequest.interactionMode).to(beNil());
        expect(testRequest.interactionChoiceSetIDList).to(beNil());
        expect(testRequest.helpPrompt).to(beNil());
        expect(testRequest.timeoutPrompt).to(beNil());
        expect(testRequest.timeout).to(beNil());
        expect(testRequest.vrHelp).to(beNil());
        expect(testRequest.interactionLayout).to(beNil());
    });
});

QuickSpecEnd