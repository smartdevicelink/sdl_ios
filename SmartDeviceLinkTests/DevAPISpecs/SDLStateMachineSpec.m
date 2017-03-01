#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLStateMachine.h"
#import "TestStateMachineTarget.h"

QuickSpecBegin(SDLStateMachineSpec)

describe(@"A state machine", ^{
    __block SDLStateMachine *testStateMachine = nil;
    __block TestStateMachineTarget *testTarget = nil;
    
    __block SDLState *initialState = @"Initial";
    __block SDLState *secondState = @"Second";
    __block SDLState *thirdState = @"Third";
    
    __block NSDictionary *allowableStateTransitions = @{
                                                        initialState: @[secondState],
                                                        secondState: @[thirdState],
                                                        thirdState: @[initialState]
                                                        };
    
    beforeEach(^{
        testTarget = [[TestStateMachineTarget alloc] init];
        
        testStateMachine = [[SDLStateMachine alloc] initWithTarget:testTarget initialState:initialState states:allowableStateTransitions];
    });
    
    describe(@"when the state machine initializes", ^{
        __block BOOL isInitialState = NO;
        
        beforeEach(^{
            isInitialState = [testStateMachine isCurrentState:initialState];
        });
        
        it(@"should be in a correct initial state", ^{
            expect(@(isInitialState)).to(equal(@YES));
            expect(testStateMachine.states).to(equal(allowableStateTransitions));
            expect(testStateMachine.target).to(equal(testTarget));
        });
        
        describe(@"when transitioning correctly", ^{
            __block BOOL didTransitionNotificationCalled = NO;
            
            __block NSDictionary<NSString *, NSString *> *willLeaveMethodInfo = nil;
            __block NSDictionary<NSString *, NSString *> *willTransitionMethodInfo = nil;
            __block NSDictionary<NSString *, NSString *> *didTransitionMethodInfo = nil;
            __block NSDictionary<NSString *, NSString *> *didEnterMethodInfo = nil;
            
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] addObserverForName:testStateMachine.transitionNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                    didTransitionNotificationCalled = YES;
                }];
                
                testTarget.callback = ^(NSString * _Nonnull type, NSString * _Nullable oldState, NSString * _Nullable newState) {
                    if ([type isEqualToString:SDLStateMachineTransitionTypeWillLeave]) {
                        willLeaveMethodInfo = @{ SDLStateMachineNotificationInfoKeyOldState: oldState };
                    } else if ([type isEqualToString:SDLStateMachineTransitionTypeWillTransition]) {
                        willTransitionMethodInfo = @{ SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: newState };
                    } else if ([type isEqualToString:SDLStateMachineTransitionTypeDidTransition]) {
                        didTransitionMethodInfo = @{ SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: newState };
                    } else if ([type isEqualToString:SDLStateMachineTransitionTypeDidEnter]) {
                        didEnterMethodInfo = @{ SDLStateMachineNotificationInfoKeyNewState: newState };
                    }
                };
                
                // Valid transition
                [testStateMachine transitionToState:secondState];
            });
            
            it(@"should end up in the correct state", ^{
                expect(@([testStateMachine isCurrentState:secondState])).to(equal(@YES));
            });
            
            it(@"should call all appropriate notifications", ^{
                expect(@(didTransitionNotificationCalled)).to(equal(@YES));
            });
            
            it(@"should call all the appropriate state methods", ^{
                expect(willLeaveMethodInfo[SDLStateMachineNotificationInfoKeyOldState]).to(match(initialState));
                expect(willLeaveMethodInfo[SDLStateMachineNotificationInfoKeyNewState]).to(beNil());
                expect(willTransitionMethodInfo[SDLStateMachineNotificationInfoKeyOldState]).to(match(initialState));
                expect(willTransitionMethodInfo[SDLStateMachineNotificationInfoKeyNewState]).to(match(secondState));
                expect(didTransitionMethodInfo[SDLStateMachineNotificationInfoKeyOldState]).to(match(initialState));
                expect(didTransitionMethodInfo[SDLStateMachineNotificationInfoKeyNewState]).to(match(secondState));
                expect(didEnterMethodInfo[SDLStateMachineNotificationInfoKeyOldState]).to(beNil());
                expect(didEnterMethodInfo[SDLStateMachineNotificationInfoKeyNewState]).to(match(secondState));
            });
        });
        
        describe(@"when transitioning incorrectly", ^{
            __block BOOL willLeaveNotificationCalled = NO;
            __block BOOL willTransitionNotificationCalled = NO;
            __block BOOL didTransitionNotificationCalled = NO;
            __block BOOL didEnterNotificationCalled = NO;
            
            __block NSDictionary<NSString *, NSString *> *willLeaveMethodInfo = nil;
            __block NSDictionary<NSString *, NSString *> *willTransitionMethodInfo = nil;
            __block NSDictionary<NSString *, NSString *> *didTransitionMethodInfo = nil;
            __block NSDictionary<NSString *, NSString *> *didEnterMethodInfo = nil;
            
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] addObserverForName:testStateMachine.transitionNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                    if ([note.userInfo[@"type"] isEqualToString:@"willLeave"]) { willLeaveNotificationCalled = YES; }
                    else if ([note.userInfo[@"type"] isEqualToString:@"willTransition"]) { willTransitionNotificationCalled = YES; }
                    else if ([note.userInfo[@"type"] isEqualToString:@"didTransition"]) { didTransitionNotificationCalled = YES; }
                    else if ([note.userInfo[@"type"] isEqualToString:@"didEnter"]) { didEnterNotificationCalled = YES; }
                }];
                
                testTarget.callback = ^(NSString * _Nonnull type, NSString * _Nullable oldState, NSString * _Nullable newState) {
                    if ([type isEqualToString:SDLStateMachineTransitionTypeWillLeave]) {
                        willLeaveMethodInfo = @{ SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: newState };
                    } else if ([type isEqualToString:SDLStateMachineTransitionTypeWillTransition]) {
                        willTransitionMethodInfo = @{ SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: newState };
                    } else if ([type isEqualToString:SDLStateMachineTransitionTypeDidTransition]) {
                        didTransitionMethodInfo = @{ SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: newState };
                    } else if ([type isEqualToString:SDLStateMachineTransitionTypeDidEnter]) {
                        didEnterMethodInfo = @{ SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: newState };
                    }
                };
            });
            
            it(@"should throw an exception trying to transition incorrectly and nothing should be called", ^{
                NSString *stateMachineClassString = NSStringFromClass(testStateMachine.class);
                NSString *targetClassString = NSStringFromClass(testTarget.class);
                
                // Side effects, but I can't think of any other way around it.
                expectAction(^{
                    [testStateMachine transitionToState:thirdState];
                }).to(raiseException().named(NSInternalInconsistencyException).reason([NSString stringWithFormat:@"Invalid state machine %@ transition of target %@ occurred from %@ to %@", stateMachineClassString, targetClassString, initialState, thirdState]).userInfo(@{@"fromState": initialState, @"toState": thirdState, @"targetClass": targetClassString}));
                    
                expect(@([testStateMachine isCurrentState:initialState])).to(equal(@YES));
                expect(@([testStateMachine isCurrentState:thirdState])).to(equal(@NO));
                expect(@(willLeaveNotificationCalled)).to(equal(@NO));
                expect(@(willTransitionNotificationCalled)).to(equal(@NO));
                expect(@(didTransitionNotificationCalled)).to(equal(@NO));
                expect(@(didEnterNotificationCalled)).to(equal(@NO));
                expect(willLeaveMethodInfo).to(beNil());
                expect(willTransitionMethodInfo).to(beNil());
                expect(didTransitionMethodInfo).to(beNil());
                expect(didEnterMethodInfo).to(beNil());
            });
        });
    });
});

// Invalid state machine transition of TestStateMachineTarget occurred from Initial to Third

QuickSpecEnd
