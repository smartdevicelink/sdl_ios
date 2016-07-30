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
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"

QuickSpecBegin(SDLPinchGestureSpec)

describe(@"SDLPinchGesture Tests", ^{
    context(@"SDLPinchGestureZero", ^{
        __block SDLPinchGesture* pinchGesture = [[SDLPinchGesture alloc] init];;
        
        it(@"should correctly initialize", ^{
            expect(pinchGesture.firstTouch).to(beNil());
            expect(pinchGesture.secondTouch).to(beNil());
            expect(@(pinchGesture.distance)).to(equal(@0));
            expect(@(CGPointEqualToPoint(pinchGesture.center, CGPointZero))).to(beTruthy());
        });
        
        it(@"should not be a valid SDLPinchGesture", ^{
            expect(@(pinchGesture.isValid)).to(beFalsy());
        });
    });
    
    context(@"SDLPinchGestureMake", ^{
        __block SDLPinchGesture* pinchGesture;
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block unsigned long secondTimeStamp = timeStamp + 1000;
        
        beforeEach(^{
            SDLTouchCoord* firstCoord = [[SDLTouchCoord alloc] init];
            firstCoord.x = @100;
            firstCoord.y = @200;
            
            SDLTouchEvent* firstTouchEvent = [[SDLTouchEvent alloc] init];
            firstTouchEvent.touchEventId = @0;
            firstTouchEvent.coord = [NSMutableArray arrayWithObject:firstCoord];
            firstTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
            
            SDLTouch* firstTouch = [[SDLTouch alloc] initWithTouchEvent:firstTouchEvent];
            
            SDLTouchCoord* secondCoord = [[SDLTouchCoord alloc] init];
            secondCoord.x = @200;
            secondCoord.y = @300;
            
            SDLTouchEvent* secondTouchEvent = [[SDLTouchEvent alloc] init];
            secondTouchEvent.touchEventId = @1;
            secondTouchEvent.coord = [NSMutableArray arrayWithObject:secondCoord];
            secondTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(secondTimeStamp)];
            
            SDLTouch* secondTouch = [[SDLTouch alloc] initWithTouchEvent:secondTouchEvent];

            pinchGesture = [[SDLPinchGesture alloc] initWithFirstTouch:firstTouch
                                                           secondTouch:secondTouch];
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
            expect(@(pinchGesture.isValid)).to(beTruthy());
        });
    });
    
    context(@"updating SDLPinchGesture", ^{
        __block SDLPinchGesture* pinchGesture;
        __block unsigned long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        __block unsigned long secondTimeStamp = timeStamp + 1000;
        __block unsigned long newTimeStamp = timeStamp + 1000;
        
        __block SDLTouch* newFirstTouch;
        __block SDLTouch* newSecondTouch;
        
        beforeEach(^{
            SDLTouchCoord* firstCoord = [[SDLTouchCoord alloc] init];
            firstCoord.x = @100;
            firstCoord.y = @200;
            
            SDLTouchEvent* firstTouchEvent = [[SDLTouchEvent alloc] init];
            firstTouchEvent.touchEventId = @0;
            firstTouchEvent.coord = [NSMutableArray arrayWithObject:firstCoord];
            firstTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
            
            SDLTouch* firstTouch = [[SDLTouch alloc] initWithTouchEvent:firstTouchEvent];
            
            SDLTouchCoord* secondCoord = [[SDLTouchCoord alloc] init];
            secondCoord.x = @200;
            secondCoord.y = @300;
            
            SDLTouchEvent* secondTouchEvent = [[SDLTouchEvent alloc] init];
            secondTouchEvent.touchEventId = @1;
            secondTouchEvent.coord = [NSMutableArray arrayWithObject:secondCoord];
            secondTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(secondTimeStamp)];
            
            SDLTouch* secondTouch = [[SDLTouch alloc] initWithTouchEvent:secondTouchEvent];
            
            pinchGesture = [[SDLPinchGesture alloc] initWithFirstTouch:firstTouch
                                                           secondTouch:secondTouch];
            
            SDLTouchCoord* newCoord = [[SDLTouchCoord alloc] init];
            newCoord.x = @150;
            newCoord.y = @250;
            
            SDLTouchEvent* newFirstTouchEvent = [[SDLTouchEvent alloc] init];
            newFirstTouchEvent.touchEventId = @0;
            newFirstTouchEvent.coord = [NSMutableArray arrayWithObject:newCoord];
            newFirstTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(newTimeStamp)];

            SDLTouchEvent* newSecondTouchEvent = [[SDLTouchEvent alloc] init];
            newSecondTouchEvent.touchEventId = @1;
            newSecondTouchEvent.coord = [NSMutableArray arrayWithObject:newCoord];
            newSecondTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(newTimeStamp)];

            newFirstTouch = [[SDLTouch alloc] initWithTouchEvent:newFirstTouchEvent];
            newSecondTouch = [[SDLTouch alloc] initWithTouchEvent:newSecondTouchEvent];
        });
        
        it(@"should update first point correctly", ^{
            pinchGesture.firstTouch = newFirstTouch;
            
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
            pinchGesture.secondTouch = newSecondTouch;
            
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