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
#import "SDLHapticRect.h"

QuickSpecBegin(SDLStreamingVideoScaleManagerSpec)

describe(@"the streaming video scale manager", ^{
    __block SDLStreamingVideoScaleManager *videoScaleManager = nil;
    __block float testScale = 2.3;
    __block CGSize testScreenSize = CGSizeMake(200, 400);

    it(@"should initialize correctly with init", ^{
        videoScaleManager = [[SDLStreamingVideoScaleManager alloc] init];

        expect(@(videoScaleManager.scale)).to(equal(1.0));
        expect(CGSizeEqualToSize(videoScaleManager.displayViewportResolution, CGSizeZero)).to(beTrue());
    });

    it(@"should initialize correctly with initWithScale:displayViewportResolution:", ^{
        videoScaleManager = [[SDLStreamingVideoScaleManager alloc] initWithScale:testScale displayViewportResolution:testScreenSize];

        expect(@(videoScaleManager.scale)).to(equal(testScale));
        expect(CGSizeEqualToSize(videoScaleManager.displayViewportResolution, testScreenSize)).to(beTrue());
    });

    context(@"test scaling a frame", ^{
         it(@"should scale the frame correctly with a scale > 1", ^{
             videoScaleManager.scale = 1.25;
             CGRect expectedRect = CGRectMake(0, 0, 160, 320);
             CGRect testRect = videoScaleManager.appViewportFrame;
             expect(CGRectEqualToRect(expectedRect, testRect)).to(beTrue());
         });

        it(@"should not scale the frame with a scale < 1", ^{
            videoScaleManager.scale = 0.3;
            CGRect expectedRect = CGRectMake(0, 0, testScreenSize.width, testScreenSize.height);
            CGRect testRect = videoScaleManager.appViewportFrame;
            expect(CGRectEqualToRect(expectedRect, testRect)).to(beTrue());
        });

        it(@"should not scale the frame with a scale = 1", ^{
            videoScaleManager.scale = 0.3;
            CGRect expectedRect = CGRectMake(0, 0, testScreenSize.width, testScreenSize.height);
            CGRect testRect = videoScaleManager.appViewportFrame;
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
            videoScaleManager.scale = 1.25;
            CGPoint expectedCoordinates = CGPointMake(80, 160);
            SDLOnTouchEvent *testOnTouchEvent = [videoScaleManager scaleTouchEventCoordinates:onTouchEvent];
            CGPoint testCoordinates = CGPointMake(testOnTouchEvent.event.firstObject.coord.firstObject.x.floatValue, testOnTouchEvent.event.firstObject.coord.firstObject.y.floatValue);
            expect(CGPointEqualToPoint(testCoordinates, expectedCoordinates)).to(beTrue());
        });

        it(@"should scale the coordinates correctly with a scale < 1", ^{
            videoScaleManager.scale = 0.1;
            CGPoint expectedCoordinates = CGPointMake(100, 200);
            SDLOnTouchEvent *testOnTouchEvent = [videoScaleManager scaleTouchEventCoordinates:onTouchEvent];
            CGPoint testCoordinates = CGPointMake(testOnTouchEvent.event.firstObject.coord.firstObject.x.floatValue, testOnTouchEvent.event.firstObject.coord.firstObject.y.floatValue);
            expect(CGPointEqualToPoint(testCoordinates, expectedCoordinates)).to(beTrue());
        });

        it(@"should scale the coordinates correctly with a scale = 1", ^{
            videoScaleManager.scale = 1.0;
            CGPoint expectedCoordinates = CGPointMake(100, 200);
            SDLOnTouchEvent *testOnTouchEvent = [videoScaleManager scaleTouchEventCoordinates:onTouchEvent];
            CGPoint testCoordinates = CGPointMake(testOnTouchEvent.event.firstObject.coord.firstObject.x.floatValue, testOnTouchEvent.event.firstObject.coord.firstObject.y.floatValue);
            expect(CGPointEqualToPoint(testCoordinates, expectedCoordinates)).to(beTrue());
        });
    });

    context(@"test scaling a haptic rect", ^{
        __block SDLHapticRect *hapticRect = nil;

         beforeEach(^{
             CGRect rect = CGRectMake(10, 10, 100, 200);
             SDLRectangle *rectangle = [[SDLRectangle alloc] initWithCGRect:rect];
             hapticRect = [[SDLHapticRect alloc] initWithId:2 rect:rectangle];
         });

         it(@"should scale the rectangle correctly with a scale > 1", ^{
             videoScaleManager.scale = 1.25;
             SDLRectangle *expectedRect = [[SDLRectangle alloc] initWithX:12.5 y:12.5 width:125 height:250];
             SDLHapticRect *testRect = [videoScaleManager scaleHapticRect:hapticRect];
             expect(testRect.rect).to(equal(expectedRect));
         });

         it(@"should scale the rectangle correctly with a scale < 1", ^{
             videoScaleManager.scale = 0.4;
             SDLRectangle *expectedRect = [[SDLRectangle alloc] initWithX:10 y:10 width:100 height:200];
             SDLHapticRect *testRect = [videoScaleManager scaleHapticRect:hapticRect];
             expect(testRect.rect).to(equal(expectedRect));
         });

         it(@"should scale the rectangle correctly with a scale = 1", ^{
             videoScaleManager.scale = 1.0;
             SDLRectangle *expectedRect = [[SDLRectangle alloc] initWithX:10 y:10 width:100 height:200];
             SDLHapticRect *testRect = [videoScaleManager scaleHapticRect:hapticRect];
             expect(testRect.rect).to(equal(expectedRect));
         });
    });
});

QuickSpecEnd
