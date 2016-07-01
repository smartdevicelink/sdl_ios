//
//  SDLTouchSpecs.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 7/1/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLTouch.h"

QuickSpecBegin(SDLTouchSpec)

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

QuickSpecEnd