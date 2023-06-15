//
//  SDLDeleteFileResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDeleteFileResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLDeleteFileResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteFileResponse* testResponse = [[SDLDeleteFileResponse alloc] init];
        
        testResponse.spaceAvailable = @0;
        
        expect(testResponse.spaceAvailable).to(equal(@0));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameResponse:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameSpaceAvailable:@0},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameDeleteFile}} mutableCopy];
        SDLDeleteFileResponse* testResponse = [[SDLDeleteFileResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.spaceAvailable).to(equal(@0));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDeleteFileResponse* testResponse = [[SDLDeleteFileResponse alloc] init];
        
        expect(testResponse.spaceAvailable).to(beNil());
    });
});

QuickSpecEnd
