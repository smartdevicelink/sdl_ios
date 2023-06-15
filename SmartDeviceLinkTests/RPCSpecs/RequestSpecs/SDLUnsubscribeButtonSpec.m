//
//  SDLUnsubscribeButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLUnsubscribeButton.h"


QuickSpecBegin(SDLUnsubscribeButtonSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] init];
        
        testRequest.buttonName = SDLButtonNamePreset0;
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset0));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameButtonName:SDLButtonNamePreset0},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameUnsubscribeButton}} mutableCopy];
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] initWithDictionary:dict];
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset0));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] init];
        
        expect(testRequest.buttonName).to(beNil());
    });
});

QuickSpecEnd
