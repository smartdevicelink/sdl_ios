//
//  SDLHapticManagerSpec.m
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLHapticManager.h"
#import "SDLSendHapticData.h"
#import "SDLManager.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouch.h"

SDLTouch* generateTouchEvent(int xCoord, int yCoord)
{
    unsigned long timeStamp = 10;
    SDLTouchCoord* firstCoord = [[SDLTouchCoord alloc] init];
    firstCoord.x = [NSNumber numberWithInt:xCoord];
    firstCoord.y = [NSNumber numberWithInt:yCoord];
    
    SDLTouchEvent* firstTouchEvent = [[SDLTouchEvent alloc] init];
    firstTouchEvent.touchEventId = @0;
    firstTouchEvent.coord = [NSMutableArray arrayWithObject:firstCoord];
    firstTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
    SDLTouch* firstTouch = [[SDLTouch alloc] initWithTouchEvent:firstTouchEvent];
    return firstTouch;
}

QuickSpecBegin(SDLHapticManagerSpec)

describe(@"the haptic manager", ^{
    
    __block UIWindow *uiWindow;
    __block UIViewController *uiViewController;
    
    __block SDLHapticManager *hapticManager;
    __block SDLSendHapticData* capturedHapticRPC;
    
    __block id sdlManagerMock = OCMClassMock([SDLManager class]);
    
    beforeEach(^{
        uiWindow = [[UIWindow alloc] init];
        uiViewController = [UIViewController alloc];
        
        [uiWindow addSubview:uiViewController.view];
        
        OCMExpect( [[sdlManagerMock stub] sendRequest:[OCMArg checkWithBlock:^BOOL(id value){
            BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
            if(isFirstArg)
            {
                capturedHapticRPC = value;
            }
            return YES;
        }] withResponseHandler:[OCMArg any]]);

    });
    
    context(@"when initialized with no view", ^{
        beforeEach(^{
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow sdlManager:sdlManagerMock];
        });
        
        it(@"should have no view", ^{
            OCMVerify(sdlManagerMock);
            expect([[capturedHapticRPC hapticRectData] count]).to(equal(0));
        });
    });
    
    context(@"when initialized with single view", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiWindow insertSubview:textField1 aboveSubview:uiWindow];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow sdlManager:sdlManagerMock];
        });
        
        it(@"should have one view", ^{
            OCMVerify(sdlManagerMock);
            expect([[capturedHapticRPC hapticRectData] count]).to(equal(1));
        });
    });
        
    context(@"when initialized with no views and then updated with two additional views", ^{
        beforeEach(^{
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow sdlManager:sdlManagerMock];
            
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:textField1];
            
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:CGRectMake(201, 201, 50, 50)];
            [uiViewController.view addSubview:textField2];
            
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have two views", ^{
            OCMVerify(sdlManagerMock);
            expect([[capturedHapticRPC hapticRectData] count]).to(equal(2));
        });
     });
    
    context(@"when initialized with two views and then updated with one view removed", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:textField1];
            
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:CGRectMake(201, 201, 50, 50)];
            [uiViewController.view addSubview:textField2];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow sdlManager:sdlManagerMock];
            
            [textField2 removeFromSuperview];
            
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have one view", ^{
            OCMVerify(sdlManagerMock);
            expect([[capturedHapticRPC hapticRectData] count]).to(equal(1));
        });
    });
    
    context(@"when touched inside a view", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:textField1];
            
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:CGRectMake(201, 201, 50, 50)];
            [uiViewController.view addSubview:textField2];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow sdlManager:sdlManagerMock];
        });
        
        it(@"should return a view object", ^{
            
            SDLTouch* collisionTouch1 = generateTouchEvent(125, 120);
            UIView* view1 = [hapticManager viewForSDLTouch:collisionTouch1];
            
            expect(view1).toNot(beNil());
            
            SDLTouch* collisionTouch2 = generateTouchEvent(202, 249);
            UIView* view2 = [hapticManager viewForSDLTouch:collisionTouch2];
            
            expect(view2).toNot(beNil());
        });
    });
    
    context(@"when touched outside view boundary", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiWindow insertSubview:textField1 aboveSubview:uiWindow];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow sdlManager:sdlManagerMock];
        });
        it(@"should return nil", ^{
            SDLTouch* collisionTouch = generateTouchEvent(0, 228);
            UIView* view = [hapticManager viewForSDLTouch:collisionTouch];
            expect(view).to(beNil());
        });
        
    });
});

QuickSpecEnd
