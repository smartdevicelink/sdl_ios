//
//  SDLSliderResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

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
        SDLSliderResponse* testResponse = [[SDLSliderResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.sliderPosition).to(equal(@13));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSliderResponse* testResponse = [[SDLSliderResponse alloc] init];
        
        expect(testResponse.sliderPosition).to(beNil());
    });
});

QuickSpecEnd
