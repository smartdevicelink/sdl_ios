//
//  SDLSubscribeButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonName.h"
#import "SDLNames.h"
#import "SDLSubscribeButton.h"


QuickSpecBegin(SDLSubscribeButtonSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        testRequest.buttonName = SDLButtonNamePreset5;
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset5));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_buttonName:SDLButtonNamePreset5},
                                             NAMES_operation_name:NAMES_SubscribeButton}} mutableCopy];
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] initWithDictionary:dict];
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset5));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        expect(testRequest.buttonName).to(beNil());
    });
});

QuickSpecEnd
