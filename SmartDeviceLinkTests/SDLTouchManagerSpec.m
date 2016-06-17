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

#import "SDLTouchManager.h"
#import "CGPoint_Util.h"
#import "SDLTouch.h"
#import "SDLPinchGesture.h"
#import "dispatch_timer.h"

QuickSpecBegin(SDLTouchManagerSpec)

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
            
            expect(@(pinchGesture.distance)).to(beCloseTo(@(141.4213)).within(0.0001));
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
            
            expect(@(pinchGesture.distance)).to(beCloseTo(@(70.7107)).within(0.0001));
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
                   expect(@(difference)).to(beCloseTo(@(2.5)).within(0.1));
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
           expect(@(dispatch_source_testcancel(timer))).to(beGreaterThan(@(0)));
       });
   });
});

QuickSpecEnd
