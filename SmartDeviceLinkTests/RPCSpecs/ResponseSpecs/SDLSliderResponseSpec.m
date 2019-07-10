//
//  SDLSliderResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSliderResponse.h"
#import "SDLDIDResult.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSliderResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSliderResponse* testResponse = [[SDLSliderResponse alloc] init];
        
        testResponse.sliderPosition = @13;
        
        expect(testResponse.sliderPosition).to(equal(@13));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameResponse:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameSliderPosition:@13},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameSlider}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSliderResponse* testResponse = [[SDLSliderResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testResponse.sliderPosition).to(equal(@13));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSliderResponse* testResponse = [[SDLSliderResponse alloc] init];
        
        expect(testResponse.sliderPosition).to(beNil());
    });
});

QuickSpecEnd
