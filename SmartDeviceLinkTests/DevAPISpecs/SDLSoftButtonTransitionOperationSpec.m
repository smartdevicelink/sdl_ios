#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLSoftButtonTransitionOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLSoftButtonTransitionOperationSpec)

describe(@"a soft button transition operation", ^{
    __block SDLSoftButtonTransitionOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    __block NSArray<SDLSoftButtonObject *> *testSoftButtonObjects = nil;
    __block NSString *testMainField1 = @"Test 1";

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);

        SDLSoftButtonState *object1State1 = [[SDLSoftButtonState alloc] initWithStateName:@"State 1" text:@"Test Text 1" artwork:nil];
        SDLSoftButtonObject *button1 = [[SDLSoftButtonObject alloc] initWithName:@"Button 1" state:object1State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        SDLSoftButtonState *object2State1 = [[SDLSoftButtonState alloc] initWithStateName:@"State 2" text:@"Test text 2" image:nil];
        SDLSoftButtonObject *button2 = [[SDLSoftButtonObject alloc] initWithName:@"Button 2" state:object2State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        testSoftButtonObjects = @[button1, button2];
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLSoftButtonTransitionOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        beforeEach(^{
            SDLSoftButtonCapabilities *capabilities = [[SDLSoftButtonCapabilities alloc] init];
            capabilities.imageSupported = @YES;

            testOp = [[SDLSoftButtonTransitionOperation alloc] initWithConnectionManager:testConnectionManager capabilities:capabilities softButtons:testSoftButtonObjects mainField1:testMainField1];
        });
    });
});

QuickSpecEnd
