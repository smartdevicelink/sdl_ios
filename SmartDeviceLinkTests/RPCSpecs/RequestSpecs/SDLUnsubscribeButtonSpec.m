//
//  SDLUnsubscribeButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonName.h"
#import "SDLNames.h"
#import "SDLUnsubscribeButton.h"


QuickSpecBegin(SDLUnsubscribeButtonSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] init];
        
        testRequest.buttonName = [SDLButtonName PRESET_0];
        
        expect(testRequest.buttonName).to(equal([SDLButtonName PRESET_0]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_buttonName:[SDLButtonName PRESET_0]},
                                             NAMES_operation_name:NAMES_UnsubscribeButton}} mutableCopy];
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] initWithDictionary:dict];
        
        expect(testRequest.buttonName).to(equal([SDLButtonName PRESET_0]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] init];
        
        expect(testRequest.buttonName).to(beNil());
    });
});

QuickSpecEnd