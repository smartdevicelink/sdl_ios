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

#import "SDLOnTouchEvent.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouchManager.h"
#import "SDLTouchType.h"

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
        __block BOOL didCallBeginPinch;
        __block BOOL didCallMovePinch;
        __block BOOL didCallEndPinch;
        
        __block DelegateCallbackBlock singleTapTests;
        __block DelegateCallbackBlock doubleTapTests;
        __block DelegateCallbackBlock panStartTests;
        __block DelegateCallbackBlock panMoveTests;
        __block DelegateCallbackBlock panEndTests;
        __block DelegateCallbackBlock pinchStartTests;
        __block DelegateCallbackBlock pinchMoveTests;
        __block DelegateCallbackBlock pinchEndTests;
        
        __block CGFloat additionalWaitTime = 1.0f;
        
        __block void (^performTouchEvent)(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) = ^(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) {
            SEL onOnTouchEvent = NSSelectorFromString(@"onOnTouchEvent:");
            ((void ( *)(id, SEL, id))[touchManager methodForSelector:onOnTouchEvent])(touchManager, onOnTouchEvent, onTouchEvent);
        };
        
        beforeEach(^{
            touchManager = [[SDLTouchManager alloc] init];
            delegateMock = OCMProtocolMock(@protocol(SDLTouchManagerDelegate));
            touchManager.touchEventDelegate = delegateMock;
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
        });
        
        describe(@"single finger", ^{
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
                touchEvent.coord = [NSMutableArray arrayWithObject:firstTouchCoord];
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(firstTouchTimeStamp)];
                
                firstOnTouchEventStart = [[SDLOnTouchEvent alloc] init];
                firstOnTouchEventStart.type = SDLTouchType.BEGIN;
                firstOnTouchEventStart.event = [NSMutableArray arrayWithObject:touchEvent];
                
                firstOnTouchEventEnd = [[SDLOnTouchEvent alloc] init];
                firstOnTouchEventEnd.type = SDLTouchType.END;
                firstOnTouchEventEnd.event = [NSMutableArray arrayWithObject:touchEvent];
            });
            
            describe(@"when receiving a single tap", ^{
                it(@"should correctly handle a single tap", ^{
    
                    singleTapTests = ^(NSInvocation* invocation) {
                        __unsafe_unretained SDLTouchManager* touchManagerCallback;
                        
                        CGPoint point;
                        
                        [invocation getArgument:&touchManagerCallback atIndex:2];
                        [invocation getArgument:&point atIndex:3];
                        
                        expect(touchManagerCallback).to(equal(touchManager));
                        expect(@(CGPointEqualToPoint(point, controlPoint))).to(beTruthy());
                    };
                    
                    performTouchEvent(touchManager, firstOnTouchEventStart);

                    performTouchEvent(touchManager, firstOnTouchEventEnd);
                    
                    expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
                    expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                });
            });
            
            describe(@"when receiving a double tap", ^{
                __block CGPoint averagePoint;
                
                __block SDLTouchEvent* secondTouchEvent;
                
                __block SDLOnTouchEvent* secondOnTouchEventStart;
                __block SDLOnTouchEvent* secondOnTouchEventEnd;
                
                beforeEach(^{
                    secondOnTouchEventStart = [[SDLOnTouchEvent alloc] init];
                    secondOnTouchEventStart.type = SDLTouchType.BEGIN;
                    
                    secondOnTouchEventEnd = [[SDLOnTouchEvent alloc] init];
                    secondOnTouchEventEnd.type = SDLTouchType.END;
                    
                    secondTouchEvent = [[SDLTouchEvent alloc] init];
                    secondTouchEvent.touchEventId = @0;
                    NSUInteger secondTouchTimeStamp = firstTouchTimeStamp + (touchManager.tapTimeThreshold - 0.1) * 1000;
                    secondTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(secondTouchTimeStamp)];
                });
                
                context(@"near the same point", ^{
                    beforeEach(^{
                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold);
                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold);
                        
                        secondTouchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];
                        
                        secondOnTouchEventStart.event = [NSMutableArray arrayWithObject:secondTouchEvent];
                        
                        secondOnTouchEventEnd.event = [NSMutableArray arrayWithObject:secondTouchEvent];
                        
                        averagePoint = CGPointMake((firstTouchCoord.x.floatValue + touchCoord.x.floatValue) / 2.0f,
                                                   (firstTouchCoord.y.floatValue + touchCoord.y.floatValue) / 2.0f);
                    });
                    
                    it(@"should issue delegate callbacks", ^{
                        doubleTapTests = ^(NSInvocation* invocation) {
                            __unsafe_unretained SDLTouchManager* touchManagerCallback;
                            
                            CGPoint point;
                            
                            [invocation getArgument:&touchManagerCallback atIndex:2];
                            [invocation getArgument:&point atIndex:3];
                            
                            expect(touchManagerCallback).to(equal(touchManager));
                            expect(@(CGPointEqualToPoint(point, averagePoint))).to(beTruthy());
                        };
                        
                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, firstOnTouchEventEnd);
                        performTouchEvent(touchManager, secondOnTouchEventStart);
                        performTouchEvent(touchManager, secondOnTouchEventEnd);
                        
                        expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
                        expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    });
                });
                
                context(@"not near the same point", ^{
                    beforeEach(^{
                        SDLTouchCoord* touchCoord = [[SDLTouchCoord alloc] init];
                        touchCoord.x = @(firstTouchCoord.x.floatValue + touchManager.tapDistanceThreshold + 1);
                        touchCoord.y = @(firstTouchCoord.y.floatValue + touchManager.tapDistanceThreshold + 1);
                        
                        secondTouchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];
                        
                        secondOnTouchEventStart.event = [NSMutableArray arrayWithObject:secondTouchEvent];
                        
                        secondOnTouchEventEnd.event = [NSMutableArray arrayWithObject:secondTouchEvent];
                    });
                    
                    it(@"should should not issue delegate callbacks", ^{
                        performTouchEvent(touchManager, firstOnTouchEventStart);
                        performTouchEvent(touchManager, firstOnTouchEventEnd);
                        performTouchEvent(touchManager, secondOnTouchEventStart);
                        performTouchEvent(touchManager, secondOnTouchEventEnd);
                        
                        expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                        expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                    });
                });
            });
        });
        context(@"when receiving a pan", ^{
            __block CGPoint panStartPoint;
            __block CGPoint panMovePoint;
            __block CGPoint panSecondMovePoint;
            __block CGPoint panEndPoint;
            
            __block CGFloat distanceMoveX = 10;
            __block CGFloat distanceMoveY = 20;
            
            __block SDLOnTouchEvent* panStartOnTouchEvent;
            __block SDLOnTouchEvent* panMoveOnTouchEvent;
            __block SDLOnTouchEvent* panSecondMoveOnTouchEvent;
            __block SDLOnTouchEvent* panEndOnTouchEvent;
            
            beforeEach(^{
                // Finger touch down
                panStartPoint = controlPoint;
            
                SDLTouchCoord* panStartTouchCoord = [[SDLTouchCoord alloc] init];
                panStartTouchCoord.x = @(panStartPoint.x);
                panStartTouchCoord.y = @(panStartPoint.y);
                
                double movementTimeThresholdOffset = (touchManager.movementTimeThreshold + .01) * 1000;
                
                NSUInteger panStartTimeStamp = ([[NSDate date] timeIntervalSince1970] * 1000) + movementTimeThresholdOffset;
                
                SDLTouchEvent* panStartTouchEvent = [[SDLTouchEvent alloc] init];
                panStartTouchEvent.coord = [NSMutableArray arrayWithObject:panStartTouchCoord];
                panStartTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(panStartTimeStamp)];
                
                panStartOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panStartOnTouchEvent.event = [NSMutableArray arrayWithObject:panStartTouchEvent];
                panStartOnTouchEvent.type = SDLTouchType.BEGIN;
                
                // Finger Move
                panMovePoint = CGPointMake(panStartPoint.x + distanceMoveX, panStartPoint.y + distanceMoveY);

                SDLTouchCoord* panMoveTouchCoord = [[SDLTouchCoord alloc] init];
                panMoveTouchCoord.x = @(panMovePoint.x);
                panMoveTouchCoord.y = @(panMovePoint.y);
                
                NSUInteger panMoveTimeStamp = panStartTimeStamp + movementTimeThresholdOffset;
                
                SDLTouchEvent* panMoveTouchEvent = [[SDLTouchEvent alloc] init];
                panMoveTouchEvent.coord = [NSMutableArray arrayWithObject:panMoveTouchCoord];
                panMoveTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(panMoveTimeStamp)];
                
                panMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panMoveOnTouchEvent.event = [NSMutableArray arrayWithObject:panMoveTouchEvent];
                panMoveOnTouchEvent.type = SDLTouchType.MOVE;
                
                // Finger Move
                panSecondMovePoint = CGPointMake(panMovePoint.x + distanceMoveX, panMovePoint.y + distanceMoveY);
                
                SDLTouchCoord* panSecondMoveTouchCoord = [[SDLTouchCoord alloc] init];
                panSecondMoveTouchCoord.x = @(panSecondMovePoint.x);
                panSecondMoveTouchCoord.y = @(panSecondMovePoint.y);
                
                NSUInteger panSecondMoveTimeStamp = panMoveTimeStamp + movementTimeThresholdOffset;
                
                SDLTouchEvent* panSecondMoveTouchEvent = [[SDLTouchEvent alloc] init];
                panSecondMoveTouchEvent.coord = [NSMutableArray arrayWithObject:panSecondMoveTouchCoord];
                panSecondMoveTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(panSecondMoveTimeStamp)];
                
                panSecondMoveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panSecondMoveOnTouchEvent.event = [NSMutableArray arrayWithObject:panSecondMoveTouchEvent];
                panSecondMoveOnTouchEvent.type = SDLTouchType.MOVE;
                
                // Finger End
                panEndPoint = CGPointMake(panSecondMovePoint.x, panSecondMovePoint.y);

                SDLTouchCoord* panEndTouchCoord = [[SDLTouchCoord alloc] init];
                panEndTouchCoord.x = @(panEndPoint.x);
                panEndTouchCoord.y = @(panEndPoint.y);
                
                NSUInteger panEndTimeStamp = panSecondMoveTimeStamp + movementTimeThresholdOffset;
                
                SDLTouchEvent* panEndTouchEvent = [[SDLTouchEvent alloc] init];
                panEndTouchEvent.coord = [NSMutableArray arrayWithObject:panEndTouchCoord];
                panEndTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(panEndTimeStamp)];
                
                panEndOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                panEndOnTouchEvent.event = [NSMutableArray arrayWithObject:panEndTouchEvent];
                panEndOnTouchEvent.type = SDLTouchType.END;
            });
            
            it(@"should correctly give all pan callbacks", ^{
                panStartTests = ^(NSInvocation* invocation) {
                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
                    
                    CGPoint point;
                    
                    [invocation getArgument:&touchManagerCallback atIndex:2];
                    [invocation getArgument:&point atIndex:3];
                    
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
                    [invocation getArgument:&point atIndex:3];
                    
                    expect(touchManagerCallback).to(equal(touchManager));
                    expect(@(CGPointEqualToPoint(point, panEndPoint))).to(beTruthy());
                };

                performTouchEvent(touchManager, panStartOnTouchEvent);
                performTouchEvent(touchManager, panMoveOnTouchEvent);
                performTouchEvent(touchManager, panSecondMoveOnTouchEvent);
                performTouchEvent(touchManager, panEndOnTouchEvent);
                
                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());

            });
        });
        context(@"when receiving a pinch", ^{
            
            __block CGPoint pinchStartCenter;
            __block CGPoint pinchMoveCenter;
            __block CGFloat pinchMoveScale;
            __block CGPoint pinchEndCenter;
            
            __block SDLOnTouchEvent* pinchStartFirstFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchStartSecondFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchMoveSecondFingerOnTouchEvent;
            __block SDLOnTouchEvent* pinchEndSecondFingerOnTouchEvent;
            
            beforeEach(^{
                // First finger touch down
                SDLTouchCoord* firstFingerTouchCoord = [[SDLTouchCoord alloc] init];
                firstFingerTouchCoord.x = @(controlPoint.x);
                firstFingerTouchCoord.y = @(controlPoint.y);
                
                NSUInteger firstFingerTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
                
                SDLTouchEvent* firstFingerTouchEvent = [[SDLTouchEvent alloc] init];
                firstFingerTouchEvent.coord = [NSMutableArray arrayWithObject:firstFingerTouchCoord];
                firstFingerTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(firstFingerTimeStamp)];
                
                pinchStartFirstFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchStartFirstFingerOnTouchEvent.event = [NSMutableArray arrayWithObject:firstFingerTouchEvent];
                pinchStartFirstFingerOnTouchEvent.type = SDLTouchType.BEGIN;
                
                // Second finger touch down
                SDLTouchCoord* secondFingerTouchCoord = [[SDLTouchCoord alloc] init];
                secondFingerTouchCoord.x = @(firstFingerTouchCoord.x.floatValue + 100);
                secondFingerTouchCoord.y = @(firstFingerTouchCoord.y.floatValue + 100);
                
                NSUInteger secondFingerTimeStamp = firstFingerTimeStamp;
                
                SDLTouchEvent* secondFingerTouchEvent = [[SDLTouchEvent alloc] init];
                secondFingerTouchEvent.touchEventId = @1;
                secondFingerTouchEvent.coord = [NSMutableArray arrayWithObject:secondFingerTouchCoord];
                secondFingerTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(secondFingerTimeStamp)];
                
                pinchStartSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchStartSecondFingerOnTouchEvent.event = [NSMutableArray arrayWithObject:secondFingerTouchEvent];
                pinchStartSecondFingerOnTouchEvent.type = SDLTouchType.BEGIN;
                
                pinchStartCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerTouchCoord.x.floatValue) / 2.0f,
                                               (firstFingerTouchCoord.y.floatValue + secondFingerTouchCoord.y.floatValue) / 2.0f);
                
                CGFloat pinchStartDistance = hypotf(firstFingerTouchCoord.x.floatValue - secondFingerTouchCoord.x.floatValue,
                                                    firstFingerTouchCoord.y.floatValue - secondFingerTouchCoord.y.floatValue);
                
                // Second finger move
                SDLTouchCoord* secondFingerMoveTouchCoord = [[SDLTouchCoord alloc] init];
                secondFingerMoveTouchCoord.x = @(secondFingerTouchCoord.x.floatValue - 50);
                secondFingerMoveTouchCoord.y = @(secondFingerTouchCoord.y.floatValue - 40);
                
                NSUInteger secondFingerMoveTimeStamp = secondFingerTimeStamp + ((touchManager.movementTimeThreshold + 0.1) * 1000);
                
                SDLTouchEvent* secondFingerMoveTouchEvent = [[SDLTouchEvent alloc] init];
                secondFingerMoveTouchEvent.touchEventId = @1;
                secondFingerMoveTouchEvent.coord = [NSMutableArray arrayWithObject:secondFingerMoveTouchCoord];
                secondFingerMoveTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(secondFingerMoveTimeStamp)];
                
                pinchMoveSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchMoveSecondFingerOnTouchEvent.event = [NSMutableArray arrayWithObject:secondFingerMoveTouchEvent];
                pinchMoveSecondFingerOnTouchEvent.type = SDLTouchType.MOVE;
                
                pinchMoveCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerMoveTouchCoord.x.floatValue) / 2.0f,
                                              (firstFingerTouchCoord.y.floatValue + secondFingerMoveTouchCoord.y.floatValue) / 2.0f);
                
                CGFloat pinchMoveDistance = hypotf(firstFingerTouchCoord.x.floatValue - secondFingerMoveTouchCoord.x.floatValue,
                                                   firstFingerTouchCoord.y.floatValue - secondFingerMoveTouchCoord.y.floatValue);
                
                pinchMoveScale = pinchMoveDistance / pinchStartDistance;
                
                // Second finger end
                SDLTouchCoord* secondFingerEndTouchCoord = secondFingerMoveTouchCoord;
                
                NSUInteger secondFingerEndTimeStamp = secondFingerMoveTimeStamp + ((touchManager.movementTimeThreshold + 0.1) * 1000);
                
                SDLTouchEvent* secondFingerEndTouchEvent = [[SDLTouchEvent alloc] init];
                secondFingerEndTouchEvent.touchEventId = @1;
                secondFingerEndTouchEvent.coord = [NSMutableArray arrayWithObject:secondFingerEndTouchCoord];
                secondFingerEndTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(secondFingerEndTimeStamp)];
                
                pinchEndSecondFingerOnTouchEvent = [[SDLOnTouchEvent alloc] init];
                pinchEndSecondFingerOnTouchEvent.event = [NSMutableArray arrayWithObject:secondFingerEndTouchEvent];
                pinchEndSecondFingerOnTouchEvent.type = SDLTouchType.END;
                
                pinchEndCenter = CGPointMake((firstFingerTouchCoord.x.floatValue + secondFingerEndTouchCoord.x.floatValue) / 2.0f,
                                             (firstFingerTouchCoord.y.floatValue + secondFingerEndTouchCoord.y.floatValue) / 2.0f);
            });
            
            it(@"should correctly give all pinch callback", ^{
                pinchStartTests = ^(NSInvocation* invocation) {
                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
                    
                    CGPoint point;
                    
                    [invocation getArgument:&touchManagerCallback atIndex:2];
                    [invocation getArgument:&point atIndex:3];
                    
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
                    [invocation getArgument:&point atIndex:3];
                    
                    expect(touchManagerCallback).to(equal(touchManager));
                    expect(@(CGPointEqualToPoint(point, pinchEndCenter))).to(beTruthy());
                };

                performTouchEvent(touchManager, pinchStartFirstFingerOnTouchEvent);
                performTouchEvent(touchManager, pinchStartSecondFingerOnTouchEvent);
                performTouchEvent(touchManager, pinchMoveSecondFingerOnTouchEvent);
                performTouchEvent(touchManager, pinchEndSecondFingerOnTouchEvent);
                
                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beFalsy());
                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + additionalWaitTime).toEventually(beTruthy());
            });
        });
    });
});

QuickSpecEnd
