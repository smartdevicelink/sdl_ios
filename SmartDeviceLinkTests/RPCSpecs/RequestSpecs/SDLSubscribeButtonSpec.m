//
//  SDLSubscribeButtonSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSubscribeButton.h"


QuickSpecBegin(SDLSubscribeButtonSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        testRequest.buttonName = SDLButtonNamePreset5;
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset5));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameButtonName:SDLButtonNamePreset5},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameSubscribeButton}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.buttonName).to(equal(SDLButtonNamePreset5));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSubscribeButton* testRequest = [[SDLSubscribeButton alloc] init];
        
        expect(testRequest.buttonName).to(beNil());
    });
});

QuickSpecEnd
