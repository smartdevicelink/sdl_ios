//
//  SDLReadDIDResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLReadDIDResponse.h"
#import "SDLDIDResult.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLReadDIDResponseSpec)

SDLDIDResult* result = [[SDLDIDResult alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] init];
        
        testResponse.didResult = [@[result] mutableCopy];
        
        expect(testResponse.didResult).to(equal([@[result] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameResponse:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameDIDResult:[@[result] mutableCopy]},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameReadDID}} mutableCopy];
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.didResult).to(equal([@[result] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLReadDIDResponse* testResponse = [[SDLReadDIDResponse alloc] init];
        
        expect(testResponse.didResult).to(beNil());
    });
});

QuickSpecEnd
