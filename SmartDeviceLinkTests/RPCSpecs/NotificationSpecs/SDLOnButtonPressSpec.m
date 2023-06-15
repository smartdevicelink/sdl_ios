//
//  SDLOnButtonPressSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"
#import "SDLOnButtonPress.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


QuickSpecBegin(SDLOnButtonPressSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnButtonPress* testNotification = [[SDLOnButtonPress alloc] init];
        
        testNotification.buttonName = SDLButtonNameCustomButton;
        testNotification.buttonPressMode = SDLButtonPressModeLong;
        testNotification.customButtonID = @5642;
        
        expect(testNotification.buttonName).to(equal(SDLButtonNameCustomButton));
        expect(testNotification.buttonPressMode).to(equal(SDLButtonPressModeLong));
        expect(testNotification.customButtonID).to(equal(@5642));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameButtonName:SDLButtonNameCustomButton,
                                                   SDLRPCParameterNameButtonPressMode:SDLButtonPressModeLong,
                                                   SDLRPCParameterNameCustomButtonId:@5642},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnButtonPress}} mutableCopy];
        SDLOnButtonPress* testNotification = [[SDLOnButtonPress alloc] initWithDictionary:dict];
        
        expect(testNotification.buttonName).to(equal(SDLButtonNameCustomButton));
        expect(testNotification.buttonPressMode).to(equal(SDLButtonPressModeLong));
        expect(testNotification.customButtonID).to(equal(@5642));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnButtonPress* testNotification = [[SDLOnButtonPress alloc] init];
        
        expect(testNotification.buttonName).to(beNil());
        expect(testNotification.buttonPressMode).to(beNil());
        expect(testNotification.customButtonID).to(beNil());
    });
});

QuickSpecEnd
