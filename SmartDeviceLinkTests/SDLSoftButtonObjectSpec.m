#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLArtwork.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

QuickSpecBegin(SDLSoftButtonObjectSpec)

describe(@"a soft button object", ^{
    __block SDLSoftButtonObject *testObject = nil;
    __block NSString *testObjectName = @"Test Object Name";

    context(@"with a single state", ^{
        __block NSString *testSingleStateName = @"Test state name";
        __block SDLSoftButtonState *testSingleState = [[SDLSoftButtonState alloc] initWithStateName:testSingleStateName text:@"Some Text" image:nil];
        __block SDLSoftButton *testSingleStateSoftButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"Some Text" image:nil highlighted:NO buttonId:0 systemAction:SDLSystemActionDefaultAction handler:nil];

        beforeEach(^{
            testObject = [[SDLSoftButtonObject alloc] initWithName:testObjectName state:testSingleState handler:nil];
        });

        it(@"should create correctly", ^{
            expect(testObject.name).to(equal(testObjectName));
            expect(testObject.currentState.name).to(equal(testSingleState.name));
            expect(testObject.currentStateSoftButton).to(equal(testSingleStateSoftButton));
            expect(testObject.states).to(haveCount(1));
        });

        it(@"should not allow transitioning to another state", ^{
            BOOL performedTransition = [testObject transitionToStateNamed:@"Some other state"];
            expect(performedTransition).to(beFalsy());
        });

        it(@"should return a state when asked and not when incorrect", ^{
            SDLSoftButtonState *returnedState = [testObject stateWithName:testSingleStateName];
            expect(returnedState).toNot(beNil());

            returnedState = [testObject stateWithName:@"Some other state"];
            expect(returnedState).to(beNil());
        });
    });

    context(@"with a single state implicitly created", ^{
        NSString *testText = @"Hello";
        SDLArtwork *testArt = [[SDLArtwork alloc] initWithStaticIcon:SDLStaticIconNameKey];

        beforeEach(^{
            testObject = [[SDLSoftButtonObject alloc] initWithName:testObjectName text:testText artwork:testArt handler:nil];
        });

        it(@"should create correctly", ^{
            expect(testObject.name).to(equal(testObjectName));
            expect(testObject.currentState.name).to(equal(testObjectName));
            expect(testObject.currentState.text).to(equal(testText));
            expect(testObject.currentState.artwork).to(equal(testArt));
            expect(testObject.states).to(haveCount(1));
        });

        it(@"should not allow transitioning to another state", ^{
            BOOL performedTransition = [testObject transitionToStateNamed:@"Some other state"];
            expect(performedTransition).to(beFalse());
        });

        it(@"should return a state when asked and not when incorrect", ^{
            SDLSoftButtonState *returnedState = [testObject stateWithName:testObjectName];
            expect(returnedState).toNot(beNil());

            returnedState = [testObject stateWithName:@"Some other state"];
            expect(returnedState).to(beNil());
        });
    });

    context(@"with multiple states", ^{
        __block NSString *testFirstStateName = @"Test First Name";
        __block SDLSoftButtonState *testFirstState = [[SDLSoftButtonState alloc] initWithStateName:testFirstStateName text:@"Some Text" image:nil];
        __block SDLSoftButton *testFirstStateSoftButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"Some Text" image:nil highlighted:NO buttonId:0 systemAction:SDLSystemActionDefaultAction handler:nil];

        __block NSString *testSecondStateName = @"Test Second Name";
        __block SDLSoftButtonState *testSecondState = [[SDLSoftButtonState alloc] initWithStateName:testSecondStateName text:@"Some Second Text" image:nil];

        beforeEach(^{
            testObject = [[SDLSoftButtonObject alloc] initWithName:testObjectName states:@[testFirstState, testSecondState] initialStateName:testFirstStateName handler:nil];
        });

        it(@"should create correctly", ^{
            expect(testObject.name).to(equal(testObjectName));
            expect(testObject.currentState.name).to(equal(testFirstState.name));
            expect(testObject.currentStateSoftButton).to(equal(testFirstStateSoftButton));
            expect(testObject.states).to(haveCount(2));
        });

        it(@"should transitioning to the second state", ^{
            BOOL performedTransition = [testObject transitionToStateNamed:testSecondStateName];
            expect(performedTransition).to(beTruthy());
            expect(testObject.currentState.name).to(equal(testSecondStateName));
        });

        it(@"should return a current when asked and not when incorrect", ^{
            SDLSoftButtonState *returnedState = [testObject stateWithName:testFirstStateName];
            expect(returnedState).toNot(beNil());

            returnedState = [testObject stateWithName:testSecondStateName];
            expect(returnedState).toNot(beNil());

            returnedState = [testObject stateWithName:@"Some other state"];
            expect(returnedState).to(beNil());
        });
    });
});

QuickSpecEnd
