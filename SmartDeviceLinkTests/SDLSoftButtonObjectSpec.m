#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"

QuickSpecBegin(SDLSoftButtonObjectSpec)

describe(@"a soft button object", ^{
    __block SDLSoftButtonObject *testObject = nil;
    __block NSString *testObjectName = @"Test Object Name";

    context(@"with a single state", ^{
        __block SDLSoftButtonState *testSingleState = OCMClassMock([SDLSoftButtonState class]);
        __block NSString *testSingleStateName = @"Test state name";
        __block SDLSoftButton *testSingleStateSoftButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"Some Text" image:nil highlighted:NO buttonId:0 systemAction:SDLSystemActionDefaultAction handler:nil];

        beforeEach(^{
            OCMStub(testSingleState.name).andReturn(testSingleStateName);
            OCMStub(testSingleState.softButton).andReturn(testSingleStateSoftButton);

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

    context(@"with multiple states", ^{
        __block SDLSoftButtonState *testFirstState = OCMClassMock([SDLSoftButtonState class]);
        __block NSString *testFirstStateName = @"Test First Name";
        __block SDLSoftButton *testFirstStateSoftButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"Some Text" image:nil highlighted:NO buttonId:0 systemAction:SDLSystemActionDefaultAction handler:nil];

        __block SDLSoftButtonState *testSecondState = OCMClassMock([SDLSoftButtonState class]);
        __block NSString *testSecondStateName = @"Test Second Name";

        beforeEach(^{
            OCMStub(testFirstState.name).andReturn(testFirstStateName);
            OCMStub(testFirstState.softButton).andReturn(testFirstStateSoftButton);

            OCMStub(testSecondState.name).andReturn(testSecondStateName);

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
