//
//  SDLPresentAlertOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 11/18/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAlert.h"
#import "SDLAlertView.h"
#import "SDLAlertAudioData.h"
#import "SDLFileManager.h"
#import "SDLPresentAlertOperation.h"
#import "SDLWindowCapability.h"
#import "SDLSoftButtonObject.h"
#import "SDLTTSChunk.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"
#import "TestConnectionManager.h"

@interface SDLPresentAlertOperation()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) SDLWindowCapability *currentCapabilities;
@property (strong, nonatomic, readwrite) SDLAlertView *alertView;
@property (assign, nonatomic) UInt16 cancelId;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

QuickSpecBegin(SDLPresentAlertOperationSpec)

describe(@"SDLPresentAlertOperation", ^{
    __block SDLPresentAlertOperation *testPresentAlertOperation = nil;
    __block TestConnectionManager *testConnectionManager = nil;
    __block id mockFileManager = nil;
    __block id mockCurrentWindowCapability = nil;
    __block SDLAlertView *testAlertView = nil;
    __block UInt16 testCancelID = 45;
    __block BOOL hasCalledOperationCompletionHandler = NO;

    __block SDLAlertAudioData *testAlertAudioData = nil;
    __block SDLSoftButtonObject *testAlertSoftButton1 = nil;
    __block SDLSoftButtonObject *testAlertSoftButton2 = nil;
    __block SDLArtwork *testAlertIcon = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMClassMock([SDLFileManager class]);
        mockCurrentWindowCapability = OCMClassMock([SDLWindowCapability class]);

        testAlertAudioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];

        testAlertSoftButton1 = [[SDLSoftButtonObject alloc] initWithName:@"button1" text:@"button1" artwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameKey] handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
            // TODO
        }];
        testAlertSoftButton2 = [[SDLSoftButtonObject alloc] initWithName:@"button2" text:@"button2" artwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameRSS] handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
            // TODO
        }];

        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];
        testAlertIcon = [SDLArtwork artworkWithImage:testImage asImageFormat:SDLArtworkImageFormatPNG];

        testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
    });

    it(@"should be initialized correctly", ^{
        testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

        expect(@(testPresentAlertOperation.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
        expect(testPresentAlertOperation.connectionManager).to(equal(testConnectionManager));
        expect(testPresentAlertOperation.fileManager).to(equal(mockFileManager));
        expect(testPresentAlertOperation.alertView).to(equal(testAlertView));
        expect(@(testPresentAlertOperation.cancelId)).to(equal(@(testCancelID)));
        expect(testPresentAlertOperation.currentCapabilities).to(equal(mockCurrentWindowCapability));
        expect(testPresentAlertOperation.internalError).to(beNil());
    });

    describe(@"presenting the alert", ^{
        beforeEach(^{
            [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertMainFieldLines];
            testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

            testPresentAlertOperation.completionBlock = ^{
                hasCalledOperationCompletionHandler = YES;
            };

            [testPresentAlertOperation start];
        });

        it(@"should send the alert", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLAlert class]));
            SDLAlert *alertRequest = testConnectionManager.receivedRequests.lastObject;
            expect(alertRequest.alertText1).toEventually(equal(testAlertView.text));
            expect(alertRequest.alertText2).to(equal(testAlertView.secondaryText));
            expect(alertRequest.alertText3).to(equal(testAlertView.tertiaryText));

            expect(alertRequest.ttsChunks.count).to(equal(1));
            expect(alertRequest.ttsChunks[0].text).to(equal(testAlertView.audio.prompts.firstObject.text));
            expect(alertRequest.duration).to(equal(testAlertView.timeout * 1000));
            expect(alertRequest.playTone).to(equal(testAlertView.audio.playTone));


//            SDLPerformInteraction *request = testConnectionManager.receivedRequests.lastObject;
//            expect(request.initialText).to(equal(testChoiceSet.title));
//            expect(request.initialPrompt).to(equal(testChoiceSet.initialPrompt));
//            expect(request.interactionMode).to(equal(testInteractionMode));
//            expect(request.interactionLayout).to(equal(SDLLayoutModeIconOnly));
//            expect(request.timeoutPrompt).to(equal(testChoiceSet.timeoutPrompt));
//            expect(request.helpPrompt).to(equal(testChoiceSet.helpPrompt));
//            expect(request.timeout).to(equal(testChoiceSet.timeout * 1000));
//            expect(request.vrHelp).to(beNil());
//            expect(request.interactionChoiceSetIDList).to(equal(@[@65535]));
//            expect(request.cancelID).to(equal(testCancelID));
        });
    });
});

QuickSpecEnd
