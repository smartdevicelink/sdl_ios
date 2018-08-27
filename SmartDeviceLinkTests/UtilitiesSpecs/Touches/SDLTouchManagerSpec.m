//
//  SDLTouchManagerSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/17/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLNotificationConstants.h"
#import "SDLFocusableItemLocator.h"
#import "SDLOnTouchEvent.h"
#import "SDLPinchGesture.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouchManager.h"
#import "SDLTouchManagerDelegate.h"
#import "SDLTouchType.h"
#import "SDLTouch.h"

@interface SDLTouchManager ()

@property (nonatomic, strong, nullable) SDLTouch *previousTouch;
@property (nonatomic, strong, nullable) SDLTouch *singleTapTouch;
@property (nonatomic, assign) CGFloat previousPinchDistance;
@property (nonatomic, strong, nullable) SDLPinchGesture *currentPinchGesture;
@property (nonatomic, strong, nullable) dispatch_source_t singleTapTimer;
@end

QuickSpecBegin(SDLTouchManagerSpec)

describe(@"SDLTouchManager Tests", ^{
    __block SDLTouchManager *touchManager;

    context(@"initializing", ^{
        it(@"should correctly have default properties", ^{
            SDLTouchManager* touchManager = [[SDLTouchManager alloc] initWithHitTester:nil];
            expect(touchManager.touchEventDelegate).to(beNil());
            expect(@(touchManager.tapDistanceThreshold)).to(equal(@50));
            expect(@(touchManager.tapTimeThreshold)).to(beCloseTo(@0.4).within(0.0001));
            expect(@(touchManager.isTouchEnabled)).to(beTruthy());
        });
    });

    describe(@"touch events", ^{
        typedef void (^DelegateCallbackBlock)(NSInvocation* invocation);

        __block id delegateMock;
        __block CGPoint controlPoint;
        __block BOOL didCallSingleTap;
        __block BOOL didCallDoubleTap;
        __block BOOL didCallBeginPan;
        __block BOOL didCallMovePan;
        __block BOOL didCallEndPan;
        __block BOOL didCallCancelPan;
        __block BOOL didCallBeginPinch;
        __block BOOL didCallMovePinch;
        __block BOOL didCallEndPinch;
        __block BOOL didCallCancelPinch;

        __block BOOL expectedDidCallSingleTap;
        __block BOOL expectedDidCallDoubleTap;
        __block BOOL expectedDidCallBeginPan;
        __block BOOL expectedDidCallMovePan;
        __block BOOL expectedDidCallEndPan;
        __block BOOL expectedDidCallCancelPan;
        __block BOOL expectedDidCallBeginPinch;
        __block BOOL expectedDidCallMovePinch;
        __block BOOL expectedDidCallEndPinch;
        __block BOOL expectedDidCallCancelPinch;

        __block DelegateCallbackBlock singleTapTests;
        __block DelegateCallbackBlock doubleTapTests;
        __block DelegateCallbackBlock panStartTests;
        __block DelegateCallbackBlock panMoveTests;
        __block DelegateCallbackBlock panEndTests;
        __block DelegateCallbackBlock panCanceledTests;
        __block DelegateCallbackBlock pinchStartTests;
        __block DelegateCallbackBlock pinchMoveTests;
        __block DelegateCallbackBlock pinchEndTests;
        __block DelegateCallbackBlock pinchCanceledTests;

        __block CGFloat additionalWaitTime = 1.0f;

        __block NSUInteger numTimesHandlerCalled;
        __block NSUInteger expectedNumTimesHandlerCalled;

        __block void (^performTouchEvent)(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) = ^(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) {
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveTouchEventNotification object:nil rpcNotification:onTouchEvent];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        };

        beforeEach(^{
            touchManager = [[SDLTouchManager alloc] initWithHitTester:nil];
            delegateMock = OCMProtocolMock(@protocol(SDLTouchManagerDelegate));
            touchManager.touchEventDelegate = delegateMock;
            touchManager.touchEventHandler = ^(SDLTouch *touch, SDLTouchType type) {
                numTimesHandlerCalled++;
            };
            touchManager.tapTimeThreshold = 0.4;

            controlPoint = CGPointMake(100, 200);

            didCallSingleTap = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallSingleTap = YES;
                singleTapTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceiveSingleTapForView:[OCMArg any] atPoint:CGPointZero];
            singleTapTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Single Tap Tests.");
            };

            didCallDoubleTap = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallDoubleTap = YES;
                doubleTapTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceiveDoubleTapForView:[OCMArg any] atPoint:CGPointZero];
            doubleTapTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Double Tap Tests.");
            };

            didCallBeginPan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallBeginPan = YES;
                panStartTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] panningDidStartInView:[OCMArg any] atPoint:CGPointZero];
            panStartTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pan Start Tests.");
            };

            didCallMovePan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallMovePan = YES;
                panMoveTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceivePanningFromPoint:CGPointZero toPoint:CGPointZero];
            panMoveTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pan Move Tests.");
            };

            didCallEndPan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallEndPan = YES;
                panEndTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] panningDidEndInView:[OCMArg any] atPoint:CGPointZero];
            panEndTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pan End Tests.");
            };

            didCallCancelPan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation *invocation) {
                didCallCancelPan = YES;
                panCanceledTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] panningCanceledAtPoint:CGPointZero];
            panCanceledTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pan Cancel Tests.");
            };

            didCallBeginPinch = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallBeginPinch = YES;
                pinchStartTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] pinchDidStartInView:[OCMArg any] atCenterPoint:CGPointZero];
            pinchStartTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pinch Start Tests.");
            };

            didCallMovePinch = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallMovePinch = YES;
                pinchMoveTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceivePinchAtCenterPoint:CGPointZero withScale:0];
            pinchMoveTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pinch Move Tests.");
            };

            didCallEndPinch = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallEndPinch = YES;
                pinchEndTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] pinchDidEndInView:[OCMArg any] atCenterPoint:CGPointZero];
            pinchEndTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pinch End Tests.");
            };

            didCallCancelPinch = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation *invocation) {
                didCallCancelPinch = YES;
                pinchCanceledTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] pinchCanceledAtCenterPoint:CGPointZero];
            pinchCanceledTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Pinch Cancel Tests.");
            };

            expectedDidCallSingleTap = NO;
            expectedDidCallDoubleTap = NO;
            expectedDidCallBeginPan = NO;
            expectedDidCallMovePan = NO;
            expectedDidCallEndPan = NO;
            expectedDidCallCancelPan = NO;
            expectedDidCallBeginPinch = NO;
            expectedDidCallMovePinch = NO;
            expectedDidCallEndPinch = NO;
            expectedDidCallCancelPinch = NO;

            numTimesHandlerCalled = 0;
            expectedNumTimesHandlerCalled = 0;
        });

        describe(@"When receiving a tap gesture", ^{
            __block SDLTouchCoord* firstTouchCoord;
            __block NSUInteger firstTouchTimeStamp;
            __block SDLOnTouchEvent* firstOnTouchEventStart;
            __block SDLOnTouchEvent* firstOnTouchEventEnd;

            beforeEach(^{
                firstTouchCoord = [[SDLTouchCoord alloc] init];
                firstTouchCoord.x = @(controlPoint.x);
                firstTouchCoord.y = @(controlPoint.y);
                firstTouchTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000.0;

                SDLTouchEvent* touchEvent = [[SDLTouchEvent alloc] init];
                touchEvent.touchEventId = @0;
                touchEvent.coord = [NSArray arrayWithObject:firstTouchCoord];
                touchEvent.timeStamp = [NSArray arrayWithObject:@(firstTouchTimeStamp)];

                firstOnTouchEventStart = [[SDLOnTouchEvent alloc] init];
                firstOnTouchEventStart.type = SDLTouchTypeBegin;
                firstOnTouchEventStart.event = [NSArray arrayWithObject:touchEvent];

                firstOnTouchEventEnd = [[SDLOnTouchEvent alloc] init];
                firstOnTouchEventEnd.type = SDLTouchTypeEnd;
                firstOnTouchEventEnd.event = [NSArray arrayWithObject:touchEvent];
            });

            describe(@"when receiving a single tap", ^{
                it(@"should correctly handle a single tap", ^{
                    singleTapTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, controlPoint))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, firstOnTouchEventStart);
                    performTouchEvent(touchManager, firstOnTouchEventEnd);

                    expectedDidCallSingleTap = YES;
                    expectedNumTimesHandlerCalled = 2;
                });
            });
            
            describe(@"when receiving a single tap with small movement", ^{
                
                __block CGPoint movePoint;
                __block SDLOnTouchEvent* firstOnTouchEventMove;
                
                beforeEach(^{
                    const CGFloat moveDistance = touchManager.panDistanceThreshold;
                    movePoint = CGPointMake(controlPoint.x + moveDistance, controlPoint.y + moveDistance);
                    
                    SDLTouchCoord* firstTouchCoordMove = [[SDLTouchCoord alloc] init];
                    firstTouchCoordMove.x = @(movePoint.x);
                    firstTouchCoordMove.y = @(movePoint.y);
                    
                    SDLTouchEvent* touchEventMove = [[SDLTouchEvent alloc] init];
                    touchEventMove.touchEventId = @0;
                    touchEventMove.coord = [NSArray arrayWithObject:firstTouchCoordMove];
                    touchEventMove.timeStamp = [NSArray arrayWithObject:@(firstTouchTimeStamp)];
                    
                    firstOnTouchEventMove = [[SDLOnTouchEvent alloc] init];
                    firstOnTouchEventMove.type = SDLTouchTypeMove;
                    firstOnTouchEventMove.event = [NSArray arrayWithObject:touchEventMove];
                    
                    firstOnTouchEventEnd = [[SDLOnTouchEvent alloc] init];
                    firstOnTouchEventEnd.type = SDLTouchTypeEnd;
                    firstOnTouchEventEnd.event = [NSArray arrayWithObject:touchEventMove];
                });
                
                it(@"should correctly handle a single tap", ^{
                    singleTapTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];
                        
                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, movePoint))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, firstOnTouchEventStart);
                    performTouchEvent(touchManager, firstOnTouchEventMove);
                    performTouchEvent(touchManager, firstOnTouchEventEnd);

                    expectedDidCallSingleTap = YES;
                    expectedNumTimesHandlerCalled = 3;
                });
            });
            
            describe(@"when receiving a double tap", ^{
                __block CGPoint averagePoint;
                __block SDLTouchEvent* secondTouchEvent;
                __block SDLOnTouchEvent* secondOnTouchEventStart;
                __block SDLOnTouchEvent* secondOnTouchEventEnd;

                beforeEach(^{
                    secondOnTouchEventStart = [[SDLOnTouchEvent alloc] init];
                    secondOnTouchEventStart.type = SDLTouchTypeBegin;

                    secondOnTouchEventEnd = [[SDLOnTouchEvent alloc] init];
                    secondOnTouchEventEnd.type = SDLTouchTypeEnd;

                    secondTouchEvent = [[SDLTouchEvent alloc] init];
                    secondTouchEvent.touchEventId = @0;
                    NSUInteger secondTouchTimeStamp = firstTouchTimeStamp + (touchManager.tapTimeThreshold - 0.1) * 1000;
                    secondTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondTouchTimeStamp)];
                });

                context(@"near the same point", ^{
                    beforeEach(^{
                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold);
                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold);

                        secondTouchEvent.coord = [NSArray arrayWithObject:touchCoord];
                        secondOnTouchEventStart.event = [NSArray arrayWithObject:secondTouchEvent];
                        secondOnTouchEventEnd.event = [NSArray arrayWithObject:secondTouchEvent];

                        averagePoint = CGPointMake((firstTouchCoord.x.floatValue + touchCoord.x.floatValue) / 2.0f,
                                                   (firstTouchCoord.y.floatValue + touchCoord.y.floatValue) / 2.0f);
                    });

                    it(@"should issue delegate callbacks", ^{
                        doubleTapTests = ^(NSInvocation* invocation) {
                            __unsafe_unretained SDLTouchManager* touchManagerCallback;
                            CGPoint point;
                            [invocation getArgument:&touchManagerCallback atIndex:2];
                            [invocation getArgument:&point atIndex:4];

                            expect(touchManagerCallback).to(equal(touchManager));
                            expect(@(CGPointEqualToPoint(point, averagePoint))).to(beTruthy());
                        };

                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, firstOnTouchEventEnd);
                        performTouchEvent(touchManager, secondOnTouchEventStart);
                        performTouchEvent(touchManager, secondOnTouchEventEnd);
                        
                        expectedDidCallDoubleTap = YES;
                        expectedNumTimesHandlerCalled = 4;
                    });
                });

                context(@"not near the same point", ^{
                    it(@"should should not issue delegate callbacks", ^{
                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold + 1);
                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold + 1);

                        secondTouchEvent.coord = [NSArray arrayWithObject:touchCoord];
                        secondOnTouchEventStart.event = [NSArray arrayWithObject:secondTouchEvent];
                        secondOnTouchEventEnd.event = [NSArray arrayWithObject:secondTouchEvent];

                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, firstOnTouchEventEnd);
                        performTouchEvent(touchManager, secondOnTouchEventStart);
                        performTouchEvent(touchManager, secondOnTouchEventEnd);

                        expectedDidCallDoubleTap = NO;
                        expectedNumTimesHandlerCalled = 4;
                    });
                });
            });

            describe(@"when a tap gesture is canceled", ^{
                __block SDLOnTouchEvent* onTouchEventCanceled;
                __block SDLTouchEvent* cancelTouchEvent;
                __block int notificationCount;

                beforeEach(^{
                    numTimesHandlerCalled = 0;
                    notificationCount = 0;

                    SDLTouchCoord* cancelTouchCoord = [[SDLTouchCoord alloc] init];
                    cancelTouchCoord.x = @(300);
                    cancelTouchCoord.y = @(400);

                    cancelTouchEvent = [[SDLTouchEvent alloc] init];
                    cancelTouchEvent.touchEventId = @0;
                    cancelTouchEvent.coord = [NSArray arrayWithObject:cancelTouchCoord];
                    cancelTouchEvent.timeStamp = [NSArray arrayWithObject:@([[NSDate date] timeIntervalSince1970] * 1000.0)];

                    onTouchEventCanceled = [[SDLOnTouchEvent alloc] init];
                    onTouchEventCanceled.type = SDLTouchTypeCancel;
                    onTouchEventCanceled.event = [NSArray arrayWithObject:cancelTouchEvent];
                });

                context(@"when a single tap is canceled", ^{
                    it(@"should not issue delegate callbacks for a canceled single tap", ^{
                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, onTouchEventCanceled);

                        expectedDidCallSingleTap = NO;
                        expectedNumTimesHandlerCalled = 2;
                    });
                });

                context(@"when a double tap is canceled", ^{
                    __block SDLOnTouchEvent* secondOnTouchEventStart;
                    __block SDLOnTouchEvent* secondOnTouchEventCancel;
                    __block SDLTouchEvent* secondTouchEvent;

                    beforeEach(^{
                        secondTouchEvent = [[SDLTouchEvent alloc] init];
                        secondTouchEvent.touchEventId = @0;
                        NSUInteger secondTouchTimeStamp = firstTouchTimeStamp + (touchManager.tapTimeThreshold - 0.1) * 1000;
                        secondTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondTouchTimeStamp)];

                        secondOnTouchEventStart = [[SDLOnTouchEvent alloc] init];
                        secondOnTouchEventStart.type = SDLTouchTypeBegin;
                        secondOnTouchEventStart.event = [NSArray arrayWithObject:secondTouchEvent];

                        secondOnTouchEventCancel = [[SDLOnTouchEvent alloc] init];
                        secondOnTouchEventCancel.type = SDLTouchTypeCancel;
                        secondOnTouchEventCancel.event = [NSArray arrayWithObject:secondTouchEvent];
                    });

                    it(@"should not issue delegate callbacks when the second tap of a double tap is canceled", ^{
                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, firstOnTouchEventEnd);
                        performTouchEvent(touchManager, secondOnTouchEventStart);
                        performTouchEvent(touchManager, secondOnTouchEventCancel);

                        expectedDidCallDoubleTap = NO;
                        expectedNumTimesHandlerCalled = 4;
                    });

                    it(@"should not issue delegate callbacks when a double tap is canceled before the start of the second tap", ^{
                        // If the single tap timer threshold is set to less than 1 second, a single tap notification may be sent before the timer can be canceled by the CANCEL onTouchEvent
                        touchManager.tapTimeThreshold = 1.0;
                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, firstOnTouchEventEnd);
                        performTouchEvent(touchManager, secondOnTouchEventCancel);

                        expectedDidCallDoubleTap = NO;
                        expectedNumTimesHandlerCalled = 3;
                    });
                });

                afterEach(^{
                    expect(touchManager.previousTouch).toEventually(beNil());
                    expect(touchManager.singleTapTouch).toEventually(beNil());
                    expect(touchManager.singleTapTimer).toEventually(beNil());
                });
            });
        });

        context(@"when receiving a pan", ^{
            __block CGPoint panStartPoint;
            __block CGPoint panMovePoint;
            __block CGPoint panSecondMovePoint;
            __block CGPoint panEndPoint;
            __block CGPoint panCancelPointAfterMove;
            __block CGPoint panCancelPointAfterSecondMove;

            __block CGFloat distanceMoveX = 10;
            __block CGFloat distanceMoveY = 20;

            __block SDLOnTouchEvent* panStartOnTouchEvent;
            __block SDLOnTouchEvent* panMoveOnTouchEvent;
            __block SDLOnTouchEvent* panSecondMoveOnTouchEvent;
            __block SDLOnTouchEvent* panEndOnTouchEvent;
            __block SDLOnTouchEvent* panCancelAfterMoveOnTouchEvent;
            __block SDLOnTouchEvent* panCancelAfterSecondMoveOnTouchEvent;

            beforeEach(^{
                // Finger touch down
                panStartPoint = controlPoint;
                SDLTouchCoord* panStartTouchCoord = [[SDLTouchCoord alloc] init];
                panStartTouchCoord.x = @(panStartPoint.x);
                panStartTouchCoord.y = @(panStartPoint.y);
                NSUInteger panStartTimeStamp = ([[NSDate date] timeIntervalSince1970] * 1000);
                SDLTouchEvent* panStartTouchEvent = [[SDLTouchEvent alloc] init];
                panStartTouchEvent.coord = [NSArray arrayWithObject:panStartTouchCoord];
                panStartTouchEvent.timeStamp = [NSArray arrayWithObject:@(panStartTimeStamp)];
                panStartOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panStartOnTouchEvent.event = [NSArray arrayWithObject:panStartTouchEvent];
                panStartOnTouchEvent.type = SDLTouchTypeBegin;

                // Finger Move
                panMovePoint = CGPointMake(panStartPoint.x + distanceMoveX, panStartPoint.y + distanceMoveY);
                SDLTouchCoord* panMoveTouchCoord = [[SDLTouchCoord alloc] init];
                panMoveTouchCoord.x = @(panMovePoint.x);
                panMoveTouchCoord.y = @(panMovePoint.y);
                NSUInteger panMoveTimeStamp = panStartTimeStamp;
                SDLTouchEvent* panMoveTouchEvent = [[SDLTouchEvent alloc] init];
                panMoveTouchEvent.coord = [NSArray arrayWithObject:panMoveTouchCoord];
                panMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(panMoveTimeStamp)];
                panMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panMoveOnTouchEvent.event = [NSArray arrayWithObject:panMoveTouchEvent];
                panMoveOnTouchEvent.type = SDLTouchTypeMove;

                // Finger Move
                panSecondMovePoint = CGPointMake(panMovePoint.x + distanceMoveX, panMovePoint.y + distanceMoveY);
                SDLTouchCoord* panSecondMoveTouchCoord = [[SDLTouchCoord alloc] init];
                panSecondMoveTouchCoord.x = @(panSecondMovePoint.x);
                panSecondMoveTouchCoord.y = @(panSecondMovePoint.y);
                SDLTouchEvent* panSecondMoveTouchEvent = [[SDLTouchEvent alloc] init];
                panSecondMoveTouchEvent.coord = [NSArray arrayWithObject:panSecondMoveTouchCoord];
                panSecondMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(panMoveTimeStamp)];
                panSecondMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panSecondMoveOnTouchEvent.event = [NSArray arrayWithObject:panSecondMoveTouchEvent];
                panSecondMoveOnTouchEvent.type = SDLTouchTypeMove;

                // Finger End
                panEndPoint = CGPointMake(panSecondMovePoint.x, panSecondMovePoint.y);
                SDLTouchCoord* panEndTouchCoord = [[SDLTouchCoord alloc] init];
                panEndTouchCoord.x = @(panEndPoint.x);
                panEndTouchCoord.y = @(panEndPoint.y);
                SDLTouchEvent* panEndTouchEvent = [[SDLTouchEvent alloc] init];
                panEndTouchEvent.coord = [NSArray arrayWithObject:panEndTouchCoord];
                panEndTouchEvent.timeStamp = [NSArray arrayWithObject:@(panMoveTimeStamp)];
                panEndOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panEndOnTouchEvent.event = [NSArray arrayWithObject:panEndTouchEvent];
                panEndOnTouchEvent.type = SDLTouchTypeEnd;

                // Pan cancel after start
                panCancelPointAfterMove = panSecondMovePoint;
                SDLTouchCoord* panCancelAfterMoveTouchCoord = [[SDLTouchCoord alloc] init];
                panCancelAfterMoveTouchCoord.x = @(panCancelPointAfterMove.x);
                panCancelAfterMoveTouchCoord.y = @(panCancelPointAfterMove.y);
                SDLTouchEvent* panCancelAfterMoveTouchEvent = [[SDLTouchEvent alloc] init];
                panCancelAfterMoveTouchEvent.coord = [NSArray arrayWithObject:panCancelAfterMoveTouchCoord];
                panCancelAfterMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(panMoveTimeStamp)];
                panCancelAfterMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panCancelAfterMoveOnTouchEvent.event = [NSArray arrayWithObject:panCancelAfterMoveTouchEvent];
                panCancelAfterMoveOnTouchEvent.type = SDLTouchTypeCancel;

                // Pan cancel after start + move
                panCancelPointAfterSecondMove = panEndPoint;
                SDLTouchCoord* panCancelAfterSecondMoveTouchCoord = [[SDLTouchCoord alloc] init];
                panCancelAfterSecondMoveTouchCoord.x = @(panCancelPointAfterSecondMove.x);
                panCancelAfterSecondMoveTouchCoord.y = @(panCancelPointAfterSecondMove.y);
                SDLTouchEvent* panCancelAfterSecondMoveTouchEvent = [[SDLTouchEvent alloc] init];
                panCancelAfterSecondMoveTouchEvent.coord = [NSArray arrayWithObject:panCancelAfterSecondMoveTouchCoord];
                panCancelAfterSecondMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(panMoveTimeStamp)];
                panCancelAfterSecondMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panCancelAfterSecondMoveOnTouchEvent.event = [NSArray arrayWithObject:panCancelAfterSecondMoveTouchEvent];
                panCancelAfterSecondMoveOnTouchEvent.type = SDLTouchTypeCancel;
            });

            context(@"When a pan gesture not interrupted", ^{
                it(@"should correctly issue all pan delegate callbacks", ^{
                    panStartTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, panMovePoint))).to(beTruthy());
                    };

                    panMoveTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint startPoint;
                        CGPoint endPoint;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&startPoint atIndex:3];
                        [invocation getArgument:&endPoint atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(startPoint, panMovePoint))).to(beTruthy());
                        expect(@(CGPointEqualToPoint(endPoint, panSecondMovePoint))).to(beTruthy());
                    };

                    panEndTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, panEndPoint))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, panStartOnTouchEvent);
                    performTouchEvent(touchManager, panMoveOnTouchEvent);
                    [touchManager syncFrame];
                    performTouchEvent(touchManager, panSecondMoveOnTouchEvent);
                    [touchManager syncFrame];
                    performTouchEvent(touchManager, panEndOnTouchEvent);

                    expectedDidCallBeginPan = YES;
                    expectedDidCallMovePan = YES;
                    expectedDidCallEndPan = YES;
                    expectedDidCallCancelPan = NO;
                    expectedNumTimesHandlerCalled = 4;
                });
            });

            context(@"when a pan gesture is canceled", ^{
                it(@"should issue a cancel pan delegate callback when the pan is canceled right after first move detected", ^{
                    panStartTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, panMovePoint))).to(beTruthy());
                    };

                    panCanceledTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, panCancelPointAfterMove))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, panStartOnTouchEvent);
                    performTouchEvent(touchManager, panMoveOnTouchEvent);
                    performTouchEvent(touchManager, panCancelAfterMoveOnTouchEvent);

                    expectedDidCallBeginPan = YES;
                    expectedDidCallMovePan = NO;
                    expectedDidCallEndPan = NO;
                    expectedDidCallCancelPan = YES;
                    expectedNumTimesHandlerCalled = 3;
                });

                it(@"should issue a cancel pan delegate callback when a pan is canceled right after second move detected", ^{
                    panStartTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, panMovePoint))).to(beTruthy());
                    };

                    panMoveTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint startPoint;
                        CGPoint endPoint;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&startPoint atIndex:3];
                        [invocation getArgument:&endPoint atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(startPoint, panMovePoint))).to(beTruthy());
                        expect(@(CGPointEqualToPoint(endPoint, panSecondMovePoint))).to(beTruthy());
                    };

                    panCanceledTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];
                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, panCancelPointAfterSecondMove))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, panStartOnTouchEvent);
                    performTouchEvent(touchManager, panMoveOnTouchEvent);
                    [touchManager syncFrame];
                    performTouchEvent(touchManager, panSecondMoveOnTouchEvent);
                    [touchManager syncFrame];
                    performTouchEvent(touchManager, panCancelAfterMoveOnTouchEvent);

                    expectedDidCallBeginPan = YES;
                    expectedDidCallMovePan = YES;
                    expectedDidCallEndPan = NO;
                    expectedDidCallCancelPan = YES;
                    expectedNumTimesHandlerCalled = 4;
                });

                it(@"should not issue a cancel pan delegate callback if the cancel onTouchEvent is received while a pan gesture is not in progress", ^{
                    performTouchEvent(touchManager, panCancelAfterSecondMoveOnTouchEvent);

                    expectedDidCallBeginPan = NO;
                    expectedDidCallMovePan = NO;
                    expectedDidCallEndPan = NO;
                    expectedDidCallCancelPan = NO;
                    expectedNumTimesHandlerCalled = 1;
                });

                afterEach(^{
                    expect(touchManager.currentPinchGesture).toEventually(beNil());
                });
            });
        });

        context(@"when receiving a pinch gesture", ^{
            __block CGPoint pinchStartCenter;
            __block CGPoint pinchMoveCenter;
            __block CGFloat pinchMoveScale;
            __block CGPoint pinchEndCenter;
            __block CGPoint pinchFirstFingerCancelCenter;
            __block CGPoint pinchSecondFingerCancelCenter;

            __block SDLOnTouchEvent* pinchStartFirstFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchStartSecondFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchStartTwoFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchMoveSecondFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchEndSecondFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchCancelFirstFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchCancelSecondFingerOnTouchEvent;

            beforeEach(^{
                // First finger touch down
                SDLTouchCoord* firstFingerTouchCoord = [[SDLTouchCoord alloc] init];
                firstFingerTouchCoord.x = @(controlPoint.x);
                firstFingerTouchCoord.y = @(controlPoint.y);
                NSUInteger firstFingerTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
                SDLTouchEvent* firstFingerTouchEvent = [[SDLTouchEvent alloc] init];
                firstFingerTouchEvent.coord = [NSArray arrayWithObject:firstFingerTouchCoord];
                firstFingerTouchEvent.timeStamp = [NSArray arrayWithObject:@(firstFingerTimeStamp)];
                pinchStartFirstFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchStartFirstFingerOnTouchEvent.event = [NSArray arrayWithObject:firstFingerTouchEvent];
                pinchStartFirstFingerOnTouchEvent.type = SDLTouchTypeBegin;

                // Second finger touch down
                SDLTouchCoord* secondFingerTouchCoord = [[SDLTouchCoord alloc] init];
                secondFingerTouchCoord.x = @(firstFingerTouchCoord.x.floatValue + 100);
                secondFingerTouchCoord.y = @(firstFingerTouchCoord.y.floatValue + 100);
                NSUInteger secondFingerTimeStamp = firstFingerTimeStamp;
                SDLTouchEvent* secondFingerTouchEvent = [[SDLTouchEvent alloc] init];
                secondFingerTouchEvent.touchEventId = @1;
                secondFingerTouchEvent.coord = [NSArray arrayWithObject:secondFingerTouchCoord];
                secondFingerTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondFingerTimeStamp)];
                pinchStartSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchStartSecondFingerOnTouchEvent.event = [NSArray arrayWithObject:secondFingerTouchEvent];
                pinchStartSecondFingerOnTouchEvent.type = SDLTouchTypeBegin;
                pinchStartCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerTouchCoord.x.floatValue) / 2.0f,
                                               (firstFingerTouchCoord.y.floatValue + secondFingerTouchCoord.y.floatValue) / 2.0f);
                CGFloat pinchStartDistance = hypotf(firstFingerTouchCoord.x.floatValue - secondFingerTouchCoord.x.floatValue,
                                                    firstFingerTouchCoord.y.floatValue - secondFingerTouchCoord.y.floatValue);

                // First and second finger touch down
                pinchStartTwoFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchStartTwoFingerOnTouchEvent.event = [NSArray arrayWithObjects:firstFingerTouchEvent, secondFingerTouchEvent, nil];
                pinchStartTwoFingerOnTouchEvent.type = SDLTouchTypeBegin;

                // Second finger move
                SDLTouchCoord* secondFingerMoveTouchCoord = [[SDLTouchCoord alloc] init];
                secondFingerMoveTouchCoord.x = @(secondFingerTouchCoord.x.floatValue - 50);
                secondFingerMoveTouchCoord.y = @(secondFingerTouchCoord.y.floatValue - 40);
                SDLTouchEvent* secondFingerMoveTouchEvent = [[SDLTouchEvent alloc] init];
                secondFingerMoveTouchEvent.touchEventId = @1;
                secondFingerMoveTouchEvent.coord = [NSArray arrayWithObject:secondFingerMoveTouchCoord];
                secondFingerMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondFingerTimeStamp)];
                pinchMoveSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchMoveSecondFingerOnTouchEvent.event = [NSArray arrayWithObject:secondFingerMoveTouchEvent];
                pinchMoveSecondFingerOnTouchEvent.type = SDLTouchTypeMove;
                pinchMoveCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerMoveTouchCoord.x.floatValue) / 2.0f,
                                              (firstFingerTouchCoord.y.floatValue + secondFingerMoveTouchCoord.y.floatValue) / 2.0f);
                CGFloat pinchMoveDistance = hypotf(firstFingerTouchCoord.x.floatValue - secondFingerMoveTouchCoord.x.floatValue,
                                                   firstFingerTouchCoord.y.floatValue - secondFingerMoveTouchCoord.y.floatValue);
                pinchMoveScale = pinchMoveDistance / pinchStartDistance;

                // Second finger end
                SDLTouchCoord* secondFingerEndTouchCoord = secondFingerMoveTouchCoord;
                SDLTouchEvent* secondFingerEndTouchEvent = [[SDLTouchEvent alloc] init];
                secondFingerEndTouchEvent.touchEventId = @1;
                secondFingerEndTouchEvent.coord = [NSArray arrayWithObject:secondFingerEndTouchCoord];
                secondFingerEndTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondFingerTimeStamp)];
                pinchEndSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchEndSecondFingerOnTouchEvent.event = [NSArray arrayWithObject:secondFingerEndTouchEvent];
                pinchEndSecondFingerOnTouchEvent.type = SDLTouchTypeEnd;
                pinchEndCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerEndTouchCoord.x.floatValue) / 2.0f, (firstFingerTouchCoord.y.floatValue + secondFingerEndTouchCoord.y.floatValue) / 2.0f);

                // First finger cancel
                SDLTouchCoord* firstFingerCanceledTouchCoord = secondFingerMoveTouchCoord;
                SDLTouchEvent* firstFingerCanceledTouchEvent = [[SDLTouchEvent alloc] init];
                firstFingerCanceledTouchEvent.touchEventId = @0;
                firstFingerCanceledTouchEvent.coord = [NSArray arrayWithObject:firstFingerCanceledTouchCoord];
                firstFingerCanceledTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondFingerTimeStamp)];
                pinchCancelFirstFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchCancelFirstFingerOnTouchEvent.event = [NSArray arrayWithObject:firstFingerCanceledTouchEvent];
                pinchCancelFirstFingerOnTouchEvent.type = SDLTouchTypeCancel;
                pinchFirstFingerCancelCenter = CGPointMake((firstFingerCanceledTouchCoord.x.floatValue + secondFingerTouchCoord.x.floatValue) / 2.0f, (firstFingerCanceledTouchCoord.y.floatValue + secondFingerTouchCoord.y.floatValue) / 2.0f);

                // Second finger cancel
                SDLTouchCoord* secondFingerCanceledTouchCoord = secondFingerMoveTouchCoord;
                SDLTouchEvent* secondFingerCanceledTouchEvent = [[SDLTouchEvent alloc] init];
                secondFingerCanceledTouchEvent.touchEventId = @1;
                secondFingerCanceledTouchEvent.coord = [NSArray arrayWithObject:secondFingerCanceledTouchCoord];
                secondFingerCanceledTouchEvent.timeStamp = [NSArray arrayWithObject:@(firstFingerTimeStamp)];
                pinchCancelSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchCancelSecondFingerOnTouchEvent.event = [NSArray arrayWithObject:secondFingerCanceledTouchEvent];
                pinchCancelSecondFingerOnTouchEvent.type = SDLTouchTypeCancel;
                pinchSecondFingerCancelCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerCanceledTouchCoord.x.floatValue) / 2.0f, (firstFingerTouchCoord.y.floatValue + secondFingerCanceledTouchCoord.y.floatValue) / 2.0f);
            });

            context(@"When a pinch gesture is not interrupted", ^{
                it(@"should correctly send all pinch delegate callbacks", ^{
                    pinchStartTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;

                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchStartCenter))).to(beTruthy());
                    };

                    pinchMoveTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;

                        CGPoint point;
                        CGFloat scale;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];
                        [invocation getArgument:&scale atIndex:4];
                        
                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchMoveCenter))).to(beTruthy());
                        expect(@(scale)).to(beCloseTo(@(pinchMoveScale)).within(0.0001));
                    };
                    
                    pinchEndTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];
                        
                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchEndCenter))).to(beTruthy());
                    };
                    
                    performTouchEvent(touchManager, pinchStartFirstFingerOnTouchEvent);
                    performTouchEvent(touchManager, pinchStartSecondFingerOnTouchEvent);
                    performTouchEvent(touchManager, pinchMoveSecondFingerOnTouchEvent);
                    [touchManager syncFrame];
                    performTouchEvent(touchManager, pinchEndSecondFingerOnTouchEvent);

                    expectedDidCallBeginPinch = YES;
                    expectedDidCallMovePinch = YES;
                    expectedDidCallEndPinch = YES;
                    expectedDidCallCancelPinch = NO;
                    expectedNumTimesHandlerCalled = 4;
                });
            });

            context(@"when first and second touch begin events are notified with single SDLOnTouchEvent, and pinch gesture is not interrupted", ^{
                it(@"should correctly send all pinch delegate callbacks", ^{
                    pinchStartTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;

                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchStartCenter))).to(beTruthy());
                    };

                    pinchMoveTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;

                        CGPoint point;
                        CGFloat scale;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];
                        [invocation getArgument:&scale atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchMoveCenter))).to(beTruthy());
                        expect(@(scale)).to(beCloseTo(@(pinchMoveScale)).within(0.0001));
                    };

                    pinchEndTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;

                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchEndCenter))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, pinchStartTwoFingerOnTouchEvent);
                    performTouchEvent(touchManager, pinchMoveSecondFingerOnTouchEvent);
                    [touchManager syncFrame];
                    performTouchEvent(touchManager, pinchEndSecondFingerOnTouchEvent);

                    expectedDidCallBeginPinch = YES;
                    expectedDidCallMovePinch = YES;
                    expectedDidCallEndPinch = YES;
                    expectedDidCallCancelPinch = NO;
                    expectedNumTimesHandlerCalled = 4;
                });
            });
            
            context(@"when a pinch gesture is canceled", ^{
                it(@"should notify delegates if pinch is canceled right after it started", ^{
                    pinchStartTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchStartCenter))).to(beTruthy());
                    };

                    pinchCanceledTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchFirstFingerCancelCenter))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, pinchStartFirstFingerOnTouchEvent);
                    performTouchEvent(touchManager, pinchStartSecondFingerOnTouchEvent);
                    performTouchEvent(touchManager, pinchCancelFirstFingerOnTouchEvent);

                    expectedDidCallBeginPinch = YES;
                    expectedDidCallMovePinch = NO;
                    expectedDidCallEndPinch = NO;
                    expectedDidCallCancelPinch = YES;
                    expectedNumTimesHandlerCalled = 3;
                });

                it(@"should notify delegates if pinch is canceled while it is in progress", ^{
                    pinchStartTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchStartCenter))).to(beTruthy());
                    };

                    pinchMoveTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        CGFloat scale;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];
                        [invocation getArgument:&scale atIndex:4];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchMoveCenter))).to(beTruthy());
                        expect(@(scale)).to(beCloseTo(@(pinchMoveScale)).within(0.0001));
                    };

                    pinchCanceledTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        CGPoint point;
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];

                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, pinchSecondFingerCancelCenter))).to(beTruthy());
                    };

                    performTouchEvent(touchManager, pinchStartFirstFingerOnTouchEvent);
                    performTouchEvent(touchManager, pinchStartSecondFingerOnTouchEvent);
                    performTouchEvent(touchManager, pinchMoveSecondFingerOnTouchEvent);
                    [touchManager syncFrame];
                    performTouchEvent(touchManager, pinchCancelSecondFingerOnTouchEvent);

                    expectedDidCallBeginPinch = YES;
                    expectedDidCallMovePinch = YES;
                    expectedDidCallEndPinch = NO;
                    expectedDidCallCancelPinch = YES;
                    expectedNumTimesHandlerCalled = 4;
                });

                it(@"should not issue a cancel pinch delegate callback if the cancel onTouchEvent is received while a pinch gesture is not in progress", ^{
                    performTouchEvent(touchManager, pinchCancelSecondFingerOnTouchEvent);

                    expectedDidCallBeginPinch = NO;
                    expectedDidCallMovePinch = NO;
                    expectedDidCallEndPinch = NO;
                    expectedDidCallCancelPinch = NO;
                    expectedNumTimesHandlerCalled = 1;
                });

                afterEach(^{
                    expect(touchManager.currentPinchGesture).toEventually(beNil());
                });
            });
        });

        afterEach(^{
            CGFloat timeoutTime = touchManager.tapTimeThreshold + additionalWaitTime;
            expect(@(didCallSingleTap)).withTimeout(timeoutTime).toEventually(expectedDidCallSingleTap ? beTruthy() : beFalsy());
            expect(@(didCallDoubleTap)).withTimeout(timeoutTime).toEventually(expectedDidCallDoubleTap ? beTruthy() : beFalsy());
            expect(@(didCallBeginPan)).withTimeout(timeoutTime).toEventually(expectedDidCallBeginPan ? beTruthy() : beFalsy());
            expect(@(didCallMovePan)).withTimeout(timeoutTime).toEventually(expectedDidCallMovePan ? beTruthy() : beFalsy());
            expect(@(didCallEndPan)).withTimeout(timeoutTime).toEventually(expectedDidCallEndPan ? beTruthy() : beFalsy());
            expect(@(didCallCancelPan)).withTimeout(timeoutTime).toEventually(expectedDidCallCancelPan ? beTruthy() : beFalsy());
            expect(@(didCallBeginPinch)).withTimeout(timeoutTime).toEventually(expectedDidCallBeginPinch ? beTruthy() : beFalsy());
            expect(@(didCallMovePinch)).withTimeout(timeoutTime).toEventually(expectedDidCallMovePinch ? beTruthy() : beFalsy());
            expect(@(didCallEndPinch)).withTimeout(timeoutTime).toEventually(expectedDidCallEndPinch ? beTruthy() : beFalsy());
            expect(@(didCallCancelPinch)).withTimeout(timeoutTime).toEventually(expectedDidCallCancelPinch ? beTruthy() : beFalsy());

            expect(numTimesHandlerCalled).to(equal(@(expectedNumTimesHandlerCalled)));
        });
    });
});

QuickSpecEnd
