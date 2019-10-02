//
//  SDLStreamingVideoScaleManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 10/2/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLStreamingVideoScaleManager.h"
#import "SDLOnTouchEvent.h"
#import "SDLTouchEvent.h"
#import "SDLTouchCoord.h"
#import "SDLRectangle.h"

QuickSpecBegin(SDLStreamingVideoScaleManagerSpec)

describe(@"the streaming video manager", ^{
    context(@"test scaling a frame", ^{
        __block CGSize screenSize = CGSizeMake(200, 400);

         it(@"should scale the frame correctly with a scale > 1", ^{
             float scale = 1.25;
             CGRect expectedRect = CGRectMake(0, 0, 160, 320);
             CGRect testRect = [SDLStreamingVideoScaleManager scaleFrameForScreenSize:screenSize scale:scale];
             expect(CGRectEqualToRect(expectedRect, testRect)).to(beTrue());
         });

        it(@"should not scale the frame with a scale < 1", ^{
            float scale = 0.3;
            CGRect expectedRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
            CGRect testRect = [SDLStreamingVideoScaleManager scaleFrameForScreenSize:screenSize scale:scale];
            expect(CGRectEqualToRect(expectedRect, testRect)).to(beTrue());
        });

        it(@"should not scale the frame with a scale = 1", ^{
            float scale = 0.3;
            CGRect expectedRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
            CGRect testRect = [SDLStreamingVideoScaleManager scaleFrameForScreenSize:screenSize scale:scale];
            expect(CGRectEqualToRect(expectedRect, testRect)).to(beTrue());
        });
    });

    context(@"test scaling a touch coordinate", ^{
        __block SDLOnTouchEvent *onTouchEvent = nil;

        beforeEach(^{
            SDLTouchCoord *touchCoord = [[SDLTouchCoord alloc] init];
            touchCoord.x = @100;
            touchCoord.y = @200;

            onTouchEvent = [[SDLOnTouchEvent alloc] init];

            SDLTouchEvent *touchEvent = [[SDLTouchEvent alloc] init];
            touchEvent.coord = @[touchCoord];
            onTouchEvent.event = @[touchEvent];
        });

        it(@"should scale the coordinates correctly with a scale > 1", ^{
            float scale = 1.25;
            CGPoint expectedCoordinates = CGPointMake(80, 160);
            SDLOnTouchEvent *testOnTouchEvent = [SDLStreamingVideoScaleManager scaleTouchEventCoordinates:onTouchEvent scale:scale];
            CGPoint testCoordinates = CGPointMake(testOnTouchEvent.event.firstObject.coord.firstObject.x.floatValue, testOnTouchEvent.event.firstObject.coord.firstObject.y.floatValue);
            expect(CGPointEqualToPoint(testCoordinates, expectedCoordinates)).to(beTrue());
        });

        it(@"should scale the coordinates correctly with a scale < 1", ^{
            float scale = 0.1;
            CGPoint expectedCoordinates = CGPointMake(100, 200);
            SDLOnTouchEvent *testOnTouchEvent = [SDLStreamingVideoScaleManager scaleTouchEventCoordinates:onTouchEvent scale:scale];
            CGPoint testCoordinates = CGPointMake(testOnTouchEvent.event.firstObject.coord.firstObject.x.floatValue, testOnTouchEvent.event.firstObject.coord.firstObject.y.floatValue);
            expect(CGPointEqualToPoint(testCoordinates, expectedCoordinates)).to(beTrue());
        });

        it(@"should scale the coordinates correctly with a scale = 1", ^{
            float scale = 1.0;
            CGPoint expectedCoordinates = CGPointMake(100, 200);
            SDLOnTouchEvent *testOnTouchEvent = [SDLStreamingVideoScaleManager scaleTouchEventCoordinates:onTouchEvent scale:scale];
            CGPoint testCoordinates = CGPointMake(testOnTouchEvent.event.firstObject.coord.firstObject.x.floatValue, testOnTouchEvent.event.firstObject.coord.firstObject.y.floatValue);
            expect(CGPointEqualToPoint(testCoordinates, expectedCoordinates)).to(beTrue());
        });
    });

     context(@"test scaling a haptic rect", ^{
         __block CGRect rect = CGRectZero;

         beforeEach(^{
             rect = CGRectMake(10, 10, 100, 200);
         });

         it(@"should scale the rectangle correctly with a scale > 1", ^{
             float scale = 1.25;
             SDLRectangle *expectedRect = [[SDLRectangle alloc] initWithX:12.5 y:12.5 width:125 height:250];
             SDLRectangle *testRect = [SDLStreamingVideoScaleManager scaleHapticRectangle:rect scale:scale];
             expect(testRect).to(equal(expectedRect));
         });

         it(@"should scale the rectangle correctly with a scale < 1", ^{
             float scale = 0.4;
             SDLRectangle *expectedRect = [[SDLRectangle alloc] initWithX:10 y:10 width:100 height:200];
             SDLRectangle *testRect = [SDLStreamingVideoScaleManager scaleHapticRectangle:rect scale:scale];
             expect(testRect).to(equal(expectedRect));
         });

         it(@"should scale the rectangle correctly with a scale = 1", ^{
             float scale = 1.0;
             SDLRectangle *expectedRect = [[SDLRectangle alloc] initWithX:10 y:10 width:100 height:200];
             SDLRectangle *testRect = [SDLStreamingVideoScaleManager scaleHapticRectangle:rect scale:scale];
             expect(testRect).to(equal(expectedRect));
         });
     });
});

QuickSpecEnd
