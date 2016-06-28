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
#import "CGPoint_Util.h"
#import "SDLTouch.h"
#import "SDLPinchGesture.h"
#import "dispatch_timer.h"

QuickSpecBegin(SDLTouchManagerSpec)

typedef void (^DelegateCallbackBlock)(NSInvocation* invocation);

describe(@"CGPoint_Util Tests", ^{
    __block CGPoint first;
    __block CGPoint second;
    context(@"For two positive points", ^{
        beforeEach(^{
            first = CGPointMake(100, 200);
            second = CGPointMake(300, 400);
        });
        
        it(@"should properly calculate the average between points", ^{
            CGPoint average = CGPointAverageOfPoints(first, second);
            expect(@(average.x)).to(equal(@200));
            expect(@(average.y)).to(equal(@300));
        });
        it(@"should properly calculate the center between points", ^{
            CGPoint center = CGPointCenterOfPoints(first, second);
            expect(@(center.x)).to(equal(@200));
            expect(@(center.y)).to(equal(@300));
        });
        it(@"should properly calculate the displacement between points", ^{
            CGPoint displacement = CGPointDisplacementOfPoints(first, second);
            expect(@(displacement.x)).to(equal(@(-200)));
            expect(@(displacement.y)).to(equal(@(-200)));
        });
        it(@"should properly calculate the distance between points", ^{
            CGFloat distance = CGPointDistanceBetweenPoints(first, second);
            expect(@(distance)).to(beCloseTo(@282.8427).within(0.0001));
        });
    });
    context(@"For two negative points", ^{
        beforeEach(^{
            first = CGPointMake(-100, -200);
            second = CGPointMake(-300, -400);
        });
        
        it(@"should properly calculate the average between points", ^{
            CGPoint average = CGPointAverageOfPoints(first, second);
            expect(@(average.x)).to(equal(@(-200)));
            expect(@(average.y)).to(equal(@(-300)));
        });
        it(@"should properly calculate the center between points", ^{
            CGPoint center = CGPointCenterOfPoints(first, second);
            expect(@(center.x)).to(equal(@(-200)));
            expect(@(center.y)).to(equal(@(-300)));
        });
        it(@"should properly calculate the displacement between points", ^{
            CGPoint displacement = CGPointDisplacementOfPoints(first, second);
            expect(@(displacement.x)).to(equal(@200));
            expect(@(displacement.y)).to(equal(@200));
        });
        it(@"should properly calculate the distance between points", ^{
            CGFloat distance = CGPointDistanceBetweenPoints(first, second);
            expect(@(distance)).to(beCloseTo(@282.8427).within(0.0001));
        });
    });
    context(@"For one positive and one negative point", ^{
        beforeEach(^{
            first = CGPointMake(100, 200);
            second = CGPointMake(-300, -400);
        });
        
        it(@"should properly calculate the average between points", ^{
            CGPoint average = CGPointAverageOfPoints(first, second);
            expect(@(average.x)).to(equal(@(-100)));
            expect(@(average.y)).to(equal(@(-100)));
        });
        it(@"should properly calculate the center between points", ^{
            CGPoint center = CGPointCenterOfPoints(first, second);
            expect(@(center.x)).to(equal(@(-100)));
            expect(@(center.y)).to(equal(@(-100)));
        });
        it(@"should properly calculate the displacement between points", ^{
            CGPoint displacement = CGPointDisplacementOfPoints(first, second);
            expect(@(displacement.x)).to(equal(@400));
            expect(@(displacement.y)).to(equal(@600));
        });
        it(@"should properly calculate the distance between points", ^{
            CGFloat distance = CGPointDistanceBetweenPoints(first, second);
            expect(@(distance)).to(beCloseTo(@721.1103).within(0.0001));
        });
    });
});

describe(@"SDLTouch Tests", ^{
    context(@"SDLTouchZero", ^{
        __block SDLTouch touch = SDLTouchZero;
        
        it(@"should correctly initialize", ^{
            expect(@(touch.identifier)).to(equal(@(-1)));
            expect(@(CGPointEqualToPoint(touch.location, CGPointZero))).to(beTruthy());
            expect(@(touch.timeStamp)).to(equal(@0));
        });
        
        it(@"should not be a valid SDLTouch", ^{
            expect(@(SDLTouchIsValid(touch))).to(beFalsy());
        });
        
        it(@"should not equal First Finger Identifier", ^{
            expect(@(SDLTouchIsFirstFinger(touch))).to(beFalsy());
        });
        
        it(@"should not equal Second Finger Identifier", ^{
            expect(@(SDLTouchIsSecondFinger(touch))).to(beFalsy());
        });
    });
    
    context(@"For First Finger Identifiers", ^{
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block SDLTouch touch;
        
        beforeSuite(^{
            touch = SDLTouchMake(0, 100, 200, timeStamp);
        });
        
        it(@"should correctly make a SDLTouch struct", ^{
            expect(@(touch.identifier)).to(equal(@(SDLTouchIdentifierFirstFinger)));
            expect(@(touch.location.x)).to(equal(@100));
            expect(@(touch.location.y)).to(equal(@200));
            expect(@(touch.timeStamp)).to(equal(@(timeStamp)));
        });
        
        it(@"should be a valid SDLTouch", ^{
            expect(@(SDLTouchIsValid(touch))).to(beTruthy());
        });
        
        it(@"should equal First Finger Identifier", ^{
            expect(@(SDLTouchIsFirstFinger(touch))).to(beTruthy());
        });
        
        it(@"should not equal Second Finger Identifier", ^{
            expect(@(SDLTouchIsSecondFinger(touch))).to(beFalsy());
        });
    });
    
    context(@"For Second Finger Identifiers", ^{
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block SDLTouch touch;
        
        beforeSuite(^{
            touch = SDLTouchMake(1, 100, 200, timeStamp);
        });
        
        it(@"should correctly make a SDLTouch struct", ^{
            expect(@(touch.identifier)).to(equal(@(SDLTouchIdentifierSecondFinger)));
            expect(@(touch.location.x)).to(equal(@100));
            expect(@(touch.location.y)).to(equal(@200));
            expect(@(touch.timeStamp)).to(equal(@(timeStamp)));
        });
        
        it(@"should be a valid SDLTouch", ^{
            expect(@(SDLTouchIsValid(touch))).to(beTruthy());
        });
        
        it(@"should equal First Finger Identifier", ^{
            expect(@(SDLTouchIsFirstFinger(touch))).to(beFalsy());
        });
        
        it(@"should not equal Second Finger Identifier", ^{
            expect(@(SDLTouchIsSecondFinger(touch))).to(beTruthy());
        });
    });
});

describe(@"SDLPinchGesture Tests", ^{
    context(@"SDLPinchGestureZero", ^{
        __block SDLPinchGesture pinchGesture = SDLPinchGestureZero;
        
        it(@"should correctly initialize", ^{
            expect(@(pinchGesture.firstTouch.identifier)).to(equal(@(-1)));
            expect(@(pinchGesture.firstTouch.location.x)).to(equal(@0));
            expect(@(pinchGesture.firstTouch.location.y)).to(equal(@0));
            expect(@(pinchGesture.firstTouch.timeStamp)).to(equal(@0));

            expect(@(pinchGesture.secondTouch.identifier)).to(equal(@(-1)));
            expect(@(pinchGesture.secondTouch.location.x)).to(equal(@0));
            expect(@(pinchGesture.secondTouch.location.y)).to(equal(@0));
            expect(@(pinchGesture.secondTouch.timeStamp)).to(equal(@0));
        });
        
        it(@"should not be a valid SDLPinchGesture", ^{
            expect(@(SDLPinchGestureIsValid(pinchGesture))).to(beFalsy());
        });
    });
    
    context(@"SDLPinchGestureMake", ^{
        __block SDLPinchGesture pinchGesture;
        __block SDLTouch firstTouch;
        __block SDLTouch secondTouch;
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block unsigned long secondTimeStamp = timeStamp + 1000;
        
        beforeEach(^{
            firstTouch = SDLTouchMake(SDLTouchIdentifierFirstFinger, 100, 200, timeStamp);
            secondTouch = SDLTouchMake(SDLTouchIdentifierSecondFinger, 200, 300, secondTimeStamp);
            pinchGesture = SDLPinchGestureMake(firstTouch, secondTouch);
        });
        
        it(@"should correctly initialize", ^{
            expect(@(pinchGesture.firstTouch.identifier)).to(equal(@(SDLTouchIdentifierFirstFinger)));
            expect(@(pinchGesture.firstTouch.location.x)).to(equal(@100));
            expect(@(pinchGesture.firstTouch.location.y)).to(equal(@200));
            expect(@(pinchGesture.firstTouch.timeStamp)).to(equal(@(timeStamp)));
            
            expect(@(pinchGesture.secondTouch.identifier)).to(equal(@(SDLTouchIdentifierSecondFinger)));
            expect(@(pinchGesture.secondTouch.location.x)).to(equal(@200));
            expect(@(pinchGesture.secondTouch.location.y)).to(equal(@300));
            expect(@(pinchGesture.secondTouch.timeStamp)).to(equal(@(secondTimeStamp)));
            
            expect(@(pinchGesture.distance)).to(beCloseTo(@141.4213).within(0.0001));
            expect(@(pinchGesture.center.x)).to(equal(@150));
            expect(@(pinchGesture.center.y)).to(equal(@250));
        });
        
        it(@"should be a valid SDLPinchGesture", ^{
            expect(@(SDLPinchGestureIsValid(pinchGesture))).to(beTruthy());
        });
    });
    
    context(@"updating SDLPinchGesture", ^{
        __block SDLPinchGesture pinchGesture;
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block unsigned long secondTimeStamp = timeStamp + 1000;
        
        beforeEach(^{
            SDLTouch firstTouch = SDLTouchMake(SDLTouchIdentifierFirstFinger, 100, 200, timeStamp);
            SDLTouch secondTouch = SDLTouchMake(SDLTouchIdentifierSecondFinger, 200, 300, secondTimeStamp);
            pinchGesture = SDLPinchGestureMake(firstTouch, secondTouch);
        });
        
        it(@"should update first point correctly", ^{
            unsigned long newTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
            SDLTouch newTouch = SDLTouchMake(SDLTouchIdentifierFirstFinger, 150, 250, newTimeStamp);
            pinchGesture = SDLPinchGestureUpdateFromTouch(pinchGesture, newTouch);
            
            expect(@(pinchGesture.firstTouch.identifier)).to(equal(@(SDLTouchIdentifierFirstFinger)));
            expect(@(pinchGesture.firstTouch.location.x)).to(equal(@150));
            expect(@(pinchGesture.firstTouch.location.y)).to(equal(@250));
            expect(@(pinchGesture.firstTouch.timeStamp)).to(equal(@(newTimeStamp)));
            
            expect(@(pinchGesture.secondTouch.identifier)).to(equal(@(SDLTouchIdentifierSecondFinger)));
            expect(@(pinchGesture.secondTouch.location.x)).to(equal(@200));
            expect(@(pinchGesture.secondTouch.location.y)).to(equal(@300));
            expect(@(pinchGesture.secondTouch.timeStamp)).to(equal(@(secondTimeStamp)));
            
            expect(@(pinchGesture.distance)).to(beCloseTo(@(70.7107)).within(0.0001));
            expect(@(pinchGesture.center.x)).to(equal(@175));
            expect(@(pinchGesture.center.y)).to(equal(@275));

        });
        
        it(@"should update second point correctly", ^{            
            unsigned long newTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
            SDLTouch newTouch = SDLTouchMake(SDLTouchIdentifierSecondFinger, 150, 250, newTimeStamp);
            pinchGesture = SDLPinchGestureUpdateFromTouch(pinchGesture, newTouch);
            
            expect(@(pinchGesture.firstTouch.identifier)).to(equal(@(SDLTouchIdentifierFirstFinger)));
            expect(@(pinchGesture.firstTouch.location.x)).to(equal(@100));
            expect(@(pinchGesture.firstTouch.location.y)).to(equal(@200));
            expect(@(pinchGesture.firstTouch.timeStamp)).to(equal(@(timeStamp)));
            
            expect(@(pinchGesture.secondTouch.identifier)).to(equal(@(SDLTouchIdentifierSecondFinger)));
            expect(@(pinchGesture.secondTouch.location.x)).to(equal(@150));
            expect(@(pinchGesture.secondTouch.location.y)).to(equal(@250));
            expect(@(pinchGesture.secondTouch.timeStamp)).to(equal(@(newTimeStamp)));
            
            expect(@(pinchGesture.distance)).to(beCloseTo(@70.7107).within(0.0001));
            expect(@(pinchGesture.center.x)).to(equal(@125));
            expect(@(pinchGesture.center.y)).to(equal(@225));
        });
    });
});

describe(@"dispatch_timer Tests", ^{
   context(@"Creating", ^{
       it(@"should be successful within specified time", ^{
           waitUntilTimeout(4, ^(void (^done)(void)) {
               __block double currentTime = [[NSDate date] timeIntervalSince1970];
               dispatch_create_timer(2.5, false, ^{
                   double difference = [[NSDate date] timeIntervalSince1970] - currentTime;
                   expect(@(difference)).to(beCloseTo(@2.5).within(0.1));
                   done();
               });
           });
        });
       
       it(@"should be cancellable and not fire", ^{
           __block dispatch_source_t timer;
           waitUntilTimeout(2, ^(void (^done)(void)) {
               timer = dispatch_create_timer(2.5, false, ^{
                   fail();
               });
               [NSThread sleepForTimeInterval:0.5];
               dispatch_stop_timer(timer);
               done();
           });
           expect(@(dispatch_source_testcancel(timer))).to(beGreaterThan(@0));
       });
   });
});

describe(@"SDLTouchManager Tests", ^{
    
    __block SDLTouchManager* touchManager;
    __block id delegateMock;
    __block NSUInteger timeStamp;
    __block CGPoint controlPoint;
    __block SDLTouchCoord* touchCoord;
    __block SDLTouchEvent* touchEvent;
    __block SDLOnTouchEvent* beginOnTouchEvent;
    __block SDLOnTouchEvent* moveOnTouchEvent;
    __block SDLOnTouchEvent* endOnTouchEvent;
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
    
    __block void (^performTouchEvent)(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) = ^(SDLTouchManager* touchManager, SDLOnTouchEvent* onTouchEvent) {
        SEL onOnTouchEvent = @selector(onOnTouchEvent:);
        ((void (*)(id, SEL, id))[touchManager methodForSelector:onOnTouchEvent])(touchManager, onOnTouchEvent, onTouchEvent);
    };
    
    context(@"Initializing", ^{
        it(@"should correctly have default properties", ^{
            SDLTouchManager* touchManager = [[SDLTouchManager alloc] init];
            expect(touchManager.touchEventListener).to(beNil());
            expect(@(touchManager.tapDistanceThreshold)).to(equal(@50));
            expect(@(touchManager.tapTimeThreshold)).to(beCloseTo(@0.4).within(0.0001));
            expect(@(touchManager.panTimeThreshold)).to(equal(@50));
            expect(@(touchManager.isTouchEnabled)).to(beTruthy());
        });
        
    });
    describe(@"touch events", ^{
        beforeEach(^{
            touchManager = [[SDLTouchManager alloc] init];
            delegateMock = OCMProtocolMock(@protocol(SDLTouchManagerListener));
            touchManager.touchEventListener = delegateMock;
            timeStamp = [[NSDate date] timeIntervalSince1970] * 1000.0;
            controlPoint = CGPointMake(100, 200);
            
            touchCoord = [[SDLTouchCoord alloc] init];
            touchCoord.x = @(controlPoint.x);
            touchCoord.y = @(controlPoint.y);
            
            touchEvent = [[SDLTouchEvent alloc] init];
            touchEvent.touchEventId = @0;
            touchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];
            touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
            
            beginOnTouchEvent = [[SDLOnTouchEvent alloc] init];
            beginOnTouchEvent.type = SDLTouchType.BEGIN;
            beginOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
            
            moveOnTouchEvent = [[SDLOnTouchEvent alloc] init];
            moveOnTouchEvent.type = SDLTouchType.MOVE;
            
            endOnTouchEvent = [[SDLOnTouchEvent alloc] init];
            endOnTouchEvent.type = SDLTouchType.END;
            
            didCallSingleTap = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallSingleTap = YES;
                
                singleTapTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceiveSingleTapAtPoint:CGPointZero];

            singleTapTests = ^(NSInvocation* invocation) {
                fail();
            };
            
            didCallDoubleTap = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallDoubleTap = YES;
                
                doubleTapTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceiveDoubleTapAtPoint:CGPointZero];
            
            doubleTapTests = ^(NSInvocation* invocation) {
                fail();
            };
            
            didCallBeginPan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallBeginPan = YES;
                
                panStartTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] panningDidStartAtPoint:CGPointZero];
            
            panStartTests = ^(NSInvocation* invocation) {
                fail();
            };
            
            didCallMovePan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallMovePan = YES;
                
                panMoveTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceivePanningFromPoint:CGPointZero toPoint:CGPointZero];
            
            panMoveTests = ^(NSInvocation* invocation) {
                fail();
            };
            
            didCallEndPan = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallEndPan = YES;
                
                panEndTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] panningDidEndAtPoint:CGPointZero];
        
            panEndTests = ^(NSInvocation* invocation) {
                fail();
            };
            
            didCallBeginPinch = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallBeginPinch = YES;
                
                pinchStartTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] pinchDidStartAtCenterPoint:CGPointZero];

            pinchStartTests = ^(NSInvocation* invocation) {
                fail();
            };
            
            didCallMovePinch = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallMovePinch = YES;
                
                pinchMoveTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] didReceivePinchAtCenterPoint:CGPointZero withScale:0];

            pinchMoveTests = ^(NSInvocation* invocation) {
                fail();
            };
            
            didCallEndPinch = NO;
            [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                didCallEndPinch = YES;
                
                pinchEndTests(invocation);
            }] ignoringNonObjectArgs] touchManager:[OCMArg any] pinchDidEndAtCenterPoint:CGPointZero];
            
            pinchEndTests = ^(NSInvocation* invocation) {
                fail();
            };
        });
        
        context(@"when receiving a single tap", ^{
            it(@"should correctly handle a single tap", ^{
                singleTapTests = ^(NSInvocation* invocation) {
                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
                    
                    CGPoint point;
                    
                    [invocation getArgument:&touchManagerCallback atIndex:2];
                    [invocation getArgument:&point atIndex:3];
                    
                    expect(touchManagerCallback).to(equal(touchManager));
                    expect(@(CGPointEqualToPoint(point, controlPoint))).to(beTruthy());
                };
                
                // Begin Touch
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                // End Touch
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                endOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, endOnTouchEvent);
                
                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
            });
        });
        
        context(@"when receiving a double tap", ^{
            it(@"should correctly handle a double tap near same point", ^{
                __block CGPoint averagePoint;
                
                doubleTapTests = ^(NSInvocation* invocation) {
                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
                    
                    CGPoint point;
                    
                    [invocation getArgument:&touchManagerCallback atIndex:2];
                    [invocation getArgument:&point atIndex:3];
                    
                    expect(touchManagerCallback).to(equal(touchManager));
                    expect(@(CGPointEqualToPoint(point, averagePoint))).to(beTruthy());
                };
                
                // Begin First Touch
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                // End First Touch
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                endOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, endOnTouchEvent);
                
                // Start Second Touch
                touchCoord.x = @(touchCoord.x.floatValue + touchManager.tapDistanceThreshold);
                touchCoord.y = @(touchCoord.y.floatValue + touchManager.tapDistanceThreshold);

                averagePoint = CGPointAverageOfPoints(controlPoint,
                                                      CGPointMake(touchCoord.x.floatValue,
                                                                  touchCoord.y.floatValue));

                timeStamp += (touchManager.tapTimeThreshold - 0.1) * 1000;
                
                touchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                beginOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                // End Second Touch
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                endOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, endOnTouchEvent);
                
                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
            });
            
            it(@"should correctly not handle a double tap", ^{
                // Begin First Touch
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                // End First Touch
                endOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, endOnTouchEvent);
                
                // Start Second Touch
                timeStamp += (touchManager.tapTimeThreshold - 0.1) * 1000;
                
                touchCoord.x = @(touchCoord.x.floatValue + touchManager.tapDistanceThreshold + 1);
                touchCoord.y = @(touchCoord.y.floatValue + touchManager.tapDistanceThreshold + 1);
                
                touchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                beginOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                // End Second Touch
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                endOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, endOnTouchEvent);
                
                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
            });
        });
        context(@"when receiving a pan", ^{
            __block CGPoint panStartPoint;
            __block CGPoint panMovePoint;
            __block CGPoint panEndPoint;
            
            it(@"should correctly give all pan callbacks", ^{
                __block CGFloat distanceMoveX = 10;
                __block CGFloat distanceMoveY = 20;
                
                panStartTests = ^(NSInvocation* invocation) {
                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
                    
                    CGPoint point;
                    
                    [invocation getArgument:&touchManagerCallback atIndex:2];
                    [invocation getArgument:&point atIndex:3];
                    
                    expect(touchManagerCallback).to(equal(touchManager));
                    expect(@(CGPointEqualToPoint(point, panStartPoint))).to(beTruthy());
                };

                panMoveTests = ^(NSInvocation* invocation) {
                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
                    
                    CGPoint startPoint;
                    CGPoint endPoint;
                    
                    [invocation getArgument:&touchManagerCallback atIndex:2];
                    [invocation getArgument:&startPoint atIndex:3];
                    [invocation getArgument:&endPoint atIndex:4];
                    
                    expect(touchManagerCallback).to(equal(touchManager));
                    expect(@(CGPointEqualToPoint(startPoint, panStartPoint))).to(beTruthy());
                    expect(@(CGPointEqualToPoint(endPoint, panMovePoint))).to(beTruthy());
                };
                
                panEndTests = ^(NSInvocation* invocation) {
                    __unsafe_unretained SDLTouchManager* touchManagerCallback;
                    
                    CGPoint point;
                    
                    [invocation getArgument:&touchManagerCallback atIndex:2];
                    [invocation getArgument:&point atIndex:3];
                    
                    expect(touchManagerCallback).to(equal(touchManager));
                    expect(@(CGPointEqualToPoint(point, panEndPoint))).to(beTruthy());
                };
                
                // Begin Touch
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                // Move Touch
                touchCoord.x = @(touchCoord.x.floatValue + distanceMoveX);
                touchCoord.y = @(touchCoord.y.floatValue + distanceMoveY);
                touchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];

                panStartPoint = CGPointMake(touchCoord.x.floatValue, touchCoord.y.floatValue);
                
                timeStamp += (touchManager.panTimeThreshold * 1000);
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                moveOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, moveOnTouchEvent);
                
                // Move Touch 2
                touchCoord.x = @(touchCoord.x.floatValue + distanceMoveX);
                touchCoord.y = @(touchCoord.y.floatValue + distanceMoveY);
                touchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];
                
                panMovePoint = CGPointMake(touchCoord.x.floatValue, touchCoord.y.floatValue);
                
                timeStamp += (touchManager.panTimeThreshold * 1000);
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                moveOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, moveOnTouchEvent);
                
                // End Touch
                touchCoord.x = @(touchCoord.x.floatValue + distanceMoveX);
                touchCoord.y = @(touchCoord.y.floatValue + distanceMoveY);
                touchEvent.coord = [NSMutableArray arrayWithObject:touchCoord];

                panEndPoint = CGPointMake(touchCoord.x.floatValue, touchCoord.y.floatValue);
                
                timeStamp += (touchManager.panTimeThreshold * 1000);
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];

                endOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, endOnTouchEvent);
                
                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
            });
        });
        context(@"when receiving a pinch", ^{
            it(@"should correctly give all pinch callbacks", ^{
                __block CGPoint pinchStartCenter;
                __block CGPoint pinchMoveCenter;
                __block CGFloat pinchMoveScale;
                __block CGPoint pinchEndCenter;
                
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
                
                // Begin First Touch
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                // Begin Second Touch
                SDLTouchCoord* secondTouchCoord = [[SDLTouchCoord alloc] init];
                secondTouchCoord.x = @(controlPoint.x + 100);
                secondTouchCoord.y = @(controlPoint.y + 100);
                
                CGPoint firstPoint = CGPointMake(touchCoord.x.floatValue, touchCoord.y.floatValue);
                CGPoint secondPoint = CGPointMake(secondTouchCoord.x.floatValue, secondTouchCoord.y.floatValue);
                
                pinchStartCenter = CGPointCenterOfPoints(firstPoint, secondPoint);
                CGFloat pinchStartDistance = CGPointDistanceBetweenPoints(firstPoint, secondPoint);
                
                touchEvent.touchEventId = @1;
                touchEvent.coord = [NSMutableArray arrayWithObject:secondTouchCoord];
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                beginOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, beginOnTouchEvent);
                
                
                // Move Second Finger
                secondTouchCoord.x = @(secondTouchCoord.x.floatValue - 30);
                secondTouchCoord.y = @(secondTouchCoord.y.floatValue - 40);
                
                secondPoint = CGPointMake(secondTouchCoord.x.floatValue, secondTouchCoord.y.floatValue);
                
                pinchMoveCenter = CGPointCenterOfPoints(firstPoint, secondPoint);
                CGFloat pinchMoveDistance = CGPointDistanceBetweenPoints(firstPoint, secondPoint);
                pinchMoveScale = pinchMoveDistance / pinchStartDistance;
                
                timeStamp += touchManager.panTimeThreshold * 1000;
                
                touchEvent.touchEventId = @1;
                touchEvent.coord = [NSMutableArray arrayWithObject:secondTouchCoord];
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
                
                moveOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, moveOnTouchEvent);
                
                // End First Finger
                timeStamp += touchManager.panTimeThreshold * 1000;
                touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];

                secondPoint = CGPointMake(secondTouchCoord.x.floatValue, secondTouchCoord.y.floatValue);
                
                pinchEndCenter = CGPointCenterOfPoints(firstPoint, secondPoint);
  
                endOnTouchEvent.event = [NSMutableArray arrayWithObject:touchEvent];
                performTouchEvent(touchManager, endOnTouchEvent);
                
                expect(@(didCallSingleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallDoubleTap)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallMovePan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallEndPan)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beFalsy());
                expect(@(didCallBeginPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
                expect(@(didCallMovePinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
                expect(@(didCallEndPinch)).withTimeout(touchManager.tapTimeThreshold + 0.1).toEventually(beTruthy());
            });
        });
    });
});

QuickSpecEnd
