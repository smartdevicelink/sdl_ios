//
//  SDLPinchGestureSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 7/1/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPinchGesture.h"

QuickSpecBegin(SDLPinchGestureSpec)

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

QuickSpecEnd