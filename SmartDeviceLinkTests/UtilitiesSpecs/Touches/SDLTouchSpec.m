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

#import "SDLTouchEvent.h"
#import "SDLTouchCoord.h"
#import "SDLTouch.h"

QuickSpecBegin(SDLTouchSpec)

describe(@"SDLTouch Tests", ^{
    context(@"SDLTouchZero", ^{
        __block SDLTouch* touch = [[SDLTouch alloc] init];
        
        it(@"should correctly initialize", ^{
            expect(@(touch.identifier)).to(equal(@(-1)));
            expect(@(CGPointEqualToPoint(touch.location, CGPointZero))).to(beTruthy());
            expect(@(touch.timeStamp)).to(equal(@0));
        });
        
        it(@"should not equal First Finger Identifier", ^{
            expect(@(touch.isFirstFinger)).to(beFalsy());
        });
        
        it(@"should not equal Second Finger Identifier", ^{
            expect(@(touch.isSecondFinger)).to(beFalsy());
        });
    });
    
    context(@"For First Finger Identifiers", ^{
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block SDLTouch* touch;
        
        beforeSuite(^{
            SDLTouchCoord* coord = [[SDLTouchCoord alloc] init];
            coord.x = @100;
            coord.y = @200;
            
            SDLTouchEvent* touchEvent = [[SDLTouchEvent alloc] init];
            touchEvent.touchEventId = @0;
            touchEvent.coord = [NSMutableArray arrayWithObject:coord];
            touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
            
            touch = [[SDLTouch alloc] initWithTouchEvent:touchEvent];
        });
        
        it(@"should correctly make a SDLTouch struct", ^{
            expect(@(touch.identifier)).to(equal(@(SDLTouchIdentifierFirstFinger)));
            expect(@(touch.location.x)).to(equal(@100));
            expect(@(touch.location.y)).to(equal(@200));
            expect(@(touch.timeStamp)).to(equal(@(timeStamp)));
        });
        
        it(@"should equal First Finger Identifier", ^{
            expect(@(touch.isFirstFinger)).to(beTruthy());
        });
        
        it(@"should not equal Second Finger Identifier", ^{
            expect(@(touch.isSecondFinger)).to(beFalsy());
        });
    });
    
    context(@"For Second Finger Identifiers", ^{
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block SDLTouch* touch;
        
        beforeSuite(^{
            SDLTouchCoord* coord = [[SDLTouchCoord alloc] init];
            coord.x = @100;
            coord.y = @200;
            
            SDLTouchEvent* touchEvent = [[SDLTouchEvent alloc] init];
            touchEvent.touchEventId = @1;
            touchEvent.coord = [NSMutableArray arrayWithObject:coord];
            touchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
            
            touch = [[SDLTouch alloc] initWithTouchEvent:touchEvent];
        });
        
        it(@"should correctly make a SDLTouch struct", ^{
            expect(@(touch.identifier)).to(equal(@(SDLTouchIdentifierSecondFinger)));
            expect(@(touch.location.x)).to(equal(@100));
            expect(@(touch.location.y)).to(equal(@200));
            expect(@(touch.timeStamp)).to(equal(@(timeStamp)));
        });
        
        it(@"should equal First Finger Identifier", ^{
            expect(@(touch.isFirstFinger)).to(beFalsy());
        });
        
        it(@"should not equal Second Finger Identifier", ^{
            expect(@(touch.isSecondFinger)).to(beTruthy());
        });
    });
});

QuickSpecEnd