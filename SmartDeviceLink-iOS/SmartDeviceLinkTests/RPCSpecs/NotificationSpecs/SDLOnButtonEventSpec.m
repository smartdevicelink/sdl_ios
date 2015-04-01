//
//  SDLOnButtonEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonEventMode.h"
#import "SDLButtonName.h"
#import "SDLNames.h"
#import "SDLOnButtonEvent.h"


QuickSpecBegin(SDLOnButtonEventSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnButtonEvent* testNotification = [[SDLOnButtonEvent alloc] init];
        
        testNotification.buttonName = [SDLButtonName CUSTOM_BUTTON];
        testNotification.buttonEventMode = [SDLButtonEventMode BUTTONDOWN];
        testNotification.customButtonID = @4252;
        
        expect(testNotification.buttonName).to(equal([SDLButtonName CUSTOM_BUTTON]));
        expect(testNotification.buttonEventMode).to(equal([SDLButtonEventMode BUTTONDOWN]));
        expect(testNotification.customButtonID).to(equal(@4252));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_buttonName:[SDLButtonName CUSTOM_BUTTON],
                                                   NAMES_buttonEventMode:[SDLButtonEventMode BUTTONDOWN],
                                                   NAMES_customButtonID:@4252},
                                             NAMES_operation_name:NAMES_OnButtonEvent}} mutableCopy];
        SDLOnButtonEvent* testNotification = [[SDLOnButtonEvent alloc] initWithDictionary:dict];
        
        expect(testNotification.buttonName).to(equal([SDLButtonName CUSTOM_BUTTON]));
        expect(testNotification.buttonEventMode).to(equal([SDLButtonEventMode BUTTONDOWN]));
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