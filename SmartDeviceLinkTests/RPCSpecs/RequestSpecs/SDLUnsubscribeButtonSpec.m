//
//  SDLUnsubscribeButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset0));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLUnsubscribeButton* testRequest = [[SDLUnsubscribeButton alloc] init];
        
        expect(testRequest.buttonName).to(beNil());
    });
});

QuickSpecEnd
