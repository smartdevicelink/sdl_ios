//
//  SDLOnButtonEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonEventMode.h"
#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLOnButtonEvent.h"


QuickSpecBegin(SDLOnButtonEventSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnButtonEvent* testNotification = [[SDLOnButtonEvent alloc] init];
        
        testNotification.buttonName = SDLButtonNameCustomButton;
        testNotification.buttonEventMode = SDLButtonEventModeButtonDown;
        testNotification.customButtonID = @4252;
        
        expect(testNotification.buttonName).to(equal(SDLButtonNameCustomButton));
        expect(testNotification.buttonEventMode).to(equal(SDLButtonEventModeButtonDown));
        expect(testNotification.customButtonID).to(equal(@4252));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameButtonName:SDLButtonNameCustomButton,
                                                   SDLRPCParameterNameButtonEventMode:SDLButtonEventModeButtonDown,
                                                   SDLRPCParameterNameCustomButtonId:@4252},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnButtonEvent}} mutableCopy];
        SDLOnButtonEvent* testNotification = [[SDLOnButtonEvent alloc] initWithDictionary:dict];
        
        expect(testNotification.buttonName).to(equal(SDLButtonNameCustomButton));
        expect(testNotification.buttonEventMode).to(equal(SDLButtonEventModeButtonDown));
        expect(testNotification.customButtonID).to(equal(@4252));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnButtonEvent* testNotification = [[SDLOnButtonEvent alloc] init];
        
        expect(testNotification.buttonName).to(beNil());
        expect(testNotification.buttonEventMode).to(beNil());
        expect(testNotification.customButtonID).to(beNil());
    });
});

QuickSpecEnd
