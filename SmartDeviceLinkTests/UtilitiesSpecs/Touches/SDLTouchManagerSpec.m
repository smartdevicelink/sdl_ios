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
#import "SDLOnTouchEvent.h"
#import "SDLPinchGesture.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouchManager.h"
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

    __block SDLTouchManager* touchManager;

    context(@"initializing", ^{
        it(@"should correctly have default properties", ^{
            SDLTouchManager* touchManager = [[SDLTouchManager alloc] init];
            expect(touchManager.touchEventDelegate).to(beNil());
            expect(@(touchManager.tapDistanceThreshold)).to(equal(@50));
            expect(@(touchManager.tapTimeThreshold)).to(beCloseTo(@0.4).within(0.0001));
            expect(@(touchManager.movementTimeThreshold)).to(beCloseTo(@0.05).within(0.0001));
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

        __block NSUInteger numTimesHandlerCalled = 0;

        __block void (^performTouchEvent)(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) = ^(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) {
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveTouchEventNotification object:nil rpcNotification:onTouchEvent];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        };

        beforeEach(^{
            touchManager = [[SDLTouchManager alloc] init];
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
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceiveSingleTapAtPoint:CGPointZero];
            singleTapTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Single Tap Tests.");
            };

            didCallDoubleTap = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallDoubleTap = YES;
                doubleTapTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceiveDoubleTapAtPoint:CGPointZero];
            doubleTapTests = ^(NSInvocation* invocation) {
                failWithMessage(@"Failed to call Double Tap Tests.");
            };

            didCallBeginPan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallBeginPan = YES;
                panStartTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] panningDidStartAtPoint:CGPointZero];
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
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] panningDidEndAtPoint:CGPointZero];
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
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] pinchDidStartAtCenterPoint:CGPointZero];
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
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] pinchDidEndAtCenterPoint:CGPointZero];
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
        });

        describe(@"Single Finger", ^{
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

//            describe(@"when receiving a single tap", ^{
//                beforeEach(^{
//                    numTimesHandlerCalled = 0;
//
//                    singleTapTests = ^(NSInvocation* invocation) {
//                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
//
//                        CGPoint point;
//
//                        [invocation getArgument:&touchManagerCallback atIndex:2];
//                        [invocation getArgument:&point atIndex:3];
//
//                        expect(touchManagerCallback).to(equal(touchManager));
//                        expect(@(CGPointEqualToPoint(point, controlPoint))).to(beTruthy());
//                    };
//
//                    performTouchEvent(touchManager, firstOnTouchEventStart);
//                    performTouchEvent(touchManager, firstOnTouchEventEnd);
//                });
//
//                it(@"should correctly handle a single tap", ^{
//                    expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
//                    expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                });
//
//                it(@"should run the handler", ^{
//                    expect(@(numTimesHandlerCalled)).to(equal(@2));
//                });
//            });
//
//            describe(@"when receiving a double tap", ^{
//                __block CGPoint averagePoint;
//
//                __block SDLTouchEvent* secondTouchEvent;
//
//                __block SDLOnTouchEvent* secondOnTouchEventStart;
//                __block SDLOnTouchEvent* secondOnTouchEventEnd;
//
//                beforeEach(^{
//                    secondOnTouchEventStart = [[SDLOnTouchEvent alloc] init];
//                    secondOnTouchEventStart.type = SDLTouchTypeBegin;
//
//                    secondOnTouchEventEnd = [[SDLOnTouchEvent alloc] init];
//                    secondOnTouchEventEnd.type = SDLTouchTypeEnd;
//
//                    secondTouchEvent = [[SDLTouchEvent alloc] init];
//                    secondTouchEvent.touchEventId = @0;
//                    NSUInteger secondTouchTimeStamp = firstTouchTimeStamp + (touchManager.tapTimeThreshold - 0.1) * 1000;
//                    secondTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondTouchTimeStamp)];
//                });
//
//                context(@"near the same point", ^{
//                    beforeEach(^{
//                        numTimesHandlerCalled = 0;
//
//                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
//                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold);
//                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold);
//
//                        secondTouchEvent.coord = [NSArray arrayWithObject:touchCoord];
//
//                        secondOnTouchEventStart.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        secondOnTouchEventEnd.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        averagePoint = CGPointMake((firstTouchCoord.x.floatValue + touchCoord.x.floatValue) / 2.0f,
//                                                   (firstTouchCoord.y.floatValue + touchCoord.y.floatValue) / 2.0f);
//
//                        doubleTapTests = ^(NSInvocation* invocation) {
//                            __unsafe_unretained SDLTouchManager* touchManagerCallback;
//
//                            CGPoint point;
//
//                            [invocation getArgument:&touchManagerCallback atIndex:2];
//                            [invocation getArgument:&point atIndex:3];
//
//                            expect(touchManagerCallback).to(equal(touchManager));
//                            expect(@(CGPointEqualToPoint(point, averagePoint))).to(beTruthy());
//                        };
//
//                        performTouchEvent(touchManager, firstOnTouchEventStart);
//                        performTouchEvent(touchManager, firstOnTouchEventEnd);
//                        performTouchEvent(touchManager, secondOnTouchEventStart);
//                        performTouchEvent(touchManager, secondOnTouchEventEnd);
//
//                    });
//
//                    it(@"should issue delegate callbacks", ^{
//                        expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
//                        expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    });
//
//                    it(@"should run the handler", ^{
//                        expect(@(numTimesHandlerCalled)).to(equal(@4));
//                    });
//                });
//
//                context(@"not near the same point", ^{
//                    beforeEach(^{
//                        numTimesHandlerCalled = 0;
//
//                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
//                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold + 1);
//                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold + 1);
//
//                        secondTouchEvent.coord = [NSArray arrayWithObject:touchCoord];
//
//                        secondOnTouchEventStart.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        secondOnTouchEventEnd.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        performTouchEvent(touchManager, firstOnTouchEventStart);
//                        performTouchEvent(touchManager, firstOnTouchEventEnd);
//                        performTouchEvent(touchManager, secondOnTouchEventStart);
//                        performTouchEvent(touchManager, secondOnTouchEventEnd);
//
//                    });
//
//                    it(@"should should not issue delegate callbacks", ^{
//                        expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                        expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    });
//
//                    it(@"should run the handler", ^{
//                        expect(@(numTimesHandlerCalled)).to(equal(@4));
//                    });
//                });
//            });

            describe(@"when a single or double tap is canceled", ^{
                __block SDLOnTouchEvent* onTouchEventCanceled;
                __block SDLTouchEvent* cancelTouchEvent;

                beforeEach(^{
                    numTimesHandlerCalled = 0;

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

//                it(@"should not notify delegates when a single tap is canceled", ^{
//                    performTouchEvent(touchManager, firstOnTouchEventStart);
//                    performTouchEvent(touchManager, onTouchEventCanceled);
//                    expect(numTimesHandlerCalled).to(equal(@2));
//                });

                context(@"", ^{
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

//                    it(@"should not notify delegates when the second tap of a double tap is canceled", ^{
//                        performTouchEvent(touchManager, firstOnTouchEventStart);
//                        performTouchEvent(touchManager, firstOnTouchEventEnd);
//                        performTouchEvent(touchManager, secondOnTouchEventStart);
//                        performTouchEvent(touchManager, secondOnTouchEventCancel);
//                        expect(numTimesHandlerCalled).to(equal(@(4)));
//                    });

                    it(@"should not notify delegates when a double tap is canceled before the start of the second tap", ^{
                        touchManager.tapTimeThreshold = 1.5;
                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, firstOnTouchEventEnd);
//                        performTouchEvent(touchManager, secondOnTouchEventStart);
                        performTouchEvent(touchManager, secondOnTouchEventCancel);
//                        expect(numTimesHandlerCalled).to(equal(@(3)));
                    });
                });

                afterEach(^{
                    expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallCancelPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallCancelPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());

                    expect(touchManager.previousTouch).toEventually(beNil());
                    expect(touchManager.singleTapTouch).toEventually(beNil());
                    expect(touchManager.singleTapTimer).toEventually(beNil());
                });
            });

//            describe(@"when a double tap is canceled", ^{
//                context(@"should cancel a double tap without a notification", ^{
//                    __block CGPoint averagePoint;
//                    __block SDLTouchEvent* secondTouchEvent;
//                    __block SDLOnTouchEvent* secondOnTouchEventStart;
//                    __block SDLOnTouchEvent* secondOnTouchEventEnd;
//
//                    beforeEach(^{
//                        secondOnTouchEventStart = [[SDLOnTouchEvent alloc] init];
//                        secondOnTouchEventStart.type = SDLTouchTypeBegin;
//
//                        secondOnTouchEventEnd = [[SDLOnTouchEvent alloc] init];
//                        secondOnTouchEventEnd.type = SDLTouchTypeEnd;
//
//                        secondTouchEvent = [[SDLTouchEvent alloc] init];
//                        secondTouchEvent.touchEventId = @0;
//                        NSUInteger secondTouchTimeStamp = firstTouchTimeStamp + (touchManager.tapTimeThreshold - 0.1) * 1000;
//                        secondTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondTouchTimeStamp)];
//                    });
//
//                    it(@"should cancel if the first tap is canceled", ^{
//                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
//                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold);
//                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold);
//
//                        secondTouchEvent.coord = [NSArray arrayWithObject:touchCoord];
//
//                        secondOnTouchEventStart.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        secondOnTouchEventEnd.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        averagePoint = CGPointMake((firstTouchCoord.x.floatValue + touchCoord.x.floatValue) / 2.0f,
//                                                   (firstTouchCoord.y.floatValue + touchCoord.y.floatValue) / 2.0f);
//
//                        doubleTapTests = ^(NSInvocation* invocation) {
//                            __unsafe_unretained SDLTouchManager* touchManagerCallback;
//
//                            CGPoint point;
//
//                            [invocation getArgument:&touchManagerCallback atIndex:2];
//                            [invocation getArgument:&point atIndex:3];
//
//                            expect(touchManagerCallback).to(equal(touchManager));
//                            expect(@(CGPointEqualToPoint(point, averagePoint))).to(beTruthy());
//                        };
//
//                        performTouchEvent(touchManager, firstOnTouchEventStart);
//                        performTouchEvent(touchManager, firstOnTouchEventCanceled);
//                    });
//
//                    it(@"should cancel if a second tap is canceled", ^{
//                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
//                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold);
//                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold);
//
//                        secondTouchEvent.coord = [NSArray arrayWithObject:touchCoord];
//
//                        secondOnTouchEventStart.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        secondOnTouchEventEnd.event = [NSArray arrayWithObject:secondTouchEvent];
//
//                        averagePoint = CGPointMake((firstTouchCoord.x.floatValue + touchCoord.x.floatValue) / 2.0f,
//                                                   (firstTouchCoord.y.floatValue + touchCoord.y.floatValue) / 2.0f);
//
//                        doubleTapTests = ^(NSInvocation* invocation) {
//                            __unsafe_unretained SDLTouchManager* touchManagerCallback;
//
//                            CGPoint point;
//
//                            [invocation getArgument:&touchManagerCallback atIndex:2];
//                            [invocation getArgument:&point atIndex:3];
//
//                            expect(touchManagerCallback).to(equal(touchManager));
//                            expect(@(CGPointEqualToPoint(point, averagePoint))).to(beTruthy());
//                        };
//
//                        performTouchEvent(touchManager, firstOnTouchEventStart);
//                        performTouchEvent(touchManager, firstOnTouchEventEnd);
//                        performTouchEvent(touchManager, secondOnTouchEventStart);
//                        performTouchEvent(touchManager, secondOnTouchEventCanceled);
//                    });
//
//                    afterEach(^{
//
//                    });
//                });
//
//                afterEach(^{
//                    expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//                    expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
//
//                    expect(@(numTimesHandlerCalled)).to(equal(@2));
//                });
//            });
        });

        //        context(@"when receiving a pan", ^{
        //            __block CGPoint panStartPoint;
        //            __block CGPoint panMovePoint;
        //            __block CGPoint panSecondMovePoint;
        //            __block CGPoint panEndPoint;
        //
        //            __block CGFloat distanceMoveX = 10;
        //            __block CGFloat distanceMoveY = 20;
        //
        //            __block SDLOnTouchEvent* panStartOnTouchEvent;
        //            __block SDLOnTouchEvent* panMoveOnTouchEvent;
        //            __block SDLOnTouchEvent* panSecondMoveOnTouchEvent;
        //            __block SDLOnTouchEvent* panEndOnTouchEvent;
        //
        //            beforeEach(^{
        //                numTimesHandlerCalled = 0;
        //
        //                // Finger touch down
        //                panStartPoint = controlPoint;
        //
        //                SDLTouchCoord* panStartTouchCoord = [[SDLTouchCoord alloc] init];
        //                panStartTouchCoord.x = @(panStartPoint.x);
        //                panStartTouchCoord.y = @(panStartPoint.y);
        //
        //                double movementTimeThresholdOffset = (touchManager.movementTimeThreshold + .01) * 1000;
        //
        //                NSUInteger panStartTimeStamp = ([[NSDate date] timeIntervalSince1970] * 1000) + movementTimeThresholdOffset;
        //
        //                SDLTouchEvent* panStartTouchEvent = [[SDLTouchEvent alloc] init];
        //                panStartTouchEvent.coord = [NSArray arrayWithObject:panStartTouchCoord];
        //                panStartTouchEvent.timeStamp = [NSArray arrayWithObject:@(panStartTimeStamp)];
        //
        //                panStartOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                panStartOnTouchEvent.event = [NSArray arrayWithObject:panStartTouchEvent];
        //                panStartOnTouchEvent.type = SDLTouchTypeBegin;
        //
        //                // Finger Move
        //                panMovePoint = CGPointMake(panStartPoint.x + distanceMoveX, panStartPoint.y + distanceMoveY);
        //
        //                SDLTouchCoord* panMoveTouchCoord = [[SDLTouchCoord alloc] init];
        //                panMoveTouchCoord.x = @(panMovePoint.x);
        //                panMoveTouchCoord.y = @(panMovePoint.y);
        //
        //                NSUInteger panMoveTimeStamp = panStartTimeStamp + movementTimeThresholdOffset;
        //
        //                SDLTouchEvent* panMoveTouchEvent = [[SDLTouchEvent alloc] init];
        //                panMoveTouchEvent.coord = [NSArray arrayWithObject:panMoveTouchCoord];
        //                panMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(panMoveTimeStamp)];
        //
        //                panMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                panMoveOnTouchEvent.event = [NSArray arrayWithObject:panMoveTouchEvent];
        //                panMoveOnTouchEvent.type = SDLTouchTypeMove;
        //
        //                // Finger Move
        //                panSecondMovePoint = CGPointMake(panMovePoint.x + distanceMoveX, panMovePoint.y + distanceMoveY);
        //
        //                SDLTouchCoord* panSecondMoveTouchCoord = [[SDLTouchCoord alloc] init];
        //                panSecondMoveTouchCoord.x = @(panSecondMovePoint.x);
        //                panSecondMoveTouchCoord.y = @(panSecondMovePoint.y);
        //
        //                NSUInteger panSecondMoveTimeStamp = panMoveTimeStamp + movementTimeThresholdOffset;
        //
        //                SDLTouchEvent* panSecondMoveTouchEvent = [[SDLTouchEvent alloc] init];
        //                panSecondMoveTouchEvent.coord = [NSArray arrayWithObject:panSecondMoveTouchCoord];
        //                panSecondMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(panSecondMoveTimeStamp)];
        //
        //                panSecondMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                panSecondMoveOnTouchEvent.event = [NSArray arrayWithObject:panSecondMoveTouchEvent];
        //                panSecondMoveOnTouchEvent.type = SDLTouchTypeMove;
        //
        //                // Finger End
        //                panEndPoint = CGPointMake(panSecondMovePoint.x, panSecondMovePoint.y);
        //
        //                SDLTouchCoord* panEndTouchCoord = [[SDLTouchCoord alloc] init];
        //                panEndTouchCoord.x = @(panEndPoint.x);
        //                panEndTouchCoord.y = @(panEndPoint.y);
        //
        //                NSUInteger panEndTimeStamp = panSecondMoveTimeStamp + movementTimeThresholdOffset;
        //
        //                SDLTouchEvent* panEndTouchEvent = [[SDLTouchEvent alloc] init];
        //                panEndTouchEvent.coord = [NSArray arrayWithObject:panEndTouchCoord];
        //                panEndTouchEvent.timeStamp = [NSArray arrayWithObject:@(panEndTimeStamp)];
        //
        //                panEndOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                panEndOnTouchEvent.event = [NSArray arrayWithObject:panEndTouchEvent];
        //                panEndOnTouchEvent.type = SDLTouchTypeEnd;
        //
        //                panStartTests = ^(NSInvocation* invocation) {
        //                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
        //
        //                    CGPoint point;
        //
        //                    [invocation getArgument:&touchManagerCallback atIndex:2];
        //                    [invocation getArgument:&point atIndex:3];
        //
        //                    expect(touchManagerCallback).to(equal(touchManager));
        //                    expect(@(CGPointEqualToPoint(point, panMovePoint))).to(beTruthy());
        //                };
        //
        //                panMoveTests = ^(NSInvocation* invocation) {
        //                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
        //
        //                    CGPoint startPoint;
        //                    CGPoint endPoint;
        //
        //                    [invocation getArgument:&touchManagerCallback atIndex:2];
        //                    [invocation getArgument:&startPoint atIndex:3];
        //                    [invocation getArgument:&endPoint atIndex:4];
        //
        //                    expect(touchManagerCallback).to(equal(touchManager));
        //                    expect(@(CGPointEqualToPoint(startPoint, panMovePoint))).to(beTruthy());
        //                    expect(@(CGPointEqualToPoint(endPoint, panSecondMovePoint))).to(beTruthy());
        //                };
        //
        //                panEndTests = ^(NSInvocation* invocation) {
        //                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
        //
        //                    CGPoint point;
        //
        //                    [invocation getArgument:&touchManagerCallback atIndex:2];
        //                    [invocation getArgument:&point atIndex:3];
        //
        //                    expect(touchManagerCallback).to(equal(touchManager));
        //                    expect(@(CGPointEqualToPoint(point, panEndPoint))).to(beTruthy());
        //                };
        //
        //                performTouchEvent(touchManager, panStartOnTouchEvent);
        //                performTouchEvent(touchManager, panMoveOnTouchEvent);
        //                performTouchEvent(touchManager, panSecondMoveOnTouchEvent);
        //                performTouchEvent(touchManager, panEndOnTouchEvent);
        //            });
        //
        //            it(@"should correctly give all pan callbacks", ^{
        //                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
        //                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
        //                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
        //                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //            });
        //
        //            it(@"should run the handler", ^{
        //                expect(@(numTimesHandlerCalled)).to(equal(@4));
        //            });
        //        });

        //        context(@"when receiving a pinch", ^{
        //            __block CGPoint pinchStartCenter;
        //            __block CGPoint pinchMoveCenter;
        //            __block CGFloat pinchMoveScale;
        //            __block CGPoint pinchEndCenter;
        //
        //            __block SDLOnTouchEvent* pinchStartFirstFingerOnTouchEvent;
        //            __block SDLOnTouchEvent* pinchStartSecondFingerOnTouchEvent;
        //            __block SDLOnTouchEvent* pinchMoveSecondFingerOnTouchEvent;
        //            __block SDLOnTouchEvent* pinchEndSecondFingerOnTouchEvent;
        //
        //            beforeEach(^{
        //                numTimesHandlerCalled = 0;
        //
        //                // First finger touch down
        //                SDLTouchCoord* firstFingerTouchCoord = [[SDLTouchCoord alloc] init];
        //                firstFingerTouchCoord.x = @(controlPoint.x);
        //                firstFingerTouchCoord.y = @(controlPoint.y);
        //
        //                NSUInteger firstFingerTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        //
        //                SDLTouchEvent* firstFingerTouchEvent = [[SDLTouchEvent alloc] init];
        //                firstFingerTouchEvent.coord = [NSArray arrayWithObject:firstFingerTouchCoord];
        //                firstFingerTouchEvent.timeStamp = [NSArray arrayWithObject:@(firstFingerTimeStamp)];
        //
        //                pinchStartFirstFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                pinchStartFirstFingerOnTouchEvent.event = [NSArray arrayWithObject:firstFingerTouchEvent];
        //                pinchStartFirstFingerOnTouchEvent.type = SDLTouchTypeBegin;
        //
        //                // Second finger touch down
        //                SDLTouchCoord* secondFingerTouchCoord = [[SDLTouchCoord alloc] init];
        //                secondFingerTouchCoord.x = @(firstFingerTouchCoord.x.floatValue + 100);
        //                secondFingerTouchCoord.y = @(firstFingerTouchCoord.y.floatValue + 100);
        //
        //                NSUInteger secondFingerTimeStamp = firstFingerTimeStamp;
        //
        //                SDLTouchEvent* secondFingerTouchEvent = [[SDLTouchEvent alloc] init];
        //                secondFingerTouchEvent.touchEventId = @1;
        //                secondFingerTouchEvent.coord = [NSArray arrayWithObject:secondFingerTouchCoord];
        //                secondFingerTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondFingerTimeStamp)];
        //
        //                pinchStartSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                pinchStartSecondFingerOnTouchEvent.event = [NSArray arrayWithObject:secondFingerTouchEvent];
        //                pinchStartSecondFingerOnTouchEvent.type = SDLTouchTypeBegin;
        //
        //                pinchStartCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerTouchCoord.x.floatValue) / 2.0f,
        //                                               (firstFingerTouchCoord.y.floatValue + secondFingerTouchCoord.y.floatValue) / 2.0f);
        //
        //                CGFloat pinchStartDistance = hypotf(firstFingerTouchCoord.x.floatValue - secondFingerTouchCoord.x.floatValue,
        //                                                    firstFingerTouchCoord.y.floatValue - secondFingerTouchCoord.y.floatValue);
        //
        //                // Second finger move
        //                SDLTouchCoord* secondFingerMoveTouchCoord = [[SDLTouchCoord alloc] init];
        //                secondFingerMoveTouchCoord.x = @(secondFingerTouchCoord.x.floatValue - 50);
        //                secondFingerMoveTouchCoord.y = @(secondFingerTouchCoord.y.floatValue - 40);
        //
        //                NSUInteger secondFingerMoveTimeStamp = secondFingerTimeStamp + ((touchManager.movementTimeThreshold + 0.1) * 1000);
        //
        //                SDLTouchEvent* secondFingerMoveTouchEvent = [[SDLTouchEvent alloc] init];
        //                secondFingerMoveTouchEvent.touchEventId = @1;
        //                secondFingerMoveTouchEvent.coord = [NSArray arrayWithObject:secondFingerMoveTouchCoord];
        //                secondFingerMoveTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondFingerMoveTimeStamp)];
        //
        //                pinchMoveSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                pinchMoveSecondFingerOnTouchEvent.event = [NSArray arrayWithObject:secondFingerMoveTouchEvent];
        //                pinchMoveSecondFingerOnTouchEvent.type = SDLTouchTypeMove;
        //
        //                pinchMoveCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerMoveTouchCoord.x.floatValue) / 2.0f,
        //                                              (firstFingerTouchCoord.y.floatValue + secondFingerMoveTouchCoord.y.floatValue) / 2.0f);
        //
        //                CGFloat pinchMoveDistance = hypotf(firstFingerTouchCoord.x.floatValue - secondFingerMoveTouchCoord.x.floatValue,
        //                                                   firstFingerTouchCoord.y.floatValue - secondFingerMoveTouchCoord.y.floatValue);
        //
        //                pinchMoveScale = pinchMoveDistance / pinchStartDistance;
        //
        //                // Second finger end
        //                SDLTouchCoord* secondFingerEndTouchCoord = secondFingerMoveTouchCoord;
        //
        //                NSUInteger secondFingerEndTimeStamp = secondFingerMoveTimeStamp + ((touchManager.movementTimeThreshold + 0.1) * 1000);
        //
        //                SDLTouchEvent* secondFingerEndTouchEvent = [[SDLTouchEvent alloc] init];
        //                secondFingerEndTouchEvent.touchEventId = @1;
        //                secondFingerEndTouchEvent.coord = [NSArray arrayWithObject:secondFingerEndTouchCoord];
        //                secondFingerEndTouchEvent.timeStamp = [NSArray arrayWithObject:@(secondFingerEndTimeStamp)];
        //
        //                pinchEndSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
        //                pinchEndSecondFingerOnTouchEvent.event = [NSArray arrayWithObject:secondFingerEndTouchEvent];
        //                pinchEndSecondFingerOnTouchEvent.type = SDLTouchTypeEnd;
        //
        //                pinchEndCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerEndTouchCoord.x.floatValue) / 2.0f,
        //                                             (firstFingerTouchCoord.y.floatValue + secondFingerEndTouchCoord.y.floatValue) / 2.0f);
        //
        //                pinchStartTests = ^(NSInvocation* invocation) {
        //                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
        //
        //                    CGPoint point;
        //
        //                    [invocation getArgument:&touchManagerCallback atIndex:2];
        //                    [invocation getArgument:&point atIndex:3];
        //
        //                    expect(touchManagerCallback).to(equal(touchManager));
        //                    expect(@(CGPointEqualToPoint(point, pinchStartCenter))).to(beTruthy());
        //                };
        //
        //                pinchMoveTests = ^(NSInvocation* invocation) {
        //                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
        //                    
        //                    CGPoint point;
        //                    CGFloat scale;
        //                    
        //                    [invocation getArgument:&touchManagerCallback atIndex:2];
        //                    [invocation getArgument:&point atIndex:3];
        //                    [invocation getArgument:&scale atIndex:4];
        //                    
        //                    expect(touchManagerCallback).to(equal(touchManager));
        //                    expect(@(CGPointEqualToPoint(point, pinchMoveCenter))).to(beTruthy());
        //                    expect(@(scale)).to(beCloseTo(@(pinchMoveScale)).within(0.0001));
        //                };
        //                
        //                pinchEndTests = ^(NSInvocation* invocation) {
        //                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
        //                    
        //                    CGPoint point;
        //                    
        //                    [invocation getArgument:&touchManagerCallback atIndex:2];
        //                    [invocation getArgument:&point atIndex:3];
        //                    
        //                    expect(touchManagerCallback).to(equal(touchManager));
        //                    expect(@(CGPointEqualToPoint(point, pinchEndCenter))).to(beTruthy());
        //                };
        //                
        //                performTouchEvent(touchManager, pinchStartFirstFingerOnTouchEvent);
        //                performTouchEvent(touchManager, pinchStartSecondFingerOnTouchEvent);
        //                performTouchEvent(touchManager, pinchMoveSecondFingerOnTouchEvent);
        //                performTouchEvent(touchManager, pinchEndSecondFingerOnTouchEvent);
        //            });
        //            
        //            it(@"should correctly give all pinch callback", ^{
        //                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
        //                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
        //                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
        //                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
        //            });
        //            
        //            it(@"should run the handler", ^{
        //                expect(@(numTimesHandlerCalled)).to(equal(@4));
        //            });
        //        });
    });
});

QuickSpecEnd
