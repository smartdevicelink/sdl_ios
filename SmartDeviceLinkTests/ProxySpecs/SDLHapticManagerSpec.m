//
//  SDLHapticManagerSpec.m
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLFocusableItemLocator.h"
#import "SDLHapticRect.h"
#import "SDLLifecycleManager.h"
#import "SDLManager.h"
#import "SDLRectangle.h"
#import "SDLSendHapticData.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouch.h"

static inline BOOL floatEqual(const float f1, const float f2) {
    return fabsf(f1 - f2) < 0.01;
}

BOOL compareRectangle(SDLRectangle *sdlRectangle, CGRect cgRect) {
    return floatEqual(sdlRectangle.x.floatValue, cgRect.origin.x) &&
           floatEqual(sdlRectangle.y.floatValue, cgRect.origin.y) &&
           floatEqual(sdlRectangle.width.floatValue, cgRect.size.width) &&
           floatEqual(sdlRectangle.height.floatValue, cgRect.size.height);
}

BOOL compareScaledRectangle(SDLRectangle *sdlRectangle, CGRect cgRect, float scale) {
    return floatEqual(sdlRectangle.x.floatValue, cgRect.origin.x * scale) &&
           floatEqual(sdlRectangle.y.floatValue, cgRect.origin.y * scale) &&
           floatEqual(sdlRectangle.width.floatValue, cgRect.size.width * scale) &&
           floatEqual(sdlRectangle.height.floatValue, cgRect.size.height * scale);
}

@interface SDLFocusableItemLocator ()

@property (strong, nonatomic) SDLStreamingVideoScaleManager *videoScaleManager;

@end

QuickSpecBegin(SDLHapticManagerSpec)

describe(@"the haptic manager", ^{
    __block UIWindow *uiWindow;
    __block UIViewController *uiViewController;

    __block SDLFocusableItemLocator *hapticManager;
    __block SDLSendHapticData* sentHapticRequest;

    __block id<SDLConnectionManagerType> sdlLifecycleManager = nil;
    __block SDLStreamingVideoScaleManager *sdlStreamingVideoScaleManager = nil;
    __block CGRect viewRect1;
    __block CGRect viewRect2;

    beforeEach(^{
        const CGRect frame = CGRectMake(0, 0, 320, 480);
        uiWindow = [[UIWindow alloc] initWithFrame:frame];
        uiViewController = [[UIViewController alloc] init];
        uiWindow.rootViewController = uiViewController;
        uiViewController.view.frame = frame;

        sdlLifecycleManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));

        hapticManager = nil;
        sentHapticRequest = nil;
        sdlStreamingVideoScaleManager = [[SDLStreamingVideoScaleManager alloc] initWithScale:1.0 displayViewportResolution:uiViewController.view.frame.size];
    });

    context(@"when disabled", ^{
        beforeEach(^{
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc] initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = NO;
            [hapticManager updateInterfaceLayout];
        });

        it(@"should have no views", ^{
            OCMReject([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            expect(sentHapticRequest).to(beNil());
        });
    });

    context(@"when initialized with no focusable view", ^{
        beforeEach(^{
            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            [hapticManager updateInterfaceLayout];
        });

        it(@"should have no focusable view", ^{
            OCMReject([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);
            expect(sentHapticRequest.hapticRectData.count).to(equal(0));
        });
    });

    context(@"when initialized with single view", ^{
        beforeEach(^{
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];
        });

        it(@"should have one view", ^{
            OCMVerify([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            int expectedCount = 1;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect = hapticRectData[0];
                SDLRectangle *sdlRect = sdlhapticRect.rect;

                expect(compareRectangle(sdlRect, viewRect1)).to(beTrue());
            }
        });
    });

    context(@"when initialized with single button view", ^{
        beforeEach(^{
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UIButton *button = [[UIButton alloc] initWithFrame:viewRect1];
            [uiViewController.view addSubview:button];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];
        });

        it(@"should have one view", ^{
            OCMVerify([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            int expectedCount = 1;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect = hapticRectData[0];
                SDLRectangle *sdlRect = sdlhapticRect.rect;

                expect(compareRectangle(sdlRect, viewRect1)).to(beTrue());
            }
        });
    });

    context(@"when initialized with no views and then updated with two additional views", ^{
        beforeEach(^{
            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];

            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc] initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];

            viewRect2 = CGRectMake(201, 201, 50, 50);
            UITextField *textField2 = [[UITextField alloc] initWithFrame:viewRect2];
            [uiViewController.view addSubview:textField2];

            [hapticManager updateInterfaceLayout];
        });

        it(@"should have two views", ^{
            OCMVerify([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            int expectedCount = 2;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                SDLRectangle *sdlRect1 = sdlhapticRect1.rect;

                SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                SDLRectangle *sdlRect2 = sdlhapticRect2.rect;

                expect(compareRectangle(sdlRect1, viewRect2)).to(beTrue());
                expect(compareRectangle(sdlRect2, viewRect1)).to(beTrue());
            }
        });
    });

    context(@"when initialized with nested views", ^{
        beforeEach(^{
            UIView *containerView = [[UIView alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:containerView];

            viewRect1 = CGRectMake(110, 110, 10, 10);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            textField1.text = @"B";
            [containerView addSubview:textField1];

            viewRect2 = CGRectMake(130, 130, 10, 10);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            textField2.text = @"C";
            [containerView addSubview:textField2];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];
        });

        it(@"should have only leaf views added", ^{
            OCMVerify([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            const int expectedCount = 2;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                SDLRectangle *sdlRect1 = sdlhapticRect1.rect;

                SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                SDLRectangle *sdlRect2 = sdlhapticRect2.rect;

                expect(compareRectangle(sdlRect1, viewRect1)).to(beTrue());
                expect(compareRectangle(sdlRect2, viewRect2)).to(beTrue());
            }
        });
    });

    context(@"when initialized with nested button views", ^{
        beforeEach(^{
            UIView *boxView = [[UIView alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:boxView];

            viewRect1 = CGRectMake(110, 110, 10, 10);
            UIButton *button1 = [[UIButton alloc]  initWithFrame:viewRect1];
            [button1 setTitle:@"B" forState:UIControlStateNormal];
            [boxView addSubview:button1];

            viewRect2 = CGRectMake(130, 130, 10, 10);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            textField2.text = @"C";
            [boxView addSubview:textField2];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];
        });

        it(@"should have only leaf views added", ^{
            OCMVerify([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            const int expectedCount = 2;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                SDLRectangle *sdlRect1 = sdlhapticRect1.rect;

                SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                SDLRectangle *sdlRect2 = sdlhapticRect2.rect;

                expect(compareRectangle(sdlRect1, viewRect1)).to(beTrue());
                expect(compareRectangle(sdlRect2, viewRect2)).to(beTrue());
            }
        });
    });

    context(@"when initialized with two views and then updated with one view removed", ^{
        beforeEach(^{
            OCMStub([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];

            viewRect2 = CGRectMake(201, 201, 50, 50);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            [uiViewController.view addSubview:textField2];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];

            [textField2 removeFromSuperview];

            [hapticManager updateInterfaceLayout];
        });

        it(@"should have one view", ^{
            int expectedCount = 1;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect = hapticRectData[0];
                SDLRectangle *sdlRect = sdlhapticRect.rect;

                expect(compareRectangle(sdlRect, viewRect1)).to(beTrue());
            }
        });
    });

    context(@"when initialized with one view and notified after adding one more view", ^{
        beforeEach(^{
            OCMStub([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                if(isFirstArg) {
                    sentHapticRequest = value;
                }
                return YES;
            }] withResponseHandler:[OCMArg any]]);

            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];

            viewRect2 = CGRectMake(201, 201, 50, 50);
            UITextField *textField2 = [[UITextField alloc] initWithFrame:viewRect2];
            [uiViewController.view addSubview:textField2];
        });

        context(@"when not started", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidUpdateProjectionView object:nil];
            });

            it(@"should have one view", ^{
                int expectedCount = 1;
                expect(sentHapticRequest.hapticRectData.count).toEventually(equal(expectedCount));

                if(sentHapticRequest.hapticRectData.count == expectedCount) {
                    NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                    SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                    SDLRectangle *sdlRect1 = sdlhapticRect1.rect;

                    expect(compareRectangle(sdlRect1, viewRect1)).to(beTrue());
                }
            });
        });

        context(@"when started", ^{
            beforeEach(^{
                [hapticManager stop]; // stop it, just in case
                [hapticManager start];
                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidUpdateProjectionView object:nil];
            });

            it(@"should have two views", ^{
                int expectedCount = 2;
                expect(sentHapticRequest.hapticRectData.count).toEventually(equal(expectedCount));

                if(sentHapticRequest.hapticRectData.count == expectedCount) {
                    NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                    SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                    SDLRectangle *sdlRect1 = sdlhapticRect1.rect;

                    SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                    SDLRectangle *sdlRect2 = sdlhapticRect2.rect;

                    expect(compareRectangle(sdlRect1, viewRect2)).to(beTrue());
                    expect(compareRectangle(sdlRect2, viewRect1)).to(beTrue());
                }
            });

            context(@"when stopped", ^{
                beforeEach(^{
                    [hapticManager stop];
                    for (UIView *subview in uiViewController.view.subviews) { [subview removeFromSuperview]; }
                    [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidUpdateProjectionView object:nil];
                });

                it(@"should have two views", ^{
                    int expectedCount = 2;
                    expect(sentHapticRequest.hapticRectData.count).toEventually(equal(expectedCount));
                });
            });
        });
    });

    context(@"when touched inside a view", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:textField1];

            UITextField *textField2 = [[UITextField alloc]  initWithFrame:CGRectMake(201, 201, 50, 50)];
            [uiViewController.view addSubview:textField2];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];
        });

        it(@"should return a view object", ^{
            UIView *view1 = [hapticManager viewForPoint:CGPointMake(125, 120)];
            expect(view1).toNot(beNil());

            UIView* view2 = [hapticManager viewForPoint:CGPointMake(202, 249)];
            expect(view2).toNot(beNil());
        });
    });

    context(@"when touched in overlapping views' area", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            textField1.text = @"A";
            [uiViewController.view addSubview:textField1];

            UITextField *textField2 = [[UITextField alloc]  initWithFrame:CGRectMake(126, 126, 50, 50)];
            textField2.text = @"B";
            [uiViewController.view addSubview:textField2];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];
        });

        it(@"should return no view object", ^{
            const CGPoint pt = CGPointMake(80, 90);
            UIView *view = [hapticManager viewForPoint:pt];
            if (view) {
                failWithMessage(([NSString stringWithFormat:@"found view %@ at point %@", view, NSStringFromCGPoint(pt)]));
            }
        });
    });

    context(@"when touched outside view boundary", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiWindow insertSubview:textField1 aboveSubview:uiWindow];

            hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
            hapticManager.enableHapticDataRequests = YES;
            [hapticManager updateInterfaceLayout];
        });
        it(@"should return nil", ^{
            UIView* view = [hapticManager viewForPoint:CGPointMake(0, 228)];
            expect(view).to(beNil());
        });
    });

    describe(@"scaling", ^{
        __block float testUpdatedScale = 0.0;
        __block CGSize testScreenSize = CGSizeZero;

         beforeEach(^{
             testScreenSize = uiViewController.view.frame.size;

             viewRect1 = CGRectMake(320, 600, 100, 100);
             UIButton *button = [[UIButton alloc] initWithFrame:viewRect1];
             [uiViewController.view addSubview:button];

             sentHapticRequest = nil;

             hapticManager = [[SDLFocusableItemLocator alloc] initWithViewController:uiViewController connectionManager:sdlLifecycleManager videoScaleManager:sdlStreamingVideoScaleManager];
             hapticManager.enableHapticDataRequests = YES;
         });

         context(@"With a scale value greater than 1.0", ^{
             beforeEach(^{
                 testUpdatedScale = 1.25;
                 hapticManager.videoScaleManager = [[SDLStreamingVideoScaleManager alloc] initWithScale:testUpdatedScale displayViewportResolution:testScreenSize];
                 [hapticManager updateInterfaceLayout];
             });

             it(@"should have sent one view that has been scaled", ^{
                 OCMVerify([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                     BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                     if(isFirstArg) {
                         sentHapticRequest = value;
                     }
                     return YES;
                 }] withResponseHandler:[OCMArg any]]);

                 const int expectedCount = 1;
                 expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

                 if(sentHapticRequest.hapticRectData.count == expectedCount) {
                     NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                     SDLHapticRect *sdlhapticRect = hapticRectData[0];
                     SDLRectangle *sdlRect = sdlhapticRect.rect;

                     if (!compareScaledRectangle(sdlRect, viewRect1, testUpdatedScale)) {
                         failWithMessage(([NSString stringWithFormat:@"rects are not equal (%@ vs %@)", sdlRect, NSStringFromCGRect(viewRect1)]));
                     }
                 }
             });
         });

         context(@"With a scale value less than 1.0", ^{
             beforeEach(^{
                 testUpdatedScale = 0.4;
                 hapticManager.videoScaleManager = [[SDLStreamingVideoScaleManager alloc] initWithScale:testUpdatedScale displayViewportResolution:testScreenSize];
                 [hapticManager updateInterfaceLayout];
             });

             it(@"should have sent one view that has not been scaled", ^{
                 OCMVerify([sdlLifecycleManager sendConnectionManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
                     BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
                     if(isFirstArg) {
                         sentHapticRequest = value;
                     }
                     return YES;
                 }] withResponseHandler:[OCMArg any]]);

                 const int expectedCount = 1;
                 expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));

                 if(sentHapticRequest.hapticRectData.count == expectedCount) {
                     NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                     SDLHapticRect *sdlhapticRect = hapticRectData[0];
                     SDLRectangle *sdlRect = sdlhapticRect.rect;

                     if (!compareScaledRectangle(sdlRect, viewRect1, testUpdatedScale)) {
                         failWithMessage(([NSString stringWithFormat:@"rects are not equal {%@ vs %@}", sdlRect, NSStringFromCGRect(viewRect1)]));
                     }
                 }
             });
         });
    });
});

QuickSpecEnd
